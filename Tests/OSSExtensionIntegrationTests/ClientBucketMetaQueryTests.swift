import AlibabaCloudOSS
import AlibabaCloudOSSExtension
import XCTest

final class ClientBucketMetaQueryTests: BaseTestCase {
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
        
    func testOpenAndGetAndCloseBucketMetaQuerySuccess() async throws {
        // OpenMetaQuery
        try await assertNoThrow(await client?.openMetaQuery(OpenMetaQueryRequest(
            bucket: bucketName,
            mode: "basic"
        )))
        
        // GetMetaQueryStatus
        let result = try await client?.getMetaQueryStatus(
            GetMetaQueryStatusRequest(
                bucket: bucketName
            )
        )
        XCTAssertEqual(result?.metaQueryStatus?.state, "Ready")
        XCTAssertNotNil(result?.metaQueryStatus?.createTime)
        XCTAssertNotNil(result?.metaQueryStatus?.updateTime)
        
        // CloseMetaQuery
        try await assertNoThrow(await client?.closeMetaQuery(CloseMetaQueryRequest(
            bucket: bucketName
        )))
        try await assertThrowsAsyncError(await client?.getMetaQueryStatus(
            GetMetaQueryStatusRequest(
                bucket: bucketName
            )
        )) {
            let error = $0 as? ServerError
            XCTAssertEqual(error?.statusCode, 404)
        }
    }
    
    func testOpenMetaQueryFail() async throws {
        var request = OpenMetaQueryRequest()
        try await assertThrowsAsyncError(await client?.openMetaQuery(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = OpenMetaQueryRequest(
            bucket: bucketName,
            mode: "error"
        )
        try await assertThrowsAsyncError(await client?.openMetaQuery(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 400)
            XCTAssertEqual(serverError?.code, "InvalidArgument")
        }
    }
    
    func testGetBucketMetaQueryFail() async throws {
        var request = GetMetaQueryStatusRequest()
        try await assertThrowsAsyncError(await client?.getMetaQueryStatus(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = GetMetaQueryStatusRequest(bucket: randomBucketName())
        try await assertThrowsAsyncError(await client?.getMetaQueryStatus(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
    
    func testCloseMetaQueryFail() async throws {
        var request = CloseMetaQueryRequest()
        try await assertThrowsAsyncError(await client?.closeMetaQuery(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = CloseMetaQueryRequest(bucket: randomBucketName())
        try await assertThrowsAsyncError(await client?.closeMetaQuery(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
    
    func testDoMetaQuerySuccess() async throws {
        let key = randomObjectName()
        try await assertNoThrow(await client?.putObject(
            PutObjectRequest(
                bucket: bucketName,
                key: key,
                body: .data("hello oss".data(using: .utf8)!)
            )
        ))
        
        // OpenMetaQuery
        try await assertNoThrow(await client?.openMetaQuery(OpenMetaQueryRequest(
            bucket: bucketName,
            mode: "basic"
        )))
        
        // DoMetaQuery
        let result = try await client?.doMetaQuery(
            DoMetaQueryRequest(
                bucket: bucketName,
                mode: "basic",
                metaQuery: MetaQuery(
                    query: "{\"Field\": \"OSSObjectType\",\"Value\": \"Normal\",\"Operation\": \"eq\"}"
                )
            )
        )
        XCTAssertNotNil(result?.metaQuery)

        // CloseMetaQuery
        try await assertNoThrow(await client?.closeMetaQuery(CloseMetaQueryRequest(
            bucket: bucketName
        )))
    }
    
    func testDoMetaQueryFail() async throws {
        var request = DoMetaQueryRequest()
        try await assertThrowsAsyncError(await client?.doMetaQuery(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = DoMetaQueryRequest(
            bucket: bucketName,
        )
        try await assertThrowsAsyncError(await client?.doMetaQuery(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.metaQuery.")
        }
        
        request = DoMetaQueryRequest(
            bucket: bucketName,
            mode: "error",
            metaQuery: MetaQuery()
        )
        try await assertThrowsAsyncError(await client?.doMetaQuery(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 400)
            XCTAssertEqual(serverError?.code, "InvalidArgument")
        }
    }
}
