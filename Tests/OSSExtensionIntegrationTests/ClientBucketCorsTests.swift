import AlibabaCloudOSS
import AlibabaCloudOSSExtension
import XCTest

final class ClientBucketCorsTests: BaseTestCase {
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

    // MARK: - PutBucketCors

    func testPutBucketCors() async throws {
        let rules = [["allowedOrigin": ["www.aliyun.com",
                                        "www.test.com"],
                      "allowedMethod": ["PUT", "GET"],
                      "allowedHeader": ["authorization"],
                      "exposeHeader": ["x-oss-test",
                                       "x-oss-test1"],
                      "maxAgeSeconds": 10000],
                     ["allowedOrigin": ["www.aliyun1.com",
                                        "www.test1.com"],
                      "allowedMethod": ["DELETE", "HEAD"],
                      "allowedHeader": ["authorization"],
                      "exposeHeader": ["x-oss-test1",
                                       "x-oss-test11"],
                      "maxAgeSeconds": 20000]]

        var corsRules: [CORSRule] = []
        for rule in rules {
            let corsRule = CORSRule(allowedOrigins: rule["allowedOrigin"] as? [String],
                                    allowedMethods: rule["allowedMethod"] as? [String],
                                    allowedHeaders: rule["allowedHeader"] as? [String],
                                    exposeHeaders: rule["exposeHeader"] as? [String],
                                    maxAgeSeconds: rule["maxAgeSeconds"] as? Int)
            corsRules.append(corsRule)
        }
        let corsConfig = CORSConfiguration(corsRules: corsRules)
        let request = PutBucketCorsRequest(bucket: bucketName,
                                           corsConfiguration: corsConfig)
        let result = try await client?.putBucketCors(request)
        XCTAssertEqual(result?.statusCode, 200)
    }

    func testPutBucketCorsWithNilOption() async throws {
        let rules = [["allowedOrigin": ["www.aliyun1.com",
                                        "www.test1.com"],
                      "allowedMethod": ["PUT", "GET"],
                      "allowedHeader": nil,
                      "exposeHeader": nil,
                      "maxAgeSeconds": nil]]

        var corsRules: [CORSRule] = []
        for rule in rules {
            let corsRule = CORSRule(allowedOrigins: rule["allowedOrigin"] as? [String],
                                    allowedMethods: rule["allowedMethod"] as? [String],
                                    allowedHeaders: rule["allowedHeader"] as? [String],
                                    exposeHeaders: rule["exposeHeader"] as? [String],
                                    maxAgeSeconds: rule["maxAgeSeconds"] as? Int)
            corsRules.append(corsRule)
        }
        let corsConfig = CORSConfiguration(corsRules: corsRules)
        let request = PutBucketCorsRequest(bucket: bucketName,
                                           corsConfiguration: corsConfig)
        let result = try await client?.putBucketCors(request)
        XCTAssertEqual(result?.statusCode, 200)
    }

    func testPutBucketCorsFail() async throws {
        var request = PutBucketCorsRequest()
        try await assertThrowsAsyncError(await client?.putBucketCors(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }

        request = PutBucketCorsRequest(bucket: bucketName)
        try await assertThrowsAsyncError(await client?.putBucketCors(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.corsConfiguration.")
        }

        request = PutBucketCorsRequest(bucket: bucketName, corsConfiguration: CORSConfiguration(corsRules: [CORSRule(allowedOrigins: ["a"])]))
        try await assertThrowsAsyncError(await client?.putBucketCors(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 400)
            XCTAssertEqual(serverError?.code, "MalformedXML")
        }
    }

    // MARK: - GetBucketCors

    func testGetBucketCors() async throws {
        let rules = [["allowedOrigin": ["www.aliyun.com",
                                        "www.test.com"],
                      "allowedMethod": ["PUT", "GET"],
                      "allowedHeader": ["authorization"],
                      "exposeHeader": ["x-oss-test",
                                       "x-oss-test1"],
                      "maxAgeSeconds": 10000],
                     ["allowedOrigin": ["www.aliyun1.com",
                                        "www.test1.com"],
                      "allowedMethod": ["DELETE", "HEAD"],
                      "allowedHeader": ["authorization"],
                      "exposeHeader": ["x-oss-test1",
                                       "x-oss-test11"],
                      "maxAgeSeconds": 20000]]

        var corsRules: [CORSRule] = []
        for rule in rules {
            let corsRule = CORSRule(allowedOrigins: rule["allowedOrigin"] as? [String],
                                    allowedMethods: rule["allowedMethod"] as? [String],
                                    allowedHeaders: rule["allowedHeader"] as? [String],
                                    exposeHeaders: rule["exposeHeader"] as? [String],
                                    maxAgeSeconds: rule["maxAgeSeconds"] as? Int)
            corsRules.append(corsRule)
        }
        let corsConfig = CORSConfiguration(corsRules: corsRules)
        let request = PutBucketCorsRequest(bucket: bucketName,
                                           corsConfiguration: corsConfig)
        let result = try await client?.putBucketCors(request)
        XCTAssertEqual(result?.statusCode, 200)

        try await Task.sleep(nanoseconds: 2 * 1_000_000_000)

        let getCorsRequest = GetBucketCorsRequest(bucket: bucketName)
        let getCorsResult = try await client?.getBucketCors(getCorsRequest)
        XCTAssertEqual(getCorsResult?.statusCode, 200)
        XCTAssertEqual(getCorsResult?.corsConfiguration?.corsRules?.count, 2)

        for corsRule in getCorsResult!.corsConfiguration!.corsRules! {
            var rule: [String: Any] = [:]
            for r in rules {
                if r["allowedOrigin"] as? [String] == corsRule.allowedOrigins {
                    rule = r
                    break
                }
            }
            XCTAssertEqual(rule["allowedMethod"] as? [String], corsRule.allowedMethods)
            XCTAssertEqual(rule["allowedHeader"] as? [String], corsRule.allowedHeaders)
            XCTAssertEqual(rule["exposeHeader"] as? [String], corsRule.exposeHeaders)
            XCTAssertEqual(rule["maxAgeSeconds"] as? Int, corsRule.maxAgeSeconds)
        }
    }

    func testGetBucketCorsWithOneRule() async throws {
        let rules = [["allowedOrigin": ["www.aliyun.com",
                                        "www.test.com"],
                      "allowedMethod": ["PUT", "GET"],
                      "allowedHeader": ["authorization"],
                      "exposeHeader": ["x-oss-test",
                                       "x-oss-test1"],
                      "maxAgeSeconds": 10000]]

        var corsRules: [CORSRule] = []
        for rule in rules {
            let corsRule = CORSRule(allowedOrigins: rule["allowedOrigin"] as? [String],
                                    allowedMethods: rule["allowedMethod"] as? [String],
                                    allowedHeaders: rule["allowedHeader"] as? [String],
                                    exposeHeaders: rule["exposeHeader"] as? [String],
                                    maxAgeSeconds: rule["maxAgeSeconds"] as? Int)
            corsRules.append(corsRule)
        }
        let corsConfig = CORSConfiguration(corsRules: corsRules)
        let request = PutBucketCorsRequest(bucket: bucketName,
                                           corsConfiguration: corsConfig)
        let result = try await client?.putBucketCors(request)
        XCTAssertEqual(result?.statusCode, 200)

        try await Task.sleep(nanoseconds: 2 * 1_000_000_000)

        let getCorsRequest = GetBucketCorsRequest(bucket: bucketName)
        let getCorsResult = try await client?.getBucketCors(getCorsRequest)
        XCTAssertEqual(getCorsResult?.statusCode, 200)
        XCTAssertEqual(getCorsResult?.corsConfiguration?.corsRules?.count, 1)

        for corsRule in getCorsResult!.corsConfiguration!.corsRules! {
            var rule: [String: Any] = [:]
            for r in rules {
                if r["allowedOrigin"] as? [String] == corsRule.allowedOrigins {
                    rule = r
                    break
                }
            }
            XCTAssertEqual(rule["allowedMethod"] as? [String], corsRule.allowedMethods)
            XCTAssertEqual(rule["allowedHeader"] as? [String], corsRule.allowedHeaders)
            XCTAssertEqual(rule["exposeHeader"] as? [String], corsRule.exposeHeaders)
            XCTAssertEqual(rule["maxAgeSeconds"] as? Int, corsRule.maxAgeSeconds)
        }
    }

    func testGetBucketCorsFail() async throws {
        let getCorsRequest = GetBucketCorsRequest(bucket: bucketName)
        try await assertThrowsAsyncError(await client?.getBucketCors(getCorsRequest)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
            XCTAssertEqual(serverError?.code, "NoSuchCORSConfiguration")
        }
    }

    // MARK: - DeleteBucketCors

    func testDeleteBucketCorsSuccess() async throws {
        let deleteCorsRequest = DeleteBucketCorsRequest(bucket: bucketName)
        let deleteCorsResult = try await client?.deleteBucketCors(deleteCorsRequest)
        XCTAssertEqual(deleteCorsResult?.statusCode, 204)

        let getCorsRequest = GetBucketCorsRequest(bucket: bucketName)
        try await assertThrowsAsyncError(await client?.getBucketCors(getCorsRequest)) { error in
            XCTAssertEqual((error as? ServerError)?.statusCode, 404)
        }
    }

    func testDeleteBucketCorsFail() async throws {
        let bucket = randomBucketName()
        let deleteCorsRequest = DeleteBucketCorsRequest(bucket: bucket)
        try await assertThrowsAsyncError(await client?.deleteBucketCors(deleteCorsRequest)) { error in
            XCTAssertEqual((error as? ServerError)?.statusCode, 404)
        }
    }
}
