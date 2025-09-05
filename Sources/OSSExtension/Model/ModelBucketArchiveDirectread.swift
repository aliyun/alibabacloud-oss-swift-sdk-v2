import AlibabaCloudOSS
import Foundation



/// The container that stores the configurations for real-time access of Archive objects.
public struct ArchiveDirectReadConfiguration: Sendable {

    /// Specifies whether to enable real-time access of Archive objects for a bucket.
    /// Valid values:
    /// - true
    /// - false
    public var enabled: Swift.Bool?

    public init( 
        enabled: Swift.Bool? = nil,
    ) { 
        self.enabled = enabled
    }
}

extension ArchiveDirectReadConfiguration: Codable {
    enum CodingKeys: String, CodingKey { 
        case enabled = "Enabled"
    }
}




/// The request for the GetBucketArchiveDirectRead operation.
public struct GetBucketArchiveDirectReadRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    

    public init( 
        bucket: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the GetBucketArchiveDirectRead operation.
public struct GetBucketArchiveDirectReadResult : ResultModel {
    public var commonProp: ResultModelProp = .init()
 
    /// The container that stores the configurations for real-time access of Archive objects.
    public var archiveDirectReadConfiguration: ArchiveDirectReadConfiguration?
     
}

/// The request for the PutBucketArchiveDirectRead operation.
public struct PutBucketArchiveDirectReadRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// The request body.
    public var archiveDirectReadConfiguration: ArchiveDirectReadConfiguration?
    

    public init( 
        bucket: Swift.String? = nil,
        archiveDirectReadConfiguration: ArchiveDirectReadConfiguration? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.archiveDirectReadConfiguration = archiveDirectReadConfiguration
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the PutBucketArchiveDirectRead operation.
public struct PutBucketArchiveDirectReadResult : ResultModel {
    public var commonProp: ResultModelProp = .init()

}

