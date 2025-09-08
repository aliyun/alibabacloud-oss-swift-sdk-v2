import AlibabaCloudOSS
import XCTest

class SdkInfoTests: XCTestCase {
    func testVersion() {
        XCTAssertTrue(SdkInfo.version().contains("0.1."))
    }

    func testName() {
        XCTAssertEqual("alibabacloud-swift-sdk-v2", SdkInfo.name())
    }
}
