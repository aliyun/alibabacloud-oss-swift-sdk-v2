import AlibabaCloudOSS
@testable import AlibabaCloudOSSExtension
import XCTest

class SerdeBucketAccessMonitorTests: XCTestCase {
    func testSerializePutBucketAccessMonitor() throws {
        var input = OperationInput()

        var xml = "<AccessMonitorConfiguration />"
        var request = PutBucketAccessMonitorRequest(accessMonitorConfiguration: AccessMonitorConfiguration())
        try Serde.serializeInput(&request, &input, [Serde.serializePutBucketAccessMonitor])
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
        
        xml =
            """
            <AccessMonitorConfiguration>\
            <Status>Enabled</Status>\
            </AccessMonitorConfiguration>
            """
        request = PutBucketAccessMonitorRequest(
            accessMonitorConfiguration: AccessMonitorConfiguration(
                status: "Enabled"
            )
        )
        try Serde.serializeInput(&request, &input, [Serde.serializePutBucketAccessMonitor])
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
    }

    func testDeserializeGetBucketAccessMonitor() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = GetBucketAccessMonitorResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketAccessMonitor]))

        // normal
        let xml =
            """
            <AccessMonitorConfiguration>\
            <Status>Enabled</Status>\
            </AccessMonitorConfiguration>
            """
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = GetBucketAccessMonitorResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketAccessMonitor]))
        XCTAssertEqual(result.accessMonitorConfiguration?.status, "Enabled")
    }
}
