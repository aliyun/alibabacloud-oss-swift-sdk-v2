import AlibabaCloudOSS
@testable import AlibabaCloudOSSExtension
import XCTest

class SerdeBucketResourceGroupTests: XCTestCase {
    func testSerializePutBucketResourceGroup() throws {
        var input = OperationInput()

        var xml = "<BucketResourceGroupConfiguration />"
        var request = PutBucketResourceGroupRequest(bucketResourceGroupConfiguration: BucketResourceGroupConfiguration())
        try Serde.serializeInput(&request, &input, [Serde.serializePutBucketResourceGroup])
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
        
        xml =
            """
            <BucketResourceGroupConfiguration>\
            <ResourceGroupId>rg-aekz****</ResourceGroupId>\
            </BucketResourceGroupConfiguration>
            """
        request = PutBucketResourceGroupRequest(
            bucketResourceGroupConfiguration: BucketResourceGroupConfiguration(
                resourceGroupId: "rg-aekz****"
            )
        )
        try Serde.serializeInput(&request, &input, [Serde.serializePutBucketResourceGroup])
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
    }

    func testDeserializeGetBucketResourceGroup() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = GetBucketResourceGroupResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketResourceGroup]))

        // normal
        let xml =
            """
            <BucketResourceGroupConfiguration>
            <ResourceGroupId>rg-xxxxxx</ResourceGroupId>
            </BucketResourceGroupConfiguration>
            """
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = GetBucketResourceGroupResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketResourceGroup]))
        XCTAssertEqual(result.bucketResourceGroupConfiguration?.resourceGroupId, "rg-xxxxxx")
    }
}
