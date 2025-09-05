import AlibabaCloudOSS
@testable import AlibabaCloudOSSExtension
import XCTest

class SerdeBucketPublicAccessBlockTests: XCTestCase {
    func testSerializePutBucketPublicAccessBlock() throws {
        var input = OperationInput()

        var xml = "<PublicAccessBlockConfiguration />"
        var request = PutBucketPublicAccessBlockRequest(publicAccessBlockConfiguration: PublicAccessBlockConfiguration())
        try Serde.serializeInput(&request, &input, [Serde.serializePutBucketPublicAccessBlock])
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
        
        xml =
            """
            <PublicAccessBlockConfiguration>\
            <BlockPublicAccess>true</BlockPublicAccess>\
            </PublicAccessBlockConfiguration>
            """
        request = PutBucketPublicAccessBlockRequest(
            publicAccessBlockConfiguration: PublicAccessBlockConfiguration(
                blockPublicAccess: true
            )
        )
        try Serde.serializeInput(&request, &input, [Serde.serializePutBucketPublicAccessBlock])
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
    }

    func testDeserializeGetBucketPublicAccessBlock() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = GetBucketPublicAccessBlockResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketPublicAccessBlock]))

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
        result = GetBucketPublicAccessBlockResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketPublicAccessBlock]))
        XCTAssertEqual(result.publicAccessBlockConfiguration?.blockPublicAccess, true)
    }
}
