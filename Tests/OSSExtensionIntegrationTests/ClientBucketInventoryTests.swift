import AlibabaCloudOSS
import AlibabaCloudOSSExtension
import XCTest

final class ClientBucketInventoryTests: BaseTestCase {
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

    func testPutAndGetBucketInventorySuccess() async throws {
        let bucket = randomBucketName()
        try await createBucket(client: client!, bucket: bucket)
        
        await assertNoThrow(try await client?.putBucketInventory(PutBucketInventoryRequest(
            bucket: bucketName,
            inventoryId: "report1",
            inventoryConfiguration: InventoryConfiguration(
                id: "report1",
                isEnabled: true,
                destination: InventoryDestination(
                    ossBucketDestination: InventoryOSSBucketDestination(
                        bucket: "acs:oss:::\(bucket)",
                        prefix: "prefix1",
                        format: "CSV",
                        accountId: userId,
                        roleArn: ramRoleArn
                    )
                ),
                schedule: InventorySchedule(frequency: "Daily"),
                filter: InventoryFilter(
                    prefix: "filterPrefix/",
                    lastModifyBeginTimeStamp: 1637883649,
                    lastModifyEndTimeStamp: 1638347592,
                    lowerSizeBound: 1024,
                    upperSizeBound: 1048576,
                    storageClass: "Standard,IA"
                ),
                includedObjectVersions: "All",
                optionalFields: OptionalFields(fields: [.size, .lastModifiedDate, .eTag, .storageClass, .isMultipartUploaded, .encryptionStatus])
            )
        )))
        
        let result = try await client?.getBucketInventory(
            GetBucketInventoryRequest(
                bucket: bucketName,
                inventoryId: "report1"
            )
        )
        XCTAssertEqual(result?.inventoryConfiguration?.id, "report1")
        XCTAssertEqual(result?.inventoryConfiguration?.isEnabled, true)
        XCTAssertEqual(result?.inventoryConfiguration?.destination?.ossBucketDestination?.prefix, "prefix1")
        XCTAssertEqual(result?.inventoryConfiguration?.destination?.ossBucketDestination?.format, "CSV")
        XCTAssertEqual(result?.inventoryConfiguration?.destination?.ossBucketDestination?.accountId, userId)
        XCTAssertEqual(result?.inventoryConfiguration?.destination?.ossBucketDestination?.roleArn, ramRoleArn)
        XCTAssertEqual(result?.inventoryConfiguration?.destination?.ossBucketDestination?.bucket, "acs:oss:::\(bucket)")
        XCTAssertEqual(result?.inventoryConfiguration?.schedule?.frequency, "Daily")
        XCTAssertEqual(result?.inventoryConfiguration?.filter?.lastModifyBeginTimeStamp, 1637883649)
        XCTAssertEqual(result?.inventoryConfiguration?.filter?.lastModifyEndTimeStamp, 1638347592)
        XCTAssertEqual(result?.inventoryConfiguration?.filter?.lowerSizeBound, 1024)
        XCTAssertEqual(result?.inventoryConfiguration?.filter?.prefix, "filterPrefix/")
        XCTAssertEqual(result?.inventoryConfiguration?.filter?.storageClass?.contains("IA"), true)
        XCTAssertEqual(result?.inventoryConfiguration?.filter?.storageClass?.contains("Standard"), true)
        XCTAssertEqual(result?.inventoryConfiguration?.filter?.upperSizeBound, 1048576)
        XCTAssertEqual(result?.inventoryConfiguration?.includedObjectVersions, "All")
        XCTAssertEqual(result?.inventoryConfiguration?.optionalFields?.fields, [.size, .lastModifiedDate, .eTag, .storageClass, .isMultipartUploaded, .encryptionStatus])
    }

    func testPutBucketInventoryFail() async throws {
        var request = PutBucketInventoryRequest()
        try await assertThrowsAsyncError(await client?.putBucketInventory(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }

        request = PutBucketInventoryRequest(bucket: bucketName)
        try await assertThrowsAsyncError(await client?.putBucketInventory(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.inventoryConfiguration.")
        }

        request = PutBucketInventoryRequest(bucket: bucketName, inventoryConfiguration: InventoryConfiguration())
        try await assertThrowsAsyncError(await client?.putBucketInventory(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 400)
            XCTAssertEqual(serverError?.code, "InvalidRequest")
        }
    }
    
    func testGetBucketInventoryFail() async throws {
        var request = GetBucketInventoryRequest()
        try await assertThrowsAsyncError(await client?.getBucketInventory(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }

        request = GetBucketInventoryRequest(bucket: bucketName)
        try await assertThrowsAsyncError(await client?.getBucketInventory(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }

        request = GetBucketInventoryRequest(bucket: bucketName, inventoryId: "inventoryId")
        try await assertThrowsAsyncError(await client?.getBucketInventory(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
            XCTAssertEqual(serverError?.code, "NoSuchInventory")
        }
    }
    
    func testListBucketInventorySuccess() async throws {
        let bucket = randomBucketName()
        try await createBucket(client: client!, bucket: bucket)
        
        await assertNoThrow(try await client?.putBucketInventory(PutBucketInventoryRequest(
            bucket: bucketName,
            inventoryId: "report1",
            inventoryConfiguration: InventoryConfiguration(
                id: "report1",
                isEnabled: true,
                destination: InventoryDestination(
                    ossBucketDestination: InventoryOSSBucketDestination(
                        bucket: "acs:oss:::\(bucket)",
                        prefix: "prefix1",
                        format: "CSV",
                        accountId: userId,
                        roleArn: ramRoleArn
                    )
                ),
                schedule: InventorySchedule(frequency: "Daily"),
                filter: InventoryFilter(
                    prefix: "filterPrefix1/",
                    lastModifyBeginTimeStamp: 1637883649,
                    lastModifyEndTimeStamp: 1638347592,
                    lowerSizeBound: 1024,
                    upperSizeBound: 1048576,
                    storageClass: "Standard"
                ),
                includedObjectVersions: "All",
                optionalFields: OptionalFields(fields: [.size, .lastModifiedDate, .eTag, .storageClass, .isMultipartUploaded, .encryptionStatus])
            )
        )))
        await assertNoThrow(try await client?.putBucketInventory(PutBucketInventoryRequest(
            bucket: bucketName,
            inventoryId: "report2",
            inventoryConfiguration: InventoryConfiguration(
                id: "report2",
                isEnabled: false,
                destination: InventoryDestination(
                    ossBucketDestination: InventoryOSSBucketDestination(
                        bucket: "acs:oss:::\(bucket)",
                        prefix: "prefix2",
                        format: "CSV",
                        accountId: userId,
                        roleArn: ramRoleArn
                    )
                ),
                schedule: InventorySchedule(frequency: "Daily"),
                filter: InventoryFilter(
                    prefix: "filterPrefix2/",
                    lastModifyBeginTimeStamp: 1637883649,
                    lastModifyEndTimeStamp: 1638347592,
                    lowerSizeBound: 1024,
                    upperSizeBound: 1048576,
                    storageClass: "IA"
                ),
                includedObjectVersions: "All",
                optionalFields: OptionalFields(fields: [.size, .lastModifiedDate, .eTag, .storageClass, .isMultipartUploaded, .encryptionStatus])
            )
        )))
        
        let result = try await client?.listBucketInventory(ListBucketInventoryRequest(bucket: bucketName))
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.isTruncated, false)
        XCTAssertNil(result?.listInventoryConfigurationsResult?.nextContinuationToken)
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.count, 2)
        
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.id, "report1")
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.isEnabled, true)
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.destination?.ossBucketDestination?.prefix, "prefix1")
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.destination?.ossBucketDestination?.format, "CSV")
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.destination?.ossBucketDestination?.accountId, userId)
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.destination?.ossBucketDestination?.roleArn, ramRoleArn)
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.destination?.ossBucketDestination?.bucket, "acs:oss:::\(bucket)")
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.schedule?.frequency, "Daily")
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.filter?.lastModifyBeginTimeStamp, 1637883649)
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.filter?.lastModifyEndTimeStamp, 1638347592)
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.filter?.lowerSizeBound, 1024)
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.filter?.prefix, "filterPrefix1/")
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.filter?.storageClass, "Standard")
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.filter?.upperSizeBound, 1048576)
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.includedObjectVersions, "All")
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.optionalFields?.fields, [.size, .lastModifiedDate, .eTag, .storageClass, .isMultipartUploaded, .encryptionStatus])
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.id, "report2")
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.isEnabled, false)
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.destination?.ossBucketDestination?.prefix, "prefix2")
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.destination?.ossBucketDestination?.format, "CSV")
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.destination?.ossBucketDestination?.accountId, userId)
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.destination?.ossBucketDestination?.roleArn, ramRoleArn)
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.destination?.ossBucketDestination?.bucket, "acs:oss:::\(bucket)")
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.schedule?.frequency, "Daily")
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.filter?.lastModifyBeginTimeStamp, 1637883649)
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.filter?.lastModifyEndTimeStamp, 1638347592)
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.filter?.lowerSizeBound, 1024)
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.filter?.prefix, "filterPrefix2/")
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.filter?.storageClass, "IA")
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.filter?.upperSizeBound, 1048576)
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.includedObjectVersions, "All")
        XCTAssertEqual(result?.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.optionalFields?.fields, [.size, .lastModifiedDate, .eTag, .storageClass, .isMultipartUploaded, .encryptionStatus])
    }

    func testListBucketInventoryFail() async throws {
        var request = ListBucketInventoryRequest()
        try await assertThrowsAsyncError(await client?.listBucketInventory(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }

        request = ListBucketInventoryRequest(bucket: bucketName)
        try await assertThrowsAsyncError(await client?.listBucketInventory(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
            XCTAssertEqual(serverError?.code, "NoSuchInventory")
        }
    }
    
    func testDeleteBucketInventorySuccess() async throws {
        let bucket = randomBucketName()
        try await createBucket(client: client!, bucket: bucket)
        
        await assertNoThrow(try await client?.putBucketInventory(PutBucketInventoryRequest(
            bucket: bucketName,
            inventoryId: "report1",
            inventoryConfiguration: InventoryConfiguration(
                id: "report1",
                isEnabled: true,
                destination: InventoryDestination(
                    ossBucketDestination: InventoryOSSBucketDestination(
                        bucket: "acs:oss:::\(bucket)",
                        prefix: "prefix1",
                        format: "CSV",
                        accountId: userId,
                        roleArn: ramRoleArn
                    )
                ),
                schedule: InventorySchedule(frequency: "Daily"),
                filter: InventoryFilter(
                    prefix: "filterPrefix/",
                    lastModifyBeginTimeStamp: 1637883649,
                    lastModifyEndTimeStamp: 1638347592,
                    lowerSizeBound: 1024,
                    upperSizeBound: 1048576,
                    storageClass: "Standard,IA"
                ),
                includedObjectVersions: "All",
                optionalFields: OptionalFields(fields: [.size, .lastModifiedDate, .eTag, .storageClass, .isMultipartUploaded, .encryptionStatus])
            )
        )))
        
        let result = try await client?.getBucketInventory(
            GetBucketInventoryRequest(
                bucket: bucketName,
                inventoryId: "report1"
            )
        )
        XCTAssertEqual(result?.inventoryConfiguration?.id, "report1")
        XCTAssertEqual(result?.inventoryConfiguration?.isEnabled, true)
        XCTAssertEqual(result?.inventoryConfiguration?.destination?.ossBucketDestination?.prefix, "prefix1")
        XCTAssertEqual(result?.inventoryConfiguration?.destination?.ossBucketDestination?.format, "CSV")
        XCTAssertEqual(result?.inventoryConfiguration?.destination?.ossBucketDestination?.accountId, userId)
        XCTAssertEqual(result?.inventoryConfiguration?.destination?.ossBucketDestination?.roleArn, ramRoleArn)
        XCTAssertEqual(result?.inventoryConfiguration?.destination?.ossBucketDestination?.bucket, "acs:oss:::\(bucket)")
        XCTAssertEqual(result?.inventoryConfiguration?.schedule?.frequency, "Daily")
        XCTAssertEqual(result?.inventoryConfiguration?.filter?.lastModifyBeginTimeStamp, 1637883649)
        XCTAssertEqual(result?.inventoryConfiguration?.filter?.lastModifyEndTimeStamp, 1638347592)
        XCTAssertEqual(result?.inventoryConfiguration?.filter?.lowerSizeBound, 1024)
        XCTAssertEqual(result?.inventoryConfiguration?.filter?.prefix, "filterPrefix/")
        XCTAssertEqual(result?.inventoryConfiguration?.filter?.storageClass?.contains("IA"), true)
        XCTAssertEqual(result?.inventoryConfiguration?.filter?.storageClass?.contains("Standard"), true)
        XCTAssertEqual(result?.inventoryConfiguration?.filter?.upperSizeBound, 1048576)
        XCTAssertEqual(result?.inventoryConfiguration?.includedObjectVersions, "All")
        XCTAssertEqual(result?.inventoryConfiguration?.optionalFields?.fields, [.size, .lastModifiedDate, .eTag, .storageClass, .isMultipartUploaded, .encryptionStatus])
        
        await assertNoThrow(try await client?.deleteBucketInventory(
            DeleteBucketInventoryRequest(
                bucket: bucketName,
                inventoryId: "report1"
            )
        ))
        
        await assertThrowsAsyncError(try await client?.getBucketInventory(
            GetBucketInventoryRequest(
                bucket: bucketName,
                inventoryId: "report1"
            )
        )) {
            let error = $0 as? ServerError
            XCTAssertEqual(error?.statusCode, 404)
            XCTAssertEqual(error?.code, "NoSuchInventory")
        }
    }
    
    func testDeleteBucketInventoryFail() async throws {
        var request = DeleteBucketInventoryRequest()
        try await assertThrowsAsyncError(await client?.deleteBucketInventory(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }

        request = DeleteBucketInventoryRequest(bucket: bucketName)
        try await assertThrowsAsyncError(await client?.deleteBucketInventory(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 400)
            XCTAssertEqual(serverError?.code, "InvalidRequest")
        }
    }
}
