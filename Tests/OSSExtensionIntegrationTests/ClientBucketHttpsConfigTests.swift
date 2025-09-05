import AlibabaCloudOSS
import AlibabaCloudOSSExtension
import XCTest

final class ClientBucketHttpsConfigTests: BaseTestCase {
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
        
    func testPutAndGetBucketHttpsConfigSuccess() async throws {
        // PutBucketHttpsConfig
        try await assertNoThrow(await client?.putBucketHttpsConfig(PutBucketHttpsConfigRequest(
            bucket: bucketName,
            httpsConfiguration: HttpsConfiguration(
                tls: TLS(
                    enable: true,
                    tlsVersions: ["TLSv1.2", "TLSv1.3"]
                )
            )
        )))
        
        // GetBucketHttpsConfig
        let result = try await client?.getBucketHttpsConfig(
            GetBucketHttpsConfigRequest(bucket: bucketName)
        )
        XCTAssertEqual(result?.httpsConfiguration?.tls?.enable, true)
        XCTAssertEqual(result?.httpsConfiguration?.tls?.tlsVersions, ["TLSv1.2", "TLSv1.3"])
    }
    
    func testPutBucketHttpsConfigFail() async throws {
        var request = PutBucketHttpsConfigRequest()
        try await assertThrowsAsyncError(await client?.putBucketHttpsConfig(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = PutBucketHttpsConfigRequest(bucket: bucketName)
        try await assertThrowsAsyncError(await client?.putBucketHttpsConfig(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.httpsConfiguration.")
        }
        
        request = PutBucketHttpsConfigRequest(
            bucket: bucketName,
            httpsConfiguration: HttpsConfiguration(
                tls: TLS(
                    enable: false,
                    tlsVersions: ["1"]
                )
            )
        )
        try await assertThrowsAsyncError(await client?.putBucketHttpsConfig(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 400)
            XCTAssertEqual(serverError?.code, "MalformedXML")
        }
    }
    
    func testGetBucketHttpsConfigFail() async throws {
        var request = GetBucketHttpsConfigRequest()
        try await assertThrowsAsyncError(await client?.getBucketHttpsConfig(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = GetBucketHttpsConfigRequest(bucket: randomBucketName())
        try await assertThrowsAsyncError(await client?.getBucketHttpsConfig(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
}
