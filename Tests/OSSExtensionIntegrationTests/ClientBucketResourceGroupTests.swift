import AlibabaCloudOSS
import AlibabaCloudOSSExtension
import XCTest

final class ClientBucketResourceGroupTests: BaseTestCase {
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
        
    func testPutAndGetBucketResourceGroupSuccess() async throws {
        
        let resourceGroupId = try await client?.getBucketInfo(
            GetBucketInfoRequest(
                bucket: bucketName
            )
        ).bucketInfo?.bucket?.resourceGroupId
        XCTAssertNotNil(resourceGroupId)
        
        // PutBucketResourceGroup
        try await assertNoThrow(await client?.putBucketResourceGroup(PutBucketResourceGroupRequest(
            bucket: bucketName,
            bucketResourceGroupConfiguration: BucketResourceGroupConfiguration(
                resourceGroupId: resourceGroupId
            )
        )))
        
        // GetBucketResourceGroup
        let result = try await client?.getBucketResourceGroup(
            GetBucketResourceGroupRequest(bucket: bucketName)
        )
        XCTAssertEqual(result?.bucketResourceGroupConfiguration?.resourceGroupId, resourceGroupId)
    }
    
    func testPutBucketResourceGroupFail() async throws {
        var request = PutBucketResourceGroupRequest()
        try await assertThrowsAsyncError(await client?.putBucketResourceGroup(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = PutBucketResourceGroupRequest(bucket: bucketName)
        try await assertThrowsAsyncError(await client?.putBucketResourceGroup(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucketResourceGroupConfiguration.")
        }
        
        request = PutBucketResourceGroupRequest(
            bucket: bucketName,
            bucketResourceGroupConfiguration: BucketResourceGroupConfiguration()
        )
        try await assertThrowsAsyncError(await client?.putBucketResourceGroup(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 400)
            XCTAssertEqual(serverError?.code, "MalformedXML")
        }
    }
    
    func testGetBucketResourceGroupFail() async throws {
        var request = GetBucketResourceGroupRequest()
        try await assertThrowsAsyncError(await client?.getBucketResourceGroup(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = GetBucketResourceGroupRequest(bucket: randomBucketName())
        try await assertThrowsAsyncError(await client?.getBucketResourceGroup(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
}
