import Foundation

public enum Defaults {
    public static let product: String = "oss"

    public static let maxAttempt: Int = 3
    public static let maxBackoff: TimeInterval = 20
    public static let baseDelay: TimeInterval = 0.3
    
    public static let timeoutIntervalForRequest: TimeInterval = 15
    public static let timeoutIntervalForResource: TimeInterval = 24 * 60 * 60
    
    public static let httpProtocal = "https"

    // defaults for feature flags
    public static let featureFlags: FeatureFlag = [.correctClockSkew, .autoDetectMimeType, .enableCRC64CheckUpload, .enableCRC64CheckDownload]
}
