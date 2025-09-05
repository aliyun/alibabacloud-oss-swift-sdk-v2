import AlibabaCloudOSS
@testable import AlibabaCloudOSSExtension
import XCTest

class SerdePublicAccessBlockTests: XCTestCase {
    func testSerializePutPublicAccessBlock() throws {
        var input = OperationInput()

        var xml = "<PublicAccessBlockConfiguration />"
        var request = PutPublicAccessBlockRequest(publicAccessBlockConfiguration: PublicAccessBlockConfiguration())
        try Serde.serializeInput(&request, &input, [Serde.serializePutPublicAccessBlock])
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
        
        xml =
            """
            <PublicAccessBlockConfiguration>\
            <BlockPublicAccess>true</BlockPublicAccess>\
            </PublicAccessBlockConfiguration>
            """
        request = PutPublicAccessBlockRequest(
            publicAccessBlockConfiguration: PublicAccessBlockConfiguration(
                blockPublicAccess: true
            )
        )
        try Serde.serializeInput(&request, &input, [Serde.serializePutPublicAccessBlock])
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
    }

    func testDeserializeGetPublicAccessBlock() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = GetPublicAccessBlockResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetPublicAccessBlock]))

        // normal
        let xml =
            """
            <PublicAccessBlockConfiguration>
            <BlockPublicAccess>true</BlockPublicAccess>
            </PublicAccessBlockConfiguration>
            """
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = GetPublicAccessBlockResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetPublicAccessBlock]))
        XCTAssertEqual(result.publicAccessBlockConfiguration?.blockPublicAccess, true)
    }
}
