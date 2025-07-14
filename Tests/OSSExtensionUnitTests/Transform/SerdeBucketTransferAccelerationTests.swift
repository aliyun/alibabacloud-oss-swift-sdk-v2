import AlibabaCloudOSS
@testable import AlibabaCloudOSSExtension
import XCTest

class SerdeBucketTransferaccelerationTests: XCTestCase {
    func testSerializePutBucketTransferAcceleration() throws {
        var input = OperationInput()

        var xml = "<TransferAccelerationConfiguration />"
        var request = PutBucketTransferAccelerationRequest(transferAccelerationConfiguration: TransferAccelerationConfiguration())
        XCTAssertNoThrow(try Serde.serializeInput(&request, &input, [Serde.serializePutBucketTransferAcceleration]))
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))

        xml =
            """
            <TransferAccelerationConfiguration>\
            <Enabled>true</Enabled>\
            </TransferAccelerationConfiguration>
            """
        request = PutBucketTransferAccelerationRequest(transferAccelerationConfiguration: TransferAccelerationConfiguration(enabled: true))
        XCTAssertNoThrow(try Serde.serializeInput(&request, &input, [Serde.serializePutBucketTransferAcceleration]))
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
    }

    func testDeserializeGetBucketTransferAcceleration() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = GetBucketTransferAccelerationResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketTransferAcceleration]))

        // normal
        let xml =
            """
            <TransferAccelerationConfiguration>\
            <Enabled>true</Enabled>\
            </TransferAccelerationConfiguration>
            """
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = GetBucketTransferAccelerationResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketTransferAcceleration]))
        XCTAssertEqual(result.transferAccelerationConfiguration?.enabled, true)
    }
}
