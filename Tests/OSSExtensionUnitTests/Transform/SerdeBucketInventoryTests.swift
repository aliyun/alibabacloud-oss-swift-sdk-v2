import AlibabaCloudOSS
@testable import AlibabaCloudOSSExtension
import XCTest

class SerdeBucketInventoryTests: XCTestCase {
    func testSerializePutBucketInventory() throws {
        var input = OperationInput()

        var xml = "<InventoryConfiguration />"
        var request = PutBucketInventoryRequest(inventoryConfiguration: InventoryConfiguration())
        XCTAssertNoThrow(try Serde.serializeInput(&request, &input, [Serde.serializePutBucketInventory]))
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
        XCTAssertNil(input.parameters["inventoryId"] as Any?)
        
        xml =
            """
            <InventoryConfiguration>\
            <Id>report1</Id>\
            <IsEnabled>true</IsEnabled>\
            <Destination>\
            <OSSBucketDestination>\
            <Bucket>acs:oss:::destination-bucket</Bucket>\
            <Prefix>prefix1</Prefix>\
            <Encryption>\
            <SSE-OSS>sseOss</SSE-OSS>\
            <SSE-KMS>\
            <KeyId>keyId</KeyId>\
            </SSE-KMS>\
            </Encryption>\
            <Format>CSV</Format>\
            <AccountId>1000000000000000</AccountId>\
            <RoleArn>acs:ram::1000000000000000:role/AliyunOSSRole</RoleArn>\
            </OSSBucketDestination>\
            </Destination>\
            <Schedule>\
            <Frequency>Daily</Frequency>\
            </Schedule>\
            <Filter>\
            <Prefix>filterPrefix/</Prefix>\
            <LastModifyBeginTimeStamp>1637883649</LastModifyBeginTimeStamp>\
            <LastModifyEndTimeStamp>1638347592</LastModifyEndTimeStamp>\
            <LowerSizeBound>1024</LowerSizeBound>\
            <UpperSizeBound>1048576</UpperSizeBound>\
            <StorageClass>Standard,IA</StorageClass>\
            </Filter>\
            <IncludedObjectVersions>All</IncludedObjectVersions>\
            <OptionalFields>\
            <Field>Size</Field>\
            <Field>LastModifiedDate</Field>\
            <Field>ETag</Field>\
            <Field>StorageClass</Field>\
            <Field>IsMultipartUploaded</Field>\
            <Field>EncryptionStatus</Field>\
            </OptionalFields>\
            </InventoryConfiguration>
            """
        request = PutBucketInventoryRequest(
            inventoryId: "inventoryId",
            inventoryConfiguration: InventoryConfiguration(
                id: "report1",
                isEnabled: true,
                destination: InventoryDestination(
                    ossBucketDestination: InventoryOSSBucketDestination(
                        bucket: "acs:oss:::destination-bucket",
                        prefix: "prefix1",
                        encryption: InventoryEncryption(sseOss: "sseOss", sseKms: SSEKMS(keyId: "keyId")),
                        format: "CSV",
                        accountId: "1000000000000000",
                        roleArn: "acs:ram::1000000000000000:role/AliyunOSSRole"
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
        )
        try Serde.serializeInput(&request, &input, [Serde.serializePutBucketInventory])
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
        XCTAssertEqual(input.parameters["inventoryId"], "inventoryId")
    }

    func testSerializeGetBucketInventory() {
        var input = OperationInput()

        var request = GetBucketInventoryRequest()
        XCTAssertNoThrow(try Serde.serializeInput(&request, &input, [Serde.serializeGetBucketInventory]))
        XCTAssertNil(input.parameters["inventoryId"] as Any?)
        
        request = GetBucketInventoryRequest(inventoryId: "inventoryId")
        XCTAssertNoThrow(try Serde.serializeInput(&request, &input, [Serde.serializeGetBucketInventory]))
        XCTAssertEqual(input.parameters["inventoryId"], "inventoryId")
    }
    
    func testDeserializeGetBucketInventory() throws {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = GetBucketInventoryResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketInventory]))

        // normal
        let xml =
            """
            <InventoryConfiguration>\
            <Id>report1</Id>\
            <IsEnabled>true</IsEnabled>\
            <Destination>\
            <OSSBucketDestination>\
            <Bucket>acs:oss:::destination-bucket</Bucket>\
            <Prefix>prefix1</Prefix>\
            <Encryption>\
            <SSE-OSS>sseOss</SSE-OSS>\
            <SSE-KMS>\
            <KeyId>keyId</KeyId>\
            </SSE-KMS>\
            </Encryption>\
            <Format>CSV</Format>\
            <AccountId>1000000000000000</AccountId>\
            <RoleArn>acs:ram::1000000000000000:role/AliyunOSSRole</RoleArn>\
            </OSSBucketDestination>\
            </Destination>\
            <Schedule>\
            <Frequency>Daily</Frequency>\
            </Schedule>\
            <Filter>\
            <Prefix>filterPrefix/</Prefix>\
            <LastModifyBeginTimeStamp>1637883649</LastModifyBeginTimeStamp>\
            <LastModifyEndTimeStamp>1638347592</LastModifyEndTimeStamp>\
            <LowerSizeBound>1024</LowerSizeBound>\
            <UpperSizeBound>1048576</UpperSizeBound>\
            <StorageClass>Standard,IA</StorageClass>\
            </Filter>\
            <IncludedObjectVersions>All</IncludedObjectVersions>\
            <OptionalFields>\
            <Field>Size</Field>\
            <Field>LastModifiedDate</Field>\
            <Field>ETag</Field>\
            <Field>StorageClass</Field>\
            <Field>IsMultipartUploaded</Field>\
            <Field>EncryptionStatus</Field>\
            </OptionalFields>\
            </InventoryConfiguration>
            """
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = GetBucketInventoryResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketInventory]))
        XCTAssertEqual(result.inventoryConfiguration?.id, "report1")
        XCTAssertEqual(result.inventoryConfiguration?.isEnabled, true)
        XCTAssertEqual(result.inventoryConfiguration?.destination?.ossBucketDestination?.prefix, "prefix1")
        XCTAssertEqual(result.inventoryConfiguration?.destination?.ossBucketDestination?.encryption?.sseKms?.keyId, "keyId")
        XCTAssertEqual(result.inventoryConfiguration?.destination?.ossBucketDestination?.encryption?.sseOss, "sseOss")
        XCTAssertEqual(result.inventoryConfiguration?.destination?.ossBucketDestination?.format, "CSV")
        XCTAssertEqual(result.inventoryConfiguration?.destination?.ossBucketDestination?.accountId, "1000000000000000")
        XCTAssertEqual(result.inventoryConfiguration?.destination?.ossBucketDestination?.roleArn, "acs:ram::1000000000000000:role/AliyunOSSRole")
        XCTAssertEqual(result.inventoryConfiguration?.destination?.ossBucketDestination?.bucket, "acs:oss:::destination-bucket")
        XCTAssertEqual(result.inventoryConfiguration?.schedule?.frequency, "Daily")
        XCTAssertEqual(result.inventoryConfiguration?.filter?.lastModifyBeginTimeStamp, 1637883649)
        XCTAssertEqual(result.inventoryConfiguration?.filter?.lastModifyEndTimeStamp, 1638347592)
        XCTAssertEqual(result.inventoryConfiguration?.filter?.lowerSizeBound, 1024)
        XCTAssertEqual(result.inventoryConfiguration?.filter?.prefix, "filterPrefix/")
        XCTAssertEqual(result.inventoryConfiguration?.filter?.storageClass, "Standard,IA")
        XCTAssertEqual(result.inventoryConfiguration?.filter?.upperSizeBound, 1048576)
        XCTAssertEqual(result.inventoryConfiguration?.includedObjectVersions, "All")
        XCTAssertEqual(result.inventoryConfiguration?.optionalFields?.fields, [.size, .lastModifiedDate, .eTag, .storageClass, .isMultipartUploaded, .encryptionStatus])
    }
    
    func testSerializeListBucketInventory() {
        var input = OperationInput()

        var request = ListBucketInventoryRequest()
        XCTAssertNoThrow(try Serde.serializeInput(&request, &input, [Serde.serializeListBucketInventory]))
        XCTAssertNil(input.parameters["continuation-token"] as Any?)
        
        request = ListBucketInventoryRequest(continuationToken: "continuationToken")
        XCTAssertNoThrow(try Serde.serializeInput(&request, &input, [Serde.serializeListBucketInventory]))
        XCTAssertEqual(input.parameters["continuation-token"], "continuationToken")
    }
    
    func testDeserializeListBucketInventory() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = ListBucketInventoryResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeListBucketInventory]))
        
        // normal
        let xml =
            """
            <ListInventoryConfigurationsResult>\
            <InventoryConfiguration>\
            <Id>report1</Id>\
            <IsEnabled>true</IsEnabled>\
            <Destination>\
            <OSSBucketDestination>\
            <Bucket>acs:oss:::destination-bucket001</Bucket>\
            <Prefix>prefix1</Prefix>\
            <Encryption>\
            <SSE-OSS>sseOss1</SSE-OSS>\
            <SSE-KMS>\
            <KeyId>keyId1</KeyId>\
            </SSE-KMS>\
            </Encryption>\
            <Format>CSV</Format>\
            <AccountId>1000000000000001</AccountId>\
            <RoleArn>acs:ram::1000000000000001:role/AliyunOSSRole</RoleArn>\
            </OSSBucketDestination>\
            </Destination>\
            <Schedule>\
            <Frequency>Daily</Frequency>\
            </Schedule>\
            <Filter>\
            <Prefix>filterPrefix1/</Prefix>\
            <LastModifyBeginTimeStamp>1637883649</LastModifyBeginTimeStamp>\
            <LastModifyEndTimeStamp>1638347592</LastModifyEndTimeStamp>\
            <LowerSizeBound>1024</LowerSizeBound>\
            <UpperSizeBound>1048576</UpperSizeBound>\
            <StorageClass>Standard,IA</StorageClass>\
            </Filter>\
            <IncludedObjectVersions>All</IncludedObjectVersions>\
            <OptionalFields>\
            <Field>Size</Field>\
            <Field>LastModifiedDate</Field>\
            <Field>ETag</Field>\
            <Field>StorageClass</Field>\
            <Field>IsMultipartUploaded</Field>\
            <Field>EncryptionStatus</Field>\
            </OptionalFields>\
            </InventoryConfiguration>
            <InventoryConfiguration>\
            <Id>report2</Id>\
            <IsEnabled>false</IsEnabled>\
            <Destination>\
            <OSSBucketDestination>\
            <Bucket>acs:oss:::destination-bucket002</Bucket>\
            <Prefix>prefix2</Prefix>\
            <Encryption>\
            <SSE-OSS>sseOss2</SSE-OSS>\
            <SSE-KMS>\
            <KeyId>keyId2</KeyId>\
            </SSE-KMS>\
            </Encryption>\
            <Format>CSV</Format>\
            <AccountId>1000000000000002</AccountId>\
            <RoleArn>acs:ram::1000000000000002:role/AliyunOSSRole</RoleArn>\
            </OSSBucketDestination>\
            </Destination>\
            <Schedule>\
            <Frequency>Daily</Frequency>\
            </Schedule>\
            <Filter>\
            <Prefix>filterPrefix2/</Prefix>\
            <LastModifyBeginTimeStamp>1637883649</LastModifyBeginTimeStamp>\
            <LastModifyEndTimeStamp>1638347592</LastModifyEndTimeStamp>\
            <LowerSizeBound>1024</LowerSizeBound>\
            <UpperSizeBound>1048576</UpperSizeBound>\
            <StorageClass>Standard,IA</StorageClass>\
            </Filter>\
            <IncludedObjectVersions>All</IncludedObjectVersions>\
            <OptionalFields>\
            <Field>Size</Field>\
            <Field>LastModifiedDate</Field>\
            <Field>ETag</Field>\
            <Field>StorageClass</Field>\
            <Field>IsMultipartUploaded</Field>\
            <Field>EncryptionStatus</Field>\
            </OptionalFields>\
            </InventoryConfiguration>\
            <IsTruncated>true</IsTruncated>\
            <NextContinuationToken>nextContinuationToken</NextContinuationToken>\
            </ListInventoryConfigurationsResult>
            """
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = ListBucketInventoryResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeListBucketInventory]))
        XCTAssertEqual(result.listInventoryConfigurationsResult?.isTruncated, true)
        XCTAssertEqual(result.listInventoryConfigurationsResult?.nextContinuationToken, "nextContinuationToken")
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.count, 2)
        
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.id, "report1")
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.isEnabled, true)
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.destination?.ossBucketDestination?.prefix, "prefix1")
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.destination?.ossBucketDestination?.encryption?.sseKms?.keyId, "keyId1")
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.destination?.ossBucketDestination?.encryption?.sseOss, "sseOss1")
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.destination?.ossBucketDestination?.format, "CSV")
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.destination?.ossBucketDestination?.accountId, "1000000000000001")
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.destination?.ossBucketDestination?.roleArn, "acs:ram::1000000000000001:role/AliyunOSSRole")
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.destination?.ossBucketDestination?.bucket, "acs:oss:::destination-bucket001")
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.schedule?.frequency, "Daily")
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.filter?.lastModifyBeginTimeStamp, 1637883649)
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.filter?.lastModifyEndTimeStamp, 1638347592)
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.filter?.lowerSizeBound, 1024)
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.filter?.prefix, "filterPrefix1/")
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.filter?.storageClass, "Standard,IA")
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.filter?.upperSizeBound, 1048576)
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.includedObjectVersions, "All")
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.first?.optionalFields?.fields, [.size, .lastModifiedDate, .eTag, .storageClass, .isMultipartUploaded, .encryptionStatus])
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.id, "report2")
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.isEnabled, false)
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.destination?.ossBucketDestination?.prefix, "prefix2")
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.destination?.ossBucketDestination?.encryption?.sseKms?.keyId, "keyId2")
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.destination?.ossBucketDestination?.encryption?.sseOss, "sseOss2")
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.destination?.ossBucketDestination?.format, "CSV")
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.destination?.ossBucketDestination?.accountId, "1000000000000002")
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.destination?.ossBucketDestination?.roleArn, "acs:ram::1000000000000002:role/AliyunOSSRole")
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.destination?.ossBucketDestination?.bucket, "acs:oss:::destination-bucket002")
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.schedule?.frequency, "Daily")
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.filter?.lastModifyBeginTimeStamp, 1637883649)
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.filter?.lastModifyEndTimeStamp, 1638347592)
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.filter?.lowerSizeBound, 1024)
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.filter?.prefix, "filterPrefix2/")
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.filter?.storageClass, "Standard,IA")
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.filter?.upperSizeBound, 1048576)
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.includedObjectVersions, "All")
        XCTAssertEqual(result.listInventoryConfigurationsResult?.inventoryConfigurations?.last?.optionalFields?.fields, [.size, .lastModifiedDate, .eTag, .storageClass, .isMultipartUploaded, .encryptionStatus])
    }
    
    func testSerializeDeleteBucketInventory() {
        var input = OperationInput()

        var request = DeleteBucketInventoryRequest()
        XCTAssertNoThrow(try Serde.serializeInput(&request, &input, [Serde.serializeDeleteBucketInventory]))
        XCTAssertNil(input.parameters["inventoryId"] as Any?)
        
        request = DeleteBucketInventoryRequest(inventoryId: "inventoryId")
        XCTAssertNoThrow(try Serde.serializeInput(&request, &input, [Serde.serializeDeleteBucketInventory]))
        XCTAssertEqual(input.parameters["inventoryId"], "inventoryId")
    }
}
