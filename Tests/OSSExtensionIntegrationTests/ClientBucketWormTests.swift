import AlibabaCloudOSS
import AlibabaCloudOSSExtension
import XCTest

final class ClientBucketWormTests: BaseTestCase {
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

    func testInitiateBucketWormAndGetBucketWormSuccess() async throws {
        var getBucketWormRequest = GetBucketWormRequest(bucket: bucketName)
        await assertThrowsAsyncError(try await client?.getBucketWorm(getBucketWormRequest)) {
            let error = $0 as? ServerError
            XCTAssertEqual(error?.statusCode, 404)
            XCTAssertEqual(error?.code, "NoSuchWORMConfiguration")
            XCTAssertEqual(error?.message, "The WORM Configuration does not exist.")
        }

        let initiateBucketWormRequest = InitiateBucketWormRequest(bucket: bucketName,
                                                                  initiateWormConfiguration: InitiateWormConfiguration(retentionPeriodInDays: 1))
        try await assertNoThrow(await client?.initiateBucketWorm(initiateBucketWormRequest))

        getBucketWormRequest = GetBucketWormRequest(bucket: bucketName)
        let getBucketWormResult = try await client?.getBucketWorm(getBucketWormRequest)
        XCTAssertEqual(getBucketWormResult?.wormConfiguration?.retentionPeriodInDays, 1)
        XCTAssertNotNil(getBucketWormResult?.wormConfiguration?.wormId)
        XCTAssertNotNil(getBucketWormResult?.wormConfiguration?.state)
        XCTAssertNotNil(getBucketWormResult?.wormConfiguration?.creationDate)
        XCTAssertNotNil(getBucketWormResult?.wormConfiguration?.expirationDate)
    }

    func testInitiateBucketWormFail() async {
        var initiateBucketWormRequest = InitiateBucketWormRequest()
        try await assertThrowsAsyncError(await client?.initiateBucketWorm(initiateBucketWormRequest)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }

        initiateBucketWormRequest = InitiateBucketWormRequest(bucket: bucketName)
        try await assertThrowsAsyncError(await client?.initiateBucketWorm(initiateBucketWormRequest)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.initiateWormConfiguration.")
        }

        initiateBucketWormRequest = InitiateBucketWormRequest(bucket: bucketName,
                                                              initiateWormConfiguration: InitiateWormConfiguration())
        try await assertThrowsAsyncError(await client?.initiateBucketWorm(initiateBucketWormRequest)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 400)
            XCTAssertEqual(serverError?.code, "MalformedXML")
        }
    }

    func testGetBucketWormFail() async {
        let bucket = randomBucketName()
        var request = GetBucketWormRequest()
        try await assertThrowsAsyncError(await client?.getBucketWorm(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }

        request = GetBucketWormRequest(bucket: bucket)
        try await assertThrowsAsyncError(await client?.getBucketWorm(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }

    func testAbortBucketWormSuccess() async throws {
        let initiateBucketWormRequest = InitiateBucketWormRequest(bucket: bucketName,
                                                                  initiateWormConfiguration: InitiateWormConfiguration(retentionPeriodInDays: 1))
        try await assertNoThrow(await client?.initiateBucketWorm(initiateBucketWormRequest))

        var getBucketWormRequest = GetBucketWormRequest(bucket: bucketName)
        let getBucketWormResult = try await client?.getBucketWorm(getBucketWormRequest)
        XCTAssertEqual(getBucketWormResult?.wormConfiguration?.retentionPeriodInDays, 1)

        let request = AbortBucketWormRequest(bucket: bucketName)
        try await assertNoThrow(await client?.abortBucketWorm(request))

        getBucketWormRequest = GetBucketWormRequest(bucket: bucketName)
        await assertThrowsAsyncError(try await client?.getBucketWorm(getBucketWormRequest)) {
            let error = $0 as? ServerError
            XCTAssertEqual(error?.statusCode, 404)
            XCTAssertEqual(error?.code, "NoSuchWORMConfiguration")
            XCTAssertEqual(error?.message, "The WORM Configuration does not exist.")
        }
    }

    func testAbortBucketWormFail() async {
        let bucket = randomBucketName()
        var request = AbortBucketWormRequest()
        try await assertThrowsAsyncError(await client?.abortBucketWorm(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }

        request = AbortBucketWormRequest(bucket: bucket)
        try await assertThrowsAsyncError(await client?.abortBucketWorm(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
    
    func testCompleteBucketWormSuccess() async throws {
        let initiateBucketWormRequest = InitiateBucketWormRequest(bucket: bucketName,
                                                                  initiateWormConfiguration: InitiateWormConfiguration(retentionPeriodInDays: 1))
        try await assertNoThrow(await client?.initiateBucketWorm(initiateBucketWormRequest))

        var getBucketWormRequest = GetBucketWormRequest(bucket: bucketName)
        var getBucketWormResult = try await client?.getBucketWorm(getBucketWormRequest)
        XCTAssertEqual(getBucketWormResult?.wormConfiguration?.retentionPeriodInDays, 1)
        XCTAssertEqual(getBucketWormResult?.wormConfiguration?.state, "InProgress")

        let request = CompleteBucketWormRequest(bucket: bucketName, wormId: getBucketWormResult?.wormConfiguration?.wormId)
        try await assertNoThrow(await client?.completeBucketWorm(request))

        getBucketWormRequest = GetBucketWormRequest(bucket: bucketName)
        getBucketWormResult = try await client?.getBucketWorm(getBucketWormRequest)
        XCTAssertEqual(getBucketWormResult?.wormConfiguration?.retentionPeriodInDays, 1)
        XCTAssertEqual(getBucketWormResult?.wormConfiguration?.state, "Locked")
    }
    
    func testCompleteBucketWormFail() async {
        let bucket = randomBucketName()
        var request = CompleteBucketWormRequest()
        try await assertThrowsAsyncError(await client?.completeBucketWorm(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }

        request = CompleteBucketWormRequest(bucket: bucket)
        try await assertThrowsAsyncError(await client?.completeBucketWorm(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.wormId.")
        }
        
        request = CompleteBucketWormRequest(bucket: bucket, wormId: "wormId")
        try await assertThrowsAsyncError(await client?.completeBucketWorm(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
    
    func testExtendBucketWormSuccess() async throws {
        let initiateBucketWormRequest = InitiateBucketWormRequest(bucket: bucketName,
                                                                  initiateWormConfiguration: InitiateWormConfiguration(retentionPeriodInDays: 1))
        let initiateBucketWormResult = try await client?.initiateBucketWorm(initiateBucketWormRequest)
        
        let completeBucketWormRequest = CompleteBucketWormRequest(bucket: bucketName, wormId: initiateBucketWormResult?.headers?["x-oss-worm-id"])
        try await assertNoThrow(await client?.completeBucketWorm(completeBucketWormRequest))

        var getBucketWormRequest = GetBucketWormRequest(bucket: bucketName)
        var getBucketWormResult = try await client?.getBucketWorm(getBucketWormRequest)
        XCTAssertEqual(getBucketWormResult?.wormConfiguration?.retentionPeriodInDays, 1)
        XCTAssertEqual(getBucketWormResult?.wormConfiguration?.state, "Locked")

        let request = ExtendBucketWormRequest(bucket: bucketName,
                                              wormId: getBucketWormResult?.wormConfiguration?.wormId,
                                              extendWormConfiguration: ExtendWormConfiguration(retentionPeriodInDays: 2))
        try await assertNoThrow(await client?.extendBucketWorm(request))

        getBucketWormRequest = GetBucketWormRequest(bucket: bucketName)
        getBucketWormResult = try await client?.getBucketWorm(getBucketWormRequest)
        XCTAssertEqual(getBucketWormResult?.wormConfiguration?.retentionPeriodInDays, 2)
    }
    
    func testExtendBucketWormFail() async {
        let bucket = randomBucketName()
        var request = ExtendBucketWormRequest()
        try await assertThrowsAsyncError(await client?.extendBucketWorm(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }

        request = ExtendBucketWormRequest(bucket: bucket)
        try await assertThrowsAsyncError(await client?.extendBucketWorm(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.wormId.")
        }
        
        request = ExtendBucketWormRequest(bucket: bucket, wormId: "wormId")
        try await assertThrowsAsyncError(await client?.extendBucketWorm(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.extendWormConfiguration.")
        }
        
        request = ExtendBucketWormRequest(bucket: bucket,
                                          wormId: "wormId",
                                          extendWormConfiguration: ExtendWormConfiguration())
        try await assertThrowsAsyncError(await client?.extendBucketWorm(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
}
