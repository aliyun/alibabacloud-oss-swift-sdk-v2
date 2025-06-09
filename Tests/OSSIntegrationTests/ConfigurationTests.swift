import AlibabaCloudOSS
import Foundation
import XCTest

class ClientConfigurationTests: BaseTestCase {
    override func setUp() async throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try await super.setUp()
    }

    func testWithOptionalArgs() {
        let config = Configuration.default()
            .withRegion("region")
            .withEndpoint("endpoint")
            .withCredentialsProvider(AnonymousCredentialsProvider())
            .withRetryMaxAttempts(5)
            .withMaxConnectionsPerHost(5)
            .withTimeoutIntervalForRequest(60)
            .withTimeoutIntervalForResource(60 * 60)
            .withUserAgent("userAgent")
            .withRetryer(NopRetryer())
            .withUploadCRC64Validation(true)
            .withDownloadCRC64Validation(true)
            .withHttpProtocal(.https)
            .withTLSVerify(true)
            .withFollowRedirect(false)
            .withUsePathStyle(true)
            .withUseCname(true)
            .withUseDualStackEndpoint(true)
            .withUseInternalEndpoint(true)
            .withUseAccelerateEndpoint(true)
            .withSignerVersion(.v4)
            .withAdditionalHeaders(["key"])
            .withProxyHost("proxyHost:8080")
        
#if canImport(os)
        config.withLogger(LogAgentOSLog(level: .debug))
#endif

        XCTAssertEqual(config.region, "region")
        XCTAssertEqual(config.endpoint, "endpoint")
        XCTAssertTrue(config.credentialsProvider is AnonymousCredentialsProvider)
        XCTAssertEqual(config.retryMaxAttempts, 5)
        XCTAssertEqual(config.maxConnectionsPerHost, 5)
        XCTAssertEqual(config.timeoutIntervalForRequest, 60)
        XCTAssertEqual(config.timeoutIntervalForResource, 60 * 60)
        XCTAssertEqual(config.userAgent, "userAgent")
        XCTAssertTrue(config.retryer is NopRetryer)
        XCTAssertTrue(config.enableUploadCRC64Validation ?? false)
        XCTAssertTrue(config.enableDownloadCRC64Validation ?? false)
        XCTAssertEqual(config.httpProtocal, .https)
        XCTAssertTrue(config.enableTLSVerify ?? false)
        XCTAssertFalse(config.enableFollowRedirect ?? true)
        XCTAssertTrue(config.usePathStyle ?? false)
        XCTAssertTrue(config.enableTLSVerify ?? false)
        XCTAssertTrue(config.useCname ?? false)
        XCTAssertTrue(config.useDualStackEndpoint ?? false)
        XCTAssertTrue(config.useInternalEndpoint ?? false)
        XCTAssertTrue(config.useAccelerateEndpoint ?? false)
        XCTAssertEqual(config.signerVersion, .v4)
        XCTAssertEqual(config.additionalHeaders, ["key"])
        XCTAssertEqual(config.proxyHost, "proxyHost:8080")
#if canImport(os)
        XCTAssertTrue(config.logger is LogAgentOSLog)
#endif
    }
    
    func testWithDefaultValues() {
        let config = Configuration.default()
        
        XCTAssertNil(config.region)
        XCTAssertNil(config.endpoint)
        XCTAssertNil(config.credentialsProvider)
        XCTAssertNil(config.retryMaxAttempts)
        XCTAssertNil(config.maxConnectionsPerHost)
        XCTAssertNil(config.timeoutIntervalForRequest)
        XCTAssertNil(config.timeoutIntervalForResource)
        XCTAssertNil(config.userAgent)
        XCTAssertNil(config.retryer)
        XCTAssertNil(config.enableUploadCRC64Validation)
        XCTAssertNil(config.enableDownloadCRC64Validation)
        XCTAssertNil(config.httpProtocal)
        XCTAssertNil(config.enableTLSVerify)
        XCTAssertNil(config.enableFollowRedirect)
        XCTAssertNil(config.usePathStyle)
        XCTAssertNil(config.enableTLSVerify)
        XCTAssertNil(config.useCname)
        XCTAssertNil(config.useDualStackEndpoint)
        XCTAssertNil(config.useInternalEndpoint)
        XCTAssertNil(config.useAccelerateEndpoint)
        XCTAssertNil(config.signerVersion)
        XCTAssertNil(config.additionalHeaders)
        XCTAssertNil(config.logger)
        XCTAssertNil(config.proxyHost)
    }
}
