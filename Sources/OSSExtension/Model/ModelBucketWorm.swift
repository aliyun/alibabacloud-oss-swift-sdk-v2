import AlibabaCloudOSS
import Foundation


/// The status of the retention policy
public enum BucketWormStateType: String { 
    case inProgress = "InProgress"
    case locked = "Locked"
}


/// The container that stores the information about retention policies of the bucket.
public struct WormConfiguration {

    /// The ID of the retention policy.Note If the specified retention policy ID that is used to query the retention policy configurations of the bucket does not exist, OSS returns the 404 error code.
    public var wormId: Swift.String?

    /// The status of the retention policy. Valid values:
    /// - InProgress: indicates that the retention policy is in the InProgress state. By default, a retention policy is in the InProgress state after it is created. The policy remains in this state for 24 hours.
    /// - Locked: indicates that the retention policy is in the Locked state.
    /// Sees BucketWormStateType for supported values.
    public var state: Swift.String?

    /// The number of days for which objects can be retained.
    public var retentionPeriodInDays: Swift.Int?

    /// The time at which the retention policy was created.
    public var creationDate: Swift.String?

    /// The time at which the retention policy will be expired.
    public var expirationDate: Swift.String?

    public init( 
        wormId: Swift.String? = nil,
        state: Swift.String? = nil,
        retentionPeriodInDays: Swift.Int? = nil,
        creationDate: Swift.String? = nil,
        expirationDate: Swift.String? = nil,
    ) { 
        self.wormId = wormId
        self.state = state
        self.retentionPeriodInDays = retentionPeriodInDays
        self.creationDate = creationDate
        self.expirationDate = expirationDate
    }
}

extension WormConfiguration: Codable {
    enum CodingKeys: String, CodingKey {
        case wormId = "WormId"
        case state = "State"
        case retentionPeriodInDays = "RetentionPeriodInDays"
        case creationDate = "CreationDate"
        case expirationDate = "ExpirationDate"
    }
}

/// The container that stores the root node.
public struct InitiateWormConfiguration : Sendable {

    /// The number of days for which objects can be retained.
    public var retentionPeriodInDays: Swift.Int?

    public init( 
        retentionPeriodInDays: Swift.Int? = nil,
    ) { 
        self.retentionPeriodInDays = retentionPeriodInDays
    }
}

extension InitiateWormConfiguration: Codable {
    enum CodingKeys: String, CodingKey {
        case retentionPeriodInDays = "RetentionPeriodInDays"
    }
}

/// The container that stores the root node.
public struct ExtendWormConfiguration : Sendable {

    /// The number of days for which objects can be retained.
    public var retentionPeriodInDays: Swift.Int?

    public init( 
        retentionPeriodInDays: Swift.Int? = nil,
    ) { 
        self.retentionPeriodInDays = retentionPeriodInDays
    }
}

extension ExtendWormConfiguration: Codable {
    enum CodingKeys: String, CodingKey {
        case retentionPeriodInDays = "RetentionPeriodInDays"
    }
}

/// The request for the InitiateBucketWorm operation.
public struct InitiateBucketWormRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// The container of the request body.
    public var initiateWormConfiguration: InitiateWormConfiguration?
    

    public init( 
        bucket: Swift.String? = nil,
        initiateWormConfiguration: InitiateWormConfiguration? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.initiateWormConfiguration = initiateWormConfiguration
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the InitiateBucketWorm operation.
public struct InitiateBucketWormResult : ResultModel {
    public var commonProp: ResultModelProp = ResultModelProp()
 
    /// <no value>
    public var wormId: Swift.String? { get { return self.commonProp.headers?["x-oss-worm-id"] } } 
     
}

/// The request for the AbortBucketWorm operation.
public struct AbortBucketWormRequest : RequestModel {
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

/// The result for the AbortBucketWorm operation.
public struct AbortBucketWormResult : ResultModel {
    public var commonProp: ResultModelProp = ResultModelProp()

}

/// The request for the CompleteBucketWorm operation.
public struct CompleteBucketWormRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// The ID of the retention policy.
    public var wormId: Swift.String?
    

    public init( 
        bucket: Swift.String? = nil,
        wormId: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.wormId = wormId
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the CompleteBucketWorm operation.
public struct CompleteBucketWormResult : ResultModel {
    public var commonProp: ResultModelProp = ResultModelProp()

}

/// The request for the ExtendBucketWorm operation.
public struct ExtendBucketWormRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// The ID of the retention policy.  If the ID of the retention policy that specifies the number of days for which objects can be retained does not exist, the HTTP status code 404 is returned.
    public var wormId: Swift.String?
    
    /// The container of the request body.
    public var extendWormConfiguration: ExtendWormConfiguration?
    

    public init( 
        bucket: Swift.String? = nil,
        wormId: Swift.String? = nil,
        extendWormConfiguration: ExtendWormConfiguration? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.wormId = wormId
        self.extendWormConfiguration = extendWormConfiguration
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the ExtendBucketWorm operation.
public struct ExtendBucketWormResult : ResultModel {
    public var commonProp: ResultModelProp = ResultModelProp()

}

/// The request for the GetBucketWorm operation.
public struct GetBucketWormRequest : RequestModel {
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

/// The result for the GetBucketWorm operation.
public struct GetBucketWormResult : ResultModel {
    public var commonProp: ResultModelProp = ResultModelProp()
 
    /// The container that stores the information about retention policies of the bucket.
    public var wormConfiguration: WormConfiguration?
     
}

