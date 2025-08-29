import AlibabaCloudOSS
import TransportAsyncHTTPClient
import XCTest
import Crypto

class AsyncHTTPClientTransportTests: BaseTestCase {
    
    override func setUp() async throws {
        client = getDefaultClient()
        bucketName = "swift-sdk-test-httpdns-oss-test"
//        try await createBucket(client: client!, bucket: bucketName)
    }
    
    override func tearDown() async throws {
//        try await super.tearDown()
//        try await cleanBucket(client: client!, bucket: bucketName)
    }
    
    func testPutObjectWithDataSuccess() async throws {
        let objectKey = "11"//randomObjectName()
        let data = "hello oss!".data(using: .utf8)!

        let request = PutObjectRequest(bucket: bucketName,
                                       key: objectKey,
                                       body: .data(data))
        try await assertNoThrow(await client?.putObject(request))

        let headRequest = HeadObjectRequest(bucket: bucketName,
                                            key: objectKey)

        let headResult = try await client?.headObject(headRequest)
        XCTAssertEqual(headResult?.contentMd5, data.calculateMd5().toBase64String())
    }
    
    func testPutObjectWithFileSuccess() async throws {
        let objectKey = randomObjectName()
        let file = URL(fileURLWithPath: createTestFile(randomFileName(), 1024 * 100 + 123)!)

        let request = PutObjectRequest(bucket: bucketName,
                                       key: objectKey,
                                       body: .file(file))
        try await assertNoThrow(await client?.putObject(request))

        let headRequest = HeadObjectRequest(bucket: bucketName,
                                            key: objectKey)

        let headResult = try await client?.headObject(headRequest)
        XCTAssertEqual(headResult?.contentMd5, try Utils.calculateMd5(fileURL: file).toBase64String())
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
        let size = 300 * 1024 + 12345
        let data = randomStr(size).data(using: .utf8)!
        let objectKey = "11"//randomObjectName()
        let totalBytesSented = ValueActor(value: 0)
        var request = PutObjectRequest(bucket: bucketName,
                                       key: objectKey,
                                       body: .data(data))
        request.progress = ProgressClosure { bytesSent, totalBytesSent, totalBytesExpectedToSend in
            print("\(totalBytesSent)")
            Task {
                await totalBytesSented.setValue(value: totalBytesSented.getValue() + Int(bytesSent))
                let value = await totalBytesSented.getValue()
                XCTAssertEqual(value, Int(totalBytesSent))
                XCTAssertEqual(Int(totalBytesExpectedToSend), size)
            }
        }
        let result = try await client?.putObject(request)
        XCTAssertEqual(result?.statusCode, 200)
        let value = await totalBytesSented.getValue()
        XCTAssertEqual(value, Int(size))
    }
    
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
    func testGetObjectToFileSuccess() async throws {
        let objectKey = randomObjectName()
        let data = "hello oss".data(using: .utf8)!

        let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let file = URL(fileURLWithPath: "\(document!)/file1")
        if FileManager.default.fileExists(atPath: file.absoluteString.replacingOccurrences(of: "file://", with: "")) {
            try FileManager.default.removeItem(at: file)
        }

        let putRequest = PutObjectRequest(bucket: bucketName,
                                          key: objectKey,
                                          body: .data(data))
        await assertNoThrow(try await client?.putObject(putRequest))

        let getRequest = GetObjectRequest(bucket: bucketName,
                                          key: objectKey)
        let getResult = try await client?.getObjectToFile(getRequest, file)

        XCTAssertEqual(getResult?.statusCode, 200)
        let md5 = data.calculateMd5().toBase64String()
        let md = try Data(contentsOf: file).calculateMd5().toBase64String()
        XCTAssertEqual(md, md5)

        try FileManager.default.removeItem(at: file)
    }
    
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    func testGetObjectToFileFail() async throws {
        let objectKey = randomObjectName()

        let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let file = URL(fileURLWithPath: "\(document!)/file1")
        if FileManager.default.fileExists(atPath: file.absoluteString.replacingOccurrences(of: "file://", with: "")) {
            try FileManager.default.removeItem(at: file)
        }
        
        let getRequest = GetObjectRequest(bucket: bucketName,
                                          key: objectKey)
        await assertThrowsAsyncError(try await client?.getObjectToFile(getRequest, file)) {
            let error = $0 as? ServerError
            XCTAssertEqual(error?.statusCode, 404)
            XCTAssertEqual(error?.code, "NoSuchKey")
        }
    }
}

