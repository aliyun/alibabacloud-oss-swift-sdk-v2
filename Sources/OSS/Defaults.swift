import Foundation

public enum Defaults {
    public static let product: String = "oss"

    public static let maxAttempt: Int = 3
    public static let maxBackoff: TimeInterval = 20
    public static let baseDelay: TimeInterval = 0.3
    
    public static let timeoutIntervalForRequest: TimeInterval = 15
    public static let timeoutIntervalForResource: TimeInterval = 24 * 60 * 60
    
    public static let httpProtocal = "https"
    public static let tempFileSuffix = ".temp"

    public static let backgroundSesseionIdentifier = "com.aliyun.oss.backgroundsession"
    
    public static let maxUploadParts = 10000

    public static let partSize: Int = 6 * 1024 * 1024
    public static let uploadPartSize = partSize
    public static let downloadPartSize = partSize

    public static let parallel: Int = 3
    public static let uploadParallel = parallel
    public static let downloadParallel = parallel

    public static let checkpointMagic = "92611BED-89E2-46B6-89E5-72F273D4B0A3"
    public static let checkpointFileSuffixUploader = ".ucp"
    public static let checkpointFileSuffixDownloader = ".dcp"

    // defaults for feature flags
    public static let featureFlags: FeatureFlag = [.correctClockSkew, .autoDetectMimeType, .enableCRC64CheckUpload, .enableCRC64CheckDownload]
}
