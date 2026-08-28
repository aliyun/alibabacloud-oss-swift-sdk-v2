import AlibabaCloudOSS
import AlibabaCloudOSSAgentic
import XCTest

/// ListBucketSpaces, the bucket and object interfaces through the bucket space client, and
/// the `BucketSpaceHelper` name builder driving a plain `Client`, over one shared bucket
/// space. Creating the space requires the parent agentic bucket's full name.
final class AgenticBucketSpaceTests: AgenticBaseTestCase {
    override func setUp() async throws {
        try await super.setUp()
        try skipIfAgenticNotConfigured()

        let bucket = try await createTestAgenticBucket()
        try await createTestBucketSpace(getBucketSpaceClient(), bucket)
    }

    override func tearDown() async throws {
        if let bucket = agenticBucket {
            await deleteTestBucketSpace(getBucketSpaceClient(), bucket)
        }
        // Disables this run's bucket and runs the reaper.
        try await super.tearDown()
    }

    func testBucketSpace() async throws {
        let client = getAgenticClient()
        let bsClient = getBucketSpaceClient()
        let bucket = try XCTUnwrap(agenticBucket)

        // ListBucketSpaces
        let listResult = try await client.listBucketSpaces(ListBucketSpacesRequest(bucket: bucket))
        XCTAssertEqual(listResult.statusCode, 200)

        // Bucket interfaces through the bucket space client.
        let putAclResult = try await bsClient.putBucketAcl(PutBucketAclRequest(bucket: bucket, acl: "private"))
        XCTAssertEqual(putAclResult.statusCode, 200)

        let getAclResult = try await bsClient.getBucketAcl(GetBucketAclRequest(bucket: bucket))
        XCTAssertEqual(getAclResult.statusCode, 200)
        XCTAssertEqual("private", getAclResult.accessControlPolicy?.accessControlList?.grant)

        // Object interfaces through the bucket space client.
        let key = randomObjectName()
        let content = "hello agentic".data(using: .utf8)!

        let putResult = try await bsClient.putObject(
            PutObjectRequest(bucket: bucket, key: key, body: .data(content))
        )
        XCTAssertEqual(putResult.statusCode, 200)

        let getResult = try await bsClient.getObject(GetObjectRequest(bucket: bucket, key: key))
        XCTAssertEqual(getResult.statusCode, 200)
        XCTAssertEqual(content, try getResult.body?.readData())

        let deleteResult = try await bsClient.deleteObject(DeleteObjectRequest(bucket: bucket, key: key))
        XCTAssertTrue(deleteResult.statusCode == 200 || deleteResult.statusCode == 204)
    }

    /// Drives the same space through a plain `Client` using a helper-built full name.
    func testBucketSpaceHelper() async throws {
        let config = agenticConfig()
        let bucket = try XCTUnwrap(agenticBucket)

        let helper = BucketSpaceHelper(config: config)
        let fullName = helper.toBucketName(bucket)
        XCTAssertEqual(buildFullName(bucket, "bs-apsr"), fullName)

        let plainClient = Client(config)

        let getInfoResult = try await plainClient.getBucketInfo(GetBucketInfoRequest(bucket: fullName))
        XCTAssertEqual(getInfoResult.statusCode, 200)

        let key = randomObjectName()
        let content = "hello helper".data(using: .utf8)!

        let putResult = try await plainClient.putObject(
            PutObjectRequest(bucket: fullName, key: key, body: .data(content))
        )
        XCTAssertEqual(putResult.statusCode, 200)

        let getResult = try await plainClient.getObject(GetObjectRequest(bucket: fullName, key: key))
        XCTAssertEqual(getResult.statusCode, 200)
        XCTAssertEqual(content, try getResult.body?.readData())

        try await assertNoThrow(await plainClient.deleteObject(DeleteObjectRequest(bucket: fullName, key: key)))
    }
}
