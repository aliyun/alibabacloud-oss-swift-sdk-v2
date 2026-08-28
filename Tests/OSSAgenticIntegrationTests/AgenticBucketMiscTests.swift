import AlibabaCloudOSS
import AlibabaCloudOSSAgentic
import XCTest

/// Miscellaneous agentic scenarios that do not belong to the Basic, Lifecycle or Space
/// suites. Add future one-offs here.
///
/// Path-style addressing across both the agentic bucket client and the bucket space client.
/// Path-style may be disabled on the endpoint; each probe detects SecondLevelDomainForbidden
/// and skips rather than fails, since that is an endpoint capability and not an SDK defect.
final class AgenticBucketMiscTests: AgenticBaseTestCase {
    override func setUp() async throws {
        try await super.setUp()
        try skipIfAgenticNotConfigured()
        // Create the bucket with the default (virtual-hosted) client so the fixture stands
        // regardless of whether path-style turns out to be allowed.
        try await createTestAgenticBucket()
    }

    override func tearDown() async throws {
        if let bucket = agenticBucket {
            await deleteTestBucketSpace(getBucketSpaceClient(), bucket)
        }
        // Disables this run's bucket and runs the reaper.
        try await super.tearDown()
    }

    func testPathStyle() async throws {
        let bucket = try XCTUnwrap(agenticBucket)
        let psClient = getAgenticClientPathStyle()

        // Probe: a path-style GET carrying the bucket. ListAgenticBuckets is service level
        // (no bucket label) so its URL is identical in both styles and cannot probe
        // path-style; GetAgenticBucket carries the bucket and does.
        do {
            let getResult = try await psClient.getAgenticBucket(GetAgenticBucketRequest(bucket: bucket))
            XCTAssertEqual(getResult.statusCode, 200)
            XCTAssertNotNil(getResult.agenticBucketInfo)
        } catch {
            try skipIfSecondLevelDomainForbidden(error, "this endpoint")
            throw error
        }

        // Agentic bucket client over path-style.
        let listResult = try await psClient.listBucketSpaces(ListBucketSpacesRequest(bucket: bucket))
        XCTAssertEqual(listResult.statusCode, 200)

        // Create one bucket space with the default client, shared by the checks below.
        try await createTestBucketSpace(getBucketSpaceClient(), bucket)

        // Bucket space client over path-style. Path-style may be forbidden on the bucket
        // space endpoint independently of the agentic bucket endpoint (different domain),
        // so guard the first bucket space call separately.
        let psBsClient = getBucketSpaceClientPathStyle()
        let key = randomObjectName()
        let content = "hello path-style".data(using: .utf8)!

        do {
            let putResult = try await psBsClient.putObject(
                PutObjectRequest(bucket: bucket, key: key, body: .data(content))
            )
            XCTAssertEqual(putResult.statusCode, 200)
        } catch {
            try skipIfSecondLevelDomainForbidden(error, "the bucket space endpoint")
            throw error
        }

        let getResult = try await psBsClient.getObject(GetObjectRequest(bucket: bucket, key: key))
        XCTAssertEqual(getResult.statusCode, 200)
        XCTAssertEqual(content, try getResult.body?.readData())

        try await assertNoThrow(await psBsClient.deleteObject(DeleteObjectRequest(bucket: bucket, key: key)))

        let getAclResult = try await psBsClient.getBucketAcl(GetBucketAclRequest(bucket: bucket))
        XCTAssertEqual(getAclResult.statusCode, 200)
    }
}
