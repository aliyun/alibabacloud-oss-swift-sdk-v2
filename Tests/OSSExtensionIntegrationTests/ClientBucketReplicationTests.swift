import AlibabaCloudOSS
import AlibabaCloudOSSExtension
import XCTest

final class ClientBucketReplicationTests: BaseTestCase {
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

    // MARK: - PutBucketCors
    
    func testPutAndGetBucketReplicationSuccess() async throws {
        let bucket1 = randomBucketName()
        
        let config = Configuration.default()
            .withRegion("cn-beijing")
            .withCredentialsProvider(EnvironmentCredentialsProvider())
        let client = Client(config)
        
        try await createBucket(client: client, bucket: bucket1)

        let rules = [ReplicationRule(id: "id1",
                                     destination: ReplicationDestination(bucket: bucket1, location: "oss-cn-beijing", transferType: "internal"),
                                     historicalObjectReplication: "disabled",
                                     rtc: RTC(status: "Enabled"),
                                     prefixSet: ReplicationPrefixSet(prefixs: ["prefixs1"]),
                                     action: "PUT",
                                     status: "Enabled",
                                     sourceSelectionCriteria: ReplicationSourceSelectionCriteria(sseKmsEncryptedObjects: SseKmsEncryptedObjects(status: "Disabled")))]
        let request = PutBucketReplicationRequest(bucket: bucketName,
                                                  replicationConfiguration: ReplicationConfiguration(rules: rules))
        await assertNoThrow(try await self.client?.putBucketReplication(request))
        
        let result = try await self.client?.getBucketReplication(
            GetBucketReplicationRequest(
                bucket: bucketName
            )
        )
        XCTAssertEqual(result?.replicationConfiguration?.rules?.count, 1)
        
        XCTAssertEqual(result?.replicationConfiguration?.rules?.first?.id, "id1")
        XCTAssertEqual(result?.replicationConfiguration?.rules?.first?.destination?.bucket, bucket1)
        XCTAssertEqual(result?.replicationConfiguration?.rules?.first?.destination?.location, "oss-cn-beijing")
        XCTAssertEqual(result?.replicationConfiguration?.rules?.first?.historicalObjectReplication, "disabled")
        XCTAssertEqual(result?.replicationConfiguration?.rules?.first?.rtc?.status, "enabling")
        XCTAssertEqual(result?.replicationConfiguration?.rules?.first?.prefixSet?.prefixs?.first, "prefixs1")
        XCTAssertEqual(result?.replicationConfiguration?.rules?.first?.action, "PUT")
        XCTAssertEqual(result?.replicationConfiguration?.rules?.first?.status, "starting")

        try await cleanBucket(client: client, bucket: bucket1)
    }
    
    func testPutBucketReplicationFail() async throws {
        var request = PutBucketReplicationRequest()
        try await assertThrowsAsyncError(await client?.putBucketReplication(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }

        request = PutBucketReplicationRequest(bucket: bucketName)
        try await assertThrowsAsyncError(await client?.putBucketReplication(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.replicationConfiguration.")
        }

        request = PutBucketReplicationRequest(bucket: bucketName, replicationConfiguration: ReplicationConfiguration())
        try await assertThrowsAsyncError(await client?.putBucketReplication(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 400)
            XCTAssertEqual(serverError?.code, "MalformedXML")
        }
    }
    
    func testGetBucketReplicationFail() async throws {
        var request = GetBucketReplicationRequest()
        try await assertThrowsAsyncError(await client?.getBucketReplication(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }

        let bucket = randomBucketName()
        request = GetBucketReplicationRequest(bucket: bucket)
        try await assertThrowsAsyncError(await client?.getBucketReplication(request)) { error in
            XCTAssertEqual((error as? ServerError)?.statusCode, 404)
        }
    }

    func testPutBucketRtcSuccess() async throws {
        let bucket1 = randomBucketName()
        
        let config = Configuration.default()
            .withRegion("cn-beijing")
            .withCredentialsProvider(EnvironmentCredentialsProvider())
        let client = Client(config)
        
        try await createBucket(client: client, bucket: bucket1)

        let rules = [ReplicationRule(id: "id1",
                                     destination: ReplicationDestination(bucket: bucket1, location: "oss-cn-beijing", transferType: "internal"),
                                     historicalObjectReplication: "disabled",
                                     rtc: RTC(status: "Enabled"),
                                     prefixSet: ReplicationPrefixSet(prefixs: ["prefixs1"]),
                                     action: "PUT",
                                     status: "Enabled",
                                     sourceSelectionCriteria: ReplicationSourceSelectionCriteria(sseKmsEncryptedObjects: SseKmsEncryptedObjects(status: "Disabled")))]
        let request = PutBucketReplicationRequest(bucket: bucketName,
                                                  replicationConfiguration: ReplicationConfiguration(rules: rules))
        await assertNoThrow(try await self.client?.putBucketReplication(request))
        
        var result = try await self.client?.getBucketReplication(
            GetBucketReplicationRequest(
                bucket: bucketName
            )
        )
        XCTAssertEqual(result?.replicationConfiguration?.rules?.count, 1)
        XCTAssertEqual(result?.replicationConfiguration?.rules?.first?.rtc?.status, "enabling")
        
        await assertNoThrow(try await self.client?.putBucketRtc(PutBucketRtcRequest(
            bucket: bucketName,
            rtcConfiguration: RtcConfiguration(id: "id1", rtc: RTC(status: "Disabled"))))
        )
        
        result = try await self.client?.getBucketReplication(
            GetBucketReplicationRequest(
                bucket: bucketName
            )
        )
        XCTAssertNil(result?.replicationConfiguration?.rules?.first?.rtc?.status)

        try await cleanBucket(client: client, bucket: bucket1)
    }
    
    func testPutBucketRtcFail() async throws {
        var request = PutBucketRtcRequest()
        try await assertThrowsAsyncError(await client?.putBucketRtc(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }

        request = PutBucketRtcRequest(bucket: bucketName)
        try await assertThrowsAsyncError(await client?.putBucketRtc(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.rtcConfiguration.")
        }

        request = PutBucketRtcRequest(bucket: bucketName, rtcConfiguration: RtcConfiguration())
        try await assertThrowsAsyncError(await client?.putBucketRtc(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 400)
            XCTAssertEqual(serverError?.code, "MalformedXML")
        }
    }
    
    func testGetBucketReplicationLocationSuccess() async throws {
        let result = try await client?.getBucketReplicationLocation(
            GetBucketReplicationLocationRequest(bucket: bucketName)
        )
        XCTAssertGreaterThan(result!.replicationLocation!.locations!.count, 0)
        XCTAssertNotNil(result?.replicationLocation?.locationRTCConstraint?.locations)
        XCTAssertNotNil(result?.replicationLocation?.locationTransferTypeConstraint?.locationTransferTypes)
    }
    
    func testGetBucketReplicationLocationFail() async throws {
        var request = GetBucketReplicationLocationRequest()
        try await assertThrowsAsyncError(await client?.getBucketReplicationLocation(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }

        let bucket = randomBucketName()
        request = GetBucketReplicationLocationRequest(bucket: bucket)
        try await assertThrowsAsyncError(await client?.getBucketReplicationLocation(request)) { error in
            XCTAssertEqual((error as? ServerError)?.statusCode, 404)
        }
    }
    
    func testGetBucketReplicationProgressSuccess() async throws {
        let bucket1 = randomBucketName()
        
        let config = Configuration.default()
            .withRegion("cn-beijing")
            .withCredentialsProvider(EnvironmentCredentialsProvider())
        let client = Client(config)
        
        try await createBucket(client: client, bucket: bucket1)

        let rules = [ReplicationRule(id: "id1",
                                     destination: ReplicationDestination(bucket: bucket1, location: "oss-cn-beijing", transferType: "internal"),
                                     historicalObjectReplication: "disabled",
                                     rtc: RTC(status: "Enabled"),
                                     prefixSet: ReplicationPrefixSet(prefixs: ["prefixs1"]),
                                     action: "PUT",
                                     status: "Enabled",
                                     sourceSelectionCriteria: ReplicationSourceSelectionCriteria(sseKmsEncryptedObjects: SseKmsEncryptedObjects(status: "Disabled")))]
        let request = PutBucketReplicationRequest(bucket: bucketName,
                                                  replicationConfiguration: ReplicationConfiguration(rules: rules))
        await assertNoThrow(try await self.client?.putBucketReplication(request))
        
        let result = try await self.client?.getBucketReplicationProgress(
            GetBucketReplicationProgressRequest(bucket: bucketName,
                                                ruleId: "id1")
        )
        XCTAssertEqual(result?.replicationProgress?.rules?.count, 1)
        XCTAssertEqual(result?.replicationProgress?.rules?.first?.id, "id1")
        XCTAssertEqual(result?.replicationProgress?.rules?.first?.destination?.bucket, bucket1)
        XCTAssertEqual(result?.replicationProgress?.rules?.first?.destination?.location, "oss-cn-beijing")
        XCTAssertEqual(result?.replicationProgress?.rules?.first?.historicalObjectReplication, "disabled")
        XCTAssertEqual(result?.replicationProgress?.rules?.first?.prefixSet?.prefixs?.first, "prefixs1")
        XCTAssertEqual(result?.replicationProgress?.rules?.first?.action, "PUT")
        XCTAssertEqual(result?.replicationProgress?.rules?.first?.status, "starting")

        try await cleanBucket(client: client, bucket: bucket1)
    }
    
    func testGetBucketReplicationProgressFail() async throws {
        var request = GetBucketReplicationProgressRequest()
        try await assertThrowsAsyncError(await client?.getBucketReplicationProgress(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = GetBucketReplicationProgressRequest(bucket: bucketName)
        try await assertThrowsAsyncError(await client?.getBucketReplicationProgress(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.ruleId.")
        }

        request = GetBucketReplicationProgressRequest(bucket: bucketName, ruleId: "rule")
        try await assertThrowsAsyncError(await client?.getBucketReplicationProgress(request)) { error in
            XCTAssertEqual((error as? ServerError)?.statusCode, 404)
        }
    }
    
    func testDeleteBucketReplicationSuccess() async throws {
        let bucket1 = randomBucketName()
        
        let config = Configuration.default()
            .withRegion("cn-beijing")
            .withCredentialsProvider(EnvironmentCredentialsProvider())
        let client = Client(config)
        
        try await createBucket(client: client, bucket: bucket1)

        let rules = [ReplicationRule(id: "id1",
                                     destination: ReplicationDestination(bucket: bucket1, location: "oss-cn-beijing", transferType: "internal"),
                                     historicalObjectReplication: "disabled",
                                     rtc: RTC(status: "Enabled"),
                                     prefixSet: ReplicationPrefixSet(prefixs: ["prefixs1"]),
                                     action: "PUT",
                                     status: "Enabled",
                                     sourceSelectionCriteria: ReplicationSourceSelectionCriteria(sseKmsEncryptedObjects: SseKmsEncryptedObjects(status: "Disabled")))]
        let request = PutBucketReplicationRequest(bucket: bucketName,
                                                  replicationConfiguration: ReplicationConfiguration(rules: rules))
        await assertNoThrow(try await self.client?.putBucketReplication(request))
        
        var result = try await self.client?.getBucketReplication(
            GetBucketReplicationRequest(
                bucket: bucketName
            )
        )
        XCTAssertEqual(result?.replicationConfiguration?.rules?.count, 1)
        
        await assertNoThrow(try await self.client?.deleteBucketReplication(
            DeleteBucketReplicationRequest(
                bucket: bucketName,
                replicationRules: ReplicationRules(id: "id1")
            )
        ))
        
        result = try await self.client?.getBucketReplication(
            GetBucketReplicationRequest(
                bucket: bucketName
            )
        )
        XCTAssertEqual(result?.replicationConfiguration?.rules?.count, 1)
        XCTAssertEqual(result?.replicationConfiguration?.rules?.first?.status, "closing")

        try await cleanBucket(client: client, bucket: bucket1)
    }
    
    func testDeleteBucketReplicationFail() async throws {
        var request = DeleteBucketReplicationRequest()
        try await assertThrowsAsyncError(await client?.deleteBucketReplication(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = DeleteBucketReplicationRequest(bucket: bucketName)
        try await assertThrowsAsyncError(await client?.deleteBucketReplication(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.replicationRules.")
        }

        request = DeleteBucketReplicationRequest(bucket: bucketName, replicationRules: ReplicationRules(id: ""))
        try await assertThrowsAsyncError(await client?.deleteBucketReplication(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 400)
            XCTAssertEqual(serverError?.code, "MalformedXML")
        }
    }
}
