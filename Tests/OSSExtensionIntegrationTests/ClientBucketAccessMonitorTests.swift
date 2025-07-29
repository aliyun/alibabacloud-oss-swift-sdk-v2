import AlibabaCloudOSS
import AlibabaCloudOSSExtension
import XCTest

final class ClientBucketAccessMonitorTests: BaseTestCase {
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
        
    func testPutAndGetBucketAccessMonitorSuccess() async throws {
        // PutBucketAccessMonitor
        try await assertNoThrow(await client?.putBucketAccessMonitor(PutBucketAccessMonitorRequest(
            bucket: bucketName,
            accessMonitorConfiguration: AccessMonitorConfiguration(status: "Enabled")
        )))
        
        // GetBucketAccessMonitor
        let result = try await client?.getBucketAccessMonitor(
            GetBucketAccessMonitorRequest(bucket: bucketName)
        )
        XCTAssertEqual(result?.accessMonitorConfiguration?.status, "Enabled")
    }
    
    func testPutBucketAccessMonitorFail() async throws {
        var request = PutBucketAccessMonitorRequest()
        try await assertThrowsAsyncError(await client?.putBucketAccessMonitor(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = PutBucketAccessMonitorRequest(bucket: bucketName)
        try await assertThrowsAsyncError(await client?.putBucketAccessMonitor(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.accessMonitorConfiguration.")
        }
        
        request = PutBucketAccessMonitorRequest(
            bucket: bucketName,
            accessMonitorConfiguration: AccessMonitorConfiguration()
        )
        try await assertThrowsAsyncError(await client?.putBucketAccessMonitor(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 400)
            XCTAssertEqual(serverError?.code, "MalformedXML")
        }
    }
    
    func testGetBucketAccessMonitorFail() async throws {
        var request = GetBucketAccessMonitorRequest()
        try await assertThrowsAsyncError(await client?.getBucketAccessMonitor(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = GetBucketAccessMonitorRequest(bucket: randomBucketName())
        try await assertThrowsAsyncError(await client?.getBucketAccessMonitor(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
}
