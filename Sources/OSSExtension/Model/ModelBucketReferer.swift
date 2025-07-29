import AlibabaCloudOSS
import Foundation



/// The container that stores the Referer whitelist.  ****The PutBucketReferer operation overwrites the existing Referer whitelist with the Referer whitelist specified in RefererList. If RefererList is not specified in the request, which specifies that no Referer elements are included, the operation clears the existing Referer whitelist.
public struct RefererList: Sendable {

    /// The addresses in the Referer whitelist.
    public var referers: [Swift.String]?

    public init( 
        referers: [Swift.String]? = nil,
    ) { 
        self.referers = referers
    }
}

extension RefererList: Codable {
    enum CodingKeys: String, CodingKey { 
        case referers = "Referer"
    
    }
}


/// The container that stores the Referer blacklist.
public struct RefererBlacklist: Sendable {

    /// The addresses in the Referer blacklist.
    public var referers: [Swift.String]?

    public init( 
        referers: [Swift.String]? = nil,
    ) { 
        self.referers = referers
    }
}

extension RefererBlacklist: Codable {
    enum CodingKeys: String, CodingKey { 
        case referers = "Referer"
    
    }
}


/// The container that stores the hotlink protection configurations.
public struct RefererConfiguration: Sendable {

    /// Specifies whether to allow a request whose Referer field is empty. Valid values:
    /// *   true (default)
    /// *   false
    public var allowEmptyReferer: Swift.Bool?

    /// Specifies whether to truncate the query string in the URL when the Referer is matched. Valid values:
    /// *   true (default)
    /// *   false
    public var allowTruncateQueryString: Swift.Bool?

    /// Specifies whether to truncate the path and parts that follow the path in the URL when the Referer is matched. Valid values:
    /// *   true
    /// *   false
    public var truncatePath: Swift.Bool?

    /// The container that stores the Referer whitelist.  ****The PutBucketReferer operation overwrites the existing Referer whitelist with the Referer whitelist specified in RefererList. If RefererList is not specified in the request, which specifies that no Referer elements are included, the operation clears the existing Referer whitelist.
    public var refererList: RefererList?

    /// The container that stores the Referer blacklist.
    public var refererBlacklist: RefererBlacklist?

    public init( 
        allowEmptyReferer: Swift.Bool? = nil,
        allowTruncateQueryString: Swift.Bool? = nil,
        truncatePath: Swift.Bool? = nil,
        refererList: RefererList? = nil,
        refererBlacklist: RefererBlacklist? = nil,
    ) { 
        self.allowEmptyReferer = allowEmptyReferer
        self.allowTruncateQueryString = allowTruncateQueryString
        self.truncatePath = truncatePath
        self.refererList = refererList
        self.refererBlacklist = refererBlacklist
    }
}

extension RefererConfiguration: Codable {
    enum CodingKeys: String, CodingKey { 
        case allowEmptyReferer = "AllowEmptyReferer"
    
        case allowTruncateQueryString = "AllowTruncateQueryString"
    
        case truncatePath = "TruncatePath"
    
        case refererList = "RefererList"
    
        case refererBlacklist = "RefererBlacklist"
    
    }
}




/// The request for the PutBucketReferer operation.
public struct PutBucketRefererRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// The request body schema.
    public var refererConfiguration: RefererConfiguration?
    

    public init( 
        bucket: Swift.String? = nil,
        refererConfiguration: RefererConfiguration? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.refererConfiguration = refererConfiguration
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the PutBucketReferer operation.
public struct PutBucketRefererResult : ResultModel {
    public var commonProp: ResultModelProp = .init()

}

/// The request for the GetBucketReferer operation.
public struct GetBucketRefererRequest : RequestModel {
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

/// The result for the GetBucketReferer operation.
public struct GetBucketRefererResult : ResultModel {
    public var commonProp: ResultModelProp = .init()
 
    /// The container that stores the hotlink protection configurations.
    public var refererConfiguration: RefererConfiguration?
     
}

