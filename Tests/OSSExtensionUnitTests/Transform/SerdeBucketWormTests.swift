import AlibabaCloudOSS
@testable import AlibabaCloudOSSExtension
import XCTest

class SerdeBucketWormTests: XCTestCase {
    func testSerializeInitiateBucketWorm() throws {
        var input = OperationInput()

        var xml = "<InitiateWormConfiguration />"
        var request = InitiateBucketWormRequest(initiateWormConfiguration: InitiateWormConfiguration())
        XCTAssertNoThrow(try Serde.serializeInput(&request, &input, [Serde.serializeInitiateBucketWorm]))
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))

        xml =
            """
            <InitiateWormConfiguration>\
            <RetentionPeriodInDays>1</RetentionPeriodInDays>\
            </InitiateWormConfiguration>
            """
        request = InitiateBucketWormRequest(initiateWormConfiguration: InitiateWormConfiguration(retentionPeriodInDays: 1))
        XCTAssertNoThrow(try Serde.serializeInput(&request, &input, [Serde.serializeInitiateBucketWorm]))
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
    }
    
    func testSerializeCompleteBucketWorm() {
        var input = OperationInput()

        var request = CompleteBucketWormRequest()
        XCTAssertNoThrow(try Serde.serializeInput(&request, &input, [Serde.serializeCompleteBucketWorm]))
        XCTAssertNil(input.parameters["wormId"] as Any?)

        request = CompleteBucketWormRequest(wormId: "wormId")
        XCTAssertNoThrow(try Serde.serializeInput(&request, &input, [Serde.serializeCompleteBucketWorm]))
        XCTAssertEqual(input.parameters["wormId"], "wormId")
    }
    
    func testSerializeExtendBucketWorm() {
        var input = OperationInput()

        var xml = "<ExtendWormConfiguration />"
        var request = ExtendBucketWormRequest(extendWormConfiguration: ExtendWormConfiguration())
        XCTAssertNoThrow(try Serde.serializeInput(&request, &input, [Serde.serializeExtendBucketWorm]))
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
        XCTAssertNil(input.parameters["wormId"] as Any?)

        xml =
            """
            <ExtendWormConfiguration>\
            <RetentionPeriodInDays>1</RetentionPeriodInDays>\
            </ExtendWormConfiguration>
            """
        request = ExtendBucketWormRequest(wormId: "wormId", extendWormConfiguration: ExtendWormConfiguration(retentionPeriodInDays: 1))
        XCTAssertNoThrow(try Serde.serializeInput(&request, &input, [Serde.serializeExtendBucketWorm]))
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
        XCTAssertEqual(input.parameters["wormId"], "wormId")
    }
    
    func testDeserializeGetBucketWorm() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = GetBucketWormResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketWorm]))

        // normal
        let xml =
            """
            <WormConfiguration>\
            <WormId>1666E2CFB2B3418****</WormId>\
            <State>Locked</State>\
            <RetentionPeriodInDays>1</RetentionPeriodInDays>\
            <CreationDate>2020-10-15T15:50:32</CreationDate>\
            <ExpirationDate>2021-10-15T15:50:32</ExpirationDate>\
            </WormConfiguration>
            """
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = GetBucketWormResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketWorm]))
        XCTAssertEqual(result.wormConfiguration?.wormId, "1666E2CFB2B3418****")
        XCTAssertEqual(result.wormConfiguration?.state, "Locked")
        XCTAssertEqual(result.wormConfiguration?.retentionPeriodInDays, 1)
        XCTAssertEqual(result.wormConfiguration?.creationDate, "2020-10-15T15:50:32")
        XCTAssertEqual(result.wormConfiguration?.expirationDate, "2021-10-15T15:50:32")
    }
}
