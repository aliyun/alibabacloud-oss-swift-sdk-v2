import AlibabaCloudOSS
import AlibabaCloudOSSAgentic
import XCTest

/// Shared support for the agentic integration tests: client factories, name builders and
/// the prefix-based reaper that bounds the backlog left by the two-phase
/// (Disable -> wait ~24h -> Delete) agentic bucket lifecycle.
///
/// This is a `BaseTestCase` subclass rather than a free-standing helper type so the
/// scenarios keep the house XCTest style and reuse the environment-driven configuration
/// (`endpoint`, `region`, `accessKeyId`, `accessKeySecret`, `userId`) and the helpers
/// (`randomStr`, `randomObjectName`) that `BaseTestCase` already provides.
///
/// XCTest builds a fresh instance for every test method, so a fixture created in `setUp`
/// is per test method, not per class. Because a created agentic bucket cannot be deleted
/// for ~24h, each scenario deliberately keeps a single test method that walks through its
/// steps - the shape go expresses with `t.Run` subtests - instead of one method per
/// assertion, and negative paths that need no bucket live in their own fixture-less class.
class AgenticBaseTestCase: BaseTestCase {
    /// The agentic bucket name prefix. The "ab" marker is what the reaper filters on, and
    /// the prefix is kept short so the physical name
    /// `{bucket}-{accountId}-{region}-ab-apsr` stays within the 63-character DNS label limit.
    let agenticBucketNamePrefix = "agt-sdk-ab-"

    /// The agentic bucket created by the current test, disabled and reaped in `tearDown`.
    private(set) var agenticBucket: String?

    // MARK: - Configuration

    /// The agentic operations resolve `{bucket}-{accountId}-{region}-...` client side, so
    /// both the account id and the region must be configured.
    var agenticConfigured: Bool {
        return !endpoint.isEmpty && !region.isEmpty && !userId.isEmpty
    }

    func skipIfAgenticNotConfigured() throws {
        if !agenticConfigured {
            throw XCTSkip("agentic integration tests require OSS_TEST_ENDPOINT, OSS_TEST_REGION and OSS_TEST_USER_ID")
        }
    }

    func agenticConfig(
        accessKeyId: String? = nil,
        accessKeySecret: String? = nil,
        usePathStyle: Bool = false
    ) -> Configuration {
        let credentialsProvider = StaticCredentialsProvider(
            accessKeyId: accessKeyId ?? self.accessKeyId,
            accessKeySecret: accessKeySecret ?? self.accessKeySecret
        )
        let config = Configuration.default()
        config.withCredentialsProvider(credentialsProvider)
        config.withEndpoint(endpoint)
        config.withRegion(region)
        config.withAccountId(userId)
        if usePathStyle {
            config.withUsePathStyle(true)
        }
        return config
    }

    // MARK: - Clients

    func getAgenticClient() -> AgenticBucketClient {
        return AgenticBucketClient(agenticConfig())
    }

    func getInvalidAkAgenticClient() -> AgenticBucketClient {
        return AgenticBucketClient(agenticConfig(accessKeyId: "invalid-ak", accessKeySecret: "invalid-sk"))
    }

    func getBucketSpaceClient() -> Client {
        return BucketSpaceClient.make(agenticConfig())
    }

    /// Path-style variants: the resolved full name goes into the request path instead of
    /// the leftmost host label. Used by the misc path-style scenario.
    func getAgenticClientPathStyle() -> AgenticBucketClient {
        return AgenticBucketClient(agenticConfig(usePathStyle: true))
    }

    func getBucketSpaceClientPathStyle() -> Client {
        return BucketSpaceClient.make(agenticConfig(usePathStyle: true))
    }

    // MARK: - Names

    func randomAgenticBucketName() -> String {
        return "\(agenticBucketNamePrefix)\(randomStr(6))"
    }

    /// Resolves a short name to the server-side full name
    /// `{bucket}-{accountId}-{region}-{suffix}` (suffix "ab-apsr" or "bs-apsr").
    func buildFullName(_ bucket: String, _ suffix: String) -> String {
        return "\(bucket)-\(userId)-\(region)-\(suffix)"
    }

    /// Strips the resolved tail so a listed physical name can be passed back to a client
    /// that re-expands short names.
    func toShortName(_ name: String, _ suffix: String) -> String {
        let tail = "-\(userId)-\(region)-\(suffix)"
        return name.hasSuffix(tail) ? String(name.dropLast(tail.count)) : name
    }

    // MARK: - Fixtures

    /// Creates the agentic bucket used by the current test and records it for teardown.
    @discardableResult
    func createTestAgenticBucket(
        _ configuration: CreateAgenticBucketConfiguration? = nil
    ) async throws -> String {
        let bucket = randomAgenticBucketName()
        let result = try await getAgenticClient().createAgenticBucket(
            CreateAgenticBucketRequest(
                bucket: bucket,
                createAgenticBucketConfiguration: configuration
            )
        )
        XCTAssertEqual(result.statusCode, 200)
        agenticBucket = bucket
        return bucket
    }

    /// Creates one bucket space in the given agentic bucket. The parent agentic bucket's
    /// full name is mandatory here: the short name alone is not accepted by the service.
    func createTestBucketSpace(_ bsClient: Client, _ bucket: String) async throws {
        let result = try await bsClient.putBucket(
            PutBucketRequest(
                bucket: bucket,
                agenticBucket: buildFullName(bucket, "ab-apsr")
            )
        )
        XCTAssertEqual(result.statusCode, 200)
    }

    /// Best-effort removal of a bucket space, for teardown. A non-empty bucket space
    /// cannot be deleted, so its objects go first.
    func deleteTestBucketSpace(_ bsClient: Client, _ bucket: String) async {
        await deleteBucketSpaceObjects(bsClient, bucket)
        _ = try? await bsClient.deleteBucket(DeleteBucketRequest(bucket: bucket))
    }

    // MARK: - Teardown

    override func tearDown() async throws {
        if let bucket = agenticBucket {
            agenticBucket = nil
            await disableAndReap(bucket)
        }
        try await super.tearDown()
    }

    /// The shared scenario teardown: disable this run's bucket - otherwise it stays
    /// Enabled and can never be reclaimed - then reap buckets left disabled by previous
    /// runs whose 24h has elapsed.
    func disableAndReap(_ bucket: String) async {
        let client = getAgenticClient()
        _ = try? await client.putAgenticBucketStatus(
            PutAgenticBucketStatusRequest(bucket: bucket, status: "Disabled")
        )
        await reapDisabledAgenticBuckets()
    }

    /// Deletes leftover buckets from previous runs that carry our prefix and are already
    /// Disabled (Enabled ones may belong to a concurrent run), emptying their bucket
    /// spaces first. Best-effort: every error is swallowed so teardown never fails.
    func reapDisabledAgenticBuckets() async {
        let client = getAgenticClient()

        var buckets: [String] = []
        do {
            for try await page in client.listAgenticBucketsPaginator(ListAgenticBucketsRequest()) {
                for summary in page.agenticBuckets ?? [] {
                    guard let name = summary.name, name.hasPrefix(agenticBucketNamePrefix) else {
                        continue
                    }
                    buckets.append(toShortName(name, "ab-apsr"))
                }
            }
        } catch {
            // Reaping is opportunistic; a listing failure just leaves the backlog.
        }

        for bucket in buckets {
            // The list summary carries no status, so fetch it; only reclaim Disabled ones.
            guard let info = try? await client.getAgenticBucket(
                GetAgenticBucketRequest(bucket: bucket)
            ).agenticBucketInfo,
                info.status == "Disabled"
            else {
                continue
            }
            await reapBucketSpaces(bucket)
            // Succeeds once the bucket is ready, 409 AgenticBucketNotReady until then.
            _ = try? await client.deleteAgenticBucket(DeleteAgenticBucketRequest(bucket: bucket))
        }
    }

    /// Empties and deletes every bucket space of a Disabled agentic bucket, so the bucket
    /// itself becomes deletable. Best-effort: every error is swallowed.
    func reapBucketSpaces(_ bucket: String) async {
        let client = getAgenticClient()
        let bsClient = getBucketSpaceClient()

        var spaces: [String] = []
        do {
            for try await page in client.listBucketSpacesPaginator(ListBucketSpacesRequest(bucket: bucket)) {
                for space in page.bucketSpaces ?? [] {
                    guard let name = space.name else {
                        continue
                    }
                    spaces.append(toShortName(name, "bs-apsr"))
                }
            }
        } catch {
            // Best effort.
        }

        for space in spaces {
            await deleteTestBucketSpace(bsClient, space)
        }
    }

    private func deleteBucketSpaceObjects(_ bsClient: Client, _ space: String) async {
        var keys: [String] = []
        do {
            for try await page in bsClient.listObjectsV2Paginator(ListObjectsV2Request(bucket: space)) {
                for content in page.contents ?? [] {
                    guard let key = content.key else {
                        continue
                    }
                    keys.append(key)
                }
            }
        } catch {
            // Best effort.
        }
        for key in keys {
            _ = try? await bsClient.deleteObject(DeleteObjectRequest(bucket: space, key: key))
        }
    }

    // MARK: - Path-style capability

    /// Reports whether the error is the server signalling that path-style (second level
    /// domain) addressing is not allowed on this endpoint.
    func isSecondLevelDomainForbidden(_ error: Error) -> Bool {
        return (error as? ServerError)?.code == "SecondLevelDomainForbidden"
    }

    /// Turns a path-style rejection into a skip: it is an endpoint capability, not an SDK
    /// defect. Other errors are rethrown so the test still fails on them.
    func skipIfSecondLevelDomainForbidden(_ error: Error, _ scope: String) throws {
        if isSecondLevelDomainForbidden(error) {
            throw XCTSkip("path-style addressing is not allowed for \(scope) (SecondLevelDomainForbidden)")
        }
    }
}
