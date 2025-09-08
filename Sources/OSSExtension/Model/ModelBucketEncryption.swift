import AlibabaCloudOSS
import Foundation



/// The container that stores the default server-side encryption method.
public struct ApplyServerSideEncryptionByDefault: Sendable {

    /// The default server-side encryption method. Valid values: KMS, AES256, and SM4. You are charged when you call API operations to encrypt or decrypt data by using CMKs managed by KMS. For more information, see [Billing of KMS](~~52608~~). If the default server-side encryption method is configured for the destination bucket and ReplicaCMKID is configured in the CRR rule:
    /// *   If objects in the source bucket are not encrypted, they are encrypted by using the default encryption method of the destination bucket after they are replicated.
    /// *   If objects in the source bucket are encrypted by using SSE-KMS or SSE-OSS, they are encrypted by using the same method after they are replicated.For more information, see [Use data replication with server-side encryption](~~177216~~).
    public var sseAlgorithm: Swift.String?

    /// The CMK ID that is specified when SSEAlgorithm is set to KMS and a specified CMK is used for encryption. In other cases, leave this parameter empty.
    public var kmsMasterKeyID: Swift.String?

    /// The algorithm that is used to encrypt objects. If this parameter is not specified, objects are encrypted by using AES256. This parameter is valid only when SSEAlgorithm is set to KMS. Valid value: SM4.
    public var kmsDataEncryption: Swift.String?

    public init( 
        sseAlgorithm: Swift.String? = nil,
        kmsMasterKeyID: Swift.String? = nil,
        kmsDataEncryption: Swift.String? = nil
    ) {
        self.sseAlgorithm = sseAlgorithm
        self.kmsMasterKeyID = kmsMasterKeyID
        self.kmsDataEncryption = kmsDataEncryption
    }
}

extension ApplyServerSideEncryptionByDefault: Codable {
    enum CodingKeys: String, CodingKey { 
        case sseAlgorithm = "SSEAlgorithm"
    
        case kmsMasterKeyID = "KMSMasterKeyID"
    
        case kmsDataEncryption = "KMSDataEncryption"
    
    }
}


/// The container that stores server-side encryption rules.
public struct ServerSideEncryptionRule: Sendable {

    /// The container that stores the default server-side encryption method.
    public var applyServerSideEncryptionByDefault: ApplyServerSideEncryptionByDefault?

    public init( 
        applyServerSideEncryptionByDefault: ApplyServerSideEncryptionByDefault? = nil
    ) { 
        self.applyServerSideEncryptionByDefault = applyServerSideEncryptionByDefault
    }
}

extension ServerSideEncryptionRule: Codable {
    enum CodingKeys: String, CodingKey { 
        case applyServerSideEncryptionByDefault = "ApplyServerSideEncryptionByDefault"
    
    }
}




/// The request for the PutBucketEncryption operation.
public struct PutBucketEncryptionRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// The request body schema.
    public var serverSideEncryptionRule: ServerSideEncryptionRule?
    

    public init( 
        bucket: Swift.String? = nil,
        serverSideEncryptionRule: ServerSideEncryptionRule? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.serverSideEncryptionRule = serverSideEncryptionRule
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the PutBucketEncryption operation.
public struct PutBucketEncryptionResult : ResultModel {
    public var commonProp: ResultModelProp = .init()

}

/// The request for the GetBucketEncryption operation.
public struct GetBucketEncryptionRequest : RequestModel {
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

/// The result for the GetBucketEncryption operation.
public struct GetBucketEncryptionResult : ResultModel {
    public var commonProp: ResultModelProp = .init()
 
    /// The container that stores server-side encryption rules.
    public var serverSideEncryptionRule: ServerSideEncryptionRule?
     
}

/// The request for the DeleteBucketEncryption operation.
public struct DeleteBucketEncryptionRequest : RequestModel {
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

/// The result for the DeleteBucketEncryption operation.
public struct DeleteBucketEncryptionResult : ResultModel {
    public var commonProp: ResultModelProp = .init()

}

