import AlibabaCloudOSS
import AlibabaCloudOSSAgentic
import XCTest

/// The two-phase deletion, on its own bucket so that disabling it cannot disturb the other
/// scenarios: PutAgenticBucketStatus(Disabled) succeeds, but the bucket is not yet ready to
/// be deleted (409 / AgenticBucketNotReady). Readiness takes ~24h, so no create -> delete
/// round trip can be asserted end to end here.
final class AgenticBucketLifecycleTests: AgenticBaseTestCase {
    override func setUp() async throws {
        try await super.setUp()
        try skipIfAgenticNotConfigured()
        try await createTestAgenticBucket()
    }

    func testDisableThenDelete() async throws {
        let client = getAgenticClient()
        let bucket = try XCTUnwrap(agenticBucket)

        let statusResult = try await client.putAgenticBucketStatus(
            PutAgenticBucketStatusRequest(bucket: bucket, status: "Disabled")
        )
        XCTAssertEqual(statusResult.statusCode, 200)

        try await assertThrowsAsyncError(await client.deleteAgenticBucket(DeleteAgenticBucketRequest(bucket: bucket))) {
            let serverError = $0 as? ServerError
            XCTAssertNotNil(serverError, "expected a ServerError, got \($0)")
            XCTAssertTrue(
                serverError?.statusCode == 409 || serverError?.code == "AgenticBucketNotReady",
                "expected AgenticBucketNotReady/409, got code=\(serverError?.code ?? "nil") status=\(serverError?.statusCode ?? 0)"
            )
        }
    }
}
