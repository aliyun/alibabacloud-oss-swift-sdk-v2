import AlibabaCloudOSS
import AlibabaCloudOSSExtension
import XCTest

final class ClientBucketRequestPaymentTests: BaseTestCase {
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
        
    func testPutAndGetBucketRequestPaymentSuccess() async throws {
        // PutBucketRequestPayment
        try await assertNoThrow(await client?.putBucketRequestPayment(PutBucketRequestPaymentRequest(
            bucket: bucketName,
            requestPaymentConfiguration: RequestPaymentConfiguration(payer: "Requester")
        )))
        
        // GetBucketRequestPayment
        let result = try await client?.getBucketRequestPayment(
            GetBucketRequestPaymentRequest(bucket: bucketName)
        )
        XCTAssertEqual(result?.requestPaymentConfiguration?.payer, "Requester")
    }
    
    func testPutBucketRequestPaymentFail() async throws {
        var request = PutBucketRequestPaymentRequest()
        try await assertThrowsAsyncError(await client?.putBucketRequestPayment(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = PutBucketRequestPaymentRequest(bucket: bucketName)
        try await assertThrowsAsyncError(await client?.putBucketRequestPayment(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.requestPaymentConfiguration.")
        }
        
        request = PutBucketRequestPaymentRequest(
            bucket: bucketName,
            requestPaymentConfiguration: RequestPaymentConfiguration()
        )
        try await assertThrowsAsyncError(await client?.putBucketRequestPayment(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 400)
            XCTAssertEqual(serverError?.code, "MalformedXML")
        }
    }
    
    func testGetBucketRequestPaymentFail() async throws {
        var request = GetBucketRequestPaymentRequest()
        try await assertThrowsAsyncError(await client?.getBucketRequestPayment(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = GetBucketRequestPaymentRequest(bucket: randomBucketName())
        try await assertThrowsAsyncError(await client?.getBucketRequestPayment(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
}
