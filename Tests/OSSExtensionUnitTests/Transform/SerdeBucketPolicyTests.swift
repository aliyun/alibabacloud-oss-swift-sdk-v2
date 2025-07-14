import AlibabaCloudOSS
@testable import AlibabaCloudOSSExtension
import XCTest

class SerdeBucketPolicyTests: XCTestCase {
    func testSerializePutBucketPolicy() throws {
        var input = OperationInput()

        var request = PutBucketPolicyRequest(body: .data(Data()))
        try Serde.serializeInput(&request, &input, [Serde.serializePutBucketPolicy])
        XCTAssertNotNil(input.body)
    }

    func testDeserializeGetBucketPolicy() {
        var output = OperationOutput(statusCode: 200,
                                     headers: [:],
                                     body: .data(Data()))
        var result = GetBucketPolicyResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketPolicy]))
        XCTAssertNotNil(result.body)
    }

    func testDeserializeGetBucketPolicyStatus() throws {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = GetBucketPolicyStatusResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketPolicyStatus]))

        // normal
        let xml =
            """
            <?xml version="1.0" encoding="UTF-8"?>\
            <PolicyStatus>\
            <IsPublic>true</IsPublic>\
            </PolicyStatus>
            """
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = GetBucketPolicyStatusResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketPolicyStatus]))
        XCTAssertTrue(result.policyStatus!.isPublic!)
    }
}
