import AlibabaCloudOSS
import AlibabaCloudOSSExtension
import XCTest

final class ClientBucketLifecycleTests: BaseTestCase {
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

    func testPutAndGetBucketLifecycleSuccess() async throws {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let rules = [LifecycleRule(id: "rule1",
                                   status: "Enabled",
                                   prefix: "1prefix/",
                                   transitions: [LifecycleRuleTransition(days: 30,
                                                                         storageClass: "Archive")],
                                   noncurrentVersionTransitions: [NoncurrentVersionTransition(noncurrentDays: 30,
                                                                                              storageClass: "IA")],
                                   expiration: LifecycleRuleExpiration(days: 180),
                                   abortMultipartUpload: LifecycleRuleAbortMultipartUpload(days: 30),
                                   noncurrentVersionExpiration: NoncurrentVersionExpiration(noncurrentDays: 180)),
                     LifecycleRule(id: "rule2",
                                   status: "Disabled",
                                   prefix: "2prefix/",
                                   transitions: [LifecycleRuleTransition(createdBeforeDate: formatter.date(from: "2025-05-05T00:00:00.000Z"),
                                                                         storageClass: "IA")],
                                   noncurrentVersionTransitions: [NoncurrentVersionTransition(noncurrentDays: 30,
                                                                                              storageClass: "IA")],
                                   expiration: LifecycleRuleExpiration(createdBeforeDate: formatter.date(from: "2025-04-05T00:00:00.000Z")),
                                   abortMultipartUpload: LifecycleRuleAbortMultipartUpload(createdBeforeDate: formatter.date(from: "2025-05-05T00:00:00.000Z")),
                                   noncurrentVersionExpiration: NoncurrentVersionExpiration(noncurrentDays: 180))]
        let request = PutBucketLifecycleRequest(bucket: bucketName, lifecycleConfiguration: LifecycleConfiguration(rules: rules))
        await assertNoThrow(try await client?.putBucketLifecycle(request))
        
        let result = try await client?.getBucketLifecycle(
            GetBucketLifecycleRequest(
                bucket: bucketName
            )
        )
        XCTAssertEqual(result?.lifecycleConfiguration?.rules?.count, 2)
        // rule1
        XCTAssertEqual(result?.lifecycleConfiguration?.rules?.first?.id, "rule1")
        XCTAssertEqual(result?.lifecycleConfiguration?.rules?.first?.status, "Enabled")
//        XCTAssertEqual(result?.lifecycleConfiguration?.rules?.first?.transitions?.first?.returnToStdWhenVisit, true)
//        XCTAssertEqual(result?.lifecycleConfiguration?.rules?.first?.transitions?.first?.allowSmallFile, true)
        XCTAssertEqual(result?.lifecycleConfiguration?.rules?.first?.transitions?.first?.days, 30)
        XCTAssertEqual(result?.lifecycleConfiguration?.rules?.first?.transitions?.first?.storageClass, "Archive")
//        XCTAssertEqual(result?.lifecycleConfiguration?.rules?.first?.transitions?.first?.isAccessTime, true)
//        XCTAssertEqual(result?.lifecycleConfiguration?.rules?.first?.noncurrentVersionTransitions?.first?.isAccessTime, true)
//        XCTAssertEqual(result?.lifecycleConfiguration?.rules?.first?.noncurrentVersionTransitions?.first?.allowSmallFile, true)
        XCTAssertEqual(result?.lifecycleConfiguration?.rules?.first?.noncurrentVersionTransitions?.first?.noncurrentDays, 30)
        XCTAssertEqual(result?.lifecycleConfiguration?.rules?.first?.noncurrentVersionTransitions?.first?.storageClass, "IA")
        XCTAssertEqual(result?.lifecycleConfiguration?.rules?.first?.prefix, "1prefix/")
        XCTAssertEqual(result?.lifecycleConfiguration?.rules?.first?.expiration?.days, 180)
        XCTAssertEqual(result?.lifecycleConfiguration?.rules?.first?.abortMultipartUpload?.days, 30)
        XCTAssertEqual(result?.lifecycleConfiguration?.rules?.first?.noncurrentVersionExpiration?.noncurrentDays, 180)
        // rule2
        XCTAssertEqual(result?.lifecycleConfiguration?.rules?.last?.id, "rule2")
        XCTAssertEqual(result?.lifecycleConfiguration?.rules?.last?.status, "Disabled")
        XCTAssertEqual(result?.lifecycleConfiguration?.rules?.last?.transitions?.first?.createdBeforeDate, formatter.date(from: "2025-05-05T00:00:00.000Z"))
        XCTAssertEqual(result?.lifecycleConfiguration?.rules?.last?.transitions?.first?.storageClass, "IA")
        XCTAssertEqual(result?.lifecycleConfiguration?.rules?.last?.noncurrentVersionTransitions?.first?.noncurrentDays, 30)
        XCTAssertEqual(result?.lifecycleConfiguration?.rules?.last?.noncurrentVersionTransitions?.first?.storageClass, "IA")
        XCTAssertEqual(result?.lifecycleConfiguration?.rules?.last?.prefix, "2prefix/")
        XCTAssertEqual(result?.lifecycleConfiguration?.rules?.last?.expiration?.createdBeforeDate, formatter.date(from: "2025-04-05T00:00:00.000Z"))
        XCTAssertEqual(result?.lifecycleConfiguration?.rules?.last?.abortMultipartUpload?.createdBeforeDate, formatter.date(from: "2025-05-05T00:00:00.000Z"))
        XCTAssertEqual(result?.lifecycleConfiguration?.rules?.first?.noncurrentVersionExpiration?.noncurrentDays, 180)
    }

    func testPutBucketLifecycleFail() async {
        try await assertThrowsAsyncError(await client?.putBucketLifecycle(PutBucketLifecycleRequest())) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        try await assertThrowsAsyncError(await client?.putBucketLifecycle(PutBucketLifecycleRequest(bucket: bucketName))) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.lifecycleConfiguration.")
        }
        
        let request = PutBucketLifecycleRequest(bucket: bucketName,
                                                lifecycleConfiguration: LifecycleConfiguration(rules: [LifecycleRule()]))
        await assertThrowsAsyncError(try await client?.putBucketLifecycle(request)) {
            let error = $0 as? ServerError
            XCTAssertEqual(error?.statusCode, 400)
            XCTAssertEqual(error?.code, "MalformedXML")
            XCTAssertEqual(error?.message, "The XML you provided was not well-formed or did not validate against our published schema.")
        }
    }

    func testGetBucketLifecycleFail() async {
        try await assertThrowsAsyncError(await client?.getBucketLifecycle(GetBucketLifecycleRequest())) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }

        try await assertThrowsAsyncError(await client?.getBucketLifecycle(GetBucketLifecycleRequest(bucket: bucketName))) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }

    func testDeleteBucketLifecycleSuccess() async throws {
        let rules = [LifecycleRule(id: "rule",
                                   status: "Enabled",
                                   prefix: "",
                                   transitions: [LifecycleRuleTransition(days: 30,
                                                                         storageClass: "Archive")])]
        let request = PutBucketLifecycleRequest(bucket: bucketName, lifecycleConfiguration: LifecycleConfiguration(rules: rules))
        await assertNoThrow(try await client?.putBucketLifecycle(request))
        
        let result = try await client?.getBucketLifecycle(
            GetBucketLifecycleRequest(
                bucket: bucketName
            )
        )
        XCTAssertEqual(result?.lifecycleConfiguration?.rules?.count, 1)
        
        await assertNoThrow(try await client?.deleteBucketLifecycle(
            DeleteBucketLifecycleRequest(
                bucket: bucketName
            )
        ))
        try await assertThrowsAsyncError(await client?.getBucketLifecycle(GetBucketLifecycleRequest(bucket: bucketName))) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }

    func testDeleteBucketLifecycleFail() async {
        let bucket = randomBucketName()
        try await assertThrowsAsyncError(await client?.deleteBucketLifecycle(DeleteBucketLifecycleRequest())) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }

        try await assertThrowsAsyncError(await client?.deleteBucketLifecycle(DeleteBucketLifecycleRequest(bucket: bucket))) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
}
