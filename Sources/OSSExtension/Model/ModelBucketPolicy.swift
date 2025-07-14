import AlibabaCloudOSS
import Foundation



/// The container that stores public access information.
public struct PolicyStatus: Sendable {

    /// Indicates whether the current bucket policy allows public access.truefalse
    public var isPublic: Swift.Bool?

    public init( 
        isPublic: Swift.Bool? = nil,
    ) { 
        self.isPublic = isPublic
    }
}

extension PolicyStatus: Codable {
    enum CodingKeys: String, CodingKey { 
        case isPublic = "IsPublic"
    }
}




/// The request for the PutBucketPolicy operation.
public struct PutBucketPolicyRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// The request parameters.
    public var body: ByteStream?
    

    public init( 
        bucket: Swift.String? = nil,
        body: ByteStream? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.body = body
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the PutBucketPolicy operation.
public struct PutBucketPolicyResult : ResultModel {
    public var commonProp: ResultModelProp = .init()

}

/// The request for the GetBucketPolicy operation.
public struct GetBucketPolicyRequest : RequestModel {
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

/// The result for the GetBucketPolicy operation.
public struct GetBucketPolicyResult : ResultModel {
    public var commonProp: ResultModelProp = .init()
 
    /// <no value>
    public var body: ByteStream?
     
}

/// The request for the DeleteBucketPolicy operation.
public struct DeleteBucketPolicyRequest : RequestModel {
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

/// The result for the DeleteBucketPolicy operation.
public struct DeleteBucketPolicyResult : ResultModel {
    public var commonProp: ResultModelProp = .init()

}

/// The request for the GetBucketPolicyStatus operation.
public struct GetBucketPolicyStatusRequest : RequestModel {
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

/// The result for the GetBucketPolicyStatus operation.
public struct GetBucketPolicyStatusResult : ResultModel {
    public var commonProp: ResultModelProp = .init()
 
    /// The container that stores public access information.
    public var policyStatus: PolicyStatus?
     
}

