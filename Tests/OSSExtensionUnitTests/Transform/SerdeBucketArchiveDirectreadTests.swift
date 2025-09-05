import AlibabaCloudOSS
@testable import AlibabaCloudOSSExtension
import XCTest

class SerdeBucketArchiveDirectreadTests: XCTestCase {
    func testSerializePutBucketArchiveDirectRead() throws {
        var input = OperationInput()

        var xml = "<ArchiveDirectReadConfiguration />"
        var request = PutBucketArchiveDirectReadRequest(archiveDirectReadConfiguration: ArchiveDirectReadConfiguration())
        try Serde.serializeInput(&request, &input, [Serde.serializePutBucketArchiveDirectRead])
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
        
        xml =
            """
            <ArchiveDirectReadConfiguration>\
            <Enabled>true</Enabled>\
            </ArchiveDirectReadConfiguration>
            """
        request = PutBucketArchiveDirectReadRequest(
            archiveDirectReadConfiguration: ArchiveDirectReadConfiguration(
                enabled: true
            )
        )
        try Serde.serializeInput(&request, &input, [Serde.serializePutBucketArchiveDirectRead])
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
    }

    func testDeserializeGetBucketArchiveDirectRead() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = GetBucketArchiveDirectReadResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketArchiveDirectRead]))

        // normal
        let xml =
            """
            <ArchiveDirectReadConfiguration>\
            <Enabled>true</Enabled>\
            </ArchiveDirectReadConfiguration>
            """
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = GetBucketArchiveDirectReadResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketArchiveDirectRead]))
        XCTAssertEqual(result.archiveDirectReadConfiguration?.enabled, true)
    }
}
