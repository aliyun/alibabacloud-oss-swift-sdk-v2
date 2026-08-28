@testable import AlibabaCloudOSS
import XCTest

final class BucketSpaceHelperTests: XCTestCase {
    func testBucketSpaceHelperToBucketName() {
        let helper = BucketSpaceHelper(accountId: "137", region: "cn-hangzhou")
        XCTAssertEqual(helper.toBucketName("prefix"), "prefix-137-cn-hangzhou-bs-apsr")

        let config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withAccountId("137")
        let fromConfig = BucketSpaceHelper(config: config)
        XCTAssertEqual(fromConfig.toBucketName("prefix"), "prefix-137-cn-hangzhou-bs-apsr")
    }
}
