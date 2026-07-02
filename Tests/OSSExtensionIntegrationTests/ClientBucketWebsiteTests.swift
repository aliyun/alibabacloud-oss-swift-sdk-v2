import AlibabaCloudOSS
import AlibabaCloudOSSExtension
import XCTest

final class ClientBucketWebsiteTests: BaseTestCase {
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
        
    func testPutAndGetBucketWebsiteSuccess() async throws {
        try await assertNoThrow(await client?.putBucketWebsite(
            PutBucketWebsiteRequest(
                bucket: bucketName,
                websiteConfiguration: WebsiteConfiguration(
                    indexDocument: IndexDocument(suffix: "index.html", supportSubDir: true, type: 0),
                    errorDocument: ErrorDocument(key: "error.html", httpStatus: 404),
                    routingRules: RoutingRules(
                        routingRules: [RoutingRule(
                            ruleNumber: 1,
                            condition: RoutingRuleCondition(
                                keyPrefixEquals: "abc/",
                                httpErrorCodeReturnedEquals: 404,
                            ),
                            redirect: RoutingRuleRedirect(
                                redirectType: "Mirror",
                                mirrorFollowRedirect: true,
                                passQueryString: true,
                                mirrorCheckMd5: false,
                                mirrorPassQueryString: true,
                                mirrorHeaders: MirrorHeaders(passAll: true,
                                                             pass: ["myheader-key1", "myheader-key2"],
                                                             removes: ["myheader-key3", "myheader-key4"],
                                                             sets: [Set(key: "myheader-key5", value: "myheader-value5")]),
                                mirrorURL: "http://example.com/",
                            )
                        ), RoutingRule(
                            ruleNumber: 2,
                            condition: RoutingRuleCondition(
                                keyPrefixEquals: "abc/",
                                httpErrorCodeReturnedEquals: 404,
                                includeHeaders: [IncludeHeader(key: "host", equals: "test.oss-cn-beijing-internal.aliyuncs.com")]
                            ),
                            redirect: RoutingRuleRedirect(
                                redirectType: "AliCDN",
                                passQueryString: false,
                                replaceKeyWith: "prefix/${key}.suffix",
                                httpRedirectCode: 301,
                                protocol: "http",
                                hostName: "example.com",
                            )
                        ), RoutingRule(
                            ruleNumber: 3,
                            condition: RoutingRuleCondition(
                                httpErrorCodeReturnedEquals: 404,
                            ),
                            redirect: RoutingRuleRedirect(
                                redirectType: "External",
                                passQueryString: false,
                                replaceKeyWith: "prefix/${key}",
                                enableReplacePrefix: false,
                                httpRedirectCode: 302,
                                protocol: "http",
                                hostName: "example.com"
                            )
                        )])
                )
            )
        ))
        
        let result = try await client?.getBucketWebsite(
            GetBucketWebsiteRequest(bucket: bucketName)
        )
        XCTAssertEqual(result?.websiteConfiguration?.indexDocument?.suffix, "index.html")
        XCTAssertEqual(result?.websiteConfiguration?.indexDocument?.supportSubDir, true)
        XCTAssertEqual(result?.websiteConfiguration?.indexDocument?.type, 0)
        XCTAssertEqual(result?.websiteConfiguration?.errorDocument?.key, "error.html")
        XCTAssertEqual(result?.websiteConfiguration?.errorDocument?.httpStatus, 404)
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[0].ruleNumber, 1)
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[0].condition?.keyPrefixEquals, "abc/")
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[0].condition?.httpErrorCodeReturnedEquals, 404)
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[0].redirect?.redirectType, "Mirror")
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[0].redirect?.mirrorFollowRedirect, true)
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[0].redirect?.passQueryString, true)
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[0].redirect?.mirrorCheckMd5, false)
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[0].redirect?.mirrorPassQueryString, true)
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[0].redirect?.mirrorHeaders?.passAll, true)
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[0].redirect?.mirrorHeaders?.pass, ["myheader-key1", "myheader-key2"])
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[0].redirect?.mirrorHeaders?.removes, ["myheader-key3", "myheader-key4"])
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[0].redirect?.mirrorHeaders?.sets?.first?.key, "myheader-key5")
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[0].redirect?.mirrorHeaders?.sets?.first?.value, "myheader-value5")
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[0].redirect?.mirrorURL, "http://example.com/")
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[1].ruleNumber, 2)
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[1].condition?.keyPrefixEquals, "abc/")
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[1].condition?.httpErrorCodeReturnedEquals, 404)
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[1].condition?.includeHeaders?.first?.key, "host")
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[1].condition?.includeHeaders?.first?.equals, "test.oss-cn-beijing-internal.aliyuncs.com")
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[1].redirect?.redirectType, "AliCDN")
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[1].redirect?.passQueryString, false)
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[1].redirect?.replaceKeyWith, "prefix/${key}.suffix")
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[1].redirect?.httpRedirectCode, 301)
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[1].redirect?.protocol, "http")
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[1].redirect?.hostName, "example.com")
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[2].ruleNumber, 3)
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[2].condition?.httpErrorCodeReturnedEquals, 404)
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[2].redirect?.redirectType, "External")
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[2].redirect?.passQueryString, false)
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[2].redirect?.replaceKeyWith, "prefix/${key}")
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[2].redirect?.enableReplacePrefix, false)
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[2].redirect?.httpRedirectCode, 302)
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[2].redirect?.protocol, "http")
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?[2].redirect?.hostName, "example.com")
    }
    
    func testPutBucketWebsiteFail() async throws {
        var request = PutBucketWebsiteRequest()
        try await assertThrowsAsyncError(await client?.putBucketWebsite(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = PutBucketWebsiteRequest(bucket: bucketName)
        try await assertThrowsAsyncError(await client?.putBucketWebsite(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.websiteConfiguration.")
        }
        
        request = PutBucketWebsiteRequest(
            bucket: bucketName,
            websiteConfiguration: WebsiteConfiguration()
        )
        try await assertThrowsAsyncError(await client?.putBucketWebsite(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 400)
            XCTAssertEqual(serverError?.code, "MalformedXML")
        }
    }
    
    func testGetBucketWebsiteFail() async throws {
        var request = GetBucketWebsiteRequest()
        try await assertThrowsAsyncError(await client?.getBucketWebsite(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = GetBucketWebsiteRequest(bucket: bucketName)
        try await assertThrowsAsyncError(await client?.getBucketWebsite(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
    
    func testDeleteBucketWebsiteSuccess() async throws {
        try await assertNoThrow(await client?.putBucketWebsite(
            PutBucketWebsiteRequest(
                bucket: bucketName,
                websiteConfiguration: WebsiteConfiguration(
                    indexDocument: IndexDocument(suffix: "index.html", supportSubDir: true, type: 0),
                    errorDocument: ErrorDocument(key: "error.html", httpStatus: 404),
                    routingRules: RoutingRules(
                        routingRules: [RoutingRule(
                            ruleNumber: 1,
                            condition: RoutingRuleCondition(
                                keyPrefixEquals: "abc/",
                                httpErrorCodeReturnedEquals: 404,
                            ),
                            redirect: RoutingRuleRedirect(
                                redirectType: "Mirror",
                                mirrorFollowRedirect: true,
                                passQueryString: true,
                                mirrorCheckMd5: false,
                                mirrorPassQueryString: true,
                                mirrorHeaders: MirrorHeaders(passAll: true,
                                                             pass: ["myheader-key1", "myheader-key2"],
                                                             removes: ["myheader-key3", "myheader-key4"],
                                                             sets: [Set(key: "myheader-key5", value: "myheader-value5")]),
                                mirrorURL: "http://example.com/",
                            )
                        )])
                )
            )
        ))
        
        let result = try await client?.getBucketWebsite(
            GetBucketWebsiteRequest(bucket: bucketName)
        )
        XCTAssertEqual(result?.websiteConfiguration?.routingRules?.routingRules?.count, 1)
        
        try await assertNoThrow(await client?.deleteBucketWebsite(
            DeleteBucketWebsiteRequest(bucket: bucketName)
        ))
        
        try await assertThrowsAsyncError(await client?.getBucketWebsite(
            GetBucketWebsiteRequest(bucket: bucketName)
        )) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
    
    func testDeleteBucketWebsiteFail() async throws {
        var request = DeleteBucketWebsiteRequest()
        try await assertThrowsAsyncError(await client?.deleteBucketWebsite(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = DeleteBucketWebsiteRequest(bucket: randomBucketName())
        try await assertThrowsAsyncError(await client?.deleteBucketWebsite(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
}
