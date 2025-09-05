import AlibabaCloudOSS
@testable import AlibabaCloudOSSExtension
import XCTest

class SerdeBucketHttpsConfigTests: XCTestCase {
    func testSerializePutBucketHttpsConfig() throws {
        var input = OperationInput()

        var xml = "<HttpsConfiguration />"
        var request = PutBucketHttpsConfigRequest(httpsConfiguration: HttpsConfiguration())
        try Serde.serializeInput(&request, &input, [Serde.serializePutBucketHttpsConfig])
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
        
        xml =
            """
            <HttpsConfiguration>\
            <TLS>\
            <Enable>true</Enable>\ 
            <TLSVersion>TLSv1.2</TLSVersion>\
            <TLSVersion>TLSv1.3</TLSVersion>\
            </TLS>\
            </HttpsConfiguration>
            """
        request = PutBucketHttpsConfigRequest(
            httpsConfiguration: HttpsConfiguration(
                tls: TLS(
                    enable: true,
                    tlsVersions: ["TLSv1.2", "TLSv1.3"]
                )
            )
        )
        try Serde.serializeInput(&request, &input, [Serde.serializePutBucketHttpsConfig])
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
    }

    func testDeserializeGetBucketHttpsConfig() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = GetBucketHttpsConfigResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketHttpsConfig]))

        // normal
        let xml =
            """
            <HttpsConfiguration>\
            <TLS>\
            <Enable>true</Enable>\ 
            <TLSVersion>TLSv1.2</TLSVersion>\
            <TLSVersion>TLSv1.3</TLSVersion>\
            </TLS>\
            </HttpsConfiguration>
            """
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = GetBucketHttpsConfigResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketHttpsConfig]))
        XCTAssertEqual(result.httpsConfiguration?.tls?.enable, true)
        XCTAssertEqual(result.httpsConfiguration?.tls?.tlsVersions, ["TLSv1.2", "TLSv1.3"])
    }
}
