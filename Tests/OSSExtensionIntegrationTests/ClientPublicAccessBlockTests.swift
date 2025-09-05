import AlibabaCloudOSS
import AlibabaCloudOSSExtension
import XCTest

final class ClientPublicAccessBlockTests: BaseTestCase {
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
    
    func testPutGetAndDeletePublicAccessBlockSuccess() async throws {
        // PutPublicAccessBlock
        try await assertNoThrow(await client?.putPublicAccessBlock(PutPublicAccessBlockRequest(
            publicAccessBlockConfiguration: PublicAccessBlockConfiguration(blockPublicAccess: true)
        )))
        
        // GetPublicAccessBlock
        try await assertNoThrow(await client?.getPublicAccessBlock(
            GetPublicAccessBlockRequest()
        ))
        
        // DeletePublicAccessBlock
        try await assertNoThrow(await client?.deletePublicAccessBlock(
            DeletePublicAccessBlockRequest()
        ))
    }
    
    func testPutPublicAccessBlockFail() async throws {
        var request = PutPublicAccessBlockRequest()
        try await assertThrowsAsyncError(await client?.putPublicAccessBlock(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.publicAccessBlockConfiguration.")
        }
        
        request = PutPublicAccessBlockRequest(
            publicAccessBlockConfiguration: PublicAccessBlockConfiguration()
        )
        try await assertThrowsAsyncError(await client?.putPublicAccessBlock(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 400)
            XCTAssertEqual(serverError?.code, "MalformedXML")
        }
    }
    
    func testGetPublicAccessBlockFail() async throws {
        let config = Configuration.default()
            .withRegion(region)
            .withCredentialsProvider(AnonymousCredentialsProvider())
        let client = Client(config)
        let request = GetPublicAccessBlockRequest()
        try await assertThrowsAsyncError(await client.getPublicAccessBlock(request)) {
            let clientError = $0 as? ServerError
            XCTAssertEqual(clientError?.statusCode, 403)
        }
    }
    
    func testDeletePublicAccessBlockFail() async throws {
        let config = Configuration.default()
            .withRegion(region)
            .withCredentialsProvider(AnonymousCredentialsProvider())
        let client = Client(config)
        let request = DeletePublicAccessBlockRequest()
        try await assertThrowsAsyncError(await client.deletePublicAccessBlock(request)) {
            let clientError = $0 as? ServerError
            XCTAssertEqual(clientError?.statusCode, 403)
        }
    }
}

