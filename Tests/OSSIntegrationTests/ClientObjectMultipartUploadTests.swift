
@testable import AlibabaCloudOSS
import XCTest

final class ClientObjectMultipartUploadTests: BaseTestCase {
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

    // MARK: - test InitiateMultipartUpload

    func testInitiateMultipartUpload() async throws {
        let objectKey = "textInitiateMultipartUpload"

        let reqesut = InitiateMultipartUploadRequest(bucket: bucketName, key: objectKey)
        let result = try await client?.initiateMultipartUpload(reqesut)
        XCTAssertEqual(result?.statusCode, 200)
        XCTAssertNotNil(result?.uploadId)

        let abortRequest = AbortMultipartUploadRequest(bucket: bucketName,
                                                       key: objectKey,
                                                       uploadId: result!.uploadId!)
        try await assertNoThrow(await client?.abortMultipartUpload(abortRequest))
    }

    func testInitiateMultipartUploadWithFillProgress() async throws {
        let objectKey = "textInitiateMultipartUpload"
        let partSize = 100 * 1024
        let filePath = createTestFile("middle", 1024 * 1024)!

        let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
        guard let fileSize = fileAttributes[FileAttributeKey.size] as? Int else {
            XCTFail("Can not get file size.")
            return
        }

        let reqesut = InitiateMultipartUploadRequest(bucket: bucketName, key: objectKey)
        let result = try await client?.initiateMultipartUpload(reqesut)
        XCTAssertEqual(result?.statusCode, 200)
        XCTAssertNotNil(result?.uploadId)

        let partCount = fileSize / partSize + (fileSize % partSize > 0 ? 1 : 0)
        for i in 0 ..< partCount {
            let fileHandle = FileHandle(forReadingAtPath: filePath)
            var data: Data?
            if #available(iOS 13.4, *) {
                try fileHandle?.seek(toOffset: UInt64(i * partSize))
                data = try fileHandle?.read(upToCount: partSize)
            } else {
                // Fallback on earlier versions
                fileHandle?.seek(toFileOffset: UInt64(i * partSize))
                data = fileHandle?.readData(ofLength: partSize)
            }
            let uploadPartRequest = UploadPartRequest(bucket: bucketName,
                                                      key: objectKey,
                                                      partNumber: i + 1,
                                                      uploadId: result!.uploadId!,
                                                      body: .data(data!))
            let UploadPartResult = try await client?.uploadPart(uploadPartRequest)
            XCTAssertEqual(UploadPartResult?.statusCode, 200)
        }

        let completeUploadRequest = CompleteMultipartUploadRequest(bucket: bucketName,
                                                                   key: objectKey,
                                                                   completeAll: "yes",
                                                                   uploadId: result!.uploadId!)
        let completeUploadResult = try await client?.completeMultipartUpload(completeUploadRequest)
        XCTAssertEqual(completeUploadResult?.statusCode, 200)

//        var data = Data()
//        let getRequest = GetObjectRequest(bucket: bucketName,
//                                          key: objectKey,
//                                          downloadable: .receive {
//                                              data.append($0)
//                                          })
//        let getResult = try await client?.getObject(getRequest)
//
//        XCTAssertEqual(getResult?.statusCode, 200)
//        let md5 = try Data(contentsOf: URL(fileURLWithPath: filePath)).calculateMd5().toBase64String()
//        let md = data.calculateMd5().toBase64String()
//        XCTAssertTrue(md == md5)
        removeTestFile(filePath)
    }

    func testInitiateMultipartUploadWithOverwrite() async throws {
        let objectKey = "testInitiateMultipartUploadWithOverwrite"
        let partSize = 100 * 1024
        let filePath = createTestFile("middle", 1024 * 1024)!
        let data = "hellow oss".data(using: .utf8)!

        let PutObjectRequest = PutObjectRequest(bucket: bucketName,
                                                key: objectKey,
                                                body: .data(data))
        try await assertNoThrow(await client?.putObject(PutObjectRequest))
//        let exist = try await client?.doesObjectExist(bucket: bucketName, key: objectKey)
//        XCTAssertTrue(exist!)

        var reqesut = InitiateMultipartUploadRequest(bucket: bucketName, key: objectKey)
        reqesut.forbidOverwrite = true
        try await assertThrowsAsyncError(await client?.initiateMultipartUpload(reqesut)) { error in
            if let serverError = error as? ServerError {
                XCTAssertEqual(serverError.statusCode, 409)
            } else {
                XCTFail()
            }
        }

        let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
        guard let fileSize = fileAttributes[FileAttributeKey.size] as? Int else {
            XCTFail("Can not get file size.")
            return
        }

        reqesut = InitiateMultipartUploadRequest(bucket: bucketName, key: objectKey)
        reqesut.forbidOverwrite = false
        let result = try await client?.initiateMultipartUpload(reqesut)
        XCTAssertEqual(result?.statusCode, 200)
        XCTAssertNotNil(result?.uploadId)

        let partCount = fileSize / partSize + (fileSize % partSize > 0 ? 1 : 0)
        for i in 0 ..< partCount {
            let fileHandle = FileHandle(forReadingAtPath: filePath)
            var data: Data?
            if #available(iOS 13.4, *) {
                try fileHandle?.seek(toOffset: UInt64(i * partSize))
                data = try fileHandle?.read(upToCount: partSize)
            } else {
                // Fallback on earlier versions
                fileHandle?.seek(toFileOffset: UInt64(i * partSize))
                data = fileHandle?.readData(ofLength: partSize)
            }
            let uploadPartRequest = UploadPartRequest(bucket: bucketName,
                                                      key: objectKey,
                                                      partNumber: i + 1,
                                                      uploadId: result!.uploadId!,
                                                      body: .data(data!))
            let UploadPartResult = try await client?.uploadPart(uploadPartRequest)
            XCTAssertEqual(UploadPartResult?.statusCode, 200)
        }

        let completeUploadRequest = CompleteMultipartUploadRequest(bucket: bucketName,
                                                                   key: objectKey,
                                                                   completeAll: "yes",
                                                                   uploadId: result!.uploadId!)
        let completeUploadResult = try await client?.completeMultipartUpload(completeUploadRequest)
        XCTAssertEqual(completeUploadResult?.statusCode, 200)

//        var data = Data()
//        let getRequest = GetObjectRequest(bucket: bucketName,
//                                          key: objectKey,
//                                          downloadable: .receive {
//                                              data.append($0)
//                                          })
//        let getResult = try await client?.getObject(getRequest)
//
//        XCTAssertEqual(getResult?.statusCode, 200)
//        let md5 = try Data(contentsOf: URL(fileURLWithPath: filePath)).calculateMd5().toBase64String()
//        let md = data.calculateMd5().toBase64String()
//        XCTAssertTrue(md == md5)

        removeTestFile(filePath)
    }

    func testInitiateMultipartUploadWithStorageClass() async throws {
        let objectKey = "testInitiateMultipartUploadWithStorageClass"
        let partSize = 100 * 1024
        let filePath = createTestFile("middle", 1024 * 1024)!
        let storageClass = "Archive"

        let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
        guard let fileSize = fileAttributes[FileAttributeKey.size] as? Int else {
            XCTFail("Can not get file size.")
            return
        }

        var reqesut = InitiateMultipartUploadRequest(bucket: bucketName, key: objectKey)
        reqesut.storageClass = storageClass
        let result = try await client?.initiateMultipartUpload(reqesut)
        XCTAssertEqual(result?.statusCode, 200)
        XCTAssertNotNil(result?.uploadId)

        let partCount = fileSize / partSize + (fileSize % partSize > 0 ? 1 : 0)
        for i in 0 ..< partCount {
            let fileHandle = FileHandle(forReadingAtPath: filePath)
            var data: Data?
            if #available(iOS 13.4, *) {
                try fileHandle?.seek(toOffset: UInt64(i * partSize))
                data = try fileHandle?.read(upToCount: partSize)
            } else {
                // Fallback on earlier versions
                fileHandle?.seek(toFileOffset: UInt64(i * partSize))
                data = fileHandle?.readData(ofLength: partSize)
            }
            let uploadPartRequest = UploadPartRequest(bucket: bucketName,
                                                      key: objectKey,
                                                      partNumber: i + 1,
                                                      uploadId: result!.uploadId!,
                                                      body: .data(data!))
            let UploadPartResult = try await client?.uploadPart(uploadPartRequest)
            XCTAssertEqual(UploadPartResult?.statusCode, 200)
        }

        let completeUploadRequest = CompleteMultipartUploadRequest(bucket: bucketName,
                                                                   key: objectKey,
                                                                   completeAll: "yes",
                                                                   uploadId: result!.uploadId!)
        let completeUploadResult = try await client?.completeMultipartUpload(completeUploadRequest)
        XCTAssertEqual(completeUploadResult?.statusCode, 200)

        let headRequest = HeadObjectRequest(bucket: bucketName, key: objectKey)
        let headResult = try await client?.headObject(headRequest)
        XCTAssertEqual(headResult?.storageClass, storageClass)

        removeTestFile(filePath)
    }

    // MARK: - test UploadPart

    func testUploadPart() async throws {
        let objectKey = "testUploadPart"
        let partSize = 100 * 1024
        let filePath = createTestFile("middle", 1024 * 1024)!

        let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
        guard let fileSize = fileAttributes[FileAttributeKey.size] as? Int else {
            XCTFail("Can not get file size.")
            return
        }

        let reqesut = InitiateMultipartUploadRequest(bucket: bucketName, key: objectKey)
        let result = try await client?.initiateMultipartUpload(reqesut)
        XCTAssertEqual(result?.statusCode, 200)
        XCTAssertNotNil(result?.uploadId)

        let partCount = fileSize / partSize + (fileSize % partSize > 0 ? 1 : 0)
        for i in 0 ..< partCount {
            let fileHandle = FileHandle(forReadingAtPath: filePath)
            var data: Data?
            if #available(iOS 13.4, *) {
                try fileHandle?.seek(toOffset: UInt64(i * partSize))
                data = try fileHandle?.read(upToCount: partSize)
            } else {
                // Fallback on earlier versions
                fileHandle?.seek(toFileOffset: UInt64(i * partSize))
                data = fileHandle?.readData(ofLength: partSize)
            }
            var uploadPartRequest = UploadPartRequest(bucket: bucketName,
                                                      key: objectKey,
                                                      partNumber: i + 1,
                                                      uploadId: result!.uploadId!,
                                                      body: .data(data!))
            uploadPartRequest.commonProp.headers = ["Content-MD5": data!.calculateMd5().toBase64String()]
            let UploadPartResult = try await client?.uploadPart(uploadPartRequest)
            XCTAssertEqual(UploadPartResult?.statusCode, 200)
        }

        let completeUploadRequest = CompleteMultipartUploadRequest(bucket: bucketName,
                                                                   key: objectKey,
                                                                   completeAll: "yes",
                                                                   uploadId: result!.uploadId!)
        let completeUploadResult = try await client?.completeMultipartUpload(completeUploadRequest)
        XCTAssertEqual(completeUploadResult?.statusCode, 200)

//        var data = Data()
//        let getRequest = GetObjectRequest(bucket: bucketName,
//                                          key: objectKey,
//                                          downloadable: .receive {
//                                              data.append($0)
//                                          })
//        let getResult = try await client?.getObject(getRequest)
//
//        XCTAssertEqual(getResult?.statusCode, 200)
//        let md5 = try Data(contentsOf: URL(fileURLWithPath: filePath)).calculateMd5().toBase64String()
//        let md = data.calculateMd5().toBase64String()
//        XCTAssertTrue(md == md5)

        removeTestFile(filePath)
    }

    func testUploadPartWithProgress() async throws {
        let objectKey = randomObjectName()
        let size: Int64 = 5 * 1024 * 1024
        let file = URL(fileURLWithPath: createTestFile(randomFileName(), Int(size))!)
        nonisolated(unsafe) var totalBytesSented: Int64 = 0

        let initReqesut = InitiateMultipartUploadRequest(bucket: bucketName, key: objectKey)
        let initResult = try await client?.initiateMultipartUpload(initReqesut)
        XCTAssertEqual(initResult?.statusCode, 200)
        XCTAssertNotNil(initResult?.uploadId)

        var request = UploadPartRequest(bucket: bucketName,
                                        key: objectKey,
                                        partNumber: 1,
                                        uploadId: initResult!.uploadId,
                                        body: .file(file))
        request.progress = ProgressClosure { bytesSent, totalBytesSent, totalBytesExpectedToSend in
            totalBytesSented += bytesSent
            XCTAssertEqual(totalBytesSented, totalBytesSent)
            XCTAssertEqual(totalBytesExpectedToSend, size)
        }
        let result = try await client?.uploadPart(request)
        XCTAssertEqual(result?.statusCode, 200)
        XCTAssertEqual(totalBytesSented, size)

        let deleteReqeust = DeleteObjectRequest(bucket: bucketName, key: objectKey)
        let _ = try await client?.deleteObject(deleteReqeust)
    }

    func testUploadPartError() async throws {
        let objectKey = "testUploadPartError"
        let data = "hello oss".data(using: .utf8)!

        var uploadPartRequest = UploadPartRequest(bucket: bucketName,
                                                  key: objectKey,
                                                  partNumber: 1,
                                                  uploadId: "error-upload-id",
                                                  body: .data(data))
        try await assertThrowsAsyncError(await client?.uploadPart(uploadPartRequest)) { error in
            if let serverError = error as? ServerError {
                XCTAssertEqual(serverError.statusCode, 404)
            } else {
                XCTFail()
            }
        }

        let reqesut = InitiateMultipartUploadRequest(bucket: bucketName, key: objectKey)
        let result = try await client?.initiateMultipartUpload(reqesut)
        XCTAssertEqual(result?.statusCode, 200)
        XCTAssertNotNil(result?.uploadId)

        uploadPartRequest = UploadPartRequest(bucket: bucketName,
                                              key: objectKey,
                                              partNumber: 10001,
                                              uploadId: result!.uploadId!,
                                              body: .data(data))
        try await assertThrowsAsyncError(await client?.uploadPart(uploadPartRequest)) { error in
            if let serverError = error as? ServerError {
                XCTAssertEqual(serverError.statusCode, 400)
            } else {
                XCTFail()
            }
        }

        uploadPartRequest = UploadPartRequest(bucket: bucketName,
                                              key: objectKey,
                                              partNumber: 1,
                                              uploadId: result!.uploadId!,
                                              body: .data(data))
        uploadPartRequest.commonProp.headers = ["Content-MD5": "eB5eJF1ptWaXm4bijS****=="]
        try await assertThrowsAsyncError(await client?.uploadPart(uploadPartRequest)) { error in
            if let serverError = error as? ServerError {
                XCTAssertEqual(serverError.statusCode, 400)
            } else {
                XCTFail()
            }
        }
    }

    // MARK: - test UploadPartCopy

    func testUploadPartCopy() async throws {
        let originalObjectKey = "testUploadPartCopyOrigin"
        let objectKey = "testUploadPartCopy"
        let partSize = 100 * 1024
        let filePath = createTestFile("middle", 1024 * 1024)!
        let copyPartNum = 11

        let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
        guard let fileSize = fileAttributes[FileAttributeKey.size] as? Int else {
            XCTFail("Can not get file size.")
            return
        }

        let reqesut = InitiateMultipartUploadRequest(bucket: bucketName, key: objectKey)
        let result = try await client?.initiateMultipartUpload(reqesut)
        XCTAssertEqual(result?.statusCode, 200)
        XCTAssertNotNil(result?.uploadId)

        let partCount = fileSize / partSize + (fileSize % partSize > 0 ? 1 : 0)
        for i in 0 ..< partCount {
            let fileHandle = FileHandle(forReadingAtPath: filePath)
            var data: Data?
            if #available(iOS 13.4, *) {
                try fileHandle?.seek(toOffset: UInt64(i * partSize))
                data = try fileHandle?.read(upToCount: partSize)
            } else {
                // Fallback on earlier versions
                fileHandle?.seek(toFileOffset: UInt64(i * partSize))
                data = fileHandle?.readData(ofLength: partSize)
            }
            if i == copyPartNum - 1 {
                let PutObjectRequest = PutObjectRequest(bucket: bucketName,
                                                        key: originalObjectKey,
                                                        body: .data(data!))
                try await assertNoThrow(await client?.putObject(PutObjectRequest))
//                let exist = try await client?.doesObjectExist(bucket: bucketName, key: originalObjectKey)
//                XCTAssertTrue(exist!)

                continue
            }
            let uploadPartRequest = UploadPartRequest(bucket: bucketName,
                                                      key: objectKey,
                                                      partNumber: i + 1,
                                                      uploadId: result!.uploadId!,
                                                      body: .data(data!))
            let UploadPartResult = try await client?.uploadPart(uploadPartRequest)
            XCTAssertEqual(UploadPartResult?.statusCode, 200)
        }

        // TODO: copy
        let copyPartRequest = UploadPartCopyRequest(bucket: bucketName,
                                                    key: objectKey,
                                                    sourceBucket: bucketName,
                                                    sourceKey: originalObjectKey,
                                                    partNumber: copyPartNum,
                                                    uploadId: result!.uploadId!)
        try await assertNoThrow(await client?.uploadPartCopy(copyPartRequest))

        let completeUploadRequest = CompleteMultipartUploadRequest(bucket: bucketName,
                                                                   key: objectKey,
                                                                   completeAll: "yes",
                                                                   uploadId: result!.uploadId!)
        let completeUploadResult = try await client?.completeMultipartUpload(completeUploadRequest)
        XCTAssertEqual(completeUploadResult?.statusCode, 200)

//        var data = Data()
//        let getRequest = GetObjectRequest(bucket: bucketName,
//                                          key: objectKey,
//                                          downloadable: .receive {
//                                              data.append($0)
//                                          })
//        let getResult = try await client?.getObject(getRequest)
//
//        XCTAssertEqual(getResult?.statusCode, 200)
//        let md5 = try Data(contentsOf: URL(fileURLWithPath: filePath)).calculateMd5().toBase64String()
//        let md = data.calculateMd5().toBase64String()
//        XCTAssertTrue(md == md5)

        removeTestFile(filePath)
    }

    func testUploadPartCopyWithSourceRange() async throws {
        let originalObjectKey = "testUploadPartCopyOrigin"
        let objectKey = "testUploadPartCopyWithSourceRange"
        let partSize = 100 * 1024
        let filePath = createTestFile("middle", 1024 * 1024)!
        let copyPartNum = 11

        let PutObjectRequest = PutObjectRequest(bucket: bucketName,
                                                key: originalObjectKey,
                                                body: .file(URL(fileURLWithPath: filePath)))
        try await assertNoThrow(await client?.putObject(PutObjectRequest))
//        let exist = try await client?.doesObjectExist(bucket: bucketName, key: originalObjectKey)
//        XCTAssertTrue(exist!)

        let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
        guard let fileSize = fileAttributes[FileAttributeKey.size] as? Int else {
            XCTFail("Can not get file size.")
            return
        }

        let reqesut = InitiateMultipartUploadRequest(bucket: bucketName, key: objectKey)
        let result = try await client?.initiateMultipartUpload(reqesut)
        XCTAssertEqual(result?.statusCode, 200)
        XCTAssertNotNil(result?.uploadId)

        let partCount = fileSize / partSize + (fileSize % partSize > 0 ? 1 : 0)
        for i in 0 ..< partCount {
            if i == copyPartNum - 1 {
                continue
            }

            let fileHandle = FileHandle(forReadingAtPath: filePath)
            var data: Data?
            if #available(iOS 13.4, *) {
                try fileHandle?.seek(toOffset: UInt64(i * partSize))
                data = try fileHandle?.read(upToCount: partSize)
            } else {
                // Fallback on earlier versions
                fileHandle?.seek(toFileOffset: UInt64(i * partSize))
                data = fileHandle?.readData(ofLength: partSize)
            }

            let uploadPartRequest = UploadPartRequest(bucket: bucketName,
                                                      key: objectKey,
                                                      partNumber: i + 1,
                                                      uploadId: result!.uploadId!,
                                                      body: .data(data!))
            let UploadPartResult = try await client?.uploadPart(uploadPartRequest)
            XCTAssertEqual(UploadPartResult?.statusCode, 200)
        }

        // TODO: copy
        var copyPartRequest = UploadPartCopyRequest(bucket: bucketName,
                                                    key: objectKey,
                                                    sourceBucket: bucketName,
                                                    sourceKey: originalObjectKey,
                                                    partNumber: copyPartNum,
                                                    uploadId: result!.uploadId!)
        copyPartRequest.copySourceRange = Range(start: UInt64((copyPartNum - 1) * partSize), end: UInt64(copyPartNum * partSize) - 1).asString()
        try await assertNoThrow(await client?.uploadPartCopy(copyPartRequest))

        let completeUploadRequest = CompleteMultipartUploadRequest(bucket: bucketName,
                                                                   key: objectKey,
                                                                   completeAll: "yes",
                                                                   uploadId: result!.uploadId!)
        let completeUploadResult = try await client?.completeMultipartUpload(completeUploadRequest)
        XCTAssertEqual(completeUploadResult?.statusCode, 200)

//        var data = Data()
//        let getRequest = GetObjectRequest(bucket: bucketName,
//                                          key: objectKey,
//                                          downloadable: .receive {
//                                              data.append($0)
//                                          })
//        let getResult = try await client?.getObject(getRequest)
//
//        XCTAssertEqual(getResult?.statusCode, 200)
//        let md5 = try Data(contentsOf: URL(fileURLWithPath: filePath)).calculateMd5().toBase64String()
//        let md = data.calculateMd5().toBase64String()
//        XCTAssertTrue(md == md5)

        removeTestFile(filePath)
    }

    func testUploadPartCopyWithHeader() async throws {
        let originalObjectKey = "testUploadPartCopyOrigin"
        let objectKey = "testUploadPartCopyWithHeader"
        let partSize = 100 * 1024
        let filePath = createTestFile("middle", 1024 * 1024)!
        let copyPartNum = 20
        let date = Date(timeIntervalSince1970: Date().timeIntervalSince1970 - 60)

        let fileHandle = FileHandle(forReadingAtPath: filePath)
        var data: Data?
        if #available(iOS 13.4, *) {
            data = try fileHandle?.read(upToCount: partSize)
        } else {
            // Fallback on earlier versions
            data = fileHandle?.readData(ofLength: partSize)
        }
        let PutObjectRequest = PutObjectRequest(bucket: bucketName,
                                                key: originalObjectKey,
                                                body: .data(data!))
        let PutObjectResult = try await client?.putObject(PutObjectRequest)
//        let exist = try await client?.doesObjectExist(bucket: bucketName, key: originalObjectKey)
//        XCTAssertTrue(exist!)

        let reqesut = InitiateMultipartUploadRequest(bucket: bucketName, key: objectKey)
        let result = try await client?.initiateMultipartUpload(reqesut)
        XCTAssertEqual(result?.statusCode, 200)
        XCTAssertNotNil(result?.uploadId)

        // TODO: copy
        // test copySourceIfMatch
        var copyPartRequest = UploadPartCopyRequest(bucket: bucketName,
                                                    key: objectKey,
                                                    sourceBucket: bucketName,
                                                    sourceKey: originalObjectKey,
                                                    partNumber: copyPartNum,
                                                    uploadId: result!.uploadId!)
        copyPartRequest.copySourceIfMatch = "error-etag"
        try await assertThrowsAsyncError(await client?.uploadPartCopy(copyPartRequest)) { error in
            if let serverError = error as? ServerError {
                XCTAssertEqual(serverError.statusCode, 412)
            } else {
                XCTFail()
            }
        }

        copyPartRequest = UploadPartCopyRequest(bucket: bucketName,
                                                key: objectKey,
                                                sourceBucket: bucketName,
                                                sourceKey: originalObjectKey,
                                                partNumber: copyPartNum,
                                                uploadId: result!.uploadId!)
        copyPartRequest.copySourceIfMatch = PutObjectResult?.etag
        try await assertNoThrow(await client?.uploadPartCopy(copyPartRequest))

        // test copySourceIfNoneMatch
        copyPartRequest = UploadPartCopyRequest(bucket: bucketName,
                                                key: objectKey,
                                                sourceBucket: bucketName,
                                                sourceKey: originalObjectKey,
                                                partNumber: copyPartNum,
                                                uploadId: result!.uploadId!)
        copyPartRequest.copySourceIfNoneMatch = PutObjectResult?.etag
        try await assertThrowsAsyncError(await client?.uploadPartCopy(copyPartRequest)) { error in
            if let serverError = error as? ServerError {
                XCTAssertEqual(serverError.statusCode, 304)
            } else {
                XCTFail()
            }
        }

        copyPartRequest = UploadPartCopyRequest(bucket: bucketName,
                                                key: objectKey,
                                                sourceBucket: bucketName,
                                                sourceKey: originalObjectKey,
                                                partNumber: copyPartNum,
                                                uploadId: result!.uploadId!)
        copyPartRequest.copySourceIfNoneMatch = "error-etag"
        try await assertNoThrow(await client?.uploadPartCopy(copyPartRequest))

        // test copySourceIfModifiedSince
        copyPartRequest = UploadPartCopyRequest(bucket: bucketName,
                                                key: objectKey,
                                                sourceBucket: bucketName,
                                                sourceKey: originalObjectKey,
                                                partNumber: copyPartNum,
                                                uploadId: result!.uploadId!)
        copyPartRequest.copySourceIfModifiedSince = DateFormatter.rfc5322DateTime.string(from: Date())
        try await assertThrowsAsyncError(await client?.uploadPartCopy(copyPartRequest)) { error in
            if let serverError = error as? ServerError {
                XCTAssertEqual(serverError.statusCode, 304)
            } else {
                XCTFail()
            }
        }

        copyPartRequest = UploadPartCopyRequest(bucket: bucketName,
                                                key: objectKey,
                                                sourceBucket: bucketName,
                                                sourceKey: originalObjectKey,
                                                partNumber: copyPartNum,
                                                uploadId: result!.uploadId!)
        copyPartRequest.copySourceIfModifiedSince = DateFormatter.rfc5322DateTime.string(from: date)
        try await assertNoThrow(await client?.uploadPartCopy(copyPartRequest))

        // test copySourceIfUnmodifiedSince
        copyPartRequest = UploadPartCopyRequest(bucket: bucketName,
                                                key: objectKey,
                                                sourceBucket: bucketName,
                                                sourceKey: originalObjectKey,
                                                partNumber: copyPartNum,
                                                uploadId: result!.uploadId!)
        copyPartRequest.copySourceIfUnmodifiedSince = DateFormatter.rfc5322DateTime.string(from: date)
        try await assertThrowsAsyncError(await client?.uploadPartCopy(copyPartRequest)) { error in
            if let serverError = error as? ServerError {
                XCTAssertEqual(serverError.statusCode, 412)
            } else {
                XCTFail()
            }
        }

        copyPartRequest = UploadPartCopyRequest(bucket: bucketName,
                                                key: objectKey,
                                                sourceBucket: bucketName,
                                                sourceKey: originalObjectKey,
                                                partNumber: copyPartNum,
                                                uploadId: result!.uploadId!)
        copyPartRequest.copySourceIfUnmodifiedSince = DateFormatter.rfc5322DateTime.string(from: Date())
        try await assertNoThrow(await client?.uploadPartCopy(copyPartRequest))

        removeTestFile(filePath)
    }

    // MARK: - test AbortMultipartUpload

    func testAbortMultipartUpload() async throws {
        let objectKey = "testAbortMultipartUpload"
        let partSize = 100 * 1024
        let filePath = createTestFile("middle", 1024 * 1024)!

        let reqesut = InitiateMultipartUploadRequest(bucket: bucketName, key: objectKey)
        let result = try await client?.initiateMultipartUpload(reqesut)
        XCTAssertEqual(result?.statusCode, 200)
        XCTAssertNotNil(result?.uploadId)

        let fileHandle = FileHandle(forReadingAtPath: filePath)
        var data: Data?
        if #available(iOS 13.4, *) {
            data = try fileHandle?.read(upToCount: partSize)
        } else {
            // Fallback on earlier versions
            data = fileHandle?.readData(ofLength: partSize)
        }
        var uploadPartRequest = UploadPartRequest(bucket: bucketName,
                                                  key: objectKey,
                                                  partNumber: 1,
                                                  uploadId: result!.uploadId!,
                                                  body: .data(data!))
        let UploadPartResult = try await client?.uploadPart(uploadPartRequest)
        XCTAssertEqual(UploadPartResult?.statusCode, 200)

        let abortRequest = AbortMultipartUploadRequest(bucket: bucketName,
                                                       key: objectKey,
                                                       uploadId: result!.uploadId!)
        let abortResult = try await client?.abortMultipartUpload(abortRequest)
        XCTAssertEqual(abortResult?.statusCode, 204)

        uploadPartRequest = UploadPartRequest(bucket: bucketName,
                                              key: objectKey,
                                              partNumber: 1,
                                              uploadId: result!.uploadId!,
                                              body: .data(data!))
        try await assertThrowsAsyncError(await client?.uploadPart(uploadPartRequest)) { error in
            if let serverError = error as? ServerError {
                XCTAssertEqual(serverError.statusCode, 404)
            } else {
                XCTFail()
            }
        }

        let completeUploadRequest = CompleteMultipartUploadRequest(bucket: bucketName,
                                                                   key: objectKey,
                                                                   completeAll: "yes",
                                                                   uploadId: result!.uploadId!)
        try await assertThrowsAsyncError(await client?.completeMultipartUpload(completeUploadRequest)) { error in
            if let serverError = error as? ServerError {
                XCTAssertEqual(serverError.statusCode, 404)
            } else {
                XCTFail()
            }
        }

        removeTestFile(filePath)
    }

    func testAbortMultipartUploadError() async throws {
        let objectKey = "testAbortMultipartUpload"
        let partSize = 100 * 1024
        let filePath = createTestFile("middle", 1024 * 1024)!

        let reqesut = InitiateMultipartUploadRequest(bucket: bucketName, key: objectKey)
        let result = try await client?.initiateMultipartUpload(reqesut)
        XCTAssertEqual(result?.statusCode, 200)
        XCTAssertNotNil(result?.uploadId)

        let fileHandle = FileHandle(forReadingAtPath: filePath)
        var data: Data?
        if #available(iOS 13.4, *) {
            data = try fileHandle?.read(upToCount: partSize)
        } else {
            // Fallback on earlier versions
            data = fileHandle?.readData(ofLength: partSize)
        }
        let uploadPartRequest = UploadPartRequest(bucket: bucketName,
                                                  key: objectKey,
                                                  partNumber: 1,
                                                  uploadId: result!.uploadId!,
                                                  body: .data(data!))
        let UploadPartResult = try await client?.uploadPart(uploadPartRequest)
        XCTAssertEqual(UploadPartResult?.statusCode, 200)

        var abortRequest = AbortMultipartUploadRequest(bucket: bucketName,
                                                       key: objectKey,
                                                       uploadId: result!.uploadId!)
        let abortResult = try await client?.abortMultipartUpload(abortRequest)
        XCTAssertEqual(abortResult?.statusCode, 204)

        abortRequest = AbortMultipartUploadRequest(bucket: bucketName,
                                                   key: objectKey,
                                                   uploadId: result!.uploadId!)
        try await assertThrowsAsyncError(await client?.abortMultipartUpload(abortRequest)) { error in
            if let serverError = error as? ServerError {
                XCTAssertEqual(serverError.statusCode, 404)
            } else {
                XCTFail()
            }
        }

        removeTestFile(filePath)
    }

    // MARK: - test CompleteMultipartUpload

    func testCompleteMultipartUpload() async throws {
        let objectKey = "testCompleteMultipartUpload"
        let partSize = 100 * 1024
        let filePath = createTestFile("middle", 1024 * 1024)!

        let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
        guard let fileSize = fileAttributes[FileAttributeKey.size] as? Int else {
            XCTFail("Can not get file size.")
            return
        }

        let reqesut = InitiateMultipartUploadRequest(bucket: bucketName, key: objectKey)
        let result = try await client?.initiateMultipartUpload(reqesut)
        XCTAssertEqual(result?.statusCode, 200)
        XCTAssertNotNil(result?.uploadId)

        let partCount = fileSize / partSize + (fileSize % partSize > 0 ? 1 : 0)
        for i in 0 ..< partCount {
            let fileHandle = FileHandle(forReadingAtPath: filePath)
            var data: Data?
            if #available(iOS 13.4, *) {
                try fileHandle?.seek(toOffset: UInt64(i * partSize))
                data = try fileHandle?.read(upToCount: partSize)
            } else {
                // Fallback on earlier versions
                fileHandle?.seek(toFileOffset: UInt64(i * partSize))
                data = fileHandle?.readData(ofLength: partSize)
            }
            let uploadPartRequest = UploadPartRequest(bucket: bucketName,
                                                      key: objectKey,
                                                      partNumber: i + 1,
                                                      uploadId: result!.uploadId!,
                                                      body: .data(data!))
            let UploadPartResult = try await client?.uploadPart(uploadPartRequest)
            XCTAssertEqual(UploadPartResult?.statusCode, 200)
        }

        let completeUploadRequest = CompleteMultipartUploadRequest(bucket: bucketName,
                                                                   key: objectKey,
                                                                   completeAll: "yes",
                                                                   uploadId: result!.uploadId!)
        let completeUploadResult = try await client?.completeMultipartUpload(completeUploadRequest)
        XCTAssertEqual(completeUploadResult?.statusCode, 200)

//        var data = Data()
//        let getRequest = GetObjectRequest(bucket: bucketName,
//                                          key: objectKey,
//                                          downloadable: .receive {
//                                              data.append($0)
//                                          })
//        let getResult = try await client?.getObject(getRequest)
//
//        XCTAssertEqual(getResult?.statusCode, 200)
//        let md5 = try Data(contentsOf: URL(fileURLWithPath: filePath)).calculateMd5().toBase64String()
//        let md = data.calculateMd5().toBase64String()
//        XCTAssertTrue(md == md5)

        removeTestFile(filePath)
    }

    func testCompleteMultipartUploadWithParts() async throws {
        let objectKey = "testCompleteMultipartUploadWithParts"
        let partSize = 100 * 1024
        let filePath = createTestFile("middle", 1024 * 1024)!

        let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
        guard let fileSize = fileAttributes[FileAttributeKey.size] as? Int else {
            XCTFail("Can not get file size.")
            return
        }

        let reqesut = InitiateMultipartUploadRequest(bucket: bucketName, key: objectKey)
        let result = try await client?.initiateMultipartUpload(reqesut)
        XCTAssertEqual(result?.statusCode, 200)
        XCTAssertNotNil(result?.uploadId)

        var parts: [UploadPart] = []
        let partCount = fileSize / partSize + (fileSize % partSize > 0 ? 1 : 0)
        for i in 0 ..< partCount {
            let fileHandle = FileHandle(forReadingAtPath: filePath)
            var data: Data?
            if #available(iOS 13.4, *) {
                try fileHandle?.seek(toOffset: UInt64(i * partSize))
                data = try fileHandle?.read(upToCount: partSize)
            } else {
                // Fallback on earlier versions
                fileHandle?.seek(toFileOffset: UInt64(i * partSize))
                data = fileHandle?.readData(ofLength: partSize)
            }
            let uploadPartRequest = UploadPartRequest(bucket: bucketName,
                                                      key: objectKey,
                                                      partNumber: i + 1,
                                                      uploadId: result!.uploadId!,
                                                      body: .data(data!))
            let UploadPartResult = try await client?.uploadPart(uploadPartRequest)
            XCTAssertEqual(UploadPartResult?.statusCode, 200)

            let part = UploadPart(etag: UploadPartResult!.etag!, partNumber: uploadPartRequest.partNumber)
            parts.append(part)
        }

        let completeUploadRequest = CompleteMultipartUploadRequest(bucket: bucketName,
                                                                   key: objectKey,
                                                                   uploadId: result!.uploadId!,
                                                                   completeMultipartUpload: CompleteMultipartUpload(parts: parts))
        let completeUploadResult = try await client?.completeMultipartUpload(completeUploadRequest)
        XCTAssertEqual(completeUploadResult?.statusCode, 200)

//        var data = Data()
//        let getRequest = GetObjectRequest(bucket: bucketName,
//                                          key: objectKey,
//                                          downloadable: .receive {
//                                              data.append($0)
//                                          })
//        let getResult = try await client?.getObject(getRequest)
//
//        XCTAssertEqual(getResult?.statusCode, 200)
//        let md5 = try Data(contentsOf: URL(fileURLWithPath: filePath)).calculateMd5().toBase64String()
//        let md = data.calculateMd5().toBase64String()
//        XCTAssertTrue(md == md5)

        removeTestFile(filePath)
    }

    func testCompleteMultipartUploadWithCallback() async throws {
        let objectKey = "testCompleteMultipartUploadWithCallback"
        let partSize = 100 * 1024
        let filePath = createTestFile("middle", 1024 * 1024)!

        let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
        guard let fileSize = fileAttributes[FileAttributeKey.size] as? Int else {
            XCTFail("Can not get file size.")
            return
        }

        let reqesut = InitiateMultipartUploadRequest(bucket: bucketName, key: objectKey)
        let result = try await client?.initiateMultipartUpload(reqesut)
        XCTAssertEqual(result?.statusCode, 200)
        XCTAssertNotNil(result?.uploadId)

        let partCount = fileSize / partSize + (fileSize % partSize > 0 ? 1 : 0)
        for i in 0 ..< partCount {
            let fileHandle = FileHandle(forReadingAtPath: filePath)
            var data: Data?
            if #available(iOS 13.4, *) {
                try fileHandle?.seek(toOffset: UInt64(i * partSize))
                data = try fileHandle?.read(upToCount: partSize)
            } else {
                // Fallback on earlier versions
                fileHandle?.seek(toFileOffset: UInt64(i * partSize))
                data = fileHandle?.readData(ofLength: partSize)
            }
            let uploadPartRequest = UploadPartRequest(bucket: bucketName,
                                                      key: objectKey,
                                                      partNumber: i + 1,
                                                      uploadId: result!.uploadId!,
                                                      body: .data(data!))
            let UploadPartResult = try await client?.uploadPart(uploadPartRequest)
            XCTAssertEqual(UploadPartResult?.statusCode, 200)
        }

//        let callback = Callback(callbackUrl: callback,
//                                callbackBody: "bucket=${bucket}")
//        var completeUploadRequest = CompleteMultipartUploadRequest(bucket: bucketName,
//                                                                   key: objectKey,
//                                                                   completeAll: "all",
//                                                                   uploadId: result!.uploadId!)
//        completeUploadRequest.callback = callback
//        let completeUploadResult = try await client?.completeMultipartUpload(completeUploadRequest)
//        XCTAssertEqual(completeUploadResult?.statusCode, 200)
//        XCTAssertNotNil(completeUploadResult?.callbackResponseBody)

//        var data = Data()
//        let getRequest = GetObjectRequest(bucket: bucketName,
//                                          key: objectKey,
//                                          downloadable: .receive {
//                                              data.append($0)
//                                          })
//        let getResult = try await client?.getObject(getRequest)
//
//        XCTAssertEqual(getResult?.statusCode, 200)
//        let md5 = try Data(contentsOf: URL(fileURLWithPath: filePath)).calculateMd5().toBase64String()
//        let md = data.calculateMd5().toBase64String()
//        XCTAssertTrue(md == md5)

        removeTestFile(filePath)
    }

    func testCompleteMultipartUploadWithOverwrite() async throws {
        let objectKey = "testCompleteMultipartUploadWithOverwrite"
        let partSize = 100 * 1024
        let filePath = createTestFile("middle", 1024 * 1024)!

        let PutObjectRequest = PutObjectRequest(bucket: bucketName,
                                                key: objectKey,
                                                body: .file(URL(fileURLWithPath: filePath)))
        try await assertNoThrow(await client?.putObject(PutObjectRequest))
//        let exist = try await client?.doesObjectExist(bucket: bucketName, key: objectKey)
//        XCTAssertTrue(exist!)

        let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
        guard let fileSize = fileAttributes[FileAttributeKey.size] as? Int else {
            XCTFail("Can not get file size.")
            return
        }

        let reqesut = InitiateMultipartUploadRequest(bucket: bucketName, key: objectKey)
        let result = try await client?.initiateMultipartUpload(reqesut)
        XCTAssertEqual(result?.statusCode, 200)
        XCTAssertNotNil(result?.uploadId)

        let partCount = fileSize / partSize + (fileSize % partSize > 0 ? 1 : 0)
        for i in 0 ..< partCount {
            let fileHandle = FileHandle(forReadingAtPath: filePath)
            var data: Data?
            if #available(iOS 13.4, *) {
                try fileHandle?.seek(toOffset: UInt64(i * partSize))
                data = try fileHandle?.read(upToCount: partSize)
            } else {
                // Fallback on earlier versions
                fileHandle?.seek(toFileOffset: UInt64(i * partSize))
                data = fileHandle?.readData(ofLength: partSize)
            }
            let uploadPartRequest = UploadPartRequest(bucket: bucketName,
                                                      key: objectKey,
                                                      partNumber: i + 1,
                                                      uploadId: result!.uploadId!,
                                                      body: .data(data!))
            let UploadPartResult = try await client?.uploadPart(uploadPartRequest)
            XCTAssertEqual(UploadPartResult?.statusCode, 200)
        }

        var completeUploadRequest = CompleteMultipartUploadRequest(bucket: bucketName,
                                                                   key: objectKey,
                                                                   completeAll: "yes",
                                                                   uploadId: result!.uploadId!)
        completeUploadRequest.forbidOverwrite = true
        try await assertThrowsAsyncError(await client?.completeMultipartUpload(completeUploadRequest)) { error in
            if let serverError = error as? ServerError {
                XCTAssertEqual(serverError.statusCode, 409)
            } else {
                XCTFail()
            }
        }

        completeUploadRequest = CompleteMultipartUploadRequest(bucket: bucketName,
                                                               key: objectKey,
                                                               completeAll: "yes",
                                                               uploadId: result!.uploadId!)
        completeUploadRequest.forbidOverwrite = false
        let completeUploadResult = try await client?.completeMultipartUpload(completeUploadRequest)
        XCTAssertEqual(completeUploadResult?.statusCode, 200)

//        var data = Data()
//        let getRequest = GetObjectRequest(bucket: bucketName,
//                                          key: objectKey,
//                                          downloadable: .receive {
//                                              data.append($0)
//                                          })
//        let getResult = try await client?.getObject(getRequest)
//
//        XCTAssertEqual(getResult?.statusCode, 200)
//        let md5 = try Data(contentsOf: URL(fileURLWithPath: filePath)).calculateMd5().toBase64String()
//        let md = data.calculateMd5().toBase64String()
//        XCTAssertTrue(md == md5)

        removeTestFile(filePath)
    }

    func testCompleteMultipartUploadWithPartialParts() async throws {
        let objectKey = "testCompleteMultipartUploadWithPartialParts"
        let partSize = 100 * 1024
        let filePath = createTestFile("middle", 1024 * 1024)!
        let excludePart = 20
        var uploadData = Data()

        let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
        guard let fileSize = fileAttributes[FileAttributeKey.size] as? Int else {
            XCTFail("Can not get file size.")
            return
        }

        let reqesut = InitiateMultipartUploadRequest(bucket: bucketName, key: objectKey)
        let result = try await client?.initiateMultipartUpload(reqesut)
        XCTAssertEqual(result?.statusCode, 200)
        XCTAssertNotNil(result?.uploadId)

        var parts: [UploadPart] = []
        let partCount = fileSize / partSize + (fileSize % partSize > 0 ? 1 : 0)
        for i in 0 ..< partCount {
            let fileHandle = FileHandle(forReadingAtPath: filePath)
            var data: Data?
            if #available(iOS 13.4, *) {
                try fileHandle?.seek(toOffset: UInt64(i * partSize))
                data = try fileHandle?.read(upToCount: partSize)
            } else {
                // Fallback on earlier versions
                fileHandle?.seek(toFileOffset: UInt64(i * partSize))
                data = fileHandle?.readData(ofLength: partSize)
            }
            let uploadPartRequest = UploadPartRequest(bucket: bucketName,
                                                      key: objectKey,
                                                      partNumber: i + 1,
                                                      uploadId: result!.uploadId!,
                                                      body: .data(data!))
            let UploadPartResult = try await client?.uploadPart(uploadPartRequest)
            XCTAssertEqual(UploadPartResult?.statusCode, 200)

            let part = UploadPart(etag: UploadPartResult!.etag!, partNumber: uploadPartRequest.partNumber)
            if i != excludePart - 1 {
                uploadData.append(data!)
                parts.append(part)
            }
        }

        let completeUploadRequest = CompleteMultipartUploadRequest(bucket: bucketName,
                                                                   key: objectKey,
                                                                   uploadId: result!.uploadId!,
                                                                   completeMultipartUpload: CompleteMultipartUpload(parts: parts))
        let completeUploadResult = try await client?.completeMultipartUpload(completeUploadRequest)
        XCTAssertEqual(completeUploadResult?.statusCode, 200)

//        var data = Data()
//        let getRequest = GetObjectRequest(bucket: bucketName,
//                                          key: objectKey,
//                                          downloadable: .receive {
//                                              data.append($0)
//                                          })
//        let getResult = try await client?.getObject(getRequest)
//
//        XCTAssertEqual(getResult?.statusCode, 200)
//        let md5 = uploadData.calculateMd5().toBase64String()
//        let md = data.calculateMd5().toBase64String()
//        XCTAssertTrue(md == md5)

        removeTestFile(filePath)
    }

    func testCompleteMultipartUploadWithDisorganizedParts() async throws {
        let objectKey = "testCompleteMultipartUploadWithDisorganizedParts"
        let partSize = 100 * 1024
        let filePath = createTestFile("middle", 1024 * 1024)!
        let clientActor = ValueActor(value: getDefaultClient())
        let bucket = randomBucketName()

        let requst = PutBucketRequest(bucket: bucket)
        try await assertNoThrow(await clientActor.getValue().putBucket(requst))

        let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
        guard let fileSize = fileAttributes[FileAttributeKey.size] as? Int else {
            XCTFail("Can not get file size.")
            return
        }

        let reqesut = InitiateMultipartUploadRequest(bucket: bucket, key: objectKey)
        let result = try await clientActor.getValue().initiateMultipartUpload(reqesut)
        XCTAssertEqual(result.statusCode, 200)
        XCTAssertNotNil(result.uploadId)

        let uploadId = result.uploadId!
        let partCount = fileSize / partSize + (fileSize % partSize > 0 ? 1 : 0)
        let parts = try await withThrowingTaskGroup(of: UploadPart.self, returning: [UploadPart].self) {
            for i in 0 ..< partCount {
                $0.addTask {
                    let fileHandle = FileHandle(forReadingAtPath: filePath)
                    var data: Data?
                    if #available(iOS 13.4, *) {
                        try fileHandle?.seek(toOffset: UInt64(i * partSize))
                        data = try fileHandle?.read(upToCount: partSize)
                    } else {
                        // Fallback on earlier versions
                        fileHandle?.seek(toFileOffset: UInt64(i * partSize))
                        data = fileHandle?.readData(ofLength: partSize)
                    }
                    let uploadPartRequest = UploadPartRequest(bucket: bucket,
                                                              key: objectKey,
                                                              partNumber: i + 1,
                                                              uploadId: uploadId,
                                                              body: .data(data!))
                    let UploadPartResult = try await clientActor.getValue().uploadPart(uploadPartRequest)
                    XCTAssertEqual(UploadPartResult.statusCode, 200)

                    return UploadPart(etag: UploadPartResult.etag!, partNumber: uploadPartRequest.partNumber)
                }
            }

            var parts: [UploadPart] = []
            for try await part in $0 {
                parts.append(part)
            }
            return parts
        }

        let completeUploadRequest = CompleteMultipartUploadRequest(bucket: bucket,
                                                                   key: objectKey,
                                                                   uploadId: result.uploadId!,
                                                                   completeMultipartUpload: CompleteMultipartUpload(parts: parts))
        try await assertThrowsAsyncError(await clientActor.getValue().completeMultipartUpload(completeUploadRequest)) { error in
            if let serverError = error as? ServerError {
                XCTAssertEqual(serverError.statusCode, 400)
            } else {
                XCTFail()
            }
        }

        let abortRequest = AbortMultipartUploadRequest(bucket: bucket,
                                                       key: objectKey,
                                                       uploadId: result.uploadId!)
        try await assertNoThrow(await clientActor.getValue().abortMultipartUpload(abortRequest))

        removeTestFile(filePath)
        try await cleanBucket(client: clientActor.getValue(), bucket: bucket)
    }

    // MARK: - ListMultipartUploads

    func testListMultipartUploads() async throws {
        let objectKey = "ListMultipartUploads"
        let data = "hello oss".data(using: .utf8)!
        let objectCount = 30

        var uploads: [Upload] = []

        var listRequest = ListMultipartUploadsRequest(bucket: bucketName)
        var listResult = try await client?.listMultipartUploads(listRequest)
        XCTAssertEqual(listResult?.statusCode, 200)
        XCTAssertEqual(listResult?.uploads?.count, 0)

        let initRequest = InitiateMultipartUploadRequest(bucket: bucketName, key: objectKey)
        let initResult = try await client?.initiateMultipartUpload(initRequest)
        XCTAssertEqual(initResult?.statusCode, 200)
        XCTAssertNotNil(initResult?.uploadId)

        let uploadPartRequest = UploadPartRequest(bucket: bucketName,
                                                  key: objectKey,
                                                  partNumber: 1,
                                                  uploadId: initResult!.uploadId!,
                                                  body: .data(data))
        let UploadPartResult = try await client?.uploadPart(uploadPartRequest)
        XCTAssertEqual(UploadPartResult?.statusCode, 200)

        listRequest = ListMultipartUploadsRequest(bucket: bucketName)
        listResult = try await client?.listMultipartUploads(listRequest)
        XCTAssertEqual(listResult?.statusCode, 200)
        XCTAssertEqual(listResult?.uploads?.count, 1)

        let abortRequest = AbortMultipartUploadRequest(bucket: bucketName,
                                                       key: objectKey,
                                                       uploadId: initResult!.uploadId!)
        try await assertNoThrow(await client?.abortMultipartUpload(abortRequest))

        for i in 0 ..< objectCount {
            let key = "\(objectKey)\(i)"
            let reqesut = InitiateMultipartUploadRequest(bucket: bucketName, key: key)
            let result = try await client?.initiateMultipartUpload(reqesut)
            XCTAssertEqual(result?.statusCode, 200)
            XCTAssertNotNil(result?.uploadId)

            let upload = Upload(key: key, uploadId: result!.uploadId!)
            uploads.append(upload)

            let uploadPartRequest = UploadPartRequest(bucket: bucketName,
                                                      key: key,
                                                      partNumber: 1,
                                                      uploadId: result!.uploadId!,
                                                      body: .data(data))
            let UploadPartResult = try await client?.uploadPart(uploadPartRequest)
            XCTAssertEqual(UploadPartResult?.statusCode, 200)
        }

        listRequest = ListMultipartUploadsRequest(bucket: bucketName)
        listResult = try await client?.listMultipartUploads(listRequest)
        XCTAssertEqual(listResult?.statusCode, 200)
        XCTAssertEqual(listResult?.uploads?.count, objectCount)

        for upload in listResult!.uploads! {
            if let index = Int(upload.key!.replacingOccurrences(of: objectKey, with: "")) {
                let u = uploads[index]
                XCTAssertEqual(u.uploadId, upload.uploadId)
                XCTAssertEqual(u.key, upload.key)

                let abortRequest = AbortMultipartUploadRequest(bucket: bucketName,
                                                               key: upload.key,
                                                               uploadId: upload.uploadId)
                try await assertNoThrow(await client?.abortMultipartUpload(abortRequest))
            }
        }
    }

    func testListMultipartUploadsWithPrefix() async throws {
        let objectKey = "ListMultipartUploads"
        let data = "hello oss".data(using: .utf8)!
        let objectCount = 30
        let objectKeyPrefix = "\(objectKey)1"

        var uploads: [Upload] = []
        var uploadKeys: [String] = []

        for i in 0 ..< objectCount {
            let key = "\(objectKey)\(i)"
            let reqesut = InitiateMultipartUploadRequest(bucket: bucketName, key: key)
            let result = try await client?.initiateMultipartUpload(reqesut)
            XCTAssertEqual(result?.statusCode, 200)
            XCTAssertNotNil(result?.uploadId)

            if key.hasPrefix(objectKeyPrefix) {
                let upload = Upload(key: key, uploadId: result!.uploadId!)
                uploadKeys.append(key)
                uploads.append(upload)
            }

            let uploadPartRequest = UploadPartRequest(bucket: bucketName,
                                                      key: key,
                                                      partNumber: 1,
                                                      uploadId: result!.uploadId!,
                                                      body: .data(data))
            let UploadPartResult = try await client?.uploadPart(uploadPartRequest)
            XCTAssertEqual(UploadPartResult?.statusCode, 200)
        }

        var listRequest = ListMultipartUploadsRequest(bucket: bucketName)
        listRequest.prefix = objectKeyPrefix
        let listResult = try await client?.listMultipartUploads(listRequest)
        XCTAssertEqual(listResult?.statusCode, 200)
        XCTAssertEqual(listResult?.uploads?.count, uploads.count)

        for upload in listResult!.uploads! {
            let index = uploadKeys.firstIndex(of: upload.key!)
            let u = uploads[index!]
            XCTAssertEqual(u.uploadId, upload.uploadId)
            XCTAssertEqual(u.key, upload.key)

            let abortRequest = AbortMultipartUploadRequest(bucket: bucketName,
                                                           key: upload.key,
                                                           uploadId: upload.uploadId)
            try await assertNoThrow(await client?.abortMultipartUpload(abortRequest))
        }
    }

    func testListMultipartUploadsWithMaxUploads() async throws {
        let objectKey = "ListMultipartUploads"
        let data = "hello oss".data(using: .utf8)!
        let objectCount = 30
        let maxUploads = 10

        var uploads: [Upload] = []
        do {
            for i in 0 ..< objectCount {
                let key = "\(objectKey)\(i)"
                let reqesut = InitiateMultipartUploadRequest(bucket: bucketName, key: key)
                let result = try await client?.initiateMultipartUpload(reqesut)
                XCTAssertEqual(result?.statusCode, 200)
                XCTAssertNotNil(result?.uploadId)

                let upload = Upload(key: key, uploadId: result!.uploadId!)
                uploads.append(upload)

                let uploadPartRequest = UploadPartRequest(bucket: bucketName,
                                                          key: key,
                                                          partNumber: 1,
                                                          uploadId: result!.uploadId!,
                                                          body: .data(data))
                let UploadPartResult = try await client?.uploadPart(uploadPartRequest)
                XCTAssertEqual(UploadPartResult?.statusCode, 200)
            }

            var listRequest = ListMultipartUploadsRequest(bucket: bucketName)
            listRequest.maxUploads = maxUploads
            let listResult = try await client?.listMultipartUploads(listRequest)
            XCTAssertEqual(listResult?.statusCode, 200)
            XCTAssertEqual(listResult?.uploads?.count, maxUploads)

            for upload in listResult!.uploads! {
                let index = Int(upload.key!.replacingOccurrences(of: objectKey, with: ""))
                let u = uploads[index!]
                XCTAssertEqual(u.uploadId, upload.uploadId)
                XCTAssertEqual(u.key, upload.key)

                let abortRequest = AbortMultipartUploadRequest(bucket: bucketName,
                                                               key: upload.key,
                                                               uploadId: upload.uploadId)
                try await assertNoThrow(await client?.abortMultipartUpload(abortRequest))
            }

        } catch {
            XCTAssertNil(error)
        }
    }

    func testListMultipartUploadsWithDelimiter() async throws {
        let objectKey = "ListMultipartUploads"
        let data = "hello oss".data(using: .utf8)!
        let objectCount = 30
        let delimiter: Character = "1"

        var uploads: [Upload] = []
        var uploadKeys: [String] = []

        for i in 0 ..< objectCount {
            let key = "\(objectKey)\(i)"
            let reqesut = InitiateMultipartUploadRequest(bucket: bucketName, key: key)
            let result = try await client?.initiateMultipartUpload(reqesut)
            XCTAssertEqual(result?.statusCode, 200)
            XCTAssertNotNil(result?.uploadId)

            if key.firstIndex(of: delimiter) == nil {
                let upload = Upload(key: key, uploadId: result!.uploadId!)
                uploadKeys.append(key)
                uploads.append(upload)
            }

            let uploadPartRequest = UploadPartRequest(bucket: bucketName,
                                                      key: key,
                                                      partNumber: 1,
                                                      uploadId: result!.uploadId!,
                                                      body: .data(data))
            let UploadPartResult = try await client?.uploadPart(uploadPartRequest)
            XCTAssertEqual(UploadPartResult?.statusCode, 200)
        }

        var listRequest = ListMultipartUploadsRequest(bucket: bucketName)
        listRequest.delimiter = String(delimiter)
        let listResult = try await client?.listMultipartUploads(listRequest)
        XCTAssertEqual(listResult?.statusCode, 200)
        XCTAssertEqual(listResult?.uploads?.count, uploads.count)

        for upload in listResult!.uploads! {
            let index = uploadKeys.firstIndex(of: upload.key!)
            let u = uploads[index!]
            XCTAssertEqual(u.uploadId, upload.uploadId)
            XCTAssertEqual(u.key, upload.key)

            let abortRequest = AbortMultipartUploadRequest(bucket: bucketName,
                                                           key: upload.key,
                                                           uploadId: upload.uploadId)
            try await assertNoThrow(await client?.abortMultipartUpload(abortRequest))
        }
    }

    func testListMultipartUploadsWithKeyMarker() async throws {
        let objectKey = "ListMultipartUploads"
        let data = "hello oss".data(using: .utf8)!
        let objectCount = 30
        let keyMarker = "\(objectKey)1"

        var uploads: [Upload] = []
        var uploadKeys: [String] = []

        for i in 0 ..< objectCount {
            let key = "\(objectKey)\(i)"
            let reqesut = InitiateMultipartUploadRequest(bucket: bucketName, key: key)
            let result = try await client?.initiateMultipartUpload(reqesut)
            XCTAssertEqual(result?.statusCode, 200)
            XCTAssertNotNil(result?.uploadId)

            if key > keyMarker {
                let upload = Upload(key: key, uploadId: result!.uploadId!)
                uploadKeys.append(key)
                uploads.append(upload)
            }

            let uploadPartRequest = UploadPartRequest(bucket: bucketName,
                                                      key: key,
                                                      partNumber: 1,
                                                      uploadId: result!.uploadId!,
                                                      body: .data(data))
            let UploadPartResult = try await client?.uploadPart(uploadPartRequest)
            XCTAssertEqual(UploadPartResult?.statusCode, 200)
        }

        var listRequest = ListMultipartUploadsRequest(bucket: bucketName)
        listRequest.keyMarker = keyMarker
        let listResult = try await client?.listMultipartUploads(listRequest)
        XCTAssertEqual(listResult?.statusCode, 200)
        XCTAssertEqual(listResult?.uploads?.count, uploads.count)

        for upload in listResult!.uploads! {
            let index = uploadKeys.firstIndex(of: upload.key!)
            let u = uploads[index!]
            XCTAssertEqual(u.uploadId, upload.uploadId)
            XCTAssertEqual(u.key, upload.key)

            let abortRequest = AbortMultipartUploadRequest(bucket: bucketName,
                                                           key: upload.key,
                                                           uploadId: upload.uploadId)
            try await assertNoThrow(await client?.abortMultipartUpload(abortRequest))
        }
    }

    func testListMultipartUploadsWithUploadIdMarker() async throws {
        let objectKey = "ListMultipartUploads"
        let data = "hello oss".data(using: .utf8)!
        let objectCount = 10
        var uploadIdMarker: String?
        let marker = 5
        let similarObjectKeyCount = 10
        let uploadIdMarkerNumber = 3

        var uploadIds: [String] = []
        var similarObjectKeyUploadIds: [String] = []

        for i in 0 ..< objectCount {
            let key = "\(objectKey)\(i)"
            var result: InitiateMultipartUploadResult?
            if i == marker {
                for _ in 0 ..< similarObjectKeyCount {
                    let reqesut = InitiateMultipartUploadRequest(bucket: bucketName, key: key)
                    result = try await client?.initiateMultipartUpload(reqesut)
                    XCTAssertEqual(result?.statusCode, 200)
                    XCTAssertNotNil(result?.uploadId)

                    similarObjectKeyUploadIds.append(result!.uploadId!)
                }
            } else {
                let reqesut = InitiateMultipartUploadRequest(bucket: bucketName, key: key)
                result = try await client?.initiateMultipartUpload(reqesut)
                XCTAssertEqual(result?.statusCode, 200)
                XCTAssertNotNil(result?.uploadId)

                uploadIds.append(result!.uploadId!)
            }

            let uploadPartRequest = UploadPartRequest(bucket: bucketName,
                                                      key: key,
                                                      partNumber: 1,
                                                      uploadId: result!.uploadId!,
                                                      body: .data(data))
            let UploadPartResult = try await client?.uploadPart(uploadPartRequest)
            XCTAssertEqual(UploadPartResult?.statusCode, 200)
        }

        similarObjectKeyUploadIds = similarObjectKeyUploadIds.sorted {
            $0 < $1
        }
        uploadIdMarker = similarObjectKeyUploadIds[uploadIdMarkerNumber - 1]
        similarObjectKeyUploadIds.removeSubrange(0 ..< uploadIdMarkerNumber)

        var listRequest = ListMultipartUploadsRequest(bucket: bucketName)
        listRequest.keyMarker = "\(objectKey)\(marker)"
        listRequest.uploadIdMarker = uploadIdMarker
        let listResult = try await client?.listMultipartUploads(listRequest)
        XCTAssertEqual(listResult?.statusCode, 200)
        XCTAssertEqual(listResult?.uploads?.count, (objectCount - marker - 1) + similarObjectKeyCount - uploadIdMarkerNumber)

        for upload in listResult!.uploads! {
            if upload.key == "\(objectKey)\(marker)" {
                XCTAssertTrue(similarObjectKeyUploadIds.contains(upload.uploadId!))
            } else {
                XCTAssertTrue(uploadIds.contains(upload.uploadId!))
            }
        }
    }

    // MARK: - test ListPart

    func testListPart() async throws {
        let objectKey = "textListPart"
        let partSize = 100 * 1024
        let filePath = createTestFile("middle", 1024 * 1024)!

        let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
        guard let fileSize = fileAttributes[FileAttributeKey.size] as? Int else {
            XCTFail("Can not get file size.")
            return
        }

        var reqesut = InitiateMultipartUploadRequest(bucket: bucketName, key: objectKey)
        var result = try await client?.initiateMultipartUpload(reqesut)
        XCTAssertEqual(result?.statusCode, 200)
        XCTAssertNotNil(result?.uploadId)

        var listPartRequest = ListPartsRequest(bucket: bucketName,
                                               key: objectKey,
                                               uploadId: result!.uploadId!)
        var listPartResult = try await client?.listParts(listPartRequest)
        XCTAssertEqual(listPartResult?.statusCode, 200)
        XCTAssertEqual(listPartResult?.parts?.count, 0)

        let data = "hello oss".data(using: .utf8)!
        let uploadPartRequest = UploadPartRequest(bucket: bucketName,
                                                  key: objectKey,
                                                  partNumber: 1,
                                                  uploadId: result!.uploadId!,
                                                  body: .data(data))
        let UploadPartResult = try await client?.uploadPart(uploadPartRequest)
        XCTAssertEqual(UploadPartResult?.statusCode, 200)

        listPartRequest = ListPartsRequest(bucket: bucketName,
                                           key: objectKey,
                                           uploadId: result!.uploadId!)
        listPartResult = try await client?.listParts(listPartRequest)
        XCTAssertEqual(listPartResult?.statusCode, 200)
        XCTAssertEqual(listPartResult?.parts?.count, 1)

        reqesut = InitiateMultipartUploadRequest(bucket: bucketName, key: objectKey)
        result = try await client?.initiateMultipartUpload(reqesut)
        XCTAssertEqual(result?.statusCode, 200)
        XCTAssertNotNil(result?.uploadId)

        let partCount = fileSize / partSize + (fileSize % partSize > 0 ? 1 : 0)
        var parts: [Part] = []
        for i in 0 ..< partCount {
            let fileHandle = FileHandle(forReadingAtPath: filePath)
            var data: Data?
            if #available(iOS 13.4, *) {
                try fileHandle?.seek(toOffset: UInt64(i * partSize))
                data = try fileHandle?.read(upToCount: partSize)
            } else {
                // Fallback on earlier versions
                fileHandle?.seek(toFileOffset: UInt64(i * partSize))
                data = fileHandle?.readData(ofLength: partSize)
            }
            let uploadPartRequest = UploadPartRequest(bucket: bucketName,
                                                      key: objectKey,
                                                      partNumber: i + 1,
                                                      uploadId: result!.uploadId!,
                                                      body: .data(data!))
            let UploadPartResult = try await client?.uploadPart(uploadPartRequest)
            XCTAssertEqual(UploadPartResult?.statusCode, 200)

            let part = Part(etag: UploadPartResult!.etag!,
                            partNumber: uploadPartRequest.partNumber,
                            size: Int(data!.count))
            parts.append(part)
        }

        listPartRequest = ListPartsRequest(bucket: bucketName,
                                           key: objectKey,
                                           uploadId: result!.uploadId!)
        listPartResult = try await client?.listParts(listPartRequest)
        XCTAssertEqual(listPartResult?.statusCode, 200)
        XCTAssertEqual(listPartResult?.parts?.count, partCount)
        for part in listPartResult!.parts! {
            let origanalPart = parts[part.partNumber! - 1]
            XCTAssertEqual(origanalPart.partNumber, part.partNumber)
            XCTAssertEqual(origanalPart.size, part.size)
            XCTAssertEqual(origanalPart.etag, part.etag)
        }

        removeTestFile(filePath)
    }

    func testListPartWithMaxParts() async throws {
        let objectKey = "textListPart"
        let partSize = 100 * 1024
        let filePath = createTestFile("middle", 1024 * 1024)!
        let maxParts = 10

        let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
        guard let fileSize = fileAttributes[FileAttributeKey.size] as? Int else {
            XCTFail("Can not get file size.")
            return
        }

        let reqesut = InitiateMultipartUploadRequest(bucket: bucketName, key: objectKey)
        let result = try await client?.initiateMultipartUpload(reqesut)
        XCTAssertEqual(result?.statusCode, 200)
        XCTAssertNotNil(result?.uploadId)

        let partCount = fileSize / partSize + (fileSize % partSize > 0 ? 1 : 0)
        var parts: [Part] = []
        for i in 0 ..< partCount {
            let fileHandle = FileHandle(forReadingAtPath: filePath)
            var data: Data?
            if #available(iOS 13.4, *) {
                try fileHandle?.seek(toOffset: UInt64(i * partSize))
                data = try fileHandle?.read(upToCount: partSize)
            } else {
                // Fallback on earlier versions
                fileHandle?.seek(toFileOffset: UInt64(i * partSize))
                data = fileHandle?.readData(ofLength: partSize)
            }
            let uploadPartRequest = UploadPartRequest(bucket: bucketName,
                                                      key: objectKey,
                                                      partNumber: i + 1,
                                                      uploadId: result!.uploadId!,
                                                      body: .data(data!))
            let UploadPartResult = try await client?.uploadPart(uploadPartRequest)
            XCTAssertEqual(UploadPartResult?.statusCode, 200)

            let part = Part(etag: UploadPartResult!.etag!,
                            partNumber: uploadPartRequest.partNumber,
                            size: Int(data!.count))
            parts.append(part)
        }

        var listPartRequest = ListPartsRequest(bucket: bucketName,
                                               key: objectKey,
                                               uploadId: result!.uploadId!)
        listPartRequest.maxParts = maxParts
        var listPartResult = try await client?.listParts(listPartRequest)
        XCTAssertEqual(listPartResult?.statusCode, 200)
        XCTAssertEqual(listPartResult?.parts?.count, maxParts)
        for part in listPartResult!.parts! {
            let origanalPart = parts[part.partNumber! - 1]
            XCTAssertEqual(origanalPart.partNumber, part.partNumber)
            XCTAssertEqual(origanalPart.size, part.size)
            XCTAssertEqual(origanalPart.etag, part.etag)
        }

        var requestParts: [Part] = []
        var isTruncated = true
        var partNumberMark: Int?
        repeat {
            listPartRequest = ListPartsRequest(bucket: bucketName,
                                               key: objectKey,
                                               uploadId: result!.uploadId!)
            listPartRequest.maxParts = maxParts
            listPartRequest.partNumberMarker = partNumberMark
            listPartResult = try await client?.listParts(listPartRequest)
            isTruncated = listPartResult!.isTruncated!
            partNumberMark = listPartResult?.nextPartNumberMarker
            requestParts.append(contentsOf: listPartResult!.parts!)

        } while isTruncated

        for part in requestParts {
            let origanalPart = parts[part.partNumber! - 1]
            XCTAssertEqual(origanalPart.partNumber, part.partNumber)
            XCTAssertEqual(origanalPart.size, part.size)
            XCTAssertEqual(origanalPart.etag, part.etag)
        }

        removeTestFile(filePath)
    }

    func testListPartWithPartNumberMarker() async throws {
        let objectKey = "textListPart"
        let partSize = 100 * 1024
        let filePath = createTestFile("middle", 1024 * 1024)!

        let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
        guard let fileSize = fileAttributes[FileAttributeKey.size] as? Int else {
            XCTFail("Can not get file size.")
            return
        }

        let reqesut = InitiateMultipartUploadRequest(bucket: bucketName, key: objectKey)
        let result = try await client?.initiateMultipartUpload(reqesut)
        XCTAssertEqual(result?.statusCode, 200)
        XCTAssertNotNil(result?.uploadId)

        let partCount = fileSize / partSize + (fileSize % partSize > 0 ? 1 : 0)
        var parts: [Part] = []
        for i in 0 ..< partCount {
            let fileHandle = FileHandle(forReadingAtPath: filePath)
            var data: Data?
            if #available(iOS 13.4, *) {
                try fileHandle?.seek(toOffset: UInt64(i * partSize))
                data = try fileHandle?.read(upToCount: partSize)
            } else {
                // Fallback on earlier versions
                fileHandle?.seek(toFileOffset: UInt64(i * partSize))
                data = fileHandle?.readData(ofLength: partSize)
            }
            let uploadPartRequest = UploadPartRequest(bucket: bucketName,
                                                      key: objectKey,
                                                      partNumber: i + 1,
                                                      uploadId: result!.uploadId!,
                                                      body: .data(data!))
            let UploadPartResult = try await client?.uploadPart(uploadPartRequest)
            XCTAssertEqual(UploadPartResult?.statusCode, 200)

            let part = Part(etag: UploadPartResult!.etag!,
                            partNumber: uploadPartRequest.partNumber,
                            size: Int(data!.count))
            parts.append(part)
        }

        var listPartRequest = ListPartsRequest(bucket: bucketName,
                                               key: objectKey,
                                               uploadId: result!.uploadId!)
        listPartRequest.partNumberMarker = 1
        listPartRequest.maxParts = 10
        let listPartResult = try await client?.listParts(listPartRequest)
        XCTAssertEqual(listPartResult?.statusCode, 200)
        XCTAssertEqual(listPartResult?.parts?.count, 10)
        for part in listPartResult!.parts! {
            let origanalPart = parts[part.partNumber! - 1]
            XCTAssertEqual(origanalPart.partNumber, part.partNumber)
            XCTAssertEqual(origanalPart.size, part.size)
            XCTAssertEqual(origanalPart.etag, part.etag)
        }

        removeTestFile(filePath)
    }
}
