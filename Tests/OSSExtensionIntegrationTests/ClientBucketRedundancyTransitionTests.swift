import AlibabaCloudOSS
import AlibabaCloudOSSExtension
import XCTest

final class ClientBucketRedundancyTransitionTests: BaseTestCase {
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
        
    func testCreateAndGetBucketDataRedundancyTransitionSuccess() async throws {

        // CreateBucketDataRedundancyTransition
        let createResult = try await client?.createBucketDataRedundancyTransition(CreateBucketDataRedundancyTransitionRequest(
            bucket: bucketName,
            targetRedundancyType: "ZRS"
        ))
        XCTAssertNotNil(createResult?.bucketDataRedundancyTransition?.taskId)
        
        // GetBucketDataRedundancyTransition
        let result = try await client?.getBucketDataRedundancyTransition(
            GetBucketDataRedundancyTransitionRequest(
                bucket: bucketName,
                redundancyTransitionTaskid: createResult?.bucketDataRedundancyTransition?.taskId
            )
        )
        XCTAssertEqual(result?.bucketDataRedundancyTransition?.bucket, bucketName)
        XCTAssertEqual(result?.bucketDataRedundancyTransition?.taskId, createResult?.bucketDataRedundancyTransition?.taskId)
        XCTAssertNotNil(result?.bucketDataRedundancyTransition?.status)
        XCTAssertNotNil(result?.bucketDataRedundancyTransition?.createTime)
    }
    
    func testCreateBucketDataRedundancyTransitionFail() async throws {
        var request = CreateBucketDataRedundancyTransitionRequest()
        try await assertThrowsAsyncError(await client?.createBucketDataRedundancyTransition(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = CreateBucketDataRedundancyTransitionRequest(
            bucket: bucketName,
        )
        try await assertThrowsAsyncError(await client?.createBucketDataRedundancyTransition(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 400)
            XCTAssertEqual(serverError?.code, "MissingArgument")
        }
    }
    
    func testGetBucketRefererFail() async throws {
        var request = GetBucketDataRedundancyTransitionRequest()
        try await assertThrowsAsyncError(await client?.getBucketDataRedundancyTransition(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = GetBucketDataRedundancyTransitionRequest(
            bucket: bucketName,
            redundancyTransitionTaskid: "error"
        )
        try await assertThrowsAsyncError(await client?.getBucketDataRedundancyTransition(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
    
    func testDeleteBucketDataRedundancyTransitionSuccess() async throws {
        // CreateBucketDataRedundancyTransition
        let createResult = try await client?.createBucketDataRedundancyTransition(CreateBucketDataRedundancyTransitionRequest(
            bucket: bucketName,
            targetRedundancyType: "ZRS"
        ))
        XCTAssertNotNil(createResult?.bucketDataRedundancyTransition?.taskId)
        
        // GetBucketDataRedundancyTransition
        let result = try await client?.getBucketDataRedundancyTransition(
            GetBucketDataRedundancyTransitionRequest(
                bucket: bucketName,
                redundancyTransitionTaskid: createResult?.bucketDataRedundancyTransition?.taskId
            )
        )
        XCTAssertEqual(result?.bucketDataRedundancyTransition?.bucket, bucketName)
        XCTAssertEqual(result?.bucketDataRedundancyTransition?.taskId, createResult?.bucketDataRedundancyTransition?.taskId)
        
        // DeleteBucketDataRedundancyTransition
        try await assertNoThrow(await client?.deleteBucketDataRedundancyTransition(
            DeleteBucketDataRedundancyTransitionRequest(
                bucket: bucketName,
                redundancyTransitionTaskid: createResult?.bucketDataRedundancyTransition?.taskId
            )
        ))
        
        // GetBucketDataRedundancyTransition
        try await assertThrowsAsyncError(await client?.getBucketDataRedundancyTransition(
            GetBucketDataRedundancyTransitionRequest(
                bucket: bucketName,
                redundancyTransitionTaskid: createResult?.bucketDataRedundancyTransition?.taskId
            )
        )) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
    
    func testDeleteBucketDataRedundancyTransitionFail() async throws {
        var request = DeleteBucketDataRedundancyTransitionRequest()
        try await assertThrowsAsyncError(await client?.deleteBucketDataRedundancyTransition(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = DeleteBucketDataRedundancyTransitionRequest(
            bucket: bucketName,
            redundancyTransitionTaskid: "error"
        )
        try await assertThrowsAsyncError(await client?.deleteBucketDataRedundancyTransition(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
    
    func testListBucketDataRedundancyTransitionSuccess() async throws {
        // CreateBucketDataRedundancyTransition
        let createResult = try await client?.createBucketDataRedundancyTransition(CreateBucketDataRedundancyTransitionRequest(
            bucket: bucketName,
            targetRedundancyType: "ZRS"
        ))
        XCTAssertNotNil(createResult?.bucketDataRedundancyTransition?.taskId)
        let taskId = createResult?.bucketDataRedundancyTransition?.taskId

        // ListBucketDataRedundancyTransition
        let result = try await client?.listBucketDataRedundancyTransition(
            ListBucketDataRedundancyTransitionRequest(bucket: bucketName)
        )
        XCTAssertEqual(result?.listBucketDataRedundancyTransition?.bucketDataRedundancyTransition?.count, 1)
        XCTAssertEqual(result?.listBucketDataRedundancyTransition?.bucketDataRedundancyTransition?[0].taskId, taskId)
    }
    
    func testListBucketDataRedundancyTransitionFail() async throws {
        var request = ListBucketDataRedundancyTransitionRequest()
        try await assertThrowsAsyncError(await client?.listBucketDataRedundancyTransition(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = ListBucketDataRedundancyTransitionRequest(bucket: randomBucketName())
        try await assertThrowsAsyncError(await client?.listBucketDataRedundancyTransition(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
    
    func testListUserDataRedundancyTransitionSuccess() async throws {
        var tasks: [String] = []
        // CreateBucketDataRedundancyTransition
        var createResult = try await client?.createBucketDataRedundancyTransition(CreateBucketDataRedundancyTransitionRequest(
            bucket: bucketName,
            targetRedundancyType: "ZRS"
        ))
        XCTAssertNotNil(createResult?.bucketDataRedundancyTransition?.taskId)
        tasks.append(createResult!.bucketDataRedundancyTransition!.taskId!)
        
        let bucket = randomBucketName()
        try await createBucket(client: client!, bucket: bucket)
        createResult = try await client?.createBucketDataRedundancyTransition(CreateBucketDataRedundancyTransitionRequest(
            bucket: bucket,
            targetRedundancyType: "ZRS"
        ))
        XCTAssertNotNil(createResult?.bucketDataRedundancyTransition?.taskId)
        tasks.append(createResult!.bucketDataRedundancyTransition!.taskId!)

        // ListUserDataRedundancyTransition
        let result = try await client?.listUserDataRedundancyTransition(
            ListUserDataRedundancyTransitionRequest()
        )
        XCTAssertEqual(result?.listBucketDataRedundancyTransition?.bucketDataRedundancyTransition?.count, 2)
        XCTAssertTrue(tasks.contains(result!.listBucketDataRedundancyTransition!.bucketDataRedundancyTransition![0].taskId!))
        XCTAssertTrue(tasks.contains(result!.listBucketDataRedundancyTransition!.bucketDataRedundancyTransition![1].taskId!))

        try await cleanBucket(client: client!, bucket: bucket)
    }
    
    func testListUserDataRedundancyTransitionFail() async throws {
        let request = ListUserDataRedundancyTransitionRequest(continuationToken: "error")
        try await assertThrowsAsyncError(await client?.listUserDataRedundancyTransition(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 400)
        }
    }
}
