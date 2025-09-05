import AlibabaCloudOSS
import Foundation



/// The container that stores TLS version configurations.
public struct TLS: Sendable {

    /// Specifies whether to enable TLS version management for the bucket.Valid values:*   true            *   false            
    public var enable: Swift.Bool?

    /// The TLS versions.
    public var tlsVersions: [Swift.String]?

    public init( 
        enable: Swift.Bool? = nil,
        tlsVersions: [Swift.String]? = nil,
    ) {
        self.enable = enable
        self.tlsVersions = tlsVersions
    }
}

extension TLS: Codable {
    enum CodingKeys: String, CodingKey { 
        case enable = "Enable"
    
        case tlsVersions = "TLSVersion"
    
    }
}


/// The container that stores Transport Layer Security (TLS) version configurations.
public struct HttpsConfiguration: Sendable {

    /// The container that stores TLS version configurations.
    public var tls: TLS?

    public init( 
        tls: TLS? = nil,
    ) {
        self.tls = tls
    }
}

extension HttpsConfiguration: Codable {
    enum CodingKeys: String, CodingKey { 
        case tls = "TLS"
    
    }
}




/// The request for the GetBucketHttpsConfig operation.
public struct GetBucketHttpsConfigRequest : RequestModel {
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

/// The result for the GetBucketHttpsConfig operation.
public struct GetBucketHttpsConfigResult : ResultModel {
    public var commonProp: ResultModelProp = .init()
 
    /// The container that stores HTTPS configurations.
    public var httpsConfiguration: HttpsConfiguration?
     
}

/// The request for the PutBucketHttpsConfig operation.
public struct PutBucketHttpsConfigRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// This name of the bucket.
    public var bucket: Swift.String? 
    
    /// The request body schema.
    public var httpsConfiguration: HttpsConfiguration?
    

    public init( 
        bucket: Swift.String? = nil,
        httpsConfiguration: HttpsConfiguration? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.httpsConfiguration = httpsConfiguration
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the PutBucketHttpsConfig operation.
public struct PutBucketHttpsConfigResult : ResultModel {
    public var commonProp: ResultModelProp = .init()

}

