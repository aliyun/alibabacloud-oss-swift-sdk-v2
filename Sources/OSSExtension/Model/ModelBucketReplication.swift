import Foundation
import AlibabaCloudOSS

/// The link used to transfer data in CRR
public enum TransferType: String { 
    case `internal` = "internal"
    case ossAcc = "oss_acc"
}


/// 
public enum HistoricalObjectReplicationType: String { 
    case enabled = "enabled"
    case disabled = "disabled"
}


/// A short description of Status
public enum StatusType: String { 
    case enabled = "Enabled"
    case disabled = "Disabled"
}


/// The container that is used to filter the source objects that are encrypted by using SSE-KMS. This parameter must be specified if the SourceSelectionCriteria parameter is specified in the data replication rule.
public struct SseKmsEncryptedObjects: Sendable {

    /// Specifies whether to replicate objects that are encrypted by using SSE-KMS. Valid values:
    /// *   Enabled
    /// *   Disabled
    /// Sees StatusType for supported values.
    public var status: Swift.String?

    public init( 
        status: Swift.String? = nil,
    ) { 
        self.status = status
    }
}

extension SseKmsEncryptedObjects: Codable {
    enum CodingKeys: String, CodingKey {
        case status = "Status"
    }
}

/// Encryption configuration for the replication rule.
public struct ReplicationEncryptionConfiguration: Sendable {

    /// The KMS key ID used for replication.
    public var replicaKmsKeyID: Swift.String?

    public init( 
        replicaKmsKeyID: Swift.String? = nil,
    ) { 
        self.replicaKmsKeyID = replicaKmsKeyID
    }
}

extension ReplicationEncryptionConfiguration: Codable {
    enum CodingKeys: String, CodingKey {
        case replicaKmsKeyID = "ReplicaKmsKeyID"
    }
}

/// The data replication rule configuration.
public struct ReplicationRule: Sendable {

    /// The container that stores the information about the destination bucket.
    public var destination: ReplicationDestination?

    /// Specifies whether to replicate historical data that exists before data replication is enabled from the source bucket to the destination bucket.
    /// Valid values:
    /// *   enabled (default): replicates historical data to the destination bucket.
    /// *   disabled: does not replicate historical data to the destination bucket. Only data uploaded to the source bucket after data replication is enabled for the source bucket is replicated.
    /// Sees HistoricalObjectReplicationType for supported values.
    public var historicalObjectReplication: Swift.String?

    /// The role that you want to authorize OSS to use to replicate data. If you want to use SSE-KMS to encrypt the objects that are replicated to the destination bucket, you must specify this parameter.
    public var syncRole: Swift.String?

    /// The encryption configuration for the objects replicated to the destination bucket. If the Status parameter is set to Enabled, you must specify this parameter.
    public var encryptionConfiguration: ReplicationEncryptionConfiguration?

    /// The container that stores the status of the RTC feature.
    public var rtc: RTC?

    /// The ID of the rule.
    public var id: Swift.String?

    /// The container that stores prefixes. You can specify up to 10 prefixes in each data replication rule.
    public var prefixSet: ReplicationPrefixSet?

    /// The operations that can be synchronized to the destination bucket. If you configure Action in a data replication rule, OSS synchronizes new data and historical data based on the specified value of Action. You can set Action to one or more of the following operation types. Valid values:
    /// *   ALL (default): PUT, DELETE, and ABORT operations are synchronized to the destination bucket.
    /// *   PUT: Write operations are synchronized to the destination bucket, including PutObject, PostObject, AppendObject, CopyObject, PutObjectACL, InitiateMultipartUpload, UploadPart, UploadPartCopy, and CompleteMultipartUpload.
    public var action: Swift.String?

    /// The status of the data replication task. Valid values:
    /// *   starting: OSS creates a data replication task after a data replication rule is configured.
    /// *   doing: The replication rule is effective and the replication task is in progress.
    /// *   closing: OSS clears a data replication task after the corresponding data replication rule is deleted.
    public var status: Swift.String?

    /// The container that specifies other conditions used to filter the source objects that you want to replicate. Filter conditions can be specified only for source objects encrypted by using SSE-KMS.
    public var sourceSelectionCriteria: ReplicationSourceSelectionCriteria?

    public init( 
        id: Swift.String? = nil,
        destination: ReplicationDestination? = nil,
        historicalObjectReplication: Swift.String? = nil,
        syncRole: Swift.String? = nil,
        encryptionConfiguration: ReplicationEncryptionConfiguration? = nil,
        rtc: RTC? = nil,
        prefixSet: ReplicationPrefixSet? = nil,
        action: Swift.String? = nil,
        status: Swift.String? = nil,
        sourceSelectionCriteria: ReplicationSourceSelectionCriteria? = nil,
    ) { 
        self.destination = destination
        self.historicalObjectReplication = historicalObjectReplication
        self.syncRole = syncRole
        self.encryptionConfiguration = encryptionConfiguration
        self.rtc = rtc
        self.id = id
        self.prefixSet = prefixSet
        self.action = action
        self.status = status
        self.sourceSelectionCriteria = sourceSelectionCriteria
    }
}

extension ReplicationRule: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case destination = "Destination"
        case historicalObjectReplication = "HistoricalObjectReplication"
        case syncRole = "SyncRole"
        case encryptionConfiguration = "EncryptionConfiguration"
        case rtc = "RTC"
        case prefixSet = "PrefixSet"
        case action = "Action"
        case status = "Status"
        case sourceSelectionCriteria = "SourceSelectionCriteria"
    }
}

/// The container that stores data replication configurations.
public struct ReplicationConfiguration: Sendable {

    /// The container that stores the data replication rules.
    public var rules: [ReplicationRule]?

    public init( 
        rules: [ReplicationRule]? = nil,
    ) { 
        self.rules = rules
    }
}

extension ReplicationConfiguration: Codable {
    enum CodingKeys: String, CodingKey {
        case rules = "Rule"
    }
}

/// The container that stores Replication Time Control (RTC) configurations.
public struct RtcConfiguration: Sendable {

    /// The container that stores the status of RTC.
    public var rtc: RTC?

    /// The ID of the data replication rule for which you want to configure RTC.
    public var id: Swift.String?

    public init( 
        id: Swift.String? = nil,
        rtc: RTC? = nil,
    ) {
        self.rtc = rtc
        self.id = id
    }
}

extension RtcConfiguration: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case rtc = "RTC"
    }
}

/// The container that stores regions in which the destination bucket can be located with TransferType specified.
public struct LocationTransferTypeConstraint: Sendable {

    /// The container that stores regions in which the destination bucket can be located with the TransferType information.
    public var locationTransferTypes: [LocationTransferType]?

    public init( 
        locationTransferTypes: [LocationTransferType]? = nil,
    ) { 
        self.locationTransferTypes = locationTransferTypes
    }
}

extension LocationTransferTypeConstraint: Codable {
    enum CodingKeys: String, CodingKey {
        case locationTransferTypes = "LocationTransferType"
    }
}

/// Information about the progress of the data replication task.
public struct ReplicationProgressRule: Sendable {

    /// The ID of the data replication rule.
    public var id: Swift.String?

    /// The container that stores prefixes. You can specify up to 10 prefixes in each data replication rule.
    public var prefixSet: ReplicationPrefixSet?

    /// The operations that are synchronized to the destination bucket.
    /// *   ALL: PUT, DELETE, and ABORT operations are synchronized to the destination bucket.
    /// *   PUT: Write operations are synchronized to the destination bucket, including PutObject, PostObject, AppendObject, CopyObject, PutObjectACL, InitiateMultipartUpload, UploadPart, UploadPartCopy, and CompleteMultipartUpload.
    public var action: Swift.String?

    /// The container that stores the information about the destination bucket.
    public var destination: ReplicationDestination?

    /// The status of the data replication task. Valid values:
    /// *   starting: OSS creates a data replication task after a data replication rule is configured.
    /// *   doing: The replication rule is effective and the replication task is in progress.
    /// *   closing: OSS clears a data replication task after the corresponding data replication rule is deleted.
    public var status: Swift.String?

    /// Specifies whether to replicate historical data that exists before data replication is enabled from the source bucket to the destination bucket.
    /// *   enabled (default): replicates historical data to the destination bucket.
    /// *   disabled: ignores historical data and replicates only data uploaded to the source bucket after data replication is enabled for the source bucket.
    public var historicalObjectReplication: Swift.String?

    /// The container that stores the progress of the data replication task. This parameter is returned only when the data replication task is in the doing state.
    public var progress: Progress?

    public init( 
        id: Swift.String? = nil,
        prefixSet: ReplicationPrefixSet? = nil,
        action: Swift.String? = nil,
        destination: ReplicationDestination? = nil,
        status: Swift.String? = nil,
        historicalObjectReplication: Swift.String? = nil,
        progress: Progress? = nil,
    ) { 
        self.id = id
        self.prefixSet = prefixSet
        self.action = action
        self.destination = destination
        self.status = status
        self.historicalObjectReplication = historicalObjectReplication
        self.progress = progress
    }
}

extension ReplicationProgressRule: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case prefixSet = "PrefixSet"
        case action = "Action"
        case destination = "Destination"
        case status = "Status"
        case historicalObjectReplication = "HistoricalObjectReplication"
        case progress = "Progress"
    }
}

/// The container that stores information about the Replication Time Control (RTC) status.
public struct RTC: Sendable {

    /// Specifies whether to enable RTC.
    /// Valid values:
    /// *   disabled
    /// *   enabled
    public var status: Swift.String?

    public init( 
        status: Swift.String? = nil,
    ) { 
        self.status = status
    }
}

extension RTC: Codable {
    enum CodingKeys: String, CodingKey {
        case status = "Status"
    }
}

/// The container that stores the transfer type.
public struct TransferTypes: Sendable {

    /// The data transfer type that is used to transfer data in data replication.
    /// Valid values:
    /// *   internal (default): the default data transfer link used in OSS.
    /// *   oss_acc: the link in which data transmission is accelerated. You can set TransferType to oss_acc only when you create CRR rules.
    public var types: [Swift.String]?

    public init( 
        types: [Swift.String]? = nil,
    ) { 
        self.types = types
    }
}

extension TransferTypes: Codable {
    enum CodingKeys: String, CodingKey {
        case types = "Type"
    }
}

/// The container that stores regions in which the destination bucket can be located with the TransferType information.
public struct LocationTransferType: Sendable {

    /// The container that stores the transfer type.
    public var transferTypes: TransferTypes?

    /// The regions in which the destination bucket can be located.
    public var location: Swift.String?

    public init( 
        transferTypes: TransferTypes? = nil,
        location: Swift.String? = nil,
    ) { 
        self.transferTypes = transferTypes
        self.location = location
    }
}

extension LocationTransferType: Codable {
    enum CodingKeys: String, CodingKey {
        case transferTypes = "TransferTypes"
        case location = "Location"
    }
}

/// The container that stores the information about the destination bucket.
public struct ReplicationDestination: Sendable {

    /// The destination bucket to which data is replicated.
    public var bucket: Swift.String?

    /// The region in which the destination bucket is located.
    public var location: Swift.String?

    /// The link that is used to transfer data during data replication. Valid values:
    /// *   internal (default): the default data transfer link used in OSS.
    /// *   oss_acc: the transfer acceleration link. You can set TransferType to oss_acc only when you create CRR rules.
    /// Sees TransferType for supported values.
    public var transferType: Swift.String?

    public init( 
        bucket: Swift.String? = nil,
        location: Swift.String? = nil,
        transferType: Swift.String? = nil,
    ) { 
        self.bucket = bucket
        self.location = location
        self.transferType = transferType
    }
}

extension ReplicationDestination: Codable {
    enum CodingKeys: String, CodingKey {
        case bucket = "Bucket"
        case location = "Location"
        case transferType = "TransferType"
    }
}

/// The container that specifies other conditions used to filter the source objects that you want to replicate. Filter conditions can be specified only for source objects encrypted by using SSE-KMS.
public struct ReplicationSourceSelectionCriteria: Sendable {

    /// The container that is used to filter the source objects that are encrypted by using SSE-KMS. This parameter must be specified if the SourceSelectionCriteria parameter is specified in the data replication rule.
    public var sseKmsEncryptedObjects: SseKmsEncryptedObjects?

    public init( 
        sseKmsEncryptedObjects: SseKmsEncryptedObjects? = nil,
    ) { 
        self.sseKmsEncryptedObjects = sseKmsEncryptedObjects
    }
}

extension ReplicationSourceSelectionCriteria: Codable {
    enum CodingKeys: String, CodingKey {
        case sseKmsEncryptedObjects = "SseKmsEncryptedObjects"
    }
}

/// The container that stores the progress of the data replication task. This parameter is returned only when the data replication task is in the doing state.
public struct Progress: Sendable {

    /// The time used to determine whether data is replicated to the destination bucket. Data that is written to the source bucket before the time is replicated to the destination bucket. The value of this parameter is in the GMT format. Example: Thu, 24 Sep 2015 15:39:18 GMT.
    public var newObject: Swift.String?

    /// The percentage of the replicated historical data. This parameter is valid only when HistoricalObjectReplication is set to enabled.
    public var historicalObject: Swift.String?

    public init( 
        newObject: Swift.String? = nil,
        historicalObject: Swift.String? = nil,
    ) { 
        self.newObject = newObject
        self.historicalObject = historicalObject
    }
}

extension Progress: Codable {
    enum CodingKeys: String, CodingKey {
        case newObject = "NewObject"
        case historicalObject = "HistoricalObject"
    }
}

/// The container that is used to store the progress of data replication tasks.
public struct ReplicationProgress: Sendable {

    /// The container that stores the progress of the data replication task corresponding to each data replication rule.
    public var rules: [ReplicationProgressRule]?

    public init( 
        rules: [ReplicationProgressRule]? = nil,
    ) { 
        self.rules = rules
    }
}

extension ReplicationProgress: Codable {
    enum CodingKeys: String, CodingKey {
        case rules = "Rule"
    }
}

/// The container that stores prefixes. You can specify up to 10 prefixes in each data replication rule.
public struct ReplicationPrefixSet: Sendable {

    /// The prefix that is used to specify the object that you want to replicate. Only objects whose names contain the specified prefix are replicated to the destination bucket.
    /// *   The value of the Prefix parameter can be up to 1,023 characters in length.
    /// *   If you specify the Prefix parameter in a data replication rule, OSS synchronizes new data and historical data based on the value of the Prefix parameter.
    public var prefixs: [Swift.String]?

    public init( 
        prefixs: [Swift.String]? = nil,
    ) { 
        self.prefixs = prefixs
    }
}

extension ReplicationPrefixSet: Codable {
    enum CodingKeys: String, CodingKey {
        case prefixs = "Prefix"
    }
}

/// The container that stores regions in which the RTC can be enabled.
public struct LocationRTCConstraint: Sendable {

    /// The regions where RTC is supported.
    public var locations: [Swift.String]?

    public init( 
        locations: [Swift.String]? = nil,
    ) { 
        self.locations = locations
    }
}

extension LocationRTCConstraint: Codable {
    enum CodingKeys: String, CodingKey {
        case locations = "Location"
    }
}

/// The container that stores the region in which the destination bucket can be located.
public struct ReplicationLocation: Sendable {

    /// The regions in which the destination bucket can be located.
    public var locations: [Swift.String]?

    /// The container that stores regions in which the destination bucket can be located with TransferType specified.
    public var locationTransferTypeConstraint: LocationTransferTypeConstraint?

    /// The container that stores regions in which the RTC can be enabled.
    public var locationRTCConstraint: LocationRTCConstraint?

    public init( 
        locations: [Swift.String]? = nil,
        locationTransferTypeConstraint: LocationTransferTypeConstraint? = nil,
        locationRTCConstraint: LocationRTCConstraint? = nil,
    ) { 
        self.locations = locations
        self.locationTransferTypeConstraint = locationTransferTypeConstraint
        self.locationRTCConstraint = locationRTCConstraint
    }
}

extension ReplicationLocation: Codable {
    enum CodingKeys: String, CodingKey {
        case locations = "Location"
        case locationTransferTypeConstraint = "LocationTransferTypeConstraint"
        case locationRTCConstraint = "LocationRTCConstraint"
    }
}

public struct ReplicationRules: Sendable {
    
    // The ID of data replication rules that you want to delete. You can call the GetBucketReplication operation to obtain the ID.
    public var id: String
    
    public init(
        id: String
    ) {
        self.id = id
    }
}

extension ReplicationRules: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "ID"
    }
}

/// The request for the PutBucketRtc operation.
public struct PutBucketRtcRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// The container of the request body.
    public var rtcConfiguration: RtcConfiguration?
    

    public init( 
        bucket: Swift.String? = nil,
        rtcConfiguration: RtcConfiguration? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.rtcConfiguration = rtcConfiguration
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the PutBucketRtc operation.
public struct PutBucketRtcResult: ResultModel, Sendable {
    public var commonProp: ResultModelProp = ResultModelProp()

}

/// The request for the PutBucketReplication operation.
public struct PutBucketReplicationRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// The container of the request body.
    public var replicationConfiguration: ReplicationConfiguration?
    

    public init( 
        bucket: Swift.String? = nil,
        replicationConfiguration: ReplicationConfiguration? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.replicationConfiguration = replicationConfiguration
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the PutBucketReplication operation.
public struct PutBucketReplicationResult: ResultModel, Sendable {
    public var commonProp: ResultModelProp = ResultModelProp()
 
    /// <no value>
    public var replicationRuleId: Swift.String? { get { return self.commonProp.headers?["x-oss-replication-rule-id"] } } 
     
}

/// The request for the GetBucketReplication operation.
public struct GetBucketReplicationRequest: RequestModel {
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

/// The result for the GetBucketReplication operation.
public struct GetBucketReplicationResult: ResultModel, Sendable {
    public var commonProp: ResultModelProp = ResultModelProp()
 
    /// The container that stores data replication configurations.
    public var replicationConfiguration: ReplicationConfiguration?
     
}

/// The request for the GetBucketReplicationLocation operation.
public struct GetBucketReplicationLocationRequest: RequestModel {
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

/// The result for the GetBucketReplicationLocation operation.
public struct GetBucketReplicationLocationResult: ResultModel, Sendable {
    public var commonProp: ResultModelProp = ResultModelProp()
 
    /// The container that stores the region in which the destination bucket can be located.
    public var replicationLocation: ReplicationLocation?
     
}

/// The request for the GetBucketReplicationProgress operation.
public struct GetBucketReplicationProgressRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucekt.
    public var bucket: Swift.String? 
    
    /// The ID of the data replication rule. You can call the GetBucketReplication operation to query the ID.
    public var ruleId: Swift.String?
    

    public init( 
        bucket: Swift.String? = nil,
        ruleId: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.ruleId = ruleId
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the GetBucketReplicationProgress operation.
public struct GetBucketReplicationProgressResult: ResultModel, Sendable {
    public var commonProp: ResultModelProp = ResultModelProp()
 
    /// The container that is used to store the progress of data replication tasks.
    public var replicationProgress: ReplicationProgress?
     
}

/// The request for the DeleteBucketReplication operation.
public struct DeleteBucketReplicationRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// The container of the request body.
    public var replicationRules: ReplicationRules?
    

    public init( 
        bucket: Swift.String? = nil,
        replicationRules: ReplicationRules? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.replicationRules = replicationRules
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the DeleteBucketReplication operation.
public struct DeleteBucketReplicationResult: ResultModel, Sendable {
    public var commonProp: ResultModelProp = ResultModelProp()

}

