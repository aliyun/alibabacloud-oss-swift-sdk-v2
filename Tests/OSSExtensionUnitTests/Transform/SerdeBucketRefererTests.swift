import AlibabaCloudOSS
@testable import AlibabaCloudOSSExtension
import XCTest

class SerdeBucketRefererTests: XCTestCase {
    func testSerializePutBucketReferer() throws {
        var input = OperationInput()

        var xml = "<RefererConfiguration />"
        var request = PutBucketRefererRequest(refererConfiguration: RefererConfiguration())
        try Serde.serializeInput(&request, &input, [Serde.serializePutBucketReferer])
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
        
        xml =
            """
            <RefererConfiguration>\
            <AllowEmptyReferer>false</AllowEmptyReferer>\
            <AllowTruncateQueryString>true</AllowTruncateQueryString>\
            <TruncatePath>true</TruncatePath>\
            <RefererList>\
            <Referer>http://www.aliyun.com</Referer>\
            <Referer>https://www.aliyun.com</Referer>\
            </RefererList>\
            <RefererBlacklist>\
            <Referer>http://www.refuse.com</Referer>\
            <Referer>https://*.hack.com</Referer>\
            </RefererBlacklist>\
            </RefererConfiguration>
            """
        request = PutBucketRefererRequest(
            refererConfiguration: RefererConfiguration(
                allowEmptyReferer: false,
                allowTruncateQueryString: true,
                truncatePath: true,
                refererList: RefererList(referers: ["http://www.aliyun.com", "https://www.aliyun.com"]),
                refererBlacklist: RefererBlacklist(referers: ["http://www.refuse.com", "https://*.hack.com"])
            )
        )
        try Serde.serializeInput(&request, &input, [Serde.serializePutBucketReferer])
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
    }

    func testDeserializeGetBucketReferer() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = GetBucketRefererResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketReferer]))

        // normal
        let xml =
            """
            <RefererConfiguration>\
            <AllowEmptyReferer>false</AllowEmptyReferer>\
            <AllowTruncateQueryString>true</AllowTruncateQueryString>\
            <TruncatePath>true</TruncatePath>\
            <RefererList>\
            <Referer>http://www.aliyun.com</Referer>\
            <Referer>https://www.aliyun.com</Referer>\
            </RefererList>\
            <RefererBlacklist>\
            <Referer>http://www.refuse.com</Referer>\
            <Referer>https://*.hack.com</Referer>\
            </RefererBlacklist>\
            </RefererConfiguration>
            """
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = GetBucketRefererResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketReferer]))
        XCTAssertEqual(result.refererConfiguration?.allowEmptyReferer, false)
        XCTAssertEqual(result.refererConfiguration?.allowTruncateQueryString, true)
        XCTAssertEqual(result.refererConfiguration?.truncatePath, true)
        XCTAssertEqual(result.refererConfiguration?.refererList?.referers, ["http://www.aliyun.com", "https://www.aliyun.com"])
        XCTAssertEqual(result.refererConfiguration?.refererBlacklist?.referers, ["http://www.refuse.com", "https://*.hack.com"])
    }
}
