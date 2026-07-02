import AlibabaCloudOSS
@testable import AlibabaCloudOSSExtension
import XCTest

class SerdeBucketReplicationTests: XCTestCase {
    
    func testSerializePutBucketRtc() throws {
        var input = OperationInput()

        var xml = "<ReplicationRule />"
        var request = PutBucketRtcRequest(rtcConfiguration: RtcConfiguration())
        XCTAssertNoThrow(try Serde.serializeInput(&request, &input, [Serde.serializePutBucketRtc]))
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))

        xml =
            """
            <ReplicationRule>\
            <ID>id</ID>\
            <RTC>\
            <Status>enabled</Status>\
            </RTC>\
            </ReplicationRule>
            """
        request = PutBucketRtcRequest(rtcConfiguration: RtcConfiguration(
            id: "id",
            rtc: RTC(status: "enabled")
        ))
        XCTAssertNoThrow(try Serde.serializeInput(&request, &input, [Serde.serializePutBucketRtc]))
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
    }
    
    func testSerializePutBucketReplication() throws {
        var input = OperationInput()

        var xml = "<ReplicationConfiguration />"
        var request = PutBucketReplicationRequest(replicationConfiguration: ReplicationConfiguration())
        XCTAssertNoThrow(try Serde.serializeInput(&request, &input, [Serde.serializePutBucketReplication]))
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))

        xml =
            """
            <ReplicationConfiguration>\
            <Rule>\
            <ID>id</ID>\
            <Destination>\
            <Bucket>bucket</Bucket>\
            <Location>location</Location>\
            <TransferType>transferType</TransferType>\
            </Destination>\
            <HistoricalObjectReplication>enabled</HistoricalObjectReplication>\
            <SyncRole>syncRole</SyncRole>\
            <EncryptionConfiguration>\
            <ReplicaKmsKeyID>replicaKmsKeyID</ReplicaKmsKeyID>\
            </EncryptionConfiguration>\
            <RTC>\
            <Status>enabled</Status>\
            </RTC>\
            <PrefixSet>\
            <Prefix>prefixs1</Prefix>\
            <Prefix>prefixs2</Prefix>\
            </PrefixSet>\
            <Action>PUT</Action>\
            <Status>enabled</Status>\
            <SourceSelectionCriteria>\
            <SseKmsEncryptedObjects>\
            <Status>enabled</Status>\
            </SseKmsEncryptedObjects>\
            </SourceSelectionCriteria>\
            </Rule>\
            </ReplicationConfiguration>
            """
        request = PutBucketReplicationRequest(
            replicationConfiguration: ReplicationConfiguration(
                rules: [ReplicationRule(
                    id: "id",
                    destination: ReplicationDestination(bucket: "bucket", location: "location", transferType: "transferType"),
                    historicalObjectReplication: "enabled",
                    syncRole: "syncRole",
                    encryptionConfiguration: ReplicationEncryptionConfiguration(replicaKmsKeyID: "replicaKmsKeyID"),
                    rtc: RTC(status: "enabled"),
                    prefixSet: ReplicationPrefixSet(prefixs: ["prefixs1", "prefixs2"]),
                    action: "PUT",
                    status: "enabled",
                    sourceSelectionCriteria: ReplicationSourceSelectionCriteria(sseKmsEncryptedObjects: SseKmsEncryptedObjects(status: "enabled"))
                )]
            )
        )
        XCTAssertNoThrow(try Serde.serializeInput(&request, &input, [Serde.serializePutBucketReplication]))
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
    }

    func testDeserializeGetBucketReplication() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = GetBucketReplicationResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketReplication]))

        // normal
        let xml =
            """
            <ReplicationConfiguration>\
            <Rule>\
            <ID>id</ID>\
            <Destination>\
            <Bucket>bucket</Bucket>\
            <Location>location</Location>\
            <TransferType>transferType</TransferType>\
            </Destination>\
            <HistoricalObjectReplication>enabled</HistoricalObjectReplication>\
            <SyncRole>syncRole</SyncRole>\
            <EncryptionConfiguration>\
            <ReplicaKmsKeyID>replicaKmsKeyID</ReplicaKmsKeyID>\
            </EncryptionConfiguration>\
            <RTC>\
            <Status>enabled</Status>\
            </RTC>\
            <PrefixSet>\
            <Prefix>prefixs1</Prefix>\
            <Prefix>prefixs2</Prefix>\
            </PrefixSet>\
            <Action>PUT</Action>\
            <Status>enabled</Status>\
            <SourceSelectionCriteria>\
            <SseKmsEncryptedObjects>\
            <Status>enabled</Status>\
            </SseKmsEncryptedObjects>\
            </SourceSelectionCriteria>\
            </Rule>\
            </ReplicationConfiguration>
            """
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = GetBucketReplicationResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketReplication]))
        XCTAssertEqual(result.replicationConfiguration?.rules?.first?.id, "id")
        XCTAssertEqual(result.replicationConfiguration?.rules?.first?.destination?.bucket, "bucket")
        XCTAssertEqual(result.replicationConfiguration?.rules?.first?.destination?.location, "location")
        XCTAssertEqual(result.replicationConfiguration?.rules?.first?.destination?.transferType, "transferType")
        XCTAssertEqual(result.replicationConfiguration?.rules?.first?.historicalObjectReplication, "enabled")
        XCTAssertEqual(result.replicationConfiguration?.rules?.first?.syncRole, "syncRole")
        XCTAssertEqual(result.replicationConfiguration?.rules?.first?.encryptionConfiguration?.replicaKmsKeyID, "replicaKmsKeyID")
        XCTAssertEqual(result.replicationConfiguration?.rules?.first?.rtc?.status, "enabled")
        XCTAssertEqual(result.replicationConfiguration?.rules?.first?.prefixSet?.prefixs?.first, "prefixs1")
        XCTAssertEqual(result.replicationConfiguration?.rules?.first?.prefixSet?.prefixs?.last, "prefixs2")
        XCTAssertEqual(result.replicationConfiguration?.rules?.first?.action, "PUT")
        XCTAssertEqual(result.replicationConfiguration?.rules?.first?.status, "enabled")
        XCTAssertEqual(result.replicationConfiguration?.rules?.first?.sourceSelectionCriteria?.sseKmsEncryptedObjects?.status, "enabled")
    }
    
    func testDeserializeGetBucketReplicationLocation() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = GetBucketReplicationLocationResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketReplicationLocation]))

        // normal
        let xml =
            """
            <ReplicationLocation>\
            <Location>oss-cn-beijing</Location>\
            <Location>oss-cn-qingdao</Location>\
            <Location>oss-cn-shenzhen</Location>\
            <Location>oss-cn-hongkong</Location>\
            <Location>oss-us-west-1</Location>\
            <LocationTransferTypeConstraint>\
            <LocationTransferType>\
            <Location>oss-cn-hongkong</Location>\
            <TransferTypes>\
            <Type>oss_acc</Type>\
            </TransferTypes>\
            </LocationTransferType>\
            <LocationTransferType>\
            <Location>oss-us-west-1</Location>\
            <TransferTypes>\
            <Type>oss_acc</Type>\
            </TransferTypes>\
            </LocationTransferType>\
            </LocationTransferTypeConstraint>\
            </ReplicationLocation>
            """
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = GetBucketReplicationLocationResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketReplicationLocation]))
        XCTAssertEqual(result.replicationLocation?.locations?[0], "oss-cn-beijing")
        XCTAssertEqual(result.replicationLocation?.locations?[1], "oss-cn-qingdao")
        XCTAssertEqual(result.replicationLocation?.locations?[2], "oss-cn-shenzhen")
        XCTAssertEqual(result.replicationLocation?.locations?[3], "oss-cn-hongkong")
        XCTAssertEqual(result.replicationLocation?.locations?[4], "oss-us-west-1")
        XCTAssertEqual(result.replicationLocation?.locationTransferTypeConstraint?.locationTransferTypes?[0].location, "oss-cn-hongkong")
        XCTAssertEqual(result.replicationLocation?.locationTransferTypeConstraint?.locationTransferTypes?[0].transferTypes?.types?.first, "oss_acc")
        XCTAssertEqual(result.replicationLocation?.locationTransferTypeConstraint?.locationTransferTypes?[1].location, "oss-us-west-1")
        XCTAssertEqual(result.replicationLocation?.locationTransferTypeConstraint?.locationTransferTypes?[1].transferTypes?.types?.first, "oss_acc")
    }
    
    func testSerializeGetBucketReplicationProgress() {
        var input = OperationInput()

        var request = GetBucketReplicationProgressRequest()
        XCTAssertNoThrow(try Serde.serializeInput(&request, &input, [Serde.serializeGetBucketReplicationProgress]))
        XCTAssertNil(input.parameters["rule-id"] as Any?)

        request = GetBucketReplicationProgressRequest(ruleId: "ruleId")
        XCTAssertNoThrow(try Serde.serializeInput(&request, &input, [Serde.serializeGetBucketReplicationProgress]))
        XCTAssertEqual(input.parameters["rule-id"], "ruleId")
    }
    
    func testDeserializeGetBucketReplicationProgress() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = GetBucketReplicationProgressResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketReplicationProgress]))

        // normal
        let xml =
            """
            <ReplicationProgress>\
            <Rule>\
            <ID>test_replication_1</ID>\
            <PrefixSet>\
            <Prefix>source_image</Prefix>\
            <Prefix>video</Prefix>\
            </PrefixSet>\
            <Action>PUT</Action>\
            <Destination>\
            <Bucket>target-bucket</Bucket>\
            <Location>oss-cn-beijing</Location>\
            <TransferType>oss_acc</TransferType>\
            </Destination>\
            <Status>doing</Status>\
            <HistoricalObjectReplication>enabled</HistoricalObjectReplication>\
            <Progress>\
            <HistoricalObject>0.85</HistoricalObject>\
            <NewObject>2015-09-24T15:28:14.000Z</NewObject>\
            </Progress>\
            </Rule>\
            </ReplicationProgress>
            """
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = GetBucketReplicationProgressResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketReplicationProgress]))
        XCTAssertEqual(result.replicationProgress?.rules?.first?.id, "test_replication_1")
        XCTAssertEqual(result.replicationProgress?.rules?.first?.prefixSet?.prefixs?.first, "source_image")
        XCTAssertEqual(result.replicationProgress?.rules?.first?.prefixSet?.prefixs?.last, "video")
        XCTAssertEqual(result.replicationProgress?.rules?.first?.action, "PUT")
        XCTAssertEqual(result.replicationProgress?.rules?.first?.destination?.bucket, "target-bucket")
        XCTAssertEqual(result.replicationProgress?.rules?.first?.destination?.location, "oss-cn-beijing")
        XCTAssertEqual(result.replicationProgress?.rules?.first?.destination?.transferType, "oss_acc")
        XCTAssertEqual(result.replicationProgress?.rules?.first?.status, "doing")
        XCTAssertEqual(result.replicationProgress?.rules?.first?.historicalObjectReplication, "enabled")
        XCTAssertEqual(result.replicationProgress?.rules?.first?.progress?.historicalObject, "0.85")
        XCTAssertEqual(result.replicationProgress?.rules?.first?.progress?.newObject, "2015-09-24T15:28:14.000Z")
    }
    
    func testSerializeDeleteBucketReplication() {
        var input = OperationInput()

        let xml =
            """
            <ReplicationRules>\
            <ID>id</ID>\
            </ReplicationRules>
            """
        var request = DeleteBucketReplicationRequest(replicationRules: ReplicationRules(id: "id"))
        XCTAssertNoThrow(try Serde.serializeInput(&request, &input, [Serde.serializeDeleteBucketReplication]))
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
    }
}
