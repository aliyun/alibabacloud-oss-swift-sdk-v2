import AlibabaCloudOSS
import XCTest

class SdkInfoTests: XCTestCase {
    func testVersion() {
        XCTAssertEqual("0.1.1", SdkInfo.version())
    }

    func testName() {
        XCTAssertEqual("alibabacloud-swift-sdk-v2", SdkInfo.name())
    }
}
