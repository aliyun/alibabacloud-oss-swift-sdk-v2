import Foundation

// MARK: - public

public enum SignerVersion {
    case v1
    case v4
}

public enum OperationMetaKey: String {
    case additionalHeaderNames
    case progressHandler
    case interceptors
    case networkInterceptors
    case responseHandlers
}

public enum EndpointType {
    case defautt
    case `internal`
    case accelerate
    case dualstack
    case overseas
}

public enum AddressStyleType {
    case virtualHosted
    case cname
    case path
    case virtualHostedAlias
}

public enum HttpProtocal: String {
    case http
    case https
}

// MARK: - Feature flags

public struct FeatureFlag: OptionSet, Sendable {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    /// If the client time is different from server time by more than about 15 minutes,
    /// the requests your application makes will be signed with the incorrect time, and the server will reject them.
    /// The feature to help to identify this case, and SDK will correct for clock skew.
    public static let correctClockSkew = FeatureFlag(rawValue: 1 << 0)

    public static let enableMD5 = FeatureFlag(rawValue: 1 << 1)

    /// Content-Type is automatically added based on the object name if not specified.
    /// This feature takes effect for PutObject, AppendObject and InitiateMultipartUpload
    public static let autoDetectMimeType = FeatureFlag(rawValue: 1 << 2)

    /// Check data integrity of uploads via the crc64.
    public static let enableCRC64CheckUpload = FeatureFlag(rawValue: 1 << 3)

    /// Check data integrity of downloads via the crc64.
    public static let enableCRC64CheckDownload = FeatureFlag(rawValue: 1 << 4)
}

// MARK: - private

enum Pattern: String {
    case endpointPattern = "^[a-zA-Z0-9._-]+$"
    case regionPattern = "^[a-z0-9-]+$"
    case bucketNamePattern = "^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]$"
    case objectKeyPattern = "[^\\/]{1,1023}"
}
