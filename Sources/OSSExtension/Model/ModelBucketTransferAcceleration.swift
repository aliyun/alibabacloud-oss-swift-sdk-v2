import Foundation
import AlibabaCloudOSS

/// The container that stores the transfer acceleration configurations.
public struct TransferAccelerationConfiguration: Sendable {

    /// Whether the transfer acceleration is enabled for this bucket.
    public var enabled: Swift.Bool?

    public init( 
        enabled: Swift.Bool? = nil,
    ) { 
        self.enabled = enabled
    }
}

extension TransferAccelerationConfiguration: Codable {
    enum CodingKeys: String, CodingKey {
        case enabled = "Enabled"
    }
}


/// The request for the PutBucketTransferAcceleration operation.
public struct PutBucketTransferAccelerationRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// The container of the request body.
    public var transferAccelerationConfiguration: TransferAccelerationConfiguration?
    

    public init( 
        bucket: Swift.String? = nil,
        transferAccelerationConfiguration: TransferAccelerationConfiguration? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.transferAccelerationConfiguration = transferAccelerationConfiguration
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the PutBucketTransferAcceleration operation.
public struct PutBucketTransferAccelerationResult: ResultModel, Sendable {
    public var commonProp: ResultModelProp = ResultModelProp()

}

/// The request for the GetBucketTransferAcceleration operation.
public struct GetBucketTransferAccelerationRequest: RequestModel {
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

/// The result for the GetBucketTransferAcceleration operation.
public struct GetBucketTransferAccelerationResult : ResultModel, Sendable {
    public var commonProp: ResultModelProp = ResultModelProp()
 
    /// The container that stores the transfer acceleration configurations.
    public var transferAccelerationConfiguration: TransferAccelerationConfiguration?
     
}

