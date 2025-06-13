
public enum SdkInfo {
    // version
    static let major: String = "0"
    static let minor: String = "1"
    static let patch: String = "1"
    static let tag: String = ""

    // sdk name
    static let sdkName: String = "alibabacloud-swift-sdk-v2"

    public static func version() -> String {
        return "\(major).\(minor).\(patch)\(tag)"
    }

    public static func name() -> String {
        return "\(sdkName)"
    }
}
