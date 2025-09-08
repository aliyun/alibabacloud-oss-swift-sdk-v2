import AlibabaCloudOSS
import Foundation

/// The container in which the Block Public Access configurations are stored.
public struct PublicAccessBlockConfiguration: Sendable {

    /// Specifies whether to enable Block Public Access.
    /// true: enables Block Public Access.
    /// false (default): disables Block Public Access.
    public var blockPublicAccess: Swift.Bool?

    public init(
        blockPublicAccess: Swift.Bool? = nil
    ) {
        self.blockPublicAccess = blockPublicAccess
    }
}

extension PublicAccessBlockConfiguration: Codable {
    enum CodingKeys: String, CodingKey {
        case blockPublicAccess = "BlockPublicAccess"
    
    }
}


/// The request for the GetPublicAccessBlock operation.
public struct GetPublicAccessBlockRequest : RequestModel {
    public var commonProp: RequestModelProp


    public init( 
        commonProp: RequestModelProp? = nil
    ) { 
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the GetPublicAccessBlock operation.
public struct GetPublicAccessBlockResult : ResultModel {
    public var commonProp: ResultModelProp = .init()
 
    /// The container in which the Block Public Access configurations are stored.
    public var publicAccessBlockConfiguration: PublicAccessBlockConfiguration?
     
}

/// The request for the PutPublicAccessBlock operation.
public struct PutPublicAccessBlockRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// Request body.
    public var publicAccessBlockConfiguration: PublicAccessBlockConfiguration?
    

    public init( 
        publicAccessBlockConfiguration: PublicAccessBlockConfiguration? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.publicAccessBlockConfiguration = publicAccessBlockConfiguration
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the PutPublicAccessBlock operation.
public struct PutPublicAccessBlockResult : ResultModel {
    public var commonProp: ResultModelProp = .init()

}

/// The request for the DeletePublicAccessBlock operation.
public struct DeletePublicAccessBlockRequest : RequestModel {
    public var commonProp: RequestModelProp


    public init( 
        commonProp: RequestModelProp? = nil
    ) { 
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the DeletePublicAccessBlock operation.
public struct DeletePublicAccessBlockResult : ResultModel {
    public var commonProp: ResultModelProp = .init()

}

