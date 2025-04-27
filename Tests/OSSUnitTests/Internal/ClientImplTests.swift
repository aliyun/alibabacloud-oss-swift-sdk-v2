
@testable import AlibabaCloudOSS
import XCTest

final class ClientImplTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testClientImplConstructor() throws {
        let credentialsProvider = AnonymousCredentialsProvider()
        let endpoint = "oss-cn-hangzhou.aliyuncs.com"
        let config = Configuration.default()
            .withEndpoint(endpoint)
            .withCredentialsProvider(credentialsProvider)
        var client = ClientImpl(config)
        XCTAssertNotNil(client)

        // XCTAssertEqual("oss-cn-hangzhou.aliyuncs.com", client.options.endpoint)
        XCTAssertEqual("", client.options.region)

        client = ClientImpl(config, [{ $0.region = "cn-hangzhou" }])
        // XCTAssertEqual("oss-cn-hangzhou.aliyuncs.com", client.options.endpoint)
        XCTAssertEqual("cn-hangzhou", client.options.region)

        client = ClientImpl(
            config,
            [
                { $0.region = "cn-hangzhou" },
                // { $0.endpoint = "oss-cn-beijing.aliyuncs.com" },
                { $0.region = "cn-beijing" },
            ]
        )
        // XCTAssertEqual("oss-cn-beijing.aliyuncs.com", client.options.endpoint)
        XCTAssertEqual("cn-beijing", client.options.region)
    }

    func testResolveEndpoint() {
        // endpoint
        var endpoint = "oss-cn-beijing.aliyuncs.com"
        var config = Configuration.default()
            .withEndpoint(endpoint)
        var client = ClientImpl(config)
        XCTAssertNotNil(client.options.endpoint)

        // invalid endpoint
        endpoint = ""
        config = Configuration.default()
            .withEndpoint(endpoint)
        client = ClientImpl(config)
        XCTAssertNil(client.options.endpoint)

        // region
        let region = "cn-beijing"
        config = Configuration.default()
            .withRegion(region)
        client = ClientImpl(config)
        XCTAssertEqual(client.options.endpoint?.host, "oss-\(region).aliyuncs.com")
        XCTAssertEqual(client.options.endpoint?.scheme, config.httpProtocal.rawValue)

        config = Configuration.default()
            .withRegion(region)
            .withUseInternalEndpoint(true)
        client = ClientImpl(config)
        XCTAssertEqual(client.options.endpoint?.host, "oss-\(region)-internal.aliyuncs.com")
        XCTAssertEqual(client.options.endpoint?.scheme, config.httpProtocal.rawValue)

        config = Configuration.default()
            .withRegion(region)
            .withUseAccelerateEndpoint(true)
        client = ClientImpl(config)
        XCTAssertEqual(client.options.endpoint?.host, "oss-accelerate.aliyuncs.com")
        XCTAssertEqual(client.options.endpoint?.scheme, config.httpProtocal.rawValue)

        config = Configuration.default()
            .withRegion(region)
            .withUseDualStackEndpoint(true)
        client = ClientImpl(config)
        XCTAssertEqual(client.options.endpoint?.host, "\(region).oss.aliyuncs.com")
        XCTAssertEqual(client.options.endpoint?.scheme, config.httpProtocal.rawValue)

        // ssl
        config = Configuration.default()
            .withRegion(region)
            .withHttpProtocal(.http)
        client = ClientImpl(config)
        XCTAssertEqual(client.options.endpoint?.host, "oss-\(region).aliyuncs.com")
        XCTAssertEqual(client.options.endpoint?.scheme, config.httpProtocal.rawValue)
    }

    func testResolveRetryer() {
        let maxRetryCount = 10
        var config = Configuration.default()
            .withRetryMaxAttempts(maxRetryCount)
        var client = ClientImpl(config)
        XCTAssertNotNil(client.options.retryer)
        XCTAssertEqual(client.options.retryer.maxAttempts(), maxRetryCount)

        config = Configuration.default()
            .withRetryer(TestRetryer())
            .withRetryMaxAttempts(maxRetryCount)
        client = ClientImpl(config)
        XCTAssertEqual(client.options.retryer.maxAttempts(), 1)
    }

    func testResolveSigner() {
        var config = Configuration.default()
        var client = ClientImpl(config)
        XCTAssertTrue(client.options.signer.self is SignerV4)

        config = Configuration.default()
            .withSignerVersion(.v1)
        client = ClientImpl(config)
        XCTAssertTrue(client.options.signer.self is SignerV1)
    }

    func testResolveAddressStyle() {
        // default
        var config = Configuration.default()
        var client = ClientImpl(config)
        XCTAssertEqual(client.options.addressStyle, .virtualHosted)

        // cname
        config = Configuration.default()
            .withUseCname(true)
        client = ClientImpl(config)
        XCTAssertEqual(client.options.addressStyle, .cname)

        // path
        config = Configuration.default()
            .withUsePathStyle(true)
        client = ClientImpl(config)
        XCTAssertEqual(client.options.addressStyle, .path)

        // ip
        config = Configuration.default()
            .withEndpoint("192.169.0.1")
        client = ClientImpl(config)
        XCTAssertEqual(client.options.addressStyle, .path)

        config = Configuration.default()
            .withEndpoint("[fe80::200:ff:fe00:400]")
        client = ClientImpl(config)
        XCTAssertEqual(client.options.addressStyle, .path)
    }

    func testResolveFeatureFlags() {
        // default
        var config = Configuration.default()
        var client = ClientImpl(config)
        XCTAssertTrue(client.options.featureFlags.contains(.correctClockSkew))
        XCTAssertTrue(client.options.featureFlags.contains(.autoDetectMimeType))
        XCTAssertTrue(client.options.featureFlags.contains(.enableCRC64CheckDownload))
        XCTAssertTrue(client.options.featureFlags.contains(.enableCRC64CheckUpload))
        XCTAssertFalse(client.options.featureFlags.contains(.enableMD5))

        // CRC64CheckUpload
        config = Configuration.default()
            .withUploadCRC64Validation(true)
        client = ClientImpl(config)
        XCTAssertTrue(client.options.featureFlags.contains(.correctClockSkew))
        XCTAssertTrue(client.options.featureFlags.contains(.autoDetectMimeType))
        XCTAssertTrue(client.options.featureFlags.contains(.enableCRC64CheckDownload))
        XCTAssertTrue(client.options.featureFlags.contains(.enableCRC64CheckUpload))
        XCTAssertFalse(client.options.featureFlags.contains(.enableMD5))

        config = Configuration.default()
            .withUploadCRC64Validation(false)
        client = ClientImpl(config)
        XCTAssertTrue(client.options.featureFlags.contains(.correctClockSkew))
        XCTAssertTrue(client.options.featureFlags.contains(.autoDetectMimeType))
        XCTAssertTrue(client.options.featureFlags.contains(.enableCRC64CheckDownload))
        XCTAssertFalse(client.options.featureFlags.contains(.enableCRC64CheckUpload))
        XCTAssertFalse(client.options.featureFlags.contains(.enableMD5))

        // CRC64CheckUpload
        config = Configuration.default()
            .withDownloadCRC64Validation(true)
        client = ClientImpl(config)
        XCTAssertTrue(client.options.featureFlags.contains(.correctClockSkew))
        XCTAssertTrue(client.options.featureFlags.contains(.autoDetectMimeType))
        XCTAssertTrue(client.options.featureFlags.contains(.enableCRC64CheckDownload))
        XCTAssertTrue(client.options.featureFlags.contains(.enableCRC64CheckUpload))
        XCTAssertFalse(client.options.featureFlags.contains(.enableMD5))

        config = Configuration.default()
            .withDownloadCRC64Validation(false)
        client = ClientImpl(config)
        XCTAssertTrue(client.options.featureFlags.contains(.correctClockSkew))
        XCTAssertTrue(client.options.featureFlags.contains(.autoDetectMimeType))
        XCTAssertFalse(client.options.featureFlags.contains(.enableCRC64CheckDownload))
        XCTAssertTrue(client.options.featureFlags.contains(.enableCRC64CheckUpload))
        XCTAssertFalse(client.options.featureFlags.contains(.enableMD5))
    }

    func testConfigUserAgent() {
        let config = Configuration.default()
        let client = ClientImpl(config)
        XCTAssertNotNil(client.innerOptions)
        XCTAssertNotNil(client.innerOptions.userAgent)
    }

    func testBuildHostPath() {
        // virtual hosted
        var input = OperationInput()
        var host = input.buildHostPath(
            host: "oss-cn-hangzhou.aliyuncs.com",
            addressStyle: .virtualHosted
        )
        XCTAssertEqual("oss-cn-hangzhou.aliyuncs.com/", host)

        input.bucket = "test-bucket"
        host = input.buildHostPath(
            host: "oss-cn-hangzhou.aliyuncs.com",
            addressStyle: .virtualHosted
        )
        XCTAssertEqual("test-bucket.oss-cn-hangzhou.aliyuncs.com/", host)

        input.bucket = "test-bucket"
        input.key = "special/test-key+123"
        host = input.buildHostPath(
            host: "oss-cn-hangzhou.aliyuncs.com",
            addressStyle: .virtualHosted
        )
        XCTAssertEqual("test-bucket.oss-cn-hangzhou.aliyuncs.com/special/test-key%2B123", host)

        // path style
        input = OperationInput()
        host = input.buildHostPath(
            host: "oss-cn-hangzhou.aliyuncs.com",
            addressStyle: .path
        )
        XCTAssertEqual("oss-cn-hangzhou.aliyuncs.com/", host)

        input.bucket = "test-bucket"
        host = input.buildHostPath(
            host: "oss-cn-hangzhou.aliyuncs.com",
            addressStyle: .path
        )
        XCTAssertEqual("oss-cn-hangzhou.aliyuncs.com/test-bucket/", host)

        input.bucket = "test-bucket"
        input.key = "special/test-key+123"
        host = input.buildHostPath(
            host: "oss-cn-hangzhou.aliyuncs.com",
            addressStyle: .path
        )
        XCTAssertEqual("oss-cn-hangzhou.aliyuncs.com/test-bucket/special/test-key%2B123", host)

        // cname
        input = OperationInput()
        host = input.buildHostPath(
            host: "oss-cn-hangzhou.aliyuncs.com",
            addressStyle: .cname
        )
        XCTAssertEqual("oss-cn-hangzhou.aliyuncs.com/", host)

        input.bucket = "test-bucket"
        host = input.buildHostPath(
            host: "oss-cn-hangzhou.aliyuncs.com",
            addressStyle: .cname
        )
        XCTAssertEqual("oss-cn-hangzhou.aliyuncs.com/", host)

        input.bucket = "test-bucket"
        input.key = "special/test-key+123"
        host = input.buildHostPath(
            host: "oss-cn-hangzhou.aliyuncs.com",
            addressStyle: .cname
        )
        XCTAssertEqual("oss-cn-hangzhou.aliyuncs.com/special/test-key%2B123", host)
    }

    func testQueryString() {
        var input = OperationInput()
        var query = input.queryString()
        XCTAssertEqual("", query)

        input = OperationInput(
            parameters: [
                "key1": "value1+123",
                "key2+": "value2/123",
                "key3": "value3",
                "key4": "",
                "key5": nil,
            ]
        )
        query = input.queryString()
        XCTAssertTrue(query.contains("key1=value1%2B123"))
        XCTAssertTrue(query.contains("key2%2B=value2%2F123"))
        XCTAssertTrue(query.contains("key3=value3"))
        XCTAssertTrue(query.contains("key4="))
        XCTAssertTrue(query.contains("key5="))
    }

    func testPresignV1Success() async throws {
        let endpoint = "oss-cn-beijing.aliyuncs.com"
        var config = Configuration.default()
            .withSignerVersion(.v1)
            .withEndpoint(endpoint)
            .withCredentialsProvider(StaticCredentialsProvider(accessKeyId: "ak",
                                                               accessKeySecret: "sk"))
        var client = ClientImpl(config)

        var input = OperationInput(method: "PUT")
        let expiration = Date().addingTimeInterval(10 * 60)
        input.metadata.set(key: AttributeKeys.expirationTime, value: expiration)
        var result = try await client.presignInner(with: &input)
        XCTAssertEqual(result.method, "PUT")
        XCTAssertTrue(result.url!.contains("OSSAccessKeyId"))
        XCTAssertTrue(result.url!.contains("Signature"))
        XCTAssertTrue(result.url!.contains("Expires"))
        XCTAssertEqual(expiration, result.expiration)

        // default expiration
        input = OperationInput(method: "PUT")
        result = try await client.presignInner(with: &input)
        XCTAssertEqual(result.method, "PUT")
        XCTAssertTrue(result.url!.contains("OSSAccessKeyId"))
        XCTAssertTrue(result.url!.contains("Signature"))
        XCTAssertTrue(result.url!.contains("Expires"))
        XCTAssertLessThanOrEqual(expiration, result.expiration!)

        // CredentialsProvider is null
        config = Configuration.default()
            .withSignerVersion(.v1)
            .withEndpoint(endpoint)
        client = ClientImpl(config)
        input = OperationInput(method: "PUT")
        result = try await client.presignInner(with: &input)
        XCTAssertEqual(result.method, "PUT")
        XCTAssertFalse(result.url!.contains("OSSAccessKeyId"))
        XCTAssertFalse(result.url!.contains("Signature"))
        XCTAssertFalse(result.url!.contains("Expires"))
        XCTAssertNil(result.expiration)

        // CredentialsProvider is AnonymousCredentialsProvider
        config = Configuration.default()
            .withSignerVersion(.v1)
            .withEndpoint(endpoint)
            .withCredentialsProvider(AnonymousCredentialsProvider())
        result = try await client.presignInner(with: &input)
        XCTAssertEqual(result.method, "PUT")
        XCTAssertFalse(result.url!.contains("OSSAccessKeyId"))
        XCTAssertFalse(result.url!.contains("Signature"))
        XCTAssertFalse(result.url!.contains("Expires"))
        XCTAssertNil(result.expiration)
    }

    func testPresignV4Success() async throws {
        let endpoint = "oss-cn-beijing.aliyuncs.com"
        let region = "cn-beijing"
        var config = Configuration.default()
            .withSignerVersion(.v4)
            .withRegion(region)
            .withEndpoint(endpoint)
            .withCredentialsProvider(StaticCredentialsProvider(accessKeyId: "ak", accessKeySecret: "sk"))
        var client = ClientImpl(config)

        var input = OperationInput(method: "PUT")
        let expiration = Date().addingTimeInterval(10 * 60)

        // default expiration
        var result = try await client.presignInner(with: &input)
        XCTAssertEqual(result.method, "PUT")
        XCTAssertTrue(result.url!.contains("x-oss-signature-version"))
        XCTAssertTrue(result.url!.contains("x-oss-expires"))
        XCTAssertTrue(result.url!.contains("x-oss-credential"))
        XCTAssertTrue(result.url!.contains("x-oss-signature"))
        XCTAssertLessThanOrEqual(expiration, result.expiration!)

        // CredentialsProvider is null
        config = Configuration.default()
            .withRegion(region)
            .withEndpoint(endpoint)
        client = ClientImpl(config)
        result = try await client.presignInner(with: &input)
        XCTAssertEqual(result.method, "PUT")
        XCTAssertFalse(result.url!.contains("x-oss-signature-version"))
        XCTAssertFalse(result.url!.contains("x-oss-expires"))
        XCTAssertFalse(result.url!.contains("x-oss-credential"))
        XCTAssertFalse(result.url!.contains("x-oss-signature"))
        XCTAssertNil(result.expiration)

        // CredentialsProvider is AnonymousCredentialsProvider
        config = Configuration.default()
            .withEndpoint(endpoint)
            .withRegion(region)
            .withCredentialsProvider(AnonymousCredentialsProvider())
        client = ClientImpl(config)
        result = try await client.presignInner(with: &input)
        XCTAssertEqual(result.method, "PUT")
        XCTAssertFalse(result.url!.contains("x-oss-signature-version"))
        XCTAssertFalse(result.url!.contains("x-oss-expires"))
        XCTAssertFalse(result.url!.contains("x-oss-credential"))
        XCTAssertFalse(result.url!.contains("x-oss-signature"))
        XCTAssertNil(result.expiration)
    }

    func testPresignFail() async throws {
        let endpoint = "oss-cn-beijing.aliyuncs.com"
        let region = "cn-beijing"

        // Credentials is null
        var config = Configuration.default()
            .withRegion(region)
            .withEndpoint(endpoint)
            .withCredentialsProvider(StaticCredentialsProvider(accessKeyId: "", accessKeySecret: ""))
        var client = ClientImpl(config)
        var input = OperationInput()
        try await assertThrowsAsyncError(await client.presignInner(with: &input)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Credentials is null or empty.", clientError?.message)
        }

        // expiration is error
        config = Configuration.default()
            .withRegion(region)
            .withEndpoint(endpoint)
            .withCredentialsProvider(StaticCredentialsProvider(accessKeyId: "ak", accessKeySecret: "sk"))
        client = ClientImpl(config)
        input = OperationInput()
        input.metadata.set(key: AttributeKeys.expirationTime, value: Date().addingTimeInterval(8 * 24 * 3600))
        try await assertThrowsAsyncError(await client.presignInner(with: &input)) {
            let clientError = $0 as? ClientError
            XCTAssertTrue(clientError!.message.contains("Expires should be not greater than 604800(seven days),"))
        }
    }

    func testVerifyOperation() {
        var input = OperationInput()
        input.bucket = "-bucket"
        XCTAssertThrowsError(try ClientImpl.verifyOperation(input: &input)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Bucket name is invalid, got -bucket.", clientError?.message)
        }

        input.bucket = "bucket-"
        XCTAssertThrowsError(try ClientImpl.verifyOperation(input: &input)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Bucket name is invalid, got bucket-.", clientError?.message)
        }

        input.bucket = "bucKet"
        XCTAssertThrowsError(try ClientImpl.verifyOperation(input: &input)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Bucket name is invalid, got bucKet.", clientError?.message)
        }

        input.bucket = "12"
        XCTAssertThrowsError(try ClientImpl.verifyOperation(input: &input)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Bucket name is invalid, got 12.", clientError?.message)
        }

        input.bucket = "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijkl"
        XCTAssertThrowsError(try ClientImpl.verifyOperation(input: &input)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Bucket name is invalid, got abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijkl.", clientError?.message)
        }

        input.bucket = "bucket-name"
        XCTAssertNoThrow(try ClientImpl.verifyOperation(input: &input))

        input.key = ""
        XCTAssertThrowsError(try ClientImpl.verifyOperation(input: &input)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Object name is invalid, got .", clientError?.message)
        }

        input.key = "key"
        XCTAssertNoThrow(try ClientImpl.verifyOperation(input: &input))
    }
}

class TestRetryer: Retryer {
    func isErrorRetryable(error _: Error) -> Bool {
        false
    }

    func maxAttempts() -> Int {
        1
    }

    func retryDelay(attempt _: Int, error _: Error) -> TimeInterval {
        0
    }
}
