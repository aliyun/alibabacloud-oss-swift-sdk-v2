import AlibabaCloudOSS
@testable import AlibabaCloudOSSExtension
import XCTest

class SerdeBucketRequestPaymentTests: XCTestCase {
    func testSerializePutBucketRequestPayment() throws {
        var input = OperationInput()

        var xml = "<RequestPaymentConfiguration />"
        var request = PutBucketRequestPaymentRequest(requestPaymentConfiguration: RequestPaymentConfiguration())
        try Serde.serializeInput(&request, &input, [Serde.serializePutBucketRequestPayment])
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
        
        xml =
            """
            <RequestPaymentConfiguration>\
            <Payer>Requester</Payer>\
            </RequestPaymentConfiguration>
            """
        request = PutBucketRequestPaymentRequest(
            requestPaymentConfiguration: RequestPaymentConfiguration(
                payer: "Requester"
            )
        )
        try Serde.serializeInput(&request, &input, [Serde.serializePutBucketRequestPayment])
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
    }

    func testDeserializeGetBucketRequestPayment() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = GetBucketRequestPaymentResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketRequestPayment]))

        // normal
        let xml =
            """
            <RequestPaymentConfiguration>\
            <Payer>Requester</Payer>\
            </RequestPaymentConfiguration>
            """
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = GetBucketRequestPaymentResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketRequestPayment]))
        XCTAssertEqual(result.requestPaymentConfiguration?.payer, "Requester")
    }
}
