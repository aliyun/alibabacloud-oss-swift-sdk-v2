import AlibabaCloudOSS
import Foundation


/// The request for the GetBucketPublicAccessBlock operation.
public struct GetBucketPublicAccessBlockRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// 
    public var bucket: Swift.String? 
    

    public init( 
        bucket: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the GetBucketPublicAccessBlock operation.
public struct GetBucketPublicAccessBlockResult : ResultModel {
    public var commonProp: ResultModelProp = .init()
 
    /// The container in which the Block Public Access configurations are stored.
    public var publicAccessBlockConfiguration: PublicAccessBlockConfiguration?
     
}

/// The request for the PutBucketPublicAccessBlock operation.
public struct PutBucketPublicAccessBlockRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// Request body.
    public var publicAccessBlockConfiguration: PublicAccessBlockConfiguration?
    

    public init( 
        bucket: Swift.String? = nil,
        publicAccessBlockConfiguration: PublicAccessBlockConfiguration? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.publicAccessBlockConfiguration = publicAccessBlockConfiguration
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the PutBucketPublicAccessBlock operation.
public struct PutBucketPublicAccessBlockResult : ResultModel {
    public var commonProp: ResultModelProp = .init()

}

/// The request for the DeleteBucketPublicAccessBlock operation.
public struct DeleteBucketPublicAccessBlockRequest : RequestModel {
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

/// The result for the DeleteBucketPublicAccessBlock operation.
public struct DeleteBucketPublicAccessBlockResult : ResultModel {
    public var commonProp: ResultModelProp = .init()

}

