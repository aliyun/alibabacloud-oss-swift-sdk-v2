import AlibabaCloudOSS
import AlibabaCloudOSSExtension
import XCTest

final class ClientBucketArchiveDirectreadTests: BaseTestCase {
    override func setUp() async throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try await super.setUp()
        bucketName = randomBucketName()
        client = getDefaultClient()
        
        try await createBucket(client: client!, bucket: bucketName)
    }
    
    override func tearDown() async throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try await cleanBucket(client: getDefaultClient(), bucket: bucketName)
        try await super.tearDown()
    }
        
    func testPutAndGetBucketArchiveDirectReadSuccess() async throws {
        // PutBucketArchiveDirectRead
        try await assertNoThrow(await client?.putBucketArchiveDirectRead(PutBucketArchiveDirectReadRequest(
            bucket: bucketName,
            archiveDirectReadConfiguration: ArchiveDirectReadConfiguration(enabled: true)
        )))
        
        // GetBucketArchiveDirectRead
        let result = try await client?.getBucketArchiveDirectRead(
            GetBucketArchiveDirectReadRequest(bucket: bucketName)
        )
        XCTAssertEqual(result?.archiveDirectReadConfiguration?.enabled, true)
    }
    
    func testPutBucketArchiveDirectReadFail() async throws {
        var request = PutBucketArchiveDirectReadRequest()
        try await assertThrowsAsyncError(await client?.putBucketArchiveDirectRead(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = PutBucketArchiveDirectReadRequest(bucket: bucketName)
        try await assertThrowsAsyncError(await client?.putBucketArchiveDirectRead(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.archiveDirectReadConfiguration.")
        }
        
        request = PutBucketArchiveDirectReadRequest(
            bucket: bucketName,
            archiveDirectReadConfiguration: ArchiveDirectReadConfiguration()
        )
        try await assertThrowsAsyncError(await client?.putBucketArchiveDirectRead(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 400)
            XCTAssertEqual(serverError?.code, "MalformedXML")
        }
    }
    
    func testGetBucketArchiveDirectReadFail() async throws {
        var request = GetBucketArchiveDirectReadRequest()
        try await assertThrowsAsyncError(await client?.getBucketArchiveDirectRead(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = GetBucketArchiveDirectReadRequest(bucket: randomBucketName())
        try await assertThrowsAsyncError(await client?.getBucketArchiveDirectRead(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
}
