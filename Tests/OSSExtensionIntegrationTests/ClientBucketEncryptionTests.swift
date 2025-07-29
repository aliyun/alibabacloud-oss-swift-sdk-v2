import AlibabaCloudOSS
import AlibabaCloudOSSExtension
import XCTest

final class ClientBucketEncryptionTests: BaseTestCase {
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
        
    func testPutAndGetBucketEncryptionSuccess() async throws {
        // PutBucketEncryption
        try await assertNoThrow(await client?.putBucketEncryption(PutBucketEncryptionRequest(
            bucket: bucketName,
            serverSideEncryptionRule: ServerSideEncryptionRule(
                applyServerSideEncryptionByDefault: ApplyServerSideEncryptionByDefault(sseAlgorithm: "AES256")
            )
        )))
        
        // GetBucketEncryption
        let result = try await client?.getBucketEncryption(
            GetBucketEncryptionRequest(bucket: bucketName)
        )
        XCTAssertEqual(result?.serverSideEncryptionRule?.applyServerSideEncryptionByDefault?.sseAlgorithm, "AES256")
    }
    
    func testPutBucketEncryptionFail() async throws {
        var request = PutBucketEncryptionRequest()
        try await assertThrowsAsyncError(await client?.putBucketEncryption(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = PutBucketEncryptionRequest(bucket: bucketName)
        try await assertThrowsAsyncError(await client?.putBucketEncryption(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.serverSideEncryptionRule.")
        }
        
        request = PutBucketEncryptionRequest(
            bucket: bucketName,
            serverSideEncryptionRule: ServerSideEncryptionRule()
        )
        try await assertThrowsAsyncError(await client?.putBucketEncryption(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 400)
            XCTAssertEqual(serverError?.code, "MalformedXML")
        }
    }
    
    func testGetBucketEncryptionFail() async throws {
        var request = GetBucketEncryptionRequest()
        try await assertThrowsAsyncError(await client?.getBucketEncryption(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = GetBucketEncryptionRequest(bucket: bucketName)
        try await assertThrowsAsyncError(await client?.getBucketEncryption(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
    
    func testDeleteBucketEncryptionSuccess() async throws {
        // PutBucketEncryption
        try await assertNoThrow(await client?.putBucketEncryption(PutBucketEncryptionRequest(
            bucket: bucketName,
            serverSideEncryptionRule: ServerSideEncryptionRule(
                applyServerSideEncryptionByDefault: ApplyServerSideEncryptionByDefault(sseAlgorithm: "AES256")
            )
        )))
        
        // GetBucketEncryption
        let result = try await client?.getBucketEncryption(
            GetBucketEncryptionRequest(bucket: bucketName)
        )
        XCTAssertEqual(result?.serverSideEncryptionRule?.applyServerSideEncryptionByDefault?.sseAlgorithm, "AES256")
        
        // DeleteBucketEncryption
        try await assertNoThrow(await client?.deleteBucketEncryption(
            DeleteBucketEncryptionRequest(bucket: bucketName)
        ))
        
        // GetBucketEncryption
        try await assertThrowsAsyncError(await client?.getBucketEncryption(
            GetBucketEncryptionRequest(bucket: bucketName)
        )) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
}
