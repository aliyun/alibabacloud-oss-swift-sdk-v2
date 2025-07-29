import AlibabaCloudOSS
import AlibabaCloudOSSExtension
import XCTest

final class ClientBucketRefererTests: BaseTestCase {
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
        
    func testPutAndGetBucketRefererSuccess() async throws {
        // PutBucketReferer
        try await assertNoThrow(await client?.putBucketReferer(PutBucketRefererRequest(
            bucket: bucketName,
            refererConfiguration: RefererConfiguration(
                allowEmptyReferer: false,
                allowTruncateQueryString: true,
                truncatePath: true,
                refererList: RefererList(referers: ["http://www.aliyun.com", "https://www.aliyun.com"]),
                refererBlacklist: RefererBlacklist(referers: ["http://www.refuse.com", "https://*.hack.com"])
            )
        )))
        
        // GetBucketReferer
        let result = try await client?.getBucketReferer(
            GetBucketRefererRequest(bucket: bucketName)
        )
        XCTAssertEqual(result?.refererConfiguration?.allowEmptyReferer, false)
        XCTAssertEqual(result?.refererConfiguration?.allowTruncateQueryString, true)
        XCTAssertEqual(result?.refererConfiguration?.truncatePath, true)
        XCTAssertEqual(result?.refererConfiguration?.refererList?.referers, ["http://www.aliyun.com", "https://www.aliyun.com"])
        XCTAssertEqual(result?.refererConfiguration?.refererBlacklist?.referers, ["http://www.refuse.com", "https://*.hack.com"])
    }
    
    func testPutBucketRefererFail() async throws {
        var request = PutBucketRefererRequest()
        try await assertThrowsAsyncError(await client?.putBucketReferer(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = PutBucketRefererRequest(bucket: bucketName)
        try await assertThrowsAsyncError(await client?.putBucketReferer(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.refererConfiguration.")
        }
        
        request = PutBucketRefererRequest(
            bucket: bucketName,
            refererConfiguration: RefererConfiguration()
        )
        try await assertThrowsAsyncError(await client?.putBucketReferer(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 400)
            XCTAssertEqual(serverError?.code, "MalformedXML")
        }
    }
    
    func testGetBucketRefererFail() async throws {
        var request = GetBucketRefererRequest()
        try await assertThrowsAsyncError(await client?.getBucketReferer(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = GetBucketRefererRequest(bucket: randomBucketName())
        try await assertThrowsAsyncError(await client?.getBucketReferer(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
}
