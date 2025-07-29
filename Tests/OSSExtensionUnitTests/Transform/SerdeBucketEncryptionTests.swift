import AlibabaCloudOSS
@testable import AlibabaCloudOSSExtension
import XCTest

class SerdeBucketEncryptionTests: XCTestCase {
    func testSerializePutBucketEncryption() throws {
        var input = OperationInput()

        var xml = "<ServerSideEncryptionRule />"
        var request = PutBucketEncryptionRequest(serverSideEncryptionRule: ServerSideEncryptionRule())
        try Serde.serializeInput(&request, &input, [Serde.serializePutBucketEncryption])
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
        
        xml =
            """
            <ServerSideEncryptionRule>\
            <ApplyServerSideEncryptionByDefault>\
            <SSEAlgorithm>AES256</SSEAlgorithm>\
            <KMSMasterKeyID>kmsMasterKeyID</KMSMasterKeyID>\
            <KMSDataEncryption>kmsDataEncryption</KMSDataEncryption>\
            </ApplyServerSideEncryptionByDefault>\
            </ServerSideEncryptionRule>
            """
        request = PutBucketEncryptionRequest(
            serverSideEncryptionRule: ServerSideEncryptionRule(
                applyServerSideEncryptionByDefault: ApplyServerSideEncryptionByDefault(
                    sseAlgorithm: "AES256",
                    kmsMasterKeyID: "kmsMasterKeyID",
                    kmsDataEncryption: "kmsDataEncryption"
                )
            )
        )
        try Serde.serializeInput(&request, &input, [Serde.serializePutBucketEncryption])
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
    }

    func testDeserializeGetBucketReferer() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = GetBucketEncryptionResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketEncryption]))

        // normal
        let xml =
            """
            <ServerSideEncryptionRule>\
            <ApplyServerSideEncryptionByDefault>\
            <SSEAlgorithm>AES256</SSEAlgorithm>\
            <KMSMasterKeyID>kmsMasterKeyID</KMSMasterKeyID>\
            <KMSDataEncryption>kmsDataEncryption</KMSDataEncryption>\
            </ApplyServerSideEncryptionByDefault>\
            </ServerSideEncryptionRule>
            """
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = GetBucketEncryptionResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketEncryption]))
        XCTAssertEqual(result.serverSideEncryptionRule?.applyServerSideEncryptionByDefault?.sseAlgorithm, "AES256")
        XCTAssertEqual(result.serverSideEncryptionRule?.applyServerSideEncryptionByDefault?.kmsMasterKeyID, "kmsMasterKeyID")
        XCTAssertEqual(result.serverSideEncryptionRule?.applyServerSideEncryptionByDefault?.kmsDataEncryption, "kmsDataEncryption")
    }
}
