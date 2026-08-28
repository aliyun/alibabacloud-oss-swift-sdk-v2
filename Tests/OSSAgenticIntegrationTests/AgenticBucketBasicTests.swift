import AlibabaCloudOSS
import AlibabaCloudOSSAgentic
import XCTest

/// One agentic bucket per test method, exercising Create (in setUp) plus Get, List, the
/// paginator, PutStatus(Enabled) and ListBucketSpaces. The Disable + Delete lifecycle is
/// asserted in `AgenticBucketLifecycleTests` on its own bucket.
final class AgenticBucketBasicTests: AgenticBaseTestCase {
    override func setUp() async throws {
        try await super.setUp()
        try skipIfAgenticNotConfigured()
        try await createTestAgenticBucket(
            CreateAgenticBucketConfiguration(
                storageClass: "Standard",
                dataRedundancyType: "LRS"
            )
        )
    }

    // MARK: - Get / List / PutStatus / ListBucketSpaces

    func testAgenticBucketBasic() async throws {
        let client = getAgenticClient()
        let bucket = try XCTUnwrap(agenticBucket)

        // Get, verifying the fields the service fills in.
        let getResult = try await client.getAgenticBucket(GetAgenticBucketRequest(bucket: bucket))
        XCTAssertEqual(getResult.statusCode, 200)
        let info = try XCTUnwrap(getResult.agenticBucketInfo)
        XCTAssertTrue(info.name?.contains(bucket) ?? false, info.name ?? "nil")
        XCTAssertEqual(info.region, region)
        XCTAssertEqual(info.storageClass, "Standard")
        XCTAssertEqual(info.dataRedundancyType, "LRS")
        XCTAssertNotNil(info.status)
        XCTAssertNotNil(info.createTime)

        // List
        let listResult = try await client.listAgenticBuckets(ListAgenticBucketsRequest())
        XCTAssertEqual(listResult.statusCode, 200)

        // List through the paginator, one bucket per page.
        var pages = 0
        for try await page in client.listAgenticBucketsPaginator(ListAgenticBucketsRequest(maxKeys: 1)) {
            XCTAssertEqual(page.statusCode, 200)
            pages += 1
            if pages >= 5 {
                break
            }
        }
        XCTAssertGreaterThanOrEqual(pages, 1)

        // PutStatus
        let statusResult = try await client.putAgenticBucketStatus(
            PutAgenticBucketStatusRequest(bucket: bucket, status: "Enabled")
        )
        XCTAssertEqual(statusResult.statusCode, 200)

        // ListBucketSpaces: the bucket has no space yet, a valid response is enough.
        let spacesResult = try await client.listBucketSpaces(ListBucketSpacesRequest(bucket: bucket))
        XCTAssertEqual(spacesResult.statusCode, 200)
    }

    // MARK: - Eventually consistent listing

    /// A newly created bucket takes a while to show up in ListAgenticBuckets, so poll with
    /// a generous budget. The bucket's existence is asserted strongly by Get above, so if
    /// the listing still lags we skip rather than fail: a consistency delay is not a
    /// defect. This lives in its own test method so the skip cannot mask the assertions of
    /// `testAgenticBucketBasic`.
    func testFindCreatedAgenticBucketInListing() async throws {
        let client = getAgenticClient()
        let bucket = try XCTUnwrap(agenticBucket)

        var found = false
        for attempt in 0 ..< 12 {
            if attempt > 0 {
                try await Task.sleep(nanoseconds: 10 * 1_000_000_000)
            }
            for try await page in client.listAgenticBucketsPaginator(ListAgenticBucketsRequest()) {
                for summary in page.agenticBuckets ?? [] where summary.name?.contains(bucket) ?? false {
                    found = true
                }
            }
            if found {
                break
            }
        }

        if !found {
            throw XCTSkip("created agentic bucket has not appeared in the listing yet (eventual consistency)")
        }
    }
}

/// Negative paths that need no fixture. They live in their own class so they do not create
/// an agentic bucket, which could not be deleted for ~24h.
final class AgenticBucketBasicNegativeTests: AgenticBaseTestCase {
    override func setUp() async throws {
        try await super.setUp()
        try skipIfAgenticNotConfigured()
    }

    // MARK: - Required-field errors

    func testRequiredFieldErrors() async throws {
        let client = getAgenticClient()

        try await assertThrowsAsyncError(await client.createAgenticBucket(CreateAgenticBucketRequest())) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Missing required field, request.bucket.", clientError?.message)
        }

        try await assertThrowsAsyncError(await client.getAgenticBucket(GetAgenticBucketRequest())) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Missing required field, request.bucket.", clientError?.message)
        }

        try await assertThrowsAsyncError(await client.deleteAgenticBucket(DeleteAgenticBucketRequest())) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Missing required field, request.bucket.", clientError?.message)
        }

        try await assertThrowsAsyncError(await client.listBucketSpaces(ListBucketSpacesRequest())) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Missing required field, request.bucket.", clientError?.message)
        }

        try await assertThrowsAsyncError(await client.putAgenticBucketStatus(PutAgenticBucketStatusRequest())) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Missing required field, request.bucket.", clientError?.message)
        }
    }

    // MARK: - Not-exist errors

    func testGetNotExist() async throws {
        let client = getAgenticClient()
        let bucket = randomAgenticBucketName()

        try await assertThrowsAsyncError(await client.getAgenticBucket(GetAgenticBucketRequest(bucket: bucket))) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
            XCTAssertEqual(serverError?.code, "NoSuchAgenticBucket")
            XCTAssertFalse(serverError?.ec.isEmpty ?? true)
            XCTAssertFalse(serverError?.requestId.isEmpty ?? true)
        }
    }
}
