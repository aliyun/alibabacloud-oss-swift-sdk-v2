import AlibabaCloudOSS
import AlibabaCloudOSSExtension
import XCTest

final class ClientBucketStyleTests: BaseTestCase {
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
        
    func testPutAndGetStyleSuccess() async throws {
        // PutStyle
        try await assertNoThrow(await client?.putStyle(PutStyleRequest(
            bucket: bucketName,
            styleName: "styleName1",
            category: "image",
            style: StyleContent(
                content: "image/resize,p_50",
            )
        )))
        
        // GetStyle
        let result = try await client?.getStyle(
            GetStyleRequest(
                bucket: bucketName,
                styleName: "styleName1"
            )
        )
        XCTAssertEqual(result?.style?.name, "styleName1")
        XCTAssertEqual(result?.style?.content, "image/resize,p_50")
        XCTAssertEqual(result?.style?.category, "image")
        XCTAssertNotNil(result?.style?.createTime)
        XCTAssertEqual(result?.style?.createTime, result?.style?.lastModifyTime)
    }
    
    func testPutStyleFail() async throws {
        var request = PutStyleRequest()
        try await assertThrowsAsyncError(await client?.putStyle(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = PutStyleRequest(bucket: bucketName)
        try await assertThrowsAsyncError(await client?.putStyle(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.style.")
        }
        
        request = PutStyleRequest(
            bucket: bucketName,
            style: StyleContent()
        )
        try await assertThrowsAsyncError(await client?.putStyle(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 400)
            XCTAssertEqual(serverError?.code, "MissingArgument")
        }
    }
    
    func testGetStyleFail() async throws {
        var request = GetStyleRequest()
        try await assertThrowsAsyncError(await client?.getStyle(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = GetStyleRequest(bucket: bucketName, styleName: "error")
        try await assertThrowsAsyncError(await client?.getStyle(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
    
    func testListStyleSuccess() async throws {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE, dd MMM yyyy HH:mm:ss zzz"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // PutStyle
        try await assertNoThrow(await client?.putStyle(PutStyleRequest(
            bucket: bucketName,
            styleName: "styleName1",
            category: "image",
            style: StyleContent(
                content: "image/resize,p_50",
            )
        )))
        try await assertNoThrow(await client?.putStyle(PutStyleRequest(
            bucket: bucketName,
            styleName: "styleName2",
            category: "image",
            style: StyleContent(
                content: "image/resize,w_50",
            )
        )))
        
        // ListStyle
        let result = try await client?.listStyle(
            ListStyleRequest(bucket: bucketName)
        )
        XCTAssertEqual(result?.styleList?.styles?.count, 2)
        XCTAssertEqual(result?.styleList?.styles?[0].name, "styleName1")
        XCTAssertEqual(result?.styleList?.styles?[0].content, "image/resize,p_50")
        XCTAssertEqual(result?.styleList?.styles?[0].category, "image")
        XCTAssertLessThanOrEqual(dateFormatter.date(from: result!.styleList!.styles![0].createTime!)!, now)
        XCTAssertLessThanOrEqual(dateFormatter.date(from: result!.styleList!.styles![0].lastModifyTime!)!, now)
        XCTAssertEqual(result?.styleList?.styles?[1].name, "styleName2")
        XCTAssertEqual(result?.styleList?.styles?[1].content, "image/resize,w_50")
        XCTAssertEqual(result?.styleList?.styles?[1].category, "image")
        XCTAssertLessThanOrEqual(dateFormatter.date(from: result!.styleList!.styles![1].createTime!)!, now)
        XCTAssertLessThanOrEqual(dateFormatter.date(from: result!.styleList!.styles![1].lastModifyTime!)!, now)
    }
    
    func testListStyleFail() async throws {
        var request = ListStyleRequest()
        try await assertThrowsAsyncError(await client?.listStyle(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = ListStyleRequest(bucket: randomBucketName())
        try await assertThrowsAsyncError(await client?.listStyle(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
    
    func testDeleteStyleSuccess() async throws {
        // PutStyle
        try await assertNoThrow(await client?.putStyle(PutStyleRequest(
            bucket: bucketName,
            styleName: "styleName1",
            category: "image",
            style: StyleContent(
                content: "image/resize,p_50",
            )
        )))
        
        // GetStyle
        let result = try await client?.getStyle(
            GetStyleRequest(
                bucket: bucketName,
                styleName: "styleName1"
            )
        )
        XCTAssertEqual(result?.style?.name, "styleName1")
        
        try await assertNoThrow(await client?.deleteStyle(
            DeleteStyleRequest(
                bucket: bucketName,
                styleName: "styleName1"
            )
        ))
        
        try await assertThrowsAsyncError(await client?.getStyle(
            GetStyleRequest(
                bucket: bucketName,
                styleName: "styleName1"
            )
        )) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
    
    func testDeleteStyleFail() async throws {
        var request = DeleteStyleRequest()
        try await assertThrowsAsyncError(await client?.deleteStyle(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = DeleteStyleRequest(bucket: randomBucketName(), styleName: "error")
        try await assertThrowsAsyncError(await client?.deleteStyle(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
}
