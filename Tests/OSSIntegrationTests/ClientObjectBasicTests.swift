@testable import AlibabaCloudOSS
import XCTest

final class ClientObjectBasicTests: BaseTestCase {
    override func setUp() async throws {
        try await super.setUp()

        client = getDefaultClient()
        bucketName = randomBucketName()

        let requst = PutBucketRequest(bucket: bucketName)
        try await assertNoThrow(await client?.putBucket(requst))
    }

    override func tearDown() async throws {
        try await cleanBucket(client: client!, bucket: bucketName)
        try await super.tearDown()
    }

    func testPutObject() async throws {
        let file = URL(fileURLWithPath: createTestFile(randomFileName(), 1024 * 100 + 123)!)
        let objectKey = randomObjectName()
        let request = PutObjectRequest(bucket: bucketName,
                                       key: objectKey,
                                       body: .file(file))
        try await assertNoThrow(await client?.putObject(request))

        let headRequest = HeadObjectRequest(bucket: bucketName,
                                            key: objectKey)

        let headResult = try await client?.headObject(headRequest)
        XCTAssertEqual(headResult?.contentMd5, try Utils.calculateMd5(fileURL: file).toBase64String())
    }

    func testAsyncPutObject() async throws {
        let file = URL(fileURLWithPath: createTestFile(randomFileName(), 1 * 100 + 123)!)
        let objectKey = randomObjectName()
        let clientActor = ValueActor(value: getDefaultClient())
        let bucket = randomBucketName()

        let requst = PutBucketRequest(bucket: bucket)
        try await assertNoThrow(await clientActor.getValue().putBucket(requst))

        await withThrowingTaskGroup(of: Void.self) {
            for i in 0 ..< 10 {
                $0.addTask {
                    let request = PutObjectRequest(bucket: bucket,
                                                   key: objectKey + "\(i)",
                                                   body: .file(file))
                    let result = try await clientActor.getValue().putObject(request)
                    XCTAssertEqual(result.statusCode, 200)
                    let headRequest = HeadObjectRequest(bucket: bucket,
                                                        key: objectKey)

                    let headResult = try await clientActor.getValue().headObject(headRequest)
                    XCTAssertEqual(headResult.contentMd5, try Utils.calculateMd5(fileURL: file).toBase64String())
                }
            }
        }
        try await cleanBucket(client: clientActor.getValue(), bucket: bucket)
    }

    func testPutObjectWithData() async throws {
        let data = "hello oss".data(using: .utf8)!
        let dataMd5 = data.calculateMd5().toBase64String()
        let objectKey = randomObjectName()
        var request = PutObjectRequest(bucket: bucketName,
                                       key: objectKey,
                                       body: .data(data))
        request.trafficLimit = 838_860_800
        try await assertNoThrow(await client?.putObject(request))

        let headRequest = HeadObjectRequest(bucket: bucketName,
                                            key: objectKey)
        let headResult = try await client?.headObject(headRequest)
        XCTAssertEqual(headResult?.contentMd5, dataMd5)
    }

    func testPutObjectWithCheckCrc() async throws {
        let data = "hello oss".data(using: .utf8)!
        let dataMd5 = data.calculateMd5().toBase64String()
        let objectKey = randomObjectName()

        let credentialsProvider = StaticCredentialsProvider(accessKeyId: accessKeyId, accessKeySecret: accessKeySecret)
        let config = Configuration.default()
            .withEndpoint(endpoint)
            .withCredentialsProvider(credentialsProvider)
            .withRegion(region)
        let client = Client(config) { $0.featureFlags.insert(.enableCRC64CheckUpload) }

        let request = PutObjectRequest(bucket: bucketName,
                                       key: objectKey,
                                       body: .data(data))
        try await assertNoThrow(await client.putObject(request))

        let headRequest = HeadObjectRequest(bucket: bucketName,
                                            key: objectKey)
        let headResult = try await client.headObject(headRequest)
        XCTAssertEqual(headResult.contentMd5, dataMd5)
    }

    func testPutObjectWithStream() async throws {
        let data = "hello oss".data(using: .utf8)!
        let dataMd5 = data.calculateMd5().toBase64String()
        let objectKey = randomObjectName()
        let inputStream = InputStream(data: data)

        /// waring
        let request = PutObjectRequest(bucket: bucketName,
                                       key: objectKey,
                                       body: .stream(inputStream))

        let result = try await client?.putObject(request)
        XCTAssertEqual(result?.statusCode, 200)

        let headRequest = HeadObjectRequest(bucket: bucketName,
                                            key: objectKey)
        let headResult = try await client!.headObject(headRequest)
        XCTAssertEqual(headResult.statusCode, 200)
        XCTAssertEqual(headResult.contentMd5, dataMd5)
    }

    func testPutObjectWithProgress() async throws {
        let size: Int64 = 300 * 1024 + 12345
        let data = randomStr(Int(size)).data(using: .utf8)!
        let objectKey = randomObjectName()
        nonisolated(unsafe) var totalBytesSented: Int64 = 0
        var request = PutObjectRequest(bucket: bucketName,
                                       key: objectKey,
                                       body: .data(data))
        request.progress = ProgressClosure { bytesSent, totalBytesSent, totalBytesExpectedToSend in
            totalBytesSented += bytesSent
            XCTAssertEqual(totalBytesSented, totalBytesSent)
            XCTAssertEqual(totalBytesExpectedToSend, size)
        }
        let result = try await client?.putObject(request)
        XCTAssertEqual(result?.statusCode, 200)
        XCTAssertEqual(totalBytesSented, size)
    }

    func testPutObjectWithHeader() async throws {
        let data = "hello oss".data(using: .utf8)!
        let dataMd5 = data.calculateMd5().toBase64String()
        let objectKey = randomObjectName()
        let userMeta = ["test-key1": "test-value1",
                        "test-key2": "test-value2"]
        let contentType = "application/octet-stream"
        let contentMD5 = dataMd5
        let contentDisposition = "inline"
        let cacheControl = "no-cache"
        let contentEncoding = "identity"
        let expires = DateFormatter.iso8601DateTimeSeconds.string(from: Date().addingTimeInterval(60 * 60))

        var request = PutObjectRequest(bucket: bucketName,
                                       key: objectKey,
                                       body: .data(data))
        request.contentMd5 = contentMD5
        request.contentType = contentType
        request.contentDisposition = contentDisposition
        request.cacheControl = cacheControl
        request.expires = expires
        request.contentEncoding = contentEncoding

        var metadata: [String: String] = [:]
        for (key, value) in userMeta {
            metadata[key] = value
        }
        request.metadata = metadata
        try await assertNoThrow(await client?.putObject(request))

        let headRequest = HeadObjectRequest(bucket: bucketName, key: objectKey)
        let headResult = try await client?.headObject(headRequest)
        XCTAssertEqual(headResult?.contentMd5, contentMD5)
        XCTAssertEqual(headResult?.contentType, contentType)
        XCTAssertEqual(headResult?.headers?["Content-Disposition"], contentDisposition)
        XCTAssertEqual(headResult?.headers?["Content-Encoding"], contentEncoding)
        XCTAssertEqual(headResult?.headers?["Expires"], expires)
        for (key, value) in userMeta {
            XCTAssertEqual(headResult?.metadata?[key], value)
        }
    }

    func testPutObjectAcl() async throws {
        let objectKey = randomObjectName()
        let acl = "public-read"
        var request = PutObjectRequest(bucket: bucketName,
                                       key: objectKey)
        request.objectAcl = acl
        try await assertNoThrow(await client?.putObject(request))

        let getObjectACLRequest = GetObjectAclRequest(bucket: bucketName,
                                                      key: objectKey)
        let result = try await client?.getObjectAcl(getObjectACLRequest)
        XCTAssertEqual(result?.accessControlPolicy?.accessControlList?.grant, acl)
    }

    func testPutObjectStorageClass() async throws {
        let objectKey = randomObjectName()
        var storageClass = "Standard"
        // TODO: test PutObject with standard StorageClass
        var request = PutObjectRequest(bucket: bucketName,
                                       key: objectKey)
        request.storageClass = storageClass
        var result = try await client?.putObject(request)
        XCTAssertEqual(result?.statusCode, 200)

        var headRequest = HeadObjectRequest(bucket: bucketName,
                                            key: objectKey)
        var headResult = try await client?.headObject(headRequest)
        XCTAssertEqual(headResult?.storageClass, storageClass)
        XCTAssertEqual(headResult?.contentLength, 0)

        // TODO: test PutObject with IA StorageClass
        storageClass = "IA"
        request = PutObjectRequest(bucket: bucketName,
                                   key: objectKey)
        request.storageClass = storageClass
        result = try await client?.putObject(request)
        XCTAssertEqual(result?.statusCode, 200)

        headRequest = HeadObjectRequest(bucket: bucketName,
                                        key: objectKey)
        headResult = try await client?.headObject(headRequest)
        XCTAssertEqual(headResult?.storageClass, storageClass)

        // TODO: test PutObject with archive StorageClass
        storageClass = "Archive"
        request = PutObjectRequest(bucket: bucketName,
                                   key: objectKey)
        request.storageClass = storageClass
        result = try await client?.putObject(request)
        XCTAssertEqual(result?.statusCode, 200)

        headRequest = HeadObjectRequest(bucket: bucketName,
                                        key: objectKey)
        headResult = try await client?.headObject(headRequest)
        XCTAssertEqual(headResult?.storageClass, storageClass)

        // TODO: test PutObject with cArchive StorageClass
        storageClass = "ColdArchive"
        request = PutObjectRequest(bucket: bucketName,
                                   key: objectKey)
        request.storageClass = storageClass
        result = try await client?.putObject(request)
        XCTAssertEqual(result?.statusCode, 200)

        headRequest = HeadObjectRequest(bucket: bucketName,
                                        key: objectKey)
        headResult = try await client?.headObject(headRequest)
        XCTAssertEqual(headResult?.storageClass, storageClass)
    }

    func testPutObjectForbidOverwrite() async throws {
        // test put object when forbidOverwrite is false
        let data = "hello oss".data(using: .utf8)!
        let dataMd5 = data.calculateMd5().toBase64String()
        let objectKey = randomObjectName()
        var request = PutObjectRequest(bucket: bucketName,
                                       key: objectKey,
                                       body: .data(data))
        var result = try await client?.putObject(request)
        XCTAssertEqual(result?.statusCode, 200)

        var headRequest = HeadObjectRequest(bucket: bucketName,
                                            key: objectKey)
        var headResult = try await client?.headObject(headRequest)
        XCTAssertEqual(headResult?.contentMd5, dataMd5)

        request = PutObjectRequest(bucket: bucketName,
                                   key: objectKey)
        result = try await client?.putObject(request)
        XCTAssertEqual(result?.statusCode, 200)

        headRequest = HeadObjectRequest(bucket: bucketName,
                                        key: objectKey)
        headResult = try await client?.headObject(headRequest)
        XCTAssertEqual(headResult?.statusCode, 200)
        XCTAssertEqual(headResult?.contentLength, 0)

        // test put object when forbidOverwrite is true
        request = PutObjectRequest(bucket: bucketName,
                                   key: objectKey,
                                   body: .data(data))
        request.forbidOverwrite = true
        try await assertThrowsAsyncError(await client?.putObject(request)) { error in
            switch error {
            case let serverError as ServerError:
                XCTAssertEqual(serverError.statusCode, 409)
            default:
                XCTFail()
            }
        }
    }

    func testPutObjectWithCallback() async throws {
        let data = "hello oss".data(using: .utf8)!
        let objectKey = randomObjectName()
        var request = PutObjectRequest(bucket: bucketName,
                                       key: objectKey,
                                       body: .data(data))
        try await assertNoThrow(await client?.putObject(request))
        
        request = PutObjectRequest(bucket: bucketName,
                                       key: objectKey,
                                       body: .data(data))
        request.callback = Callback(callbackUrl: "https://www.callback.com",
                                    callbackBody: "bucket=${bucket}").toDictionary().toBase64JsonString()
        let result = try await client?.putObject(request)
        XCTAssertEqual(result?.statusCode, 203)
        
    }

    func testPutObjectAndCancel() async throws {
        let objectKey = randomObjectName()
        let file = createTestFile(objectKey, 5 * 1024 * 1024)
        let request = PutObjectRequest(bucket: bucketName,
                                       key: objectKey,
                                       body: .file(URL(fileURLWithPath: file!)))
        let task1 = Task {
            try await assertThrowsAsyncError(await client?.putObject(request)) { error in
                XCTAssertTrue(error is CancellationError)
            }
        }
        task1.cancel()
        let _ = await task1.result

        let task2 = Task {
            try await assertThrowsAsyncError(await client?.putObject(request)) { error in
                XCTAssertTrue(error is CancellationError)
            }
        }
        DispatchQueue(label: "put").async {
            Thread.sleep(forTimeInterval: 0.1)
            task2.cancel()
            print("cancel")
        }
        let _ = await task2.result

        removeTestFile(file!)
    }

    func testPutObjectWithClientError() async throws {
        let data = "hello oss".data(using: .utf8)!
        let objectKey = randomObjectName()
        let request = PutObjectRequest(bucket: "thin-ios-test_",
                                       key: objectKey,
                                       body: .data(data))
        try await assertThrowsAsyncError(await client?.putObject(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Bucket name is invalid, got thin-ios-test_.", clientError?.message)
        }
    }

    func testPutObjectWithServerError() async throws {
        let objectKey = randomObjectName()
        let data = "hello oss".data(using: .utf8)!
        let request = PutObjectRequest(bucket: "thin-ios-test1",
                                       key: objectKey,
                                       body: .data(data))
        try await assertThrowsAsyncError(await client?.putObject(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }

    // MARK: - test getObject

    func testGetObject() async throws {
        let objectKey = randomObjectName()
        let data = "hello oss".data(using: .utf8)!
        let putRequest = PutObjectRequest(bucket: bucketName,
                                          key: objectKey,
                                          body: .data(data))
        let putResult = try await client?.putObject(putRequest)
        XCTAssertEqual(putResult?.statusCode, 200)

        let getRequest = GetObjectRequest(bucket: bucketName,
                                          key: objectKey)
        let getResult = try await client?.getObject(getRequest)
        XCTAssertEqual(getResult?.statusCode, 200)
        XCTAssertEqual(data.calculateMd5().toBase64String(), try getResult?.body?.readData()?.calculateMd5().base64EncodedString())
    }

    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    func testGetObjectWithWrongPath() async throws {
        let objectKey = FileName.middle.rawValue
        let data = "hello oss".data(using: .utf8)!
        var downloadFile = URL(string: "/etc/ccc.zip")!
        let putRequest = PutObjectRequest(bucket: bucketName,
                                          key: objectKey,
                                          body: .data(data))
        let putResult = try await client?.putObject(putRequest)
        XCTAssertEqual(putResult?.statusCode, 200)

        var getRequest = GetObjectRequest(bucket: bucketName,
                                          key: objectKey)
        try await assertThrowsAsyncError(await client?.getObjectToFile(getRequest, downloadFile))

        downloadFile = URL(string: "/etc/aaa/bbb/ccc.zip")!
        getRequest = GetObjectRequest(bucket: bucketName,
                                      key: objectKey)
        try await assertThrowsAsyncError(await client?.getObjectToFile(getRequest, downloadFile))

        downloadFile = URL(fileURLWithPath: tempDir + pathSeparator + "file")
        let directory = downloadFile.deletingLastPathComponent().absoluteString.replacingOccurrences(of: "file://", with: "")
        if !FileManager.default.fileExists(atPath: directory) {
            try FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true)
        }
        if FileManager.default.fileExists(atPath: downloadFile.absoluteString.replacingOccurrences(of: "file://", with: "")) {
            try FileManager.default.removeItem(at: downloadFile)
        }
        getRequest = GetObjectRequest(bucket: bucketName,
                                      key: objectKey)
        try await assertNoThrow(await client?.getObjectToFile(getRequest, downloadFile))

        try FileManager.default.removeItem(at: downloadFile)
    }

    func testGetObjectWithRange() async throws {
        let objectKey = randomObjectName()
        let data = randomStr(150).data(using: .utf8)!
        let putRequest = PutObjectRequest(bucket: bucketName,
                                          key: objectKey,
                                          body: .data(data))
        let putResult = try await client?.putObject(putRequest)
        XCTAssertEqual(putResult?.statusCode, 200)

        var getRequest = GetObjectRequest(bucket: bucketName,
                                          key: objectKey)
        getRequest.range = Range(start: 0, end: 10).asString()
        var getResult = try await client?.getObject(getRequest)

        XCTAssertEqual(getResult?.statusCode, 206)
        var md5 = data.subdata(in: 0 ..< 11).calculateMd5().toBase64String()
        var md = try getResult?.body?.readData()?.calculateMd5().toBase64String()
        XCTAssertEqual(md5, md)

        getRequest = GetObjectRequest(bucket: bucketName,
                                      key: objectKey)
        getRequest.range = Range.from(10).asString()
        getResult = try await client?.getObject(getRequest)

        XCTAssertEqual(getResult?.statusCode, 206)
        md5 = data.subdata(in: 10 ..< data.count).calculateMd5().toBase64String()
        md = try getResult?.body?.readData()?.calculateMd5().toBase64String()
        XCTAssertEqual(md5, md)

        getRequest = GetObjectRequest(bucket: bucketName,
                                      key: objectKey)
        getRequest.range = Range.to(100).asString()
        getResult = try await client?.getObject(getRequest)

        XCTAssertEqual(getResult?.statusCode, 206)
        md5 = data.subdata(in: 0 ..< 101).calculateMd5().toBase64String()
        md = try getResult?.body?.readData()?.calculateMd5().toBase64String()
        XCTAssertEqual(md5, md)
    }

    func testConcurrencyGetObject() async throws {
        let objectKey = randomObjectName()
        let bucket = bucketName
        let client = self.client
        let data = "hello oss".data(using: .utf8)!
        let md5 = data.calculateMd5().toBase64String()
        let putRequest = PutObjectRequest(bucket: bucketName,
                                          key: objectKey,
                                          body: .data(data))
        let putResult = try await client?.putObject(putRequest)
        XCTAssertEqual(putResult?.statusCode, 200)

        await withThrowingTaskGroup(of: Void.self) {
            for _ in 0 ..< 10 {
                $0.addTask {
                    let getRequest = GetObjectRequest(bucket: bucket,
                                                      key: objectKey)
                    let result = try await client?.getObject(getRequest)
                    XCTAssertEqual(result?.statusCode, 200)
                    let md = try result?.body?.readData()?.calculateMd5().toBase64String()
                    XCTAssertEqual(md, md5)
                }
            }
        }
    }

    func testSerialGetObject() async throws {
        let objectKey = randomObjectName()
        let data = "hello oss".data(using: .utf8)!

        let putRequest = PutObjectRequest(bucket: bucketName,
                                          key: objectKey,
                                          body: .data(data))
        let putResult = try await client?.putObject(putRequest)
        XCTAssertEqual(putResult?.statusCode, 200)

        for _ in 0 ..< 10 {
            let getRequest = GetObjectRequest(bucket: bucketName,
                                              key: objectKey)
            let result = try await client?.getObject(getRequest)
            XCTAssertEqual(result?.statusCode, 200)
            let md5 = data.calculateMd5().toBase64String()
            let md = try result?.body?.readData()?.calculateMd5().toBase64String()
            XCTAssertEqual(md, md5)
        }
    }

    func testGetObjectAndCheckCRC() async throws {
        let objectKey = randomObjectName()
        let data = "hello oss".data(using: .utf8)!

        let credentialsProvider = StaticCredentialsProvider(accessKeyId: accessKeyId, accessKeySecret: accessKeySecret)
        let config = Configuration.default()
            .withEndpoint(endpoint)
            .withCredentialsProvider(credentialsProvider)
            .withRegion(region)
        let client = Client(config) { $0.featureFlags.insert(.enableCRC64CheckDownload) }

        let putRequest = PutObjectRequest(bucket: bucketName,
                                          key: objectKey,
                                          body: .data(data))
        let putResult = try await client.putObject(putRequest)
        XCTAssertEqual(putResult.statusCode, 200)

        let getRequest = GetObjectRequest(bucket: bucketName,
                                          key: objectKey)
        let getResult = try await client.getObject(getRequest)

        XCTAssertEqual(getResult.statusCode, 200)
        let md5 = data.calculateMd5().toBase64String()
        let md = try getResult.body?.readData()?.calculateMd5().toBase64String()
        XCTAssertEqual(md, md5)
    }

    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    func testGetObjectAndCheckCRCWithFile() async throws {
        let objectKey = randomObjectName()
        let filePath = URL(fileURLWithPath: tempDir + pathSeparator + "file")
        let data = "hello oss".data(using: .utf8)!

        let credentialsProvider = StaticCredentialsProvider(accessKeyId: accessKeyId, accessKeySecret: accessKeySecret)
        let config = Configuration.default()
            .withEndpoint(endpoint)
            .withCredentialsProvider(credentialsProvider)
            .withRegion(region)
        let client = Client(config) { $0.featureFlags.insert(.enableCRC64CheckDownload) }

        let putRequest = PutObjectRequest(bucket: bucketName,
                                          key: objectKey,
                                          body: .data(data))
        let putResult = try await client.putObject(putRequest)
        XCTAssertEqual(putResult.statusCode, 200)

        let directory = filePath.deletingLastPathComponent().absoluteString.replacingOccurrences(of: "file://", with: "")
        if !FileManager.default.fileExists(atPath: directory) {
            try FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true)
        }
        if FileManager.default.fileExists(atPath: filePath.absoluteString.replacingOccurrences(of: "file://", with: "")) {
            try FileManager.default.removeItem(at: filePath)
        }

        let getRequest = GetObjectRequest(bucket: bucketName,
                                          key: objectKey)
        let getResult = try await client.getObjectToFile(getRequest, filePath)

        XCTAssertEqual(getResult.statusCode, 200)
        XCTAssertEqual(try Data(contentsOf: filePath).calculateMd5(), data.calculateMd5())

        try FileManager.default.removeItem(at: filePath)
    }

    func testGetObjectWithModifiedSince() async throws {
        let objectKey = randomObjectName()
        let data = "hello oss".data(using: .utf8)!

        let putRequest = PutObjectRequest(bucket: bucketName,
                                          key: objectKey,
                                          body: .data(data))
        let putResult = try await client?.putObject(putRequest)
        XCTAssertEqual(putResult?.statusCode, 200)

        var getRequest = GetObjectRequest(bucket: bucketName,
                                          key: objectKey)
        getRequest.ifModifiedSince = DateFormatter.rfc5322DateTime.string(from: Date().addingTimeInterval(-60 * 60))
        let getResult = try await client?.getObject(getRequest)

        XCTAssertEqual(getResult?.statusCode, 200)
        let md5 = data.calculateMd5().toBase64String()
        let md = try getResult?.body?.readData()?.calculateMd5().toBase64String()
        XCTAssertEqual(md, md5)

        getRequest = GetObjectRequest(bucket: bucketName,
                                      key: objectKey)
        getRequest.ifModifiedSince = DateFormatter.rfc5322DateTime.string(from: Date().addingTimeInterval(160 * 60))
        try await assertThrowsAsyncError(await client?.getObject(getRequest)) { error in
            let serverError = error as! ServerError
            XCTAssertEqual(serverError.statusCode, 304)
        }
    }

    func testGetObjectWithUnmodifiedSince() async throws {
        let objectKey = randomObjectName()
        let data = "hello oss".data(using: .utf8)!

        let putRequest = PutObjectRequest(bucket: bucketName,
                                          key: objectKey,
                                          body: .data(data))
        let putResult = try await client?.putObject(putRequest)
        XCTAssertEqual(putResult?.statusCode, 200)

        var getRequest = GetObjectRequest(bucket: bucketName,
                                          key: objectKey)
        getRequest.ifUnmodifiedSince = DateFormatter.rfc5322DateTime.string(from: Date().addingTimeInterval(60 * 60))
        let getResult = try await client?.getObject(getRequest)

        XCTAssertEqual(getResult?.statusCode, 200)
        let md5 = data.calculateMd5().toBase64String()
        let md = try getResult?.body?.readData()?.calculateMd5().toBase64String()
        XCTAssertEqual(md, md5)

        getRequest = GetObjectRequest(bucket: bucketName,
                                      key: objectKey)
        getRequest.ifUnmodifiedSince = DateFormatter.rfc5322DateTime.string(from: Date().addingTimeInterval(-60 * 60))
        try await assertThrowsAsyncError(await client?.getObject(getRequest)) { error in
            let serverError = error as! ServerError
            XCTAssertEqual(serverError.statusCode, 412)
        }
    }

    func testGetObjectWithMatchingETag() async throws {
        let objectKey = randomObjectName()
        let data = "hello oss".data(using: .utf8)!

        let putRequest = PutObjectRequest(bucket: bucketName,
                                          key: objectKey,
                                          body: .data(data))
        let putResult = try await client?.putObject(putRequest)
        XCTAssertEqual(putResult?.statusCode, 200)

        let headRequest = HeadObjectRequest(bucket: bucketName, key: objectKey)
        let headResult = try await client?.headObject(headRequest)

        var getRequest = GetObjectRequest(bucket: bucketName,
                                          key: objectKey)
        getRequest.ifMatch = [headResult!.etag!].joined(separator: ",")
        let getResult = try await client?.getObject(getRequest)

        XCTAssertEqual(getResult?.statusCode, 200)
        let md5 = data.calculateMd5().toBase64String()
        let md = try getResult?.body?.readData()?.calculateMd5().toBase64String()
        XCTAssertEqual(md, md5)

        getRequest = GetObjectRequest(bucket: bucketName,
                                      key: objectKey)
        getRequest.ifMatch = ["errorEtag"].joined(separator: ",")
        try await assertThrowsAsyncError(await client?.getObject(getRequest)) { error in
            let serverError = error as! ServerError
            XCTAssertEqual(serverError.statusCode, 412)
        }
    }

    func testGetObjectWithNomatchingETag() async throws {
        let objectKey = randomObjectName()
        let data = "hello oss".data(using: .utf8)!

        let putRequest = PutObjectRequest(bucket: bucketName,
                                          key: objectKey,
                                          body: .data(data))
        let putResult = try await client?.putObject(putRequest)
        XCTAssertEqual(putResult?.statusCode, 200)

        let headRequest = HeadObjectRequest(bucket: bucketName, key: objectKey)
        let headResult = try await client?.headObject(headRequest)

        var getRequest = GetObjectRequest(bucket: bucketName,
                                          key: objectKey)
        getRequest.ifNoneMatch = ["errorEtag"].joined(separator: ",")
        let getResult = try await client?.getObject(getRequest)

        XCTAssertEqual(getResult?.statusCode, 200)
        let md5 = data.calculateMd5().toBase64String()
        let md = try getResult?.body?.readData()?.calculateMd5().toBase64String()
        XCTAssertEqual(md, md5)

        getRequest = GetObjectRequest(bucket: bucketName,
                                      key: objectKey)
        getRequest.ifNoneMatch = [headResult!.etag!].joined(separator: ",")
        try await assertThrowsAsyncError(await client?.getObject(getRequest)) { error in
            let serverError = error as! ServerError
            XCTAssertEqual(serverError.statusCode, 304)
        }
    }

    // MARK: - test copyObject

    func testCopyObject() async throws {
        let objectKey = "copyTestFile"
        let sourceObjectKey = "copyTestSourceFile"

        let data = "hello oss".data(using: .utf8)!
        let request = PutObjectRequest(bucket: bucketName,
                                       key: sourceObjectKey,
                                       body: .data(data))
        try await assertNoThrow(await client?.putObject(request))

        var copyRequest = CopyObjectRequest(bucket: bucketName,
                                            key: objectKey,
                                            sourceBucket: bucketName,
                                            sourceKey: sourceObjectKey)
        copyRequest.trafficLimit = 838_860_800
        let copyResult = try await client?.copyObject(copyRequest)
        XCTAssertEqual(copyResult?.statusCode, 200)
        XCTAssertNotNil(copyResult?.etag)
        XCTAssertNotNil(copyResult?.lastModified)
    }

    func testCopyObjectWithoutSourceObject() async throws {
        let objectKey = "copyTestFile"
        let sourceObjectKey = "copyTestSourceFile"

        if try await client!.isObjectExist(bucketName, sourceObjectKey) {
            let deleteObject = DeleteObjectRequest(bucket: bucketName, key: sourceObjectKey)
            let deleteResult = try await client?.deleteObject(deleteObject)
            XCTAssertEqual(deleteResult?.statusCode, 204)
        }

        let copyRequest = CopyObjectRequest(bucket: bucketName,
                                            key: objectKey,
                                            sourceBucket: bucketName,
                                            sourceKey: sourceObjectKey)

        try await assertThrowsAsyncError(await client?.copyObject(copyRequest)) { error in
            XCTAssertEqual((error as! ServerError).statusCode, 404)
        }
    }

    func testCopyObjectWithHeader() async throws {
        let data = "hello oss".data(using: .utf8)!
        let sourceObjectKey = "copyTestSourceFile"
        let targetObjectKey = "copyTestTargetFile"
        let beforTime = Date(timeIntervalSince1970: Date().timeIntervalSince1970 - 60)
        let userMetaData = ["originalKey": "originalValue"]

        var request = PutObjectRequest(bucket: bucketName,
                                       key: sourceObjectKey,
                                       body: .data(data))
        request.metadata = userMetaData
        var result = try await client?.putObject(request)
        XCTAssertEqual(result?.statusCode, 200)

        request = PutObjectRequest(bucket: bucketName,
                                   key: targetObjectKey,
                                   body: .data(data))
        result = try await client?.putObject(request)
        XCTAssertEqual(result?.statusCode, 200)

        // TODO: test x-oss-forbid-overwrite
        var copyRequest = CopyObjectRequest(bucket: bucketName,
                                            key: targetObjectKey,
                                            sourceBucket: bucketName,
                                            sourceKey: sourceObjectKey)
        copyRequest.forbidOverwrite = true
        do {
            let _ = try await client?.copyObject(copyRequest)
        } catch {
            switch error {
            case let serverError as ServerError:
                XCTAssertEqual(serverError.statusCode, 409)
            default:
                XCTFail("Test x-oss-forbid-overwrite fail, it should throw server error")
            }
        }

        // TODO: test x-oss-copy-source-if-match
        copyRequest = CopyObjectRequest(bucket: bucketName,
                                        key: targetObjectKey,
                                        sourceBucket: bucketName,
                                        sourceKey: sourceObjectKey)
        copyRequest.copySourceIfMatch = result?.etag
        var copyResult = try await client?.copyObject(copyRequest)
        XCTAssertEqual(copyResult?.statusCode, 200)

        copyRequest = CopyObjectRequest(bucket: bucketName,
                                        key: targetObjectKey,
                                        sourceBucket: bucketName,
                                        sourceKey: sourceObjectKey)
        copyRequest.copySourceIfMatch = "-6D81B360A5672D80C27430F39153E2C"
        do {
            let _ = try await client?.copyObject(copyRequest)
        } catch {
            switch error {
            case let serverError as ServerError:
                XCTAssertEqual(serverError.statusCode, 412)
            default:
                XCTFail("Test x-oss-copy-source-if-match fail, it should throw server error")
            }
        }

        // TODO: test x-oss-copy-source-if-none-match
        copyRequest = CopyObjectRequest(bucket: bucketName,
                                        key: targetObjectKey,
                                        sourceBucket: bucketName,
                                        sourceKey: sourceObjectKey)
        copyRequest.copySourceIfNoneMatch = result?.etag
        do {
            let _ = try await client?.copyObject(copyRequest)
        } catch {
            switch error {
            case let serverError as ServerError:
                XCTAssertEqual(serverError.statusCode, 304)
            default:
                XCTFail("Test x-oss-copy-source-if-none-match fail, it should throw server error")
            }
        }

        copyRequest = CopyObjectRequest(bucket: bucketName,
                                        key: targetObjectKey,
                                        sourceBucket: bucketName,
                                        sourceKey: sourceObjectKey)
        copyRequest.copySourceIfNoneMatch = "-6D81B360A5672D80C27430F39153E2C"
        copyResult = try await client?.copyObject(copyRequest)
        XCTAssertEqual(copyResult?.statusCode, 200)

        // TODO: test x-oss-copy-source-if-unmodified-since
        copyRequest = CopyObjectRequest(bucket: bucketName,
                                        key: targetObjectKey,
                                        sourceBucket: bucketName,
                                        sourceKey: sourceObjectKey)
        copyRequest.copySourceIfUnmodifiedSince = DateFormatter.rfc5322DateTime.string(from: Date())
        copyResult = try await client?.copyObject(copyRequest)
        XCTAssertEqual(copyResult?.statusCode, 200)

        copyRequest = CopyObjectRequest(bucket: bucketName,
                                        key: targetObjectKey,
                                        sourceBucket: bucketName,
                                        sourceKey: sourceObjectKey)
        copyRequest.copySourceIfUnmodifiedSince = DateFormatter.rfc5322DateTime.string(from: beforTime)
        do {
            let _ = try await client?.copyObject(copyRequest)
        } catch {
            switch error {
            case let serverError as ServerError:
                XCTAssertEqual(serverError.statusCode, 412)
            default:
                XCTFail("Test x-oss-copy-source-if-unmodified-since fail, it should throw server error")
            }
        }

        // TODO: test x-oss-copy-source-if-modified-since
        copyRequest = CopyObjectRequest(bucket: bucketName,
                                        key: targetObjectKey,
                                        sourceBucket: bucketName,
                                        sourceKey: sourceObjectKey)
        copyRequest.copySourceIfModifiedSince = DateFormatter.rfc5322DateTime.string(from: Date())
        do {
            let _ = try await client?.copyObject(copyRequest)
        } catch {
            switch error {
            case let serverError as ServerError:
                XCTAssertEqual(serverError.statusCode, 304)
            default:
                XCTFail("Test x-oss-copy-source-if-modified-since fail, it should throw server error")
            }
        }

        copyRequest = CopyObjectRequest(bucket: bucketName,
                                        key: targetObjectKey,
                                        sourceBucket: bucketName,
                                        sourceKey: sourceObjectKey)
        copyRequest.copySourceIfModifiedSince = DateFormatter.rfc5322DateTime.string(from: beforTime)

        copyResult = try await client?.copyObject(copyRequest)
        XCTAssertEqual(copyResult?.statusCode, 200)

        // TODO: test x-oss-metadata-directive
        copyRequest = CopyObjectRequest(bucket: bucketName,
                                        key: targetObjectKey,
                                        sourceBucket: bucketName,
                                        sourceKey: sourceObjectKey)
        copyRequest.metadataDirective = "copy"
        copyResult = try await client?.copyObject(copyRequest)
        XCTAssertEqual(copyResult?.statusCode, 200)

        var headRequest = HeadObjectRequest(bucket: bucketName, key: targetObjectKey)
        var headResult = try await client?.headObject(headRequest)
        for (key, value) in userMetaData {
            XCTAssertEqual(value, headResult?.metadata?[key.lowercased()])
        }

        copyRequest = CopyObjectRequest(bucket: bucketName,
                                        key: targetObjectKey,
                                        sourceBucket: bucketName,
                                        sourceKey: sourceObjectKey)
        copyRequest.metadata = ["newKey": "newValue"]
        copyRequest.metadataDirective = "replace"
        copyResult = try await client?.copyObject(copyRequest)
        XCTAssertEqual(copyResult?.statusCode, 200)

        headRequest = HeadObjectRequest(bucket: bucketName, key: targetObjectKey)
        headResult = try await client?.headObject(headRequest)
        for (key, _) in userMetaData {
            XCTAssertNil(headResult?.metadata?[key.lowercased()])
        }
        for (key, value) in copyRequest.metadata! {
            XCTAssertEqual(value, headResult?.metadata?[key.lowercased()])
        }

        // common header
        let contentType = "application/octet-stream"
        let contentMD5 = data.calculateMd5().toBase64String()
        let contentDisposition = "inline"
        let cacheControl = "no-cache"
        let contentEncoding = "identity"
        let expires = DateFormatter.iso8601DateTimeSeconds.string(from: Date().addingTimeInterval(60 * 60))
        copyRequest = CopyObjectRequest(bucket: bucketName,
                                        key: targetObjectKey,
                                        sourceBucket: bucketName,
                                        sourceKey: sourceObjectKey)
        copyRequest.contentMd5 = contentMD5
        copyRequest.contentType = contentType
        copyRequest.contentDisposition = contentDisposition
        copyRequest.cacheControl = cacheControl
        copyRequest.expires = expires
        copyRequest.contentEncoding = contentEncoding
        copyRequest.metadataDirective = "REPLACE"
        copyResult = try await client?.copyObject(copyRequest)
        XCTAssertEqual(copyResult?.statusCode, 200)

        headRequest = HeadObjectRequest(bucket: bucketName, key: targetObjectKey)
        headResult = try await client?.headObject(headRequest)
        XCTAssertEqual(headResult?.contentMd5, contentMD5)
        XCTAssertEqual(headResult?.contentType, contentType)
        XCTAssertEqual(headResult?.cacheControl, cacheControl)
        XCTAssertEqual(headResult?.contentDisposition, contentDisposition)
        XCTAssertEqual(headResult?.contentEncoding, contentEncoding)
        XCTAssertEqual(headResult?.expires, expires)
    }

    func testCopyObjectWithACL() async throws {
        let data = "hello oss".data(using: .utf8)!
        let sourceObjectKey = "copyTestSourceFile"
        let targetObjectKey = "copyTestTargetFile"
        let acls = ["default", "private", "public-read", "public-read-write"]

        var request = PutObjectRequest(bucket: bucketName,
                                       key: sourceObjectKey,
                                       body: .data(data))
        request.metadata = ["originalKey": "originalValue"]
        var result = try await client?.putObject(request)
        XCTAssertEqual(result?.statusCode, 200)

        request = PutObjectRequest(bucket: bucketName,
                                   key: targetObjectKey,
                                   body: .data(data))
        result = try await client?.putObject(request)
        XCTAssertEqual(result?.statusCode, 200)

        for acl in acls {
            var copyRequest = CopyObjectRequest(bucket: bucketName,
                                                key: targetObjectKey,
                                                sourceBucket: bucketName,
                                                sourceKey: sourceObjectKey)
            copyRequest.objectAcl = acl
            let copyResult = try await client?.copyObject(copyRequest)
            XCTAssertEqual(copyResult?.statusCode, 200)

            let getACLRequest = GetObjectAclRequest(bucket: bucketName,
                                                    key: targetObjectKey)
            let getACLResult = try await client?.getObjectAcl(getACLRequest)
            XCTAssertEqual(acl, getACLResult?.accessControlPolicy?.accessControlList?.grant)
        }
    }

    func testCopyObjectWithStorageClass() async throws {
        let data = "hello oss".data(using: .utf8)!
        let sourceObjectKey = "copyTestSourceFile"
        let targetObjectKey = "copyTestTargetFile"
        let storageClasses = ["IA", "Archive", "ColdArchive", "DeepColdArchive", "Standard"]

        var request = PutObjectRequest(bucket: bucketName,
                                       key: sourceObjectKey,
                                       body: .data(data))
        request.metadata = ["originalKey": "originalValue"]
        var result = try await client?.putObject(request)
        XCTAssertEqual(result?.statusCode, 200)

        request = PutObjectRequest(bucket: bucketName,
                                   key: targetObjectKey,
                                   body: .data(data))
        result = try await client?.putObject(request)
        XCTAssertEqual(result?.statusCode, 200)

        for storageClass in storageClasses {
            var copyRequest = CopyObjectRequest(bucket: bucketName,
                                                key: targetObjectKey,
                                                sourceBucket: bucketName,
                                                sourceKey: sourceObjectKey)
            copyRequest.storageClass = storageClass
            let copyResult = try await client?.copyObject(copyRequest)
            XCTAssertEqual(copyResult?.statusCode, 200)

            let headRequest = HeadObjectRequest(bucket: bucketName, key: targetObjectKey)
            let headResult = try await client?.headObject(headRequest)
            XCTAssertEqual(storageClass, headResult?.storageClass)
        }
    }

    func testCopyObjectWithTagging() async throws {
        let data = "hello oss".data(using: .utf8)!
        let sourceObjectKey = "copyTestSourceFile"
        let targetObjectKey = "copyTestTargetFile"
        let tagging: [String: String] = ["a": "b",
                                         "c": "d"]

        var request = PutObjectRequest(bucket: bucketName,
                                       key: sourceObjectKey,
                                       body: .data(data))
        request.metadata = ["originalKey": "originalValue"]
        var result = try await client?.putObject(request)
        XCTAssertEqual(result?.statusCode, 200)

        request = PutObjectRequest(bucket: bucketName,
                                   key: targetObjectKey,
                                   body: .data(data))
        result = try await client?.putObject(request)
        XCTAssertEqual(result?.statusCode, 200)

        var copyRequest = CopyObjectRequest(bucket: bucketName,
                                            key: targetObjectKey,
                                            sourceBucket: bucketName,
                                            sourceKey: sourceObjectKey)
        copyRequest.tagging = tagging.encodedQuery()
        var copyResult = try await client?.copyObject(copyRequest)
        XCTAssertEqual(copyResult?.statusCode, 200)

        copyRequest = CopyObjectRequest(bucket: bucketName,
                                        key: targetObjectKey,
                                        sourceBucket: bucketName,
                                        sourceKey: sourceObjectKey)
        copyRequest.tagging = tagging.encodedQuery()
        copyRequest.taggingDirective = "replace"
        copyResult = try await client?.copyObject(copyRequest)
        XCTAssertEqual(copyResult?.statusCode, 200)
    }

    // MARK: - test headObject

    func testHeadObject() async throws {
        let objectKey = randomObjectName()
        let data = "hello oss".data(using: .utf8)!
        let userMeta = ["test-key1": "test-value1",
                        "test-key2": "test-value2"]
        let contentType = "application/octet-stream"
        let contentMD5 = data.calculateMd5().toBase64String()
        let contentDisposition = "inline"
        let cacheControl = "no-cache"
        let contentEncoding = "identity"
        let expires = DateFormatter.iso8601DateTimeSeconds.string(from: Date().addingTimeInterval(60 * 60))

        var request = PutObjectRequest(bucket: bucketName,
                                       key: objectKey,
                                       body: .data(data))
        request.addHeader(Headers.contentType.rawValue, contentType)
        request.addHeader(Headers.contentMD5.rawValue, contentMD5)
        request.addHeader(Headers.contentDisposition.rawValue, contentDisposition)
        request.addHeader(Headers.cacheControl.rawValue, cacheControl)
        request.addHeader(Headers.contentEncoding.rawValue, contentEncoding)
        request.addHeader(Headers.expires.rawValue, expires)
        request.metadata = userMeta

        let result = try await client?.putObject(request)
        XCTAssertEqual(result?.statusCode, 200)

        let headRequest = HeadObjectRequest(bucket: bucketName, key: objectKey)
        let headResult = try await client?.headObject(headRequest)
        XCTAssertEqual(headResult?.contentMd5, contentMD5)
        XCTAssertEqual(headResult?.headers?[Headers.contentType.rawValue], contentType)
        XCTAssertEqual(headResult?.headers?[Headers.contentDisposition.rawValue], contentDisposition)
        XCTAssertEqual(headResult?.headers?[Headers.contentEncoding.rawValue], contentEncoding)
        XCTAssertEqual(headResult?.headers?[Headers.expires.rawValue], expires)
        for (key, value) in userMeta {
            XCTAssertEqual(headResult?.metadata?[key], value)
        }
    }

    func testHeadObjectWithModifiedSince() async throws {
        let objectKey = randomObjectName()
        let data = "hello oss".data(using: .utf8)!
        let putRequest = PutObjectRequest(bucket: bucketName,
                                          key: objectKey,
                                          body: .data(data))
        let putResult = try await client?.putObject(putRequest)
        XCTAssertEqual(putResult?.statusCode, 200)

        var headRequest = HeadObjectRequest(bucket: bucketName, key: objectKey)
        headRequest.ifModifiedSince = DateFormatter.rfc5322DateTime.string(from: Date().addingTimeInterval(-60 * 60))
        let headResult = try await client?.headObject(headRequest)

        XCTAssertEqual(headResult?.statusCode, 200)

        headRequest = HeadObjectRequest(bucket: bucketName, key: objectKey)
        headRequest.ifModifiedSince = DateFormatter.rfc5322DateTime.string(from: Date().addingTimeInterval(60 * 60))
        try await assertThrowsAsyncError(await client?.headObject(headRequest)) { error in
            let serverError = error as! ServerError
            XCTAssertEqual(serverError.statusCode, 304)
        }
    }

    func testHeadObjectWithUnmodifiedSince() async throws {
        let objectKey = randomObjectName()
        let data = "hello oss".data(using: .utf8)!
        let putRequest = PutObjectRequest(bucket: bucketName,
                                          key: objectKey,
                                          body: .data(data))
        let putResult = try await client?.putObject(putRequest)
        XCTAssertEqual(putResult?.statusCode, 200)

        var headRequest = HeadObjectRequest(bucket: bucketName, key: objectKey)
        headRequest.ifUnmodifiedSince = DateFormatter.rfc5322DateTime.string(from: Date().addingTimeInterval(60 * 60))
        let headResult = try await client?.headObject(headRequest)

        XCTAssertEqual(headResult?.statusCode, 200)

        headRequest = HeadObjectRequest(bucket: bucketName, key: objectKey)
        headRequest.ifUnmodifiedSince = DateFormatter.rfc5322DateTime.string(from: Date().addingTimeInterval(-60 * 60))
        try await assertThrowsAsyncError(await client?.headObject(headRequest)) { error in
            let serverError = error as! ServerError
            XCTAssertEqual(serverError.statusCode, 412)
        }
    }

    func testHeadObjectWithMatchingETag() async throws {
        let objectKey = randomObjectName()
        let data = "hello oss".data(using: .utf8)!
        let putRequest = PutObjectRequest(bucket: bucketName,
                                          key: objectKey,
                                          body: .data(data))
        let putResult = try await client?.putObject(putRequest)
        XCTAssertEqual(putResult?.statusCode, 200)

        let headRequest = HeadObjectRequest(bucket: bucketName, key: objectKey)
        let headResult = try await client?.headObject(headRequest)

        var request = HeadObjectRequest(bucket: bucketName, key: objectKey)
        request.ifMatch = headResult!.etag!
        let result = try await client?.headObject(request)

        XCTAssertEqual(result?.statusCode, 200)

        request = HeadObjectRequest(bucket: bucketName, key: objectKey)
        request.ifMatch = "errorEtag"
        try await assertThrowsAsyncError(await client?.headObject(request)) { error in
            let serverError = error as! ServerError
            XCTAssertEqual(serverError.statusCode, 412)
        }
    }

    func testHeadObjectWithNomatchingETag() async throws {
        let objectKey = randomObjectName()
        let data = "hello oss".data(using: .utf8)!
        let putRequest = PutObjectRequest(bucket: bucketName,
                                          key: objectKey,
                                          body: .data(data))
        let putResult = try await client?.putObject(putRequest)
        XCTAssertEqual(putResult?.statusCode, 200)

        let headRequest = HeadObjectRequest(bucket: bucketName, key: objectKey)
        let headResult = try await client?.headObject(headRequest)

        var request = HeadObjectRequest(bucket: bucketName, key: objectKey)
        request.ifNoneMatch = "errorEtag"
        let result = try await client?.headObject(request)

        XCTAssertEqual(result?.statusCode, 200)

        request = HeadObjectRequest(bucket: bucketName, key: objectKey)
        request.ifNoneMatch = headResult!.etag!
        try await assertThrowsAsyncError(await client?.headObject(request)) { error in
            let serverError = error as! ServerError
            XCTAssertEqual(serverError.statusCode, 304)
        }
    }

    // MARK: - test appendObject

    func testAppendObject() async throws {
        let objectKey = "testAppendFile"
        let data = "hello oss".data(using: .utf8)!
        let size = 2
        var uploadedSize = 0
        var crc: UInt64 = 0

        var deleteReqeust = DeleteObjectRequest(bucket: bucketName, key: objectKey)
        let _ = try await client?.deleteObject(deleteReqeust)

        repeat {
            let request = AppendObjectRequest(bucket: bucketName,
                                              key: objectKey,
                                              position: uploadedSize,
                                              body: .data(data.subdata(in: uploadedSize ..< ((uploadedSize + size) < data.count ? (uploadedSize + size) : data.count))),
                                              initHashCrc64: crc)
            let result = try await client?.appendObject(request)
            XCTAssertEqual(result?.statusCode, 200)
            XCTAssertNotNil(result?.nextAppendPosition)
            XCTAssertNotNil(result?.hashCrc64ecma)
            crc = result!.hashCrc64ecma!
            uploadedSize += size
        } while uploadedSize < data.count

        let getRequest = GetObjectRequest(bucket: bucketName,
                                          key: objectKey)
        let getResult = try await client?.getObject(getRequest)
        XCTAssertEqual(getResult?.statusCode, 200)
        XCTAssertEqual(data.calculateMd5(), try getResult?.body?.readData()?.calculateMd5())

        deleteReqeust = DeleteObjectRequest(bucket: bucketName, key: objectKey)
        let _ = try await client?.deleteObject(deleteReqeust)
    }

    func testAppendObjectWithFile() async throws {
        let objectKey = randomObjectName()
        let size = 100 * 1024
        let file = URL(fileURLWithPath: createTestFile(randomFileName(), size)!)
        let count = 5
        var uploadedCount = 0
        var crc: UInt64 = 0

        repeat {
            let request = AppendObjectRequest(bucket: bucketName,
                                              key: objectKey,
                                              position: Int(uploadedCount * size),
                                              body: .file(file),
                                              initHashCrc64: crc)
            let result = try await client?.appendObject(request)
            XCTAssertEqual(result?.statusCode, 200)
            XCTAssertNotNil(result?.nextAppendPosition)
            XCTAssertNotNil(result?.hashCrc64ecma)
            crc = result!.hashCrc64ecma!
            uploadedCount += 1
        } while uploadedCount < count

        let getRequest = GetObjectRequest(bucket: bucketName,
                                          key: objectKey)
        let getResult = try await client?.getObject(getRequest)
        XCTAssertEqual(getResult?.statusCode, 200)
        var fileData = Data()
        for _ in 0 ..< 5 {
            try fileData.append(Data(contentsOf: file))
        }
        XCTAssertEqual(fileData.calculateMd5(), try getResult?.body?.readData()?.calculateMd5())

        let deleteReqeust = DeleteObjectRequest(bucket: bucketName, key: objectKey)
        let _ = try await client?.deleteObject(deleteReqeust)
    }

    func testAppendObjectWithProgress() async throws {
        let objectKey = randomObjectName()
        let size = 5 * 1024 * 1024
        let file = URL(fileURLWithPath: createTestFile(randomFileName(), size)!)
        let totalBytesSented = ValueActor(value: 0)

        var request = AppendObjectRequest(bucket: bucketName,
                                          key: objectKey,
                                          position: 0,
                                          body: .file(file))
        request.progress = ProgressClosure { bytesSent, totalBytesSent, totalBytesExpectedToSend in
            Task {
                await totalBytesSented.setValue(value: totalBytesSented.getValue() + Int(bytesSent))
                let value = await totalBytesSented.getValue()
                XCTAssertEqual(value, Int(totalBytesSent))
                XCTAssertEqual(Int(totalBytesExpectedToSend), size)
            }
        }
        let result = try await client?.appendObject(request)
        XCTAssertEqual(result?.statusCode, 200)
        XCTAssertNotNil(result?.nextAppendPosition)
        XCTAssertNotNil(result?.hashCrc64ecma)
        let value = await totalBytesSented.getValue()
        XCTAssertEqual(value, Int(size))

        let deleteReqeust = DeleteObjectRequest(bucket: bucketName, key: objectKey)
        let _ = try await client?.deleteObject(deleteReqeust)
    }

    func testAppendObjectFail() async throws {
        let objectKey = "testAppendFile"
        let data = "hello oss".data(using: .utf8)!
        let size = 5

        var deleteReqeust = DeleteObjectRequest(bucket: bucketName, key: objectKey)
        let _ = try await client?.deleteObject(deleteReqeust)

        // TODO: test `PositionNotEqualToLength` error
        var request = AppendObjectRequest(bucket: bucketName,
                                          key: objectKey,
                                          position: 0,
                                          body: .data(data.subdata(in: 0 ..< size)))
        request.trafficLimit = 838_860_800
        let result = try await client?.appendObject(request)
        XCTAssertEqual(result?.statusCode, 200)

        request = AppendObjectRequest(bucket: bucketName,
                                      key: objectKey,
                                      position: Int(size - 1),
                                      body: .data(data.subdata(in: 0 ..< size)))
        do {
            let _ = try await client?.appendObject(request)
            XCTFail("It should throw error")
        } catch {
            switch error {
            case let serverError as ServerError:
                XCTAssertEqual(serverError.statusCode, 409)
            default:
                XCTFail("It should throw server error")
            }
        }

        deleteReqeust = DeleteObjectRequest(bucket: bucketName, key: objectKey)
        let _ = try await client?.deleteObject(deleteReqeust)

        // TODO: test `ObjectNotAppendable` error
        let putRequest = PutObjectRequest(bucket: bucketName,
                                          key: objectKey,
                                          body: .data(data.subdata(in: 0 ..< size)))
        let putResult = try await client?.putObject(putRequest)
        XCTAssertEqual(putResult?.statusCode, 200)

        request = AppendObjectRequest(bucket: bucketName,
                                      key: objectKey,
                                      position: Int(size - 1),
                                      body: .data(data.subdata(in: 0 ..< size)))
        do {
            let _ = try await client?.appendObject(request)
            XCTFail("It should throw error")
        } catch {
            switch error {
            case let serverError as ServerError:
                XCTAssertEqual(serverError.statusCode, 409)
            default:
                XCTFail("It should throw server error")
            }
        }

        deleteReqeust = DeleteObjectRequest(bucket: bucketName, key: objectKey)
        let _ = try await client?.deleteObject(deleteReqeust)
    }

    func testAppendObjectWithCrc() async throws {
        let objectKey = randomObjectName()
        let file = URL(fileURLWithPath: createTestFile(randomFileName(), 5 * 1024 * 1024)!)
        let data = try Data(contentsOf: file)
        let size = 256 * 1024
        var uploadedSize = 0
        var crcValue: UInt64 = 0

        let credentialsProvider = StaticCredentialsProvider(accessKeyId: accessKeyId, accessKeySecret: accessKeySecret)
        let config = Configuration.default()
            .withEndpoint(endpoint)
            .withCredentialsProvider(credentialsProvider)
            .withRegion(region)
            .withUploadCRC64Validation(true)
        let client = Client(config)

        var deleteReqeust = DeleteObjectRequest(bucket: bucketName, key: objectKey)
        let _ = try await client.deleteObject(deleteReqeust)

        repeat {
            var request = AppendObjectRequest(bucket: bucketName,
                                              key: objectKey,
                                              position: uploadedSize,
                                              body: .data(data.subdata(in: uploadedSize ..< (uploadedSize + size))))
            request.initHashCrc64 = crcValue
            let result = try await client.appendObject(request)
            XCTAssertEqual(result.statusCode, 200)
            if let crc = result.hashCrc64ecma {
                crcValue = crc
            } else {
                XCTFail("crc value not should be nil")
            }
            uploadedSize += size
        } while uploadedSize < data.count

        let getRequest = GetObjectRequest(bucket: bucketName,
                                          key: objectKey)
        let getResult = try await client.getObject(getRequest)
        XCTAssertEqual(getResult.statusCode, 200)
        XCTAssertEqual(data.calculateMd5(), try getResult.body?.readData()?.calculateMd5())

        deleteReqeust = DeleteObjectRequest(bucket: bucketName, key: objectKey)
        let _ = try await client.deleteObject(deleteReqeust)
    }

    func testAppendObjectWithErrorCrc() async throws {
        let objectKey = randomObjectName()
        let crcValue: UInt64 = 10

        let credentialsProvider = StaticCredentialsProvider(accessKeyId: accessKeyId, accessKeySecret: accessKeySecret)
        let config = Configuration.default()
            .withEndpoint(endpoint)
            .withCredentialsProvider(credentialsProvider)
            .withRegion(region)
            .withRetryMaxAttempts(0)
            .withUploadCRC64Validation(true)
        let client = Client(config)

        var deleteReqeust = DeleteObjectRequest(bucket: bucketName, key: objectKey)
        let _ = try await client.deleteObject(deleteReqeust)

        var request = AppendObjectRequest(bucket: bucketName,
                                          key: objectKey,
                                          position: 0,
                                          body: .data("hello oss".data(using: .utf8)!))
        request.initHashCrc64 = crcValue
        try await assertThrowsAsyncError(await client.appendObject(request)) {
            let error = $0 as? ClientError
            XCTAssertEqual(error?.message.prefix(19), "crc is inconsistent")
        }

        deleteReqeust = DeleteObjectRequest(bucket: bucketName, key: objectKey)
        try await assertNoThrow(await client.deleteObject(deleteReqeust))
    }
    
    // MARK: - test sealAppendObject

    func testSealAppendObject() async throws {
        let objectKey = "testAppendFile"
        let data = "hello oss".data(using: .utf8)!

        let request = AppendObjectRequest(bucket: bucketName,
                                          key: objectKey,
                                          position: 0,
                                          body: .data(data))
        let result = try await client?.appendObject(request)
        XCTAssertEqual(result?.statusCode, 200)
        XCTAssertNotNil(result?.nextAppendPosition)
        XCTAssertNotNil(result?.hashCrc64ecma)

        let sealResult = try await client?.sealAppendObject(SealAppendObjectRequest(
            bucket: bucketName,
            key: objectKey,
            position: data.count
        ))
        XCTAssertEqual(sealResult?.statusCode, 200)

        let deleteReqeust = DeleteObjectRequest(bucket: bucketName, key: objectKey)
        let _ = try await client?.deleteObject(deleteReqeust)
    }
    
    func testSealAppendObjectWithError() async throws {
        await assertThrowsAsyncError(try await client?.sealAppendObject(SealAppendObjectRequest())) {
            let error = $0 as? ClientError
            XCTAssertEqual("Missing required field, request.bucket.", error?.message)
        }
        
        await assertThrowsAsyncError(try await client?.sealAppendObject(SealAppendObjectRequest(
            bucket: bucketName
        ))) {
            let error = $0 as? ClientError
            XCTAssertEqual("Missing required field, request.key.", error?.message)
        }
        
        await assertThrowsAsyncError(try await client?.sealAppendObject(SealAppendObjectRequest(
            bucket: bucketName,
            key: "key"
        ))) {
            let error = $0 as? ClientError
            XCTAssertEqual("Missing required field, request.position.", error?.message)
        }
        
        await assertThrowsAsyncError(try await getInvalidAkClient().sealAppendObject(SealAppendObjectRequest(
            bucket: bucketName,
            key: "key",
            position: 1
        ))) {
            let error = $0 as? ServerError
            XCTAssertEqual(403, error?.statusCode)
        }
    }

    // MARK: - test DeleteMultipleObjects

    func testDeleteMultipleObjects() async throws {
        let objectKey = randomObjectName()

        let objects = ArrayActor<DeleteObject>()
        let client = self.client!
        let bucket = bucketName

        await withThrowingTaskGroup(of: Void.self) {
            for i in 0 ..< 10 {
                $0.addTask {
                    let object = objectKey.appending("\(i)")
                    let deleteObject = DeleteObject(key: object)
                    await objects.append(deleteObject)
                    let putRequest = PutObjectRequest(bucket: bucket,
                                                      key: object,
                                                      body: .data("hello oss".data(using: .utf8)!))
                    try await assertNoThrow(await client.putObject(putRequest))
                }
            }
        }

        let request = await DeleteMultipleObjectsRequest(bucket: bucketName, objects: objects.elements)
        let result = try await client.deleteMultipleObjects(request)
        XCTAssertEqual(result.statusCode, 200)
        XCTAssertNotNil(result.deletedObjects)
        for object in await objects.elements {
            XCTAssertTrue(result.deletedObjects!.contains(where: { deletedObject in
                deletedObject.key == object.key
            }))
        }

        for object in await objects.elements {
            try await assertThrowsAsyncError(await client.headObject(HeadObjectRequest(bucket: bucketName, key: object.key))) {
                let serverError = $0 as? ServerError
                XCTAssertEqual(serverError?.statusCode, 404)
            }
        }
    }

    func testDeleteMultipleObjectsWithQuiet() async throws {
        let objectKey = randomObjectName()
        var objects = ArrayActor<DeleteObject>()
        let client = self.client!
        let bucket = bucketName

        // quiet = true
        await withThrowingTaskGroup(of: Void.self) {
            for i in 0 ..< 10 {
                $0.addTask {
                    let object = objectKey.appending("\(i)")
                    let deleteObject = DeleteObject(key: object)
                    await objects.append(deleteObject)
                    let putRequest = PutObjectRequest(bucket: bucket,
                                                      key: object,
                                                      body: .data("hello oss".data(using: .utf8)!))
                    try await assertNoThrow(await client.putObject(putRequest))
                }
            }
        }

        var request = await DeleteMultipleObjectsRequest(bucket: bucketName, objects: objects.elements)
        request.quiet = true
        var result = try await client.deleteMultipleObjects(request)
        XCTAssertEqual(result.statusCode, 200)
        XCTAssertNil(result.deletedObjects)

        for object in await objects.elements {
            try await assertThrowsAsyncError(await client.headObject(HeadObjectRequest(bucket: bucketName, key: object.key))) {
                let serverError = $0 as? ServerError
                XCTAssertEqual(serverError?.statusCode, 404)
            }
        }

        // quiet = false
        objects = ArrayActor<DeleteObject>()
        await withThrowingTaskGroup(of: Void.self) {
            for i in 0 ..< 10 {
                $0.addTask {
                    let object = objectKey.appending("\(i)")
                    let deleteObject = DeleteObject(key: object)
                    await objects.append(deleteObject)
                    let putRequest = PutObjectRequest(bucket: bucket,
                                                      key: object,
                                                      body: .data("hello oss".data(using: .utf8)!))
                    try await assertNoThrow(await client.putObject(putRequest))
                }
            }
        }

        request = await DeleteMultipleObjectsRequest(bucket: bucketName, objects: objects.elements)
        request.quiet = false
        result = try await client.deleteMultipleObjects(request)
        XCTAssertEqual(result.statusCode, 200)
        XCTAssertNotNil(result.deletedObjects)
        for object in await objects.elements {
            XCTAssertTrue(result.deletedObjects!.contains(where: { deletedObject in
                deletedObject.key == object.key
            }))
        }

        for object in await objects.elements {
            try await assertThrowsAsyncError(await client.headObject(HeadObjectRequest(bucket: bucketName, key: object.key))) {
                let serverError = $0 as? ServerError
                XCTAssertEqual(serverError?.statusCode, 404)
            }
        }

        // quiet is nil
        objects = ArrayActor<DeleteObject>()
        await withThrowingTaskGroup(of: Void.self) {
            for i in 0 ..< 10 {
                $0.addTask {
                    let object = objectKey.appending("\(i)")
                    let deleteObject = DeleteObject(key: object)
                    await objects.append(deleteObject)
                    let putRequest = PutObjectRequest(bucket: bucket,
                                                      key: object,
                                                      body: .data("hello oss".data(using: .utf8)!))
                    try await assertNoThrow(await client.putObject(putRequest))
                }
            }
        }

        request = await DeleteMultipleObjectsRequest(bucket: bucketName, objects: objects.elements)
        request.quiet = false
        result = try await client.deleteMultipleObjects(request)
        XCTAssertEqual(result.statusCode, 200)
        XCTAssertNotNil(result.deletedObjects)
        for object in await objects.elements {
            XCTAssertTrue(result.deletedObjects!.contains(where: { deletedObject in
                deletedObject.key == object.key
            }))
        }

        for object in await objects.elements {
            try await assertThrowsAsyncError(await client.headObject(HeadObjectRequest(bucket: bucketName, key: object.key))) {
                let serverError = $0 as? ServerError
                XCTAssertEqual(serverError?.statusCode, 404)
            }
        }
    }

    func testDeleteMultiplePartialObjects() async throws {
        let objectKey = "testDeleteObjectsFile"
        var objects: [DeleteObject] = []

        try await assertNoThrow(await client?.putBucketVersioning(PutBucketVersioningRequest(bucket: bucketName,
                                                                                             versioningConfiguration: VersioningConfiguration(status: "Enabled"))))

        var existedFile: [DeleteObject] = []
        for i in 0 ..< 10 {
            let object = objectKey.appending("\(i)")
            let deleteObject = DeleteObject(key: object)
            existedFile.append(deleteObject)
            let putRequest = PutObjectRequest(bucket: bucketName,
                                              key: object,
                                              body: .data("hello oss".data(using: .utf8)!))
            try await assertNoThrow(await client?.putObject(putRequest))
        }

        var noExistedFile: [DeleteObject] = []
        for i in 10 ..< 20 {
            let object = objectKey.appending("\(i)")
            let deleteObject = DeleteObject(key: object)
            noExistedFile.append(deleteObject)
        }

        objects.append(contentsOf: existedFile)
        objects.append(contentsOf: noExistedFile)

        let request = DeleteMultipleObjectsRequest(bucket: bucketName, objects: objects)
        let result = try await client?.deleteMultipleObjects(request)
        XCTAssertEqual(result?.statusCode, 200)
        XCTAssertNotNil(result?.deletedObjects)
        for object in objects {
            XCTAssertTrue(result!.deletedObjects!.contains(where: { deletedObject in
                deletedObject.key == object.key
            }))
        }

        for object in existedFile {
            XCTAssertTrue(result!.deletedObjects!.contains(where: { deletedObject in
                deletedObject.key == object.key
            }))
        }

        for object in noExistedFile {
            XCTAssertTrue(result!.deletedObjects!.contains(where: { deletedObject in
                deletedObject.key == object.key
            }))
        }

        for object in objects {
            try await assertThrowsAsyncError(await client?.headObject(HeadObjectRequest(bucket: bucketName, key: object.key))) {
                let serverError = $0 as? ServerError
                XCTAssertEqual(serverError?.statusCode, 404)
            }
        }
    }

    func testDeleteMultiplePartialObjectsWithVersion() async throws {
        let objectKey = randomObjectName()

        try await assertNoThrow(await client?.putBucketVersioning(PutBucketVersioningRequest(bucket: bucketName,
                                                                                             versioningConfiguration: VersioningConfiguration(status: "Enabled"))))
        var objects: [DeleteObject] = []
        for i in 20 ..< 30 {
            let object = objectKey.appending("\(i)")
            var putRequest = PutObjectRequest(bucket: bucketName,
                                              key: object,
                                              body: .data("hello oss".data(using: .utf8)!))
            try await assertNoThrow(await client?.putObject(putRequest))

            putRequest = PutObjectRequest(bucket: bucketName,
                                          key: object,
                                          body: .data("hello oss".data(using: .utf8)!))
            let result = try await client?.putObject(putRequest)
            let deleteObject = DeleteObject(key: object,
                                            versionId: result?.versionId)
            objects.append(deleteObject)
        }

        let request = DeleteMultipleObjectsRequest(bucket: bucketName,
                                                   objects: objects)
        let result = try await client?.deleteMultipleObjects(request)
        XCTAssertEqual(result?.statusCode, 200)
        XCTAssertNotNil(result?.deletedObjects)
        for object in objects {
            XCTAssertTrue(result!.deletedObjects!.contains(where: { deletedObject in
                deletedObject.key == object.key
            }))
            XCTAssertNotNil(object.versionId)
        }
    }

    // MARK: - test GetObjectMeta

    func testGetObjectMeta() async throws {
        let objectKey = "getObjectMetaTest"
        let data = "hello oss".data(using: .utf8)!
        let fileSize = data.count

        var deleteReqeust = DeleteObjectRequest(bucket: bucketName, key: objectKey)
        let _ = try await client?.deleteObject(deleteReqeust)

        let putRequest = PutObjectRequest(bucket: bucketName,
                                          key: objectKey,
                                          body: .data(data))
        let putResult = try await client?.putObject(putRequest)

        let request = GetObjectMetaRequest(bucket: bucketName, key: objectKey)
        let result = try await client?.getObjectMeta(request)
        XCTAssertEqual(fileSize, result!.contentLength)
        XCTAssertEqual(putResult?.headers?[Headers.etag.rawValue], result?.headers?[Headers.etag.rawValue])
        XCTAssertNotNil(result?.lastModified)
        XCTAssertNil(result?.lastAccessTime)

        deleteReqeust = DeleteObjectRequest(bucket: bucketName, key: objectKey)
        let _ = try await client?.deleteObject(deleteReqeust)
    }

    func testGetObjectMetaWithTxtFile() async throws {
        let objectKey = "getObjectMetaTest.txt"
        let data = "hello oss".data(using: .utf8)!
        let fileSize = data.count

        try await assertNoThrow(await client?.putBucketVersioning(PutBucketVersioningRequest(bucket: bucketName,
                                                                                             versioningConfiguration: VersioningConfiguration(status: "Enabled"))))
        var deleteReqeust = DeleteObjectRequest(bucket: bucketName, key: objectKey)
        let _ = try await client?.deleteObject(deleteReqeust)

        let putRequest = PutObjectRequest(bucket: bucketName,
                                          key: objectKey,
                                          body: .data(data))
        let putResult = try await client?.putObject(putRequest)

        let request = GetObjectMetaRequest(bucket: bucketName, key: objectKey)
        let result = try await client?.getObjectMeta(request)
        XCTAssertEqual(fileSize, result!.contentLength)
        XCTAssertEqual(putResult?.headers?[Headers.etag.rawValue], result?.headers?[Headers.etag.rawValue])
        XCTAssertEqual(putResult?.versionId, result?.versionId)
        XCTAssertNotNil(result?.lastModified)
        XCTAssertNil(result?.lastAccessTime)

        deleteReqeust = DeleteObjectRequest(bucket: bucketName, key: objectKey)
        let _ = try await client?.deleteObject(deleteReqeust)
    }

    func testGetObjectMetaWithAppendFile() async throws {
        let objectKey = "getObjectMetaTest"
        let fileSize = 512 * 1024 + 123

        let data = randomStr(fileSize).data(using: .utf8)!
        let size = 64 * 1024
        var uploadedSize = 0
        var crc: UInt64 = 0

        var deleteReqeust = DeleteObjectRequest(bucket: bucketName, key: objectKey)
        let _ = try await client?.deleteObject(deleteReqeust)

        repeat {
            let request = AppendObjectRequest(bucket: bucketName,
                                              key: objectKey,
                                              position: Int(uploadedSize),
                                              body: .data(data.subdata(in: uploadedSize ..< ((uploadedSize + size) < fileSize ? (uploadedSize + size) : fileSize))),
                                              initHashCrc64: crc)
            let result = try await client?.appendObject(request)
            XCTAssertEqual(result?.statusCode, 200)
            XCTAssertNotNil(result?.nextAppendPosition)
            XCTAssertNotNil(result?.hashCrc64ecma)
            crc = result!.hashCrc64ecma!
            uploadedSize += size
        } while uploadedSize < data.count

        let request = GetObjectMetaRequest(bucket: bucketName, key: objectKey)
        let result = try await client?.getObjectMeta(request)
        XCTAssertEqual(fileSize, result!.contentLength)
        XCTAssertNotNil(result?.lastModified)
        XCTAssertNil(result?.lastAccessTime)

        deleteReqeust = DeleteObjectRequest(bucket: bucketName, key: objectKey)
        let _ = try await client?.deleteObject(deleteReqeust)
    }

    func testGetObjectMetaFail() async throws {
        let objectKey = "getObjectMetaTest"

        let deleteReqeust = DeleteObjectRequest(bucket: bucketName, key: objectKey)
        let _ = try await client?.deleteObject(deleteReqeust)

        let request = GetObjectMetaRequest(bucket: bucketName, key: objectKey)
        try await assertThrowsAsyncError(await client?.getObjectMeta(request))
    }

    // MARK: - test RestoreObject

    func testRestoreObject() async throws {
        let data = "hello oss".data(using: .utf8)!
        let objectKey = randomObjectName()
        let storageClass = "Archive"

        var deleteReqeust = DeleteObjectRequest(bucket: bucketName, key: objectKey)
        let _ = try await client?.deleteObject(deleteReqeust)

        var putObject = PutObjectRequest(bucket: bucketName,
                                         key: objectKey,
                                         body: .data(data))
        putObject.storageClass = storageClass
        let _ = try await client?.putObject(putObject)

        let getRequest = GetObjectRequest(bucket: bucketName,
                                          key: objectKey)
        try await assertThrowsAsyncError(await client?.getObject(getRequest)) { error in
            let serverError = error as! ServerError
            XCTAssertEqual(serverError.statusCode, 403)
            XCTAssertEqual(serverError.code, "InvalidObjectState")
        }

        var request = RestoreObjectRequest(bucket: bucketName,
                                           key: objectKey)
        request.restoreRequest = RestoreRequest(days: 1)
        try await assertNoThrow(await client?.restoreObject(request))

        deleteReqeust = DeleteObjectRequest(bucket: bucketName, key: objectKey)
        let _ = try await client?.deleteObject(deleteReqeust)
    }

    func testRestoreObjectFail() async throws {
        let data = "hello oss".data(using: .utf8)!
        let objectKey = randomObjectName()
        let storageClass = "Archive"

        var deleteReqeust = DeleteObjectRequest(bucket: bucketName, key: objectKey)
        let _ = try await client?.deleteObject(deleteReqeust)

        var putObject = PutObjectRequest(bucket: bucketName,
                                         key: objectKey,
                                         body: .data(data))
        let _ = try await client?.putObject(putObject)

        var getRequest = GetObjectRequest(bucket: bucketName,
                                          key: objectKey)
        try await assertNoThrow(await client?.getObject(getRequest))

        var request = RestoreObjectRequest(bucket: bucketName,
                                           key: objectKey,
                                           restoreRequest: RestoreRequest(days: 1))
        try await assertThrowsAsyncError(await client?.restoreObject(request)) { error in
            let serverError = error as! ServerError
            XCTAssertEqual(serverError.statusCode, 400)
            XCTAssertEqual(serverError.code, "OperationNotSupported")
        }

        deleteReqeust = DeleteObjectRequest(bucket: bucketName, key: objectKey)
        let _ = try await client?.deleteObject(deleteReqeust)

        putObject = PutObjectRequest(bucket: bucketName,
                                     key: objectKey,
                                     body: .data(data))
        putObject.storageClass = storageClass
        let _ = try await client?.putObject(putObject)

        getRequest = GetObjectRequest(bucket: bucketName,
                                      key: objectKey)
        try await assertThrowsAsyncError(await client?.getObject(getRequest)) { error in
            let serverError = error as! ServerError
            XCTAssertEqual(serverError.statusCode, 403)
            XCTAssertEqual(serverError.code, "InvalidObjectState")
        }

        request = RestoreObjectRequest(bucket: bucketName,
                                       key: objectKey,
                                       restoreRequest: RestoreRequest(days: 1))
        try await assertNoThrow(await client?.restoreObject(request))

        request = RestoreObjectRequest(bucket: bucketName,
                                       key: objectKey,
                                       restoreRequest: RestoreRequest(days: 1))
        try await assertThrowsAsyncError(await client?.restoreObject(request)) { error in
            let serverError = error as! ServerError
            XCTAssertEqual(serverError.statusCode, 409)
        }
    }
}
