import AlibabaCloudOSS
import Foundation
import XCTest

final class ClientMiscTests: BaseTestCase {
    class CustomerPorgress: ProgressDelegate, @unchecked Sendable {
        public var bytesAdded: Int64 = 0
        public var totalBytesTransferred: Int64 = 0
        public var totalBytesExpected: Int64 = 0

        public func onProgress(_ increment: Int64, _ transferred: Int64, _ total: Int64) {
            bytesAdded += increment
            totalBytesTransferred = transferred
            totalBytesExpected = total
            // print("onProgress: \(increment), \(transferred), \(total)\n")
        }

        public func reset() {
            bytesAdded = 0
            totalBytesTransferred = 0
            totalBytesExpected = 0
        }
    }

    func testSendDifferentByteStreamType() async throws {
        // default
        let client = getDefaultClient()
        let bucket = randomBucketName()
        let key = randomObjectName()

        try await createBucket(client: client, bucket: bucket)

        var request: PutObjectRequest
        var result: PutObjectResult
        var getResult: GetObjectResult

        // send data
        let data = "hello world from data".data(using: .utf8)!
        request = PutObjectRequest(bucket: bucket,
                                   key: key,
                                   body: .data(data))

        result = try await client.putObject(request)
        XCTAssertEqual(result.statusCode, 200)

        getResult = try await client.getObject(GetObjectRequest(bucket: bucket, key: key))
        XCTAssertEqual(getResult.statusCode, 200)
        XCTAssertNotNil(getResult.body)
        switch getResult.body {
        case let .data(d):
            XCTAssertEqual(String(data: d, encoding: .utf8), "hello world from data")
        default:
            XCTFail("getResult.body is not data")
        }

        // send file
        let file = URL(fileURLWithPath: createTestFile(randomFileName(), "hello world from file".data(using: .utf8)!)!)
        request = PutObjectRequest(bucket: bucket,
                                   key: key,
                                   body: .file(file))

        result = try await client.putObject(request)
        XCTAssertEqual(result.statusCode, 200)

        getResult = try await client.getObject(GetObjectRequest(bucket: bucket, key: key))
        XCTAssertEqual(getResult.statusCode, 200)
        XCTAssertNotNil(getResult.body)
        switch getResult.body {
        case let .data(d):
            XCTAssertEqual(String(data: d, encoding: .utf8), "hello world from file")
        default:
            XCTFail("getResult.body is not data")
        }

        // send stream
        let stream = InputStream(data: "hello world from stream".data(using: .utf8)!)
        request = PutObjectRequest(bucket: bucket,
                                   key: key,
                                   body: .stream(stream))

        result = try await client.putObject(request)
        XCTAssertEqual(result.statusCode, 200)

        getResult = try await client.getObject(GetObjectRequest(bucket: bucket, key: key))
        XCTAssertEqual(getResult.statusCode, 200)
        XCTAssertNotNil(getResult.body)
        switch getResult.body {
        case let .data(d):
            XCTAssertEqual(String(data: d, encoding: .utf8), "hello world from stream")
        default:
            XCTFail("getResult.body is not data")
        }

        // send none
        request = PutObjectRequest(bucket: bucket,
                                   key: key,
                                   body: ByteStream.none)

        result = try await client.putObject(request)
        XCTAssertEqual(result.statusCode, 200)

        getResult = try await client.getObject(GetObjectRequest(bucket: bucket, key: key))
        XCTAssertEqual(getResult.statusCode, 200)
        XCTAssertNotNil(getResult.body)
        switch getResult.body {
        case let .data(data):
            XCTAssertEqual(String(data: data, encoding: .utf8), "")
        default:
            XCTFail("getResult.body is not data")
        }

        // send nil
        request = PutObjectRequest(bucket: bucket,
                                   key: key)

        result = try await client.putObject(request)
        XCTAssertEqual(result.statusCode, 200)

        getResult = try await client.getObject(GetObjectRequest(bucket: bucket, key: key))
        XCTAssertEqual(getResult.statusCode, 200)
        XCTAssertNotNil(getResult.body)
        switch getResult.body {
        case let .data(d):
            XCTAssertEqual(String(data: d, encoding: .utf8), "")
        default:
            XCTFail("getResult.body is not data")
        }
    }

    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    func testDownloadToDifferentByteStreamType() async throws {
        // default
        let client = getDefaultClient()
        let bucket = randomBucketName()
        let key = randomObjectName()

        try await createBucket(client: client, bucket: bucket)

        var request: PutObjectRequest
        var result: PutObjectResult
        var getResult: GetObjectResult

        // send data
        let data = "hello world from data".data(using: .utf8)!
        request = PutObjectRequest(bucket: bucket,
                                   key: key,
                                   body: .data(data))

        result = try await client.putObject(request)
        XCTAssertEqual(result.statusCode, 200)

        // download as Data
        getResult = try await client.getObject(GetObjectRequest(bucket: bucket, key: key))
        XCTAssertEqual(getResult.statusCode, 200)
        XCTAssertNotNil(getResult.body)
        switch getResult.body {
        case let .data(data):
            XCTAssertEqual(String(data: data, encoding: .utf8), "hello world from data")
        default:
            XCTFail("getResult.body is not data")
        }

        // download as Data + with operation options
        let opts = OperationOptions()
        getResult = try await client.getObject(GetObjectRequest(bucket: bucket, key: key), opts)
        XCTAssertEqual(getResult.statusCode, 200)
        XCTAssertNotNil(getResult.body)
        switch getResult.body {
        case let .data(data):
            XCTAssertEqual(String(data: data, encoding: .utf8), "hello world from data")
        default:
            XCTFail("getResult.body is not data")
        }

        // download as URL
        let file = URL(fileURLWithPath: createTestFile(randomFileName(), "".data(using: .utf8)!)!)
        getResult = try await client.getObjectToFile(GetObjectRequest(bucket: bucket, key: key), file)
        XCTAssertEqual(getResult.statusCode, 200)
        XCTAssertNotNil(getResult.body)
        switch getResult.body {
        case let .file(url):
            XCTAssertEqual(data, FileManager.default.contents(atPath: url.path))
        default:
            XCTFail("getResult.body is not data")
        }
    }

    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    func testDownloadToUrlWithError() async throws {
        // default
        let client = getDefaultClient()
        let bucket = randomBucketName()
        let key = randomObjectName()

        // download as URL
        let file = URL(fileURLWithPath: createTestFile(randomFileName(), "".data(using: .utf8)!)!)

        try await assertThrowsAsyncError(await client.getObjectToFile(GetObjectRequest(bucket: bucket, key: key), file)) { error in
            switch error {
            case let serverError as ServerError:
                XCTAssertEqual("NoSuchBucket", serverError.code)
            default:
                XCTFail("Test fail, it should throw client error")
            }
        }
    }

    func testURLSession_data_ForUploadProgress() async throws {
        // default
        let client = getDefaultClient()
        let bucket = randomBucketName()

        let request = PutBucketRequest(bucket: bucket)
        let result = try await client.putBucket(request)
        XCTAssertEqual(result.statusCode, 200)

        let size = 300 * 1024 + 12345
        let data = randomStr(size).data(using: .utf8)!
        let key = randomObjectName()
        let progress = CustomerPorgress()

        // put object
        progress.reset()
        XCTAssertEqual(progress.bytesAdded, 0)
        try await assertNoThrow(await client.putObject(PutObjectRequest(
            bucket: bucket,
            key: key,
            body: .data(data),
            progress: progress
        )
        ))

        XCTAssertEqual(progress.bytesAdded, Int64(size))
        XCTAssertEqual(progress.totalBytesTransferred, Int64(size))
        XCTAssertEqual(progress.totalBytesExpected, Int64(size))

        // appand object
        progress.reset()
        XCTAssertEqual(progress.bytesAdded, 0)
        try await assertNoThrow(await client.appendObject(AppendObjectRequest(
            bucket: bucket,
            key: key + "append",
            position: 0,
            body: .data(data),
            progress: progress
        )
        ))

        XCTAssertEqual(progress.bytesAdded, Int64(size))
        XCTAssertEqual(progress.totalBytesTransferred, Int64(size))
        XCTAssertEqual(progress.totalBytesExpected, Int64(size))

        // upload part
        progress.reset()
        XCTAssertEqual(progress.bytesAdded, 0)
        let initResult = try await client.initiateMultipartUpload(InitiateMultipartUploadRequest(
            bucket: bucket,
            key: key
        )
        )
        try await assertNoThrow(await client.uploadPart(UploadPartRequest(
            bucket: bucket,
            key: key,
            partNumber: 1,
            uploadId: initResult.uploadId,
            body: .data(data),
            progress: progress
        )))

        try await assertNoThrow(await client.completeMultipartUpload(CompleteMultipartUploadRequest(
            bucket: bucket,
            key: key,
            completeAll: "yes",
            uploadId: initResult.uploadId
        )
        ))
    }

//        func testURLSession_data_ForDownloadProgress() async throws {
//            // default
//            let client = getDefaultClient()
//            let bucket = randomBucketName()
//
//            let request = PutBucketRequest(bucket: bucket)
//            let result = try await client.putBucket(request)
//            XCTAssertEqual(result.statusCode, 200)
//
//            let size = 300*1024 + 12345
//            let data = randomStr(size).data(using: .utf8)!
//            let key = randomObjectName()
//
//            await assertNoThrow(try await client.putObject(PutObjectRequest(
//                bucket: bucket,
//                key: key,
//                body: .data(data))
//            ))
//
//            let progress = CustomerPorgress()
//            let getRequest = GetObjectRequest(
//                    bucket: bucket,
//                    key: key,
//                    progress: progress)
//
//            let getResult = try await client.getObject(getRequest)
//            XCTAssertEqual(getResult.statusCode, 200)
//            XCTAssertNotNil(getResult.body)
//            switch getResult.body {
//                case .data(let gotData):
//                    XCTAssertEqual(data, gotData)
//                default:
//                    XCTFail("getResult.body is not data")
//            }
//            XCTAssertEqual(Int64(size), progress.bytesAdded)
//            XCTAssertEqual(Int64(size), progress.totalBytesTransferred)
//            XCTAssertEqual(Int64(size), progress.totalBytesExpected)
//        }

    func testURLSession_upload_Progress() async throws {
        // default
        let client = getDefaultClient()
        let bucket = randomBucketName()

        let request = PutBucketRequest(bucket: bucket)
        let result = try await client.putBucket(request)
        XCTAssertEqual(result.statusCode, 200)

        let size = 300 * 1024 + 12345
        let file = URL(fileURLWithPath: createTestFile(randomFileName(), randomStr(size).data(using: .utf8)!)!)
        let key = randomObjectName()

        let progress = CustomerPorgress()

        // put object
        progress.reset()
        XCTAssertEqual(progress.bytesAdded, 0)
        try await assertNoThrow(await client.putObject(PutObjectRequest(
            bucket: bucket,
            key: key,
            body: .file(file),
            progress: progress
        )
        ))

        XCTAssertEqual(progress.bytesAdded, Int64(size))
        XCTAssertEqual(progress.totalBytesTransferred, Int64(size))
        XCTAssertEqual(progress.totalBytesExpected, Int64(size))

        // appand object
        progress.reset()
        XCTAssertEqual(progress.bytesAdded, 0)
        try await assertNoThrow(await client.appendObject(AppendObjectRequest(
            bucket: bucket,
            key: key + "append",
            position: 0,
            body: .file(file),
            progress: progress
        )
        ))

        XCTAssertEqual(progress.bytesAdded, Int64(size))
        XCTAssertEqual(progress.totalBytesTransferred, Int64(size))
        XCTAssertEqual(progress.totalBytesExpected, Int64(size))

        // upload part
        progress.reset()
        XCTAssertEqual(progress.bytesAdded, 0)
        let initResult = try await client.initiateMultipartUpload(InitiateMultipartUploadRequest(
            bucket: bucket,
            key: key
        )
        )
        try await assertNoThrow(await client.uploadPart(UploadPartRequest(
            bucket: bucket,
            key: key,
            partNumber: 1,
            uploadId: initResult.uploadId,
            body: .file(file),
            progress: progress
        )))

        try await assertNoThrow(await client.completeMultipartUpload(CompleteMultipartUploadRequest(
            bucket: bucket,
            key: key,
            completeAll: "yes",
            uploadId: initResult.uploadId
        )
        ))
    }

    /// because of the bug of URLSession, we can't get the progress of downloading
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    func testURLSession_download_Progress() async throws {
        // default
        let client = getDefaultClient()
        let bucket = randomBucketName()

        let request = PutBucketRequest(bucket: bucket)
        let result = try await client.putBucket(request)
        XCTAssertEqual(result.statusCode, 200)

        let size = 300 * 1024 + 12345
        let data = randomStr(size).data(using: .utf8)!
        let key = randomObjectName()

        try await assertNoThrow(await client.putObject(PutObjectRequest(
            bucket: bucket,
            key: key,
            body: .data(data)
        )
        ))

        let progress = CustomerPorgress()
        let getRequest = GetObjectRequest(
            bucket: bucket,
            key: key,
            progress: progress
        )

        let file = URL(fileURLWithPath: createTestFile(randomFileName(), "".data(using: .utf8)!)!)
        let getResult = try await client.getObjectToFile(getRequest, file)
        XCTAssertEqual(getResult.statusCode, 200)
        XCTAssertNotNil(getResult.body)
        switch getResult.body {
        case let .file(url):
            XCTAssertEqual(data, FileManager.default.contents(atPath: url.path))
        default:
            XCTFail("getResult.body is not data")
        }
        XCTAssertEqual(0, progress.bytesAdded)
        XCTAssertEqual(0, progress.totalBytesTransferred)
    }

    func testFeatureAutoDetectMimeTypeFlag() async throws {
        // default
        let client = getDefaultClient()

        // disable auto detect mime type client
        let credentialsProvider = StaticCredentialsProvider(
            accessKeyId: accessKeyId,
            accessKeySecret: accessKeySecret
        )
        let config = Configuration.default()
        config.withCredentialsProvider(credentialsProvider)
        config.withEndpoint(endpoint)
        config.withRegion(region)

        let client2 = Client(config) { $0.featureFlags.insert(.autoDetectMimeType) }

        let bucket = randomBucketName()

        let request = PutBucketRequest(bucket: bucket)
        let result = try await client.putBucket(request)
        XCTAssertEqual(result.statusCode, 200)

        let key = randomObjectName() + ".txt"

        // put object
        try await assertNoThrow(await client.putObject(PutObjectRequest(
            bucket: bucket,
            key: key,
            body: .data("hello world from data".data(using: .utf8)!)
        )))

        var getResult = try await client.getObject(GetObjectRequest(bucket: bucket, key: key))
        XCTAssertEqual("text/plain", getResult.contentType)

        try await assertNoThrow(await client2.putObject(PutObjectRequest(
            bucket: bucket,
            key: key,
            body: .data("hello world from data".data(using: .utf8)!)
        )))

        getResult = try await client.getObject(GetObjectRequest(bucket: bucket, key: key))
        XCTAssertEqual("text/plain", getResult.contentType)
        XCTAssertEqual("Normal", getResult.objectType)

        // multipart
        var initResult = try await client.initiateMultipartUpload(InitiateMultipartUploadRequest(
            bucket: bucket,
            key: key
        )
        )
        try await assertNoThrow(await client.uploadPart(UploadPartRequest(
            bucket: bucket,
            key: key,
            partNumber: 1,
            uploadId: initResult.uploadId,
            body: .data("hello world from data".data(using: .utf8)!)
        )))

        try await assertNoThrow(await client.completeMultipartUpload(CompleteMultipartUploadRequest(
            bucket: bucket,
            key: key,
            completeAll: "yes",
            uploadId: initResult.uploadId
        )
        ))
        getResult = try await client.getObject(GetObjectRequest(bucket: bucket, key: key))
        XCTAssertEqual("text/plain", getResult.contentType)
        XCTAssertEqual("Multipart", getResult.objectType)

        initResult = try await client2.initiateMultipartUpload(InitiateMultipartUploadRequest(
            bucket: bucket,
            key: key
        )
        )
        try await assertNoThrow(await client2.uploadPart(UploadPartRequest(
            bucket: bucket,
            key: key,
            partNumber: 1,
            uploadId: initResult.uploadId,
            body: .data("hello world from data".data(using: .utf8)!)
        )))

        try await assertNoThrow(await client2.completeMultipartUpload(CompleteMultipartUploadRequest(
            bucket: bucket,
            key: key,
            completeAll: "yes",
            uploadId: initResult.uploadId
        )
        ))
        getResult = try await client.getObject(GetObjectRequest(bucket: bucket, key: key))
        XCTAssertEqual("text/plain", getResult.contentType)
        XCTAssertEqual("Multipart", getResult.objectType)

        // append object
        try await assertNoThrow(await client.deleteObject(DeleteObjectRequest(bucket: bucket, key: key)))
        try await assertNoThrow(await client.appendObject(AppendObjectRequest(
            bucket: bucket,
            key: key,
            position: 0,
            body: .data("hello world from data".data(using: .utf8)!)
        )
        ))
        getResult = try await client.getObject(GetObjectRequest(bucket: bucket, key: key))
        XCTAssertEqual("text/plain", getResult.contentType)
        XCTAssertEqual("Appendable", getResult.objectType)

        try await assertNoThrow(await client.deleteObject(DeleteObjectRequest(bucket: bucket, key: key)))
        try await assertNoThrow(await client2.appendObject(AppendObjectRequest(
            bucket: bucket,
            key: key,
            position: 0,
            body: .data("hello world from data".data(using: .utf8)!)
        )
        ))
        getResult = try await client.getObject(GetObjectRequest(bucket: bucket, key: key))
        XCTAssertEqual("text/plain", getResult.contentType)
        XCTAssertEqual("Appendable", getResult.objectType)
    }

    func testFeatureEnableCRC64CheckUploadFlag() async throws {
        // default
        let client = getDefaultClient()

        // disable CRC64 Check
        let credentialsProvider = StaticCredentialsProvider(
            accessKeyId: accessKeyId,
            accessKeySecret: accessKeySecret
        )
        let config = Configuration.default()
        config.withCredentialsProvider(credentialsProvider)
        config.withEndpoint(endpoint)
        config.withRegion(region)

        let client2 = Client(config) { $0.featureFlags.insert(.enableCRC64CheckUpload) }

        let bucket = randomBucketName()

        let request = PutBucketRequest(bucket: bucket)
        let result = try await client.putBucket(request)
        XCTAssertEqual(result.statusCode, 200)

        let key = randomObjectName() + ".txt"

        // put object
        try await assertNoThrow(await client.putObject(PutObjectRequest(
            bucket: bucket,
            key: key,
            body: .data("hello world from data".data(using: .utf8)!)
        )))

        var getResult = try await client.getObject(GetObjectRequest(bucket: bucket, key: key))
        XCTAssertEqual("text/plain", getResult.contentType)

        try await assertNoThrow(await client2.putObject(PutObjectRequest(
            bucket: bucket,
            key: key,
            body: .data("hello world from data".data(using: .utf8)!)
        )))

        getResult = try await client.getObject(GetObjectRequest(bucket: bucket, key: key))
        XCTAssertEqual("Normal", getResult.objectType)

        // multipart
        var initResult = try await client.initiateMultipartUpload(InitiateMultipartUploadRequest(
            bucket: bucket,
            key: key
        )
        )
        try await assertNoThrow(await client.uploadPart(UploadPartRequest(
            bucket: bucket,
            key: key,
            partNumber: 1,
            uploadId: initResult.uploadId,
            body: .data("hello world from data".data(using: .utf8)!)
        )))

        try await assertNoThrow(await client.completeMultipartUpload(CompleteMultipartUploadRequest(
            bucket: bucket,
            key: key,
            completeAll: "yes",
            uploadId: initResult.uploadId
        )
        ))
        getResult = try await client.getObject(GetObjectRequest(bucket: bucket, key: key))
        XCTAssertEqual("text/plain", getResult.contentType)
        XCTAssertEqual("Multipart", getResult.objectType)

        initResult = try await client2.initiateMultipartUpload(InitiateMultipartUploadRequest(
            bucket: bucket,
            key: key
        )
        )
        try await assertNoThrow(await client2.uploadPart(UploadPartRequest(
            bucket: bucket,
            key: key,
            partNumber: 1,
            uploadId: initResult.uploadId,
            body: .data("hello world from data".data(using: .utf8)!)
        )))

        try await assertNoThrow(await client2.completeMultipartUpload(CompleteMultipartUploadRequest(
            bucket: bucket,
            key: key,
            completeAll: "yes",
            uploadId: initResult.uploadId
        )
        ))
        getResult = try await client.getObject(GetObjectRequest(bucket: bucket, key: key))
        XCTAssertEqual("text/plain", getResult.contentType)
        XCTAssertEqual("Multipart", getResult.objectType)

        // append object
        try await assertNoThrow(await client.deleteObject(DeleteObjectRequest(bucket: bucket, key: key)))
        try await assertNoThrow(await client.appendObject(AppendObjectRequest(
            bucket: bucket,
            key: key,
            position: 0,
            body: .data("hello world from data".data(using: .utf8)!)
        )
        ))
        getResult = try await client.getObject(GetObjectRequest(bucket: bucket, key: key))
        XCTAssertEqual("text/plain", getResult.contentType)
        XCTAssertEqual("Appendable", getResult.objectType)

        try await assertNoThrow(await client.deleteObject(DeleteObjectRequest(bucket: bucket, key: key)))
        try await assertNoThrow(await client2.appendObject(AppendObjectRequest(
            bucket: bucket,
            key: key,
            position: 0,
            body: .data("hello world from data".data(using: .utf8)!)
        )
        ))
        getResult = try await client.getObject(GetObjectRequest(bucket: bucket, key: key))
        XCTAssertEqual("text/plain", getResult.contentType)
        XCTAssertEqual("Appendable", getResult.objectType)
    }
    
    func testQueryWithSpecialChar() async throws {
        let client = getDefaultClient()
        let bucket = randomBucketName()
        let content = "hello world, hi oss!".data(using: .utf8)!

        await assertNoThrow(try await client.putBucket(PutBucketRequest(bucket: bucket)))

        let key = "special/char-123+ 456.txt"
        var putRequest = PutObjectRequest(bucket: bucket,
                                          key: key)
        putRequest.addParameter("with-plus", "123+456")
        putRequest.addParameter("with-space", "123 456")
        putRequest.addParameter("key-plus+", "value-key1")
        putRequest.addParameter("key space", "value-key2")

        var preResult = try await client.presign(putRequest)
        XCTAssertNotNil(preResult.signedHeaders)
        XCTAssertEqual("PUT", preResult.method)
        XCTAssertNotNil(preResult.expiration)
        XCTAssertTrue(preResult.url.contains("with-plus=123%2B456"))
        XCTAssertTrue(preResult.url.contains("with-space=123%20456"))
        XCTAssertTrue(preResult.url.contains("special/char-123%2B%20456.txt"))
        XCTAssertTrue(preResult.url.contains("key-plus%2B=value-key1"))
        XCTAssertTrue(preResult.url.contains("key%20space=value-key2"))

        var urlRequest = URLRequest(url: URL(string: preResult.url,)!)
        urlRequest.httpMethod = preResult.method
        var (data, _) = try await URLSession.shared.upload(for: urlRequest,
                                                                  from: content)

        var getRequest = GetObjectRequest(bucket: bucket,
                                          key: key)
        getRequest.addParameter("with-plus", "123+456")
        getRequest.addParameter("with-space", "123 456")
        getRequest.addParameter("key-plus+", "value-key1")
        getRequest.addParameter("key space", "value-key2")

        preResult = try await client.presign(getRequest);
        XCTAssertNotNil(preResult.signedHeaders);
        XCTAssertEqual("GET", preResult.method);
        XCTAssertNotNil(preResult.expiration);

        (data, _) = try await URLSession.shared.data(from: URL(string: preResult.url)!)
        XCTAssertEqual(data, content)
        
        let getResult = try await client.getObject(getRequest)
        XCTAssertEqual(try getResult.body?.readData(), content)
    }
}
