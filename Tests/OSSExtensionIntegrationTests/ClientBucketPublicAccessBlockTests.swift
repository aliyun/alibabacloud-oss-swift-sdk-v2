import AlibabaCloudOSS
import AlibabaCloudOSSExtension
import XCTest

final class ClientBucketPublicAccessBlockTests: BaseTestCase {
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
    
    func testPutGetAndDeleteBucketPublicAccessBlockSuccess() async throws {
        // PutBucketPublicAccessBlock
        try await assertNoThrow(await client?.putBucketPublicAccessBlock(
            PutBucketPublicAccessBlockRequest(
                bucket: bucketName,
                publicAccessBlockConfiguration: PublicAccessBlockConfiguration(blockPublicAccess: true)
            )
        ))
        
        // GetBucketPublicAccessBlock
        var result = try await client?.getBucketPublicAccessBlock(
            GetBucketPublicAccessBlockRequest(
                bucket: bucketName
            )
        )
        XCTAssertEqual(result?.publicAccessBlockConfiguration?.blockPublicAccess, true)
        
        // DeleteBucketPublicAccessBlock
        try await assertNoThrow(await client?.deleteBucketPublicAccessBlock(
            DeleteBucketPublicAccessBlockRequest(
                bucket: bucketName
            )
        ))
        result = try await client?.getBucketPublicAccessBlock(
            GetBucketPublicAccessBlockRequest(
                bucket: bucketName
            )
        )
        XCTAssertEqual(result?.publicAccessBlockConfiguration?.blockPublicAccess, false)
    }
    
    func testPutBucketPublicAccessBlockFail() async throws {
        var request = PutBucketPublicAccessBlockRequest()
        try await assertThrowsAsyncError(await client?.putBucketPublicAccessBlock(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = PutBucketPublicAccessBlockRequest(bucket: bucketName)
        try await assertThrowsAsyncError(await client?.putBucketPublicAccessBlock(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.publicAccessBlockConfiguration.")
        }
        
        request = PutBucketPublicAccessBlockRequest(
            bucket: bucketName,
            publicAccessBlockConfiguration: PublicAccessBlockConfiguration()
        )
        try await assertThrowsAsyncError(await client?.putBucketPublicAccessBlock(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 400)
            XCTAssertEqual(serverError?.code, "MalformedXML")
        }
    }
    
    func testGetBucketPublicAccessBlockFail() async throws {
        var request = GetBucketPublicAccessBlockRequest()
        try await assertThrowsAsyncError(await client?.getBucketPublicAccessBlock(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = GetBucketPublicAccessBlockRequest(
            bucket: randomBucketName()
        )
        try await assertThrowsAsyncError(await client?.getBucketPublicAccessBlock(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
    
    func testDeleteBucketPublicAccessBlockFail() async throws {
        var request = DeleteBucketPublicAccessBlockRequest()
        try await assertThrowsAsyncError(await client?.deleteBucketPublicAccessBlock(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = DeleteBucketPublicAccessBlockRequest(
            bucket: randomBucketName()
        )
        try await assertThrowsAsyncError(await client?.deleteBucketPublicAccessBlock(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
}

