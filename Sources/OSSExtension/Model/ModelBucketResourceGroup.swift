import AlibabaCloudOSS
import Foundation



/// The configurations of the resource group to which the bucket belongs.
public struct BucketResourceGroupConfiguration: Sendable {

    /// The ID of the resource group to which the bucket belongs.
    public var resourceGroupId: Swift.String?

    public init( 
        resourceGroupId: Swift.String? = nil,
    ) { 
        self.resourceGroupId = resourceGroupId
    }
}

extension BucketResourceGroupConfiguration: Codable {
    enum CodingKeys: String, CodingKey { 
        case resourceGroupId = "ResourceGroupId"
    
    }
}




/// The request for the GetBucketResourceGroup operation.
public struct GetBucketResourceGroupRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket that you want to query.
    public var bucket: Swift.String? 
    

    public init( 
        bucket: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the GetBucketResourceGroup operation.
public struct GetBucketResourceGroupResult : ResultModel {
    public var commonProp: ResultModelProp = .init()
 
    /// The container that stores the ID of the resource group.
    public var bucketResourceGroupConfiguration: BucketResourceGroupConfiguration?
     
}

/// The request for the PutBucketResourceGroup operation.
public struct PutBucketResourceGroupRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The bucket for which you want to modify the ID of the resource group.
    public var bucket: Swift.String? 
    
    /// The request body schema.
    public var bucketResourceGroupConfiguration: BucketResourceGroupConfiguration?
    

    public init( 
        bucket: Swift.String? = nil,
        bucketResourceGroupConfiguration: BucketResourceGroupConfiguration? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.bucketResourceGroupConfiguration = bucketResourceGroupConfiguration
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the PutBucketResourceGroup operation.
public struct PutBucketResourceGroupResult : ResultModel {
    public var commonProp: ResultModelProp = .init()

}

