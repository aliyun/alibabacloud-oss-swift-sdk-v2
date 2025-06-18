import AlibabaCloudOSS
import Foundation

/// The container that stores lifecycle rules.
/// *   A lifecycle rule cannot be configured to convert the storage class of objects in an Archive bucket.
/// *   The period of time from when the objects expire to when the objects are deleted must be longer than the period of time from when the objects expire to when the storage class of the objects is converted to IA or Archive.
public struct LifecycleRule: Sendable {

    /// The ID of the lifecycle rule. The ID can contain up to 255 characters. If you do not specify the ID, OSS automatically generates a unique ID for the lifecycle rule.
    public var id: Swift.String?

    /// Specifies whether to enable the rule. Valid values:
    /// *   Enabled: enables the rule. OSS periodically executes the rule.
    /// *   Disabled: does not enable the rule. OSS ignores the rule.
    public var status: Swift.String?

    /// The conversion of the storage class of objects that match the lifecycle rule when the objects expire. The storage class of the objects can be converted to IA, Archive, and ColdArchive. The storage class of Standard objects in a Standard bucket can be converted to IA, Archive, or Cold Archive. The period of time from when the objects expire to when the storage class of the objects is converted to Archive must be longer than the period of time from when the objects expire to when the storage class of the objects is converted to IA. For example, if the validity period is set to 30 for objects whose storage class is converted to IA after the validity period, the validity period must be set to a value greater than 30 for objects whose storage class is converted to Archive.  Either Days or CreatedBeforeDate is required.
    public var transitions: [Transition]?

    /// The tag of the objects to which the lifecycle rule applies. You can specify multiple tags.
    public var tags: [Tag]?

    /// The conversion of the storage class of previous versions of the objects that match the lifecycle rule when the previous versions expire. The storage class of the previous versions can be converted to IA or Archive. The period of time from when the previous versions expire to when the storage class of the previous versions is converted to Archive must be longer than the period of time from when the previous versions expire to when the storage class of the previous versions is converted to IA.
    public var noncurrentVersionTransitions: [NoncurrentVersionTransition]?

    /// The container that stores the Not parameter that is used to filter objects.
    public var filter: Filter?

    /// The prefix in the names of the objects to which the rule applies. The prefixes specified by different rules cannot overlap.
    /// *   If Prefix is specified, this rule applies only to objects whose names contain the specified prefix in the bucket.
    /// *   If Prefix is not specified, this rule applies to all objects in the bucket.
    public var prefix: Swift.String?

    /// The delete operation to perform on objects based on the lifecycle rule. For an object in a versioning-enabled bucket, the delete operation specified by this parameter is performed only on the current version of the object.The period of time from when the objects expire to when the objects are deleted must be longer than the period of time from when the objects expire to when the storage class of the objects is converted to IA or Archive.
    public var expiration: Expiration?

    /// The delete operation that you want OSS to perform on the parts that are uploaded in incomplete multipart upload tasks when the parts expire.
    public var abortMultipartUpload: AbortMultipartUpload?

    /// The delete operation that you want OSS to perform on the previous versions of the objects that match the lifecycle rule when the previous versions expire.
    public var noncurrentVersionExpiration: NoncurrentVersionExpiration?

    /// Timestamp for when access tracking was enabled.
    public var atimeBase: Swift.Int?

    public init( 
        id: Swift.String? = nil,
        status: Swift.String? = nil,
        prefix: Swift.String? = nil,
        transitions: [Transition]? = nil,
        tags: [Tag]? = nil,
        noncurrentVersionTransitions: [NoncurrentVersionTransition]? = nil,
        filter: Filter? = nil,
        expiration: Expiration? = nil,
        abortMultipartUpload: AbortMultipartUpload? = nil,
        noncurrentVersionExpiration: NoncurrentVersionExpiration? = nil,
        atimeBase: Swift.Int? = nil,
    ) { 
        self.id = id
        self.status = status
        self.transitions = transitions
        self.tags = tags
        self.noncurrentVersionTransitions = noncurrentVersionTransitions
        self.filter = filter
        self.prefix = prefix
        self.expiration = expiration
        self.abortMultipartUpload = abortMultipartUpload
        self.noncurrentVersionExpiration = noncurrentVersionExpiration
        self.atimeBase = atimeBase
    }
}

extension LifecycleRule: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case status = "Status"
        case transitions = "Transition"
        case tags = "Tag"
        case noncurrentVersionTransitions = "NoncurrentVersionTransition"
        case filter = "Filter"
        case prefix = "Prefix"
        case expiration = "Expiration"
        case abortMultipartUpload = "AbortMultipartUpload"
        case noncurrentVersionExpiration = "NoncurrentVersionExpiration"
        case atimeBase = "AtimeBase"
    }
}

/// The container that stores lifecycle configurations. The container can contain up to 1,000 lifecycle rules.
public struct LifecycleConfiguration: Sendable {

    /// The container that stores the lifecycle rules. The period of time after which objects expire must be longer than the period of time after which the storage class of the same objects is converted to Infrequent Access (IA) or Archive.
    public var rules: [LifecycleRule]?

    public init( 
        rules: [LifecycleRule]? = nil,
    ) { 
        self.rules = rules
    }
}

extension LifecycleConfiguration: Codable {
    enum CodingKeys: String, CodingKey {
        case rules = "Rule"
    }
}

/// The conversion of the storage class of objects that match the lifecycle rule when the objects expire. The storage class of the objects can be converted to IA, Archive, and ColdArchive. The storage class of Standard objects in a Standard bucket can be converted to IA, Archive, or Cold Archive. The period of time from when the objects expire to when the storage class of the objects is converted to Archive must be longer than the period of time from when the objects expire to when the storage class of the objects is converted to IA. For example, if the validity period is set to 30 for objects whose storage class is converted to IA after the validity period, the validity period must be set to a value greater than 30 for objects whose storage class is converted to Archive.  Either Days or CreatedBeforeDate is required.
public struct Transition: Sendable {

    /// Specifies whether to convert the storage class of non-Standard objects back to Standard after the objects are accessed. This parameter takes effect only when the IsAccessTime parameter is set to true. Valid values:*   true: converts the storage class of the objects to Standard.*   false: does not convert the storage class of the objects to Standard.
    public var returnToStdWhenVisit: Swift.Bool?

    /// Specifies whether to convert the storage class of objects whose sizes are less than 64 KB to IA, Archive, or Cold Archive based on their last access time. Valid values:
    /// *   true: converts the storage class of objects that are smaller than 64 KB to IA, Archive, or Cold Archive. Objects that are smaller than 64 KB are charged as 64 KB. Objects that are greater than or equal to 64 KB are charged based on their actual sizes. If you set this parameter to true, the storage fees may increase.
    /// *   false: does not convert the storage class of an object that is smaller than 64 KB.
    public var allowSmallFile: Swift.Bool?

    /// The date based on which the lifecycle rule takes effect. OSS performs the specified operation on data whose last modified date is earlier than this date. Specify the time in the ISO 8601 standard. The time must be at 00:00:00 in UTC.
    public var createdBeforeDate: Date?

    /// The number of days from when the objects were last modified to when the lifecycle rule takes effect.
    public var days: Swift.Int?

    /// The storage class to which objects are converted. Valid values:
    /// *   IA
    /// *   Archive
    /// *   ColdArchive
    /// You can convert the storage class of objects in an IA bucket to only Archive or Cold Archive.
    /// Sees StorageClassType for supported values.
    public var storageClass: Swift.String?

    /// Specifies whether the lifecycle rule applies to objects based on their last access time. Valid values:
    /// *   true: The rule applies to objects based on their last access time.
    /// *   false: The rule applies to objects based on their last modified time.
    public var isAccessTime: Swift.Bool?

    public init( 
        returnToStdWhenVisit: Swift.Bool? = nil,
        allowSmallFile: Swift.Bool? = nil,
        createdBeforeDate: Date? = nil,
        days: Swift.Int? = nil,
        storageClass: Swift.String? = nil,
        isAccessTime: Swift.Bool? = nil,
    ) { 
        self.returnToStdWhenVisit = returnToStdWhenVisit
        self.allowSmallFile = allowSmallFile
        self.createdBeforeDate = createdBeforeDate
        self.days = days
        self.storageClass = storageClass
        self.isAccessTime = isAccessTime
    }
}

extension Transition: Codable {
    enum CodingKeys: String, CodingKey {
        case returnToStdWhenVisit = "ReturnToStdWhenVisit"
        case allowSmallFile = "AllowSmallFile"
        case createdBeforeDate = "CreatedBeforeDate"
        case days = "Days"
        case storageClass = "StorageClass"
        case isAccessTime = "IsAccessTime"
    }
}

/// The condition that is matched by objects to which the lifecycle rule does not apply.
public struct Not: Sendable {

    /// The prefix in the names of the objects to which the lifecycle rule does not apply.
    public var prefix: Swift.String?

    /// The tag of the objects to which the lifecycle rule does not apply.
    public var tag: Tag?

    public init( 
        prefix: Swift.String? = nil,
        tag: Tag? = nil,
    ) { 
        self.prefix = prefix
        self.tag = tag
    }
}

extension Not: Codable {
    enum CodingKeys: String, CodingKey {
        case prefix = "Prefix"
        case tag = "Tag"
    }
}

/// The container that stores the Not parameter that is used to filter objects.
public struct Filter: Sendable {

    /// The condition that is matched by objects to which the lifecycle rule does not apply.
    public var not: Not?

    /// This lifecycle rule only applies to files larger than this size.
    public var objectSizeGreaterThan: Swift.Int?

    /// This lifecycle rule only applies to files smaller than this size.
    public var objectSizeLessThan: Swift.Int?

    public init( 
        not: Not? = nil,
        objectSizeGreaterThan: Swift.Int? = nil,
        objectSizeLessThan: Swift.Int? = nil,
    ) { 
        self.not = not
        self.objectSizeGreaterThan = objectSizeGreaterThan
        self.objectSizeLessThan = objectSizeLessThan
    }
}

extension Filter: Codable {
    enum CodingKeys: String, CodingKey {
        case not = "Not"
        case objectSizeGreaterThan = "ObjectSizeGreaterThan"
        case objectSizeLessThan = "ObjectSizeLessThan"
    }
}

/// The delete operation that you want OSS to perform on the previous versions of the objects that match the lifecycle rule when the previous versions expire.
public struct NoncurrentVersionExpiration: Sendable {

    /// The number of days from when the objects became previous versions to when the lifecycle rule takes effect.
    public var noncurrentDays: Swift.Int?

    public init( 
        noncurrentDays: Swift.Int? = nil,
    ) { 
        self.noncurrentDays = noncurrentDays
    }
}

extension NoncurrentVersionExpiration: Codable {
    enum CodingKeys: String, CodingKey {
        case noncurrentDays = "NoncurrentDays"
    }
}

/// The conversion of the storage class of previous versions of the objects that match the lifecycle rule when the previous versions expire. The storage class of the previous versions can be converted to IA or Archive. The period of time from when the previous versions expire to when the storage class of the previous versions is converted to Archive must be longer than the period of time from when the previous versions expire to when the storage class of the previous versions is converted to IA.
public struct NoncurrentVersionTransition: Sendable {

    /// Specifies whether the lifecycle rule applies to objects based on their last access time. Valid values:
    /// *   true: The rule applies to objects based on their last access time.
    /// *   false: The rule applies to objects based on their last modified time.
    public var isAccessTime: Swift.Bool?

    /// Specifies whether to convert the storage class of non-Standard objects back to Standard after the objects are accessed. This parameter takes effect only when the IsAccessTime parameter is set to true. Valid values:
    /// *   true: converts the storage class of the objects to Standard.
    /// *   false: does not convert the storage class of the objects to Standard.
    public var returnToStdWhenVisit: Swift.Bool?

    /// Specifies whether to convert the storage class of objects whose sizes are less than 64 KB to IA, Archive, or Cold Archive based on their last access time. Valid values:
    /// *   true: converts the storage class of objects that are smaller than 64 KB to IA, Archive, or Cold Archive. Objects that are smaller than 64 KB are charged as 64 KB. Objects that are greater than or equal to 64 KB are charged based on their actual sizes. If you set this parameter to true, the storage fees may increase.
    /// *   false: does not convert the storage class of an object that is smaller than 64 KB.
    public var allowSmallFile: Swift.Bool?

    /// The number of days from when the objects became previous versions to when the lifecycle rule takes effect.
    public var noncurrentDays: Swift.Int?

    /// The storage class to which objects are converted. Valid values:
    /// *   IA
    /// *   Archive
    /// *   ColdArchive
    /// You can convert the storage class of objects in an IA bucket to only Archive or Cold Archive.
    /// Sees StorageClassType for supported values.
    public var storageClass: Swift.String?

    public init( 
        isAccessTime: Swift.Bool? = nil,
        returnToStdWhenVisit: Swift.Bool? = nil,
        allowSmallFile: Swift.Bool? = nil,
        noncurrentDays: Swift.Int? = nil,
        storageClass: Swift.String? = nil,
    ) { 
        self.isAccessTime = isAccessTime
        self.returnToStdWhenVisit = returnToStdWhenVisit
        self.allowSmallFile = allowSmallFile
        self.noncurrentDays = noncurrentDays
        self.storageClass = storageClass
    }
}

extension NoncurrentVersionTransition: Codable {
    enum CodingKeys: String, CodingKey {
        case isAccessTime = "IsAccessTime"
        case returnToStdWhenVisit = "ReturnToStdWhenVisit"
        case allowSmallFile = "AllowSmallFile"
        case noncurrentDays = "NoncurrentDays"
        case storageClass = "StorageClass"
    }
}

/// The delete operation to perform on objects based on the lifecycle rule. For an object in a versioning-enabled bucket, the delete operation specified by this parameter is performed only on the current version of the object.The period of time from when the objects expire to when the objects are deleted must be longer than the period of time from when the objects expire to when the storage class of the objects is converted to IA or Archive.
public struct Expiration: Sendable {

    /// The date based on which the lifecycle rule takes effect. OSS performs the specified operation on data whose last modified date is earlier than this date. The value of this parameter is in the yyyy-MM-ddT00:00:00.000Z format.Specify the time in the ISO 8601 standard. The time must be at 00:00:00 in UTC.
    public var createdBeforeDate: Date?

    /// The number of days from when the objects were last modified to when the lifecycle rule takes effect.
    public var days: Swift.Int?

    /// Specifies whether to automatically remove expired delete markers.
    /// *   true: Expired delete markers are automatically removed. If you set this parameter to true, you cannot specify the Days or CreatedBeforeDate parameter.
    /// *   false: Expired delete markers are not automatically removed. If you set this parameter to false, you must specify the Days or CreatedBeforeDate parameter.
    public var expiredObjectDeleteMarker: Swift.Bool?

    /// The date after which the lifecycle rule takes effect. If the specified time is earlier than the current moment, it'll takes effect immediately. (This fields is NOT RECOMMENDED, please use Days or CreateDateBefore)
    public var date: Date?

    public init( 
        createdBeforeDate: Date? = nil,
        days: Swift.Int? = nil,
        expiredObjectDeleteMarker: Swift.Bool? = nil,
        date: Date? = nil,
    ) { 
        self.createdBeforeDate = createdBeforeDate
        self.days = days
        self.expiredObjectDeleteMarker = expiredObjectDeleteMarker
        self.date = date
    }
}

extension Expiration: Codable {
    enum CodingKeys: String, CodingKey {
        case createdBeforeDate = "CreatedBeforeDate"
        case days = "Days"
        case expiredObjectDeleteMarker = "ExpiredObjectDeleteMarker"
        case date = "Date"
    }
}

/// The delete operation that you want OSS to perform on the parts that are uploaded in incomplete multipart upload tasks when the parts expire.
public struct AbortMultipartUpload: Sendable {

    /// The number of days from when the objects were last modified to when the lifecycle rule takes effect.
    public var days: Swift.Int?

    /// The date based on which the lifecycle rule takes effect. OSS performs the specified operation on data whose last modified date is earlier than this date. Specify the time in the ISO 8601 standard. The time must be at 00:00:00 in UTC.
    public var createdBeforeDate: Date?

    public init( 
        days: Swift.Int? = nil,
        createdBeforeDate: Date? = nil,
    ) { 
        self.days = days
        self.createdBeforeDate = createdBeforeDate
    }
}

extension AbortMultipartUpload: Codable {
    enum CodingKeys: String, CodingKey {
        case createdBeforeDate = "CreatedBeforeDate"
        case days = "Days"
    }
}

/// The request for the PutBucketLifecycle operation.
public struct PutBucketLifecycleRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// Specifies whether to allow overlapped prefixes. Valid values:
    /// true: Overlapped prefixes are allowed.
    /// false: Overlapped prefixes are not allowed.
    public var allowSameActionOverlap: Swift.String?
    
    /// The container of the request body.
    public var lifecycleConfiguration: LifecycleConfiguration?
    

    public init( 
        bucket: Swift.String? = nil,
        allowSameActionOverlap: Swift.String? = nil,
        lifecycleConfiguration: LifecycleConfiguration? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.allowSameActionOverlap = allowSameActionOverlap
        self.lifecycleConfiguration = lifecycleConfiguration
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the PutBucketLifecycle operation.
public struct PutBucketLifecycleResult : ResultModel {
    public var commonProp: ResultModelProp = ResultModelProp()

}

/// The request for the GetBucketLifecycle operation.
public struct GetBucketLifecycleRequest : RequestModel {
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

/// The result for the GetBucketLifecycle operation.
public struct GetBucketLifecycleResult : ResultModel {
    public var commonProp: ResultModelProp = ResultModelProp()
 
    /// The container that stores the lifecycle rules configured for the bucket.
    public var lifecycleConfiguration: LifecycleConfiguration?
     
}

/// The request for the DeleteBucketLifecycle operation.
public struct DeleteBucketLifecycleRequest : RequestModel {
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

/// The result for the DeleteBucketLifecycle operation.
public struct DeleteBucketLifecycleResult : ResultModel {
    public var commonProp: ResultModelProp = ResultModelProp()

}

