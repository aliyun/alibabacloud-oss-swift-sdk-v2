import AlibabaCloudOSS
import Foundation



/// A short description of struct
public enum AccessMonitorStatusType: String { 
    case enabled = "Enabled"
    case disabled = "Disabled"
}


/// The container that stores access monitor configuration.
public struct AccessMonitorConfiguration: Sendable {

    /// The access tracking status of the bucket. Valid values:
    /// - Enabled: Access tracking is enabled.
    /// - Disabled: Access tracking is disabled.
    /// Sees AccessMonitorStatusType for supported values.
    public var status: Swift.String?

    public init( 
        status: Swift.String? = nil
    ) { 
        self.status = status
    }
}

extension AccessMonitorConfiguration: Codable {
    enum CodingKeys: String, CodingKey { 
        case status = "Status"
    
    }
}




/// The request for the PutBucketAccessMonitor operation.
public struct PutBucketAccessMonitorRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// The request body schema.
    public var accessMonitorConfiguration: AccessMonitorConfiguration?
    

    public init( 
        bucket: Swift.String? = nil,
        accessMonitorConfiguration: AccessMonitorConfiguration? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.accessMonitorConfiguration = accessMonitorConfiguration
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the PutBucketAccessMonitor operation.
public struct PutBucketAccessMonitorResult : ResultModel {
    public var commonProp: ResultModelProp = .init()

}

/// The request for the GetBucketAccessMonitor operation.
public struct GetBucketAccessMonitorRequest : RequestModel {
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

/// The result for the GetBucketAccessMonitor operation.
public struct GetBucketAccessMonitorResult : ResultModel {
    public var commonProp: ResultModelProp = .init()
 
    /// The container that stores access monitor configuration.
    public var accessMonitorConfiguration: AccessMonitorConfiguration?
     
}

