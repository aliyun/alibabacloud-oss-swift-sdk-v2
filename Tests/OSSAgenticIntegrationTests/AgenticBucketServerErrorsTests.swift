import AlibabaCloudOSS
import AlibabaCloudOSSAgentic
import XCTest

/// Error propagation with invalid credentials. No fixture is created: every request is
/// expected to be rejected. Create and List are answered with 403 InvalidAccessKeyId, while
/// Get is answered with 404 NoSuchAgenticBucket because the service resolves bucket existence
/// before it validates the AK. The ec values are only checked for presence, they are
/// server-internal diagnostics and not part of the contract.
final class AgenticBucketServerErrorsTests: AgenticBaseTestCase {
    override func setUp() async throws {
        try await super.setUp()
        try skipIfAgenticNotConfigured()
    }

    func testInvalidCredentials() async throws {
        let client = getInvalidAkAgenticClient()
        let bucket = randomAgenticBucketName()

        try await assertThrowsAsyncError(await client.createAgenticBucket(CreateAgenticBucketRequest(bucket: bucket))) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 403)
            XCTAssertEqual(serverError?.code, "InvalidAccessKeyId")
            XCTAssertFalse(serverError?.ec.isEmpty ?? true)
            XCTAssertFalse(serverError?.requestId.isEmpty ?? true)
        }

        try await assertThrowsAsyncError(await client.getAgenticBucket(GetAgenticBucketRequest(bucket: bucket))) {
            let serverError = $0 as? ServerError
            XCTAssertNotNil(serverError, "expected a ServerError, got \($0)")
            XCTAssertEqual(serverError?.statusCode, 404)
            XCTAssertEqual(serverError?.code, "NoSuchAgenticBucket")
            XCTAssertFalse(serverError?.ec.isEmpty ?? true)
            XCTAssertFalse(serverError?.requestId.isEmpty ?? true)
        }

        try await assertThrowsAsyncError(await client.listAgenticBuckets(ListAgenticBucketsRequest())) {
            let serverError = $0 as? ServerError
            XCTAssertNotNil(serverError, "expected a ServerError, got \($0)")
            XCTAssertEqual(serverError?.statusCode, 403)
            XCTAssertEqual(serverError?.code, "InvalidAccessKeyId")
            XCTAssertFalse(serverError?.ec.isEmpty ?? true)
            XCTAssertFalse(serverError?.requestId.isEmpty ?? true)
        }
    }
}
