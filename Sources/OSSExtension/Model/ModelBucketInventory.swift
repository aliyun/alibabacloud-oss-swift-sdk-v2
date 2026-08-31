import AlibabaCloudOSS
import Foundation



/// The format of the exported inventory list
public enum InventoryFormatType: String { 
    case cSV = "CSV"
}


/// The frequency that inventory lists are exported
public enum InventoryFrequencyType: String { 
    case daily = "Daily"
    case weekly = "Weekly"
}


/// 
public enum InventoryOptionalFieldType: String, Codable, Sendable {
    case size = "Size"
    case lastModifiedDate = "LastModifiedDate"
    case eTag = "ETag"
    case storageClass = "StorageClass"
    case isMultipartUploaded = "IsMultipartUploaded"
    case encryptionStatus = "EncryptionStatus"
}


/// Contains the frequency that inventory lists are exported
public struct InventorySchedule: Sendable {

    /// The frequency at which the inventory list is exported. Valid values:
    /// - Daily: The inventory list is exported on a daily basis.
    /// - Weekly: The inventory list is exported on a weekly basis.
    /// Sees InventoryFrequencyType for supported values.
    public var frequency: Swift.String?

    public init( 
        frequency: Swift.String? = nil,
    ) { 
        self.frequency = frequency
    }
}

extension InventorySchedule: Codable {
    enum CodingKeys: String, CodingKey { 
        case frequency = "Frequency"
    }
}


/// The container that stores the configuration fields in inventory lists.
public struct OptionalFields: Sendable {

    /// The configuration fields that are included in inventory lists. Available configuration fields:
    /// *   Size: the size of the object.
    /// *   LastModifiedDate: the time when the object was last modified.
    /// *   ETag: the ETag of the object. It is used to identify the content of the object.
    /// *   StorageClass: the storage class of the object.
    /// *   IsMultipartUploaded: specifies whether the object is uploaded by using multipart upload.
    /// *   EncryptionStatus: the encryption status of the object.
    public var fields: [InventoryOptionalFieldType]?

    public init( 
        fields: [InventoryOptionalFieldType]? = nil,
    ) { 
        self.fields = fields
    }
}

extension OptionalFields: Codable {
    enum CodingKeys: String, CodingKey { 
        case fields = "Field"
    }
}


/// The container that stores the encryption method of exported inventory lists.
public struct InventoryEncryption: Sendable {

    /// The container that stores information about the SSE-OSS encryption method.
    public var sseOss: Swift.String?

    /// The container that stores the customer master key (CMK) used for SSE-KMS encryption.
    public var sseKms: SSEKMS?

    public init( 
        sseOss: Swift.String? = nil,
        sseKms: SSEKMS? = nil,
    ) { 
        self.sseOss = sseOss
        self.sseKms = sseKms
    }
}

extension InventoryEncryption: Codable {
    enum CodingKeys: String, CodingKey { 
        case sseOss = "SSE-OSS"
    
        case sseKms = "SSE-KMS"
    
    }
}


/// The container that stores inventory configuration list.
public struct ListInventoryConfigurationsResult: Sendable {

    /// The container that stores inventory configurations.
    public var inventoryConfigurations: [InventoryConfiguration]?

    /// Specifies whether to list all inventory tasks configured for the bucket.Valid values: true and false- The value of false indicates that all inventory tasks configured for the bucket are listed.- The value of true indicates that not all inventory tasks configured for the bucket are listed. To list the next page of inventory configurations, set the continuation-token parameter in the next request to the value of the NextContinuationToken header in the response to the current request.
    public var isTruncated: Swift.Bool?

    /// If the value of IsTruncated in the response is true and value of this header is not null, set the continuation-token parameter in the next request to the value of this header.
    public var nextContinuationToken: Swift.String?

    public init( 
        inventoryConfigurations: [InventoryConfiguration]? = nil,
        isTruncated: Swift.Bool? = nil,
        nextContinuationToken: Swift.String? = nil,
    ) { 
        self.inventoryConfigurations = inventoryConfigurations
        self.isTruncated = isTruncated
        self.nextContinuationToken = nextContinuationToken
    }
}

extension ListInventoryConfigurationsResult: Codable {
    enum CodingKeys: String, CodingKey { 
        case inventoryConfigurations = "InventoryConfiguration"
    
        case isTruncated = "IsTruncated"
    
        case nextContinuationToken = "NextContinuationToken"
    
    }
}


/// The container that stores information about the bucket in which exported inventory lists are stored.
public struct InventoryOSSBucketDestination: Sendable {

    /// The prefix of the path in which the exported inventory lists are stored.
    public var prefix: Swift.String?

    /// The container that stores the encryption method of the exported inventory lists.
    public var encryption: InventoryEncryption?

    /// The format of exported inventory lists. The exported inventory lists are CSV objects compressed by using GZIP.
    /// Sees InventoryFormatType for supported values. 
    public var format: Swift.String?

    /// The ID of the account to which permissions are granted by the bucket owner.
    public var accountId: Swift.String?

    /// The Alibaba Cloud Resource Name (ARN) of the role that has the permissions to read all objects from the source bucket and write objects to the destination bucket. Format: `acs:ram::uid:role/rolename`.
    public var roleArn: Swift.String?

    /// The name of the bucket in which exported inventory lists are stored.
    public var bucket: Swift.String?

    public init( 
        bucket: Swift.String? = nil,
        prefix: Swift.String? = nil,
        encryption: InventoryEncryption? = nil,
        format: Swift.String? = nil,
        accountId: Swift.String? = nil,
        roleArn: Swift.String? = nil,
    ) {
        self.prefix = prefix
        self.encryption = encryption
        self.format = format
        self.accountId = accountId
        self.roleArn = roleArn
        self.bucket = bucket
    }
}

extension InventoryOSSBucketDestination: Codable {
    enum CodingKeys: String, CodingKey { 
        case bucket = "Bucket"
        case prefix = "Prefix"
        case encryption = "Encryption"
        case format = "Format"
        case accountId = "AccountId"
        case roleArn = "RoleArn"
    }
}


/// The container that stores information about exported inventory lists.
public struct InventoryDestination: Sendable {

    /// The container that stores information about the bucket in which exported inventory lists are stored.
    public var ossBucketDestination: InventoryOSSBucketDestination?

    public init( 
        ossBucketDestination: InventoryOSSBucketDestination? = nil,
    ) {
        self.ossBucketDestination = ossBucketDestination
    }
}

extension InventoryDestination: Codable {
    enum CodingKeys: String, CodingKey { 
        case ossBucketDestination = "OSSBucketDestination"
    
    }
}


/// The container that stores the prefix used to filter objects. Only objects whose names contain the specified prefix are included in the inventory.
public struct InventoryFilter: Sendable {

    /// The prefix that is specified in the inventory.
    public var prefix: Swift.String?

    /// The beginning of the time range during which the object was last modified. Unit: seconds.Valid values: [1262275200, 253402271999]
    public var lastModifyBeginTimeStamp: Swift.Int?

    /// The end of the time range during which the object was last modified. Unit: seconds.Valid values: [1262275200, 253402271999]
    public var lastModifyEndTimeStamp: Swift.Int?

    /// The minimum size of the specified object.Unit: B.Valid values: [0 B, 48.8 TB]
    public var lowerSizeBound: Swift.Int?

    /// The maximum size of the specified object.Unit: B.Valid values: [0B, 48.8TB]
    public var upperSizeBound: Swift.Int?

    /// The storage class of the object. You can specify multiple storage classes.Valid values:
    /// - Standard
    /// - IA
    /// - Archive
    /// - ColdArchive
    /// - All
    public var storageClass: Swift.String?

    public init( 
        prefix: Swift.String? = nil,
        lastModifyBeginTimeStamp: Swift.Int? = nil,
        lastModifyEndTimeStamp: Swift.Int? = nil,
        lowerSizeBound: Swift.Int? = nil,
        upperSizeBound: Swift.Int? = nil,
        storageClass: Swift.String? = nil,
    ) { 
        self.prefix = prefix
        self.lastModifyBeginTimeStamp = lastModifyBeginTimeStamp
        self.lastModifyEndTimeStamp = lastModifyEndTimeStamp
        self.lowerSizeBound = lowerSizeBound
        self.upperSizeBound = upperSizeBound
        self.storageClass = storageClass
    }
}

extension InventoryFilter: Codable {
    enum CodingKeys: String, CodingKey { 
        case prefix = "Prefix"
    
        case lastModifyBeginTimeStamp = "LastModifyBeginTimeStamp"
    
        case lastModifyEndTimeStamp = "LastModifyEndTimeStamp"
    
        case lowerSizeBound = "LowerSizeBound"
    
        case upperSizeBound = "UpperSizeBound"
    
        case storageClass = "StorageClass"
    
    }
}


/// The container that stores the configurations of the inventory.
public struct InventoryConfiguration: Sendable {

    /// Specifies whether to enable the bucket inventory feature. Valid values:*   true*   false
    public var isEnabled: Swift.Bool?

    /// The container that stores the exported inventory lists.
    public var destination: InventoryDestination?

    /// The container that stores information about the frequency at which inventory lists are exported.
    public var schedule: InventorySchedule?

    /// The container that stores the prefix used to filter objects. Only objects whose names contain the specified prefix are included in the inventory.
    public var filter: InventoryFilter?

    /// Specifies whether to include the version information about the objects in inventory lists. Valid values:
    /// *   All: The information about all versions of the objects is exported.
    /// *   Current: Only the information about the current versions of the objects is exported.
    public var includedObjectVersions: Swift.String?

    /// The container that stores the configuration fields in inventory lists.
    public var optionalFields: OptionalFields?

    /// The name of the inventory. The name must be unique in the bucket.
    public var id: Swift.String?

    public init( 
        id: Swift.String? = nil,
        isEnabled: Swift.Bool? = nil,
        destination: InventoryDestination? = nil,
        schedule: InventorySchedule? = nil,
        filter: InventoryFilter? = nil,
        includedObjectVersions: Swift.String? = nil,
        optionalFields: OptionalFields? = nil,
    ) {
        self.isEnabled = isEnabled
        self.destination = destination
        self.schedule = schedule
        self.filter = filter
        self.includedObjectVersions = includedObjectVersions
        self.optionalFields = optionalFields
        self.id = id
    }
}

extension InventoryConfiguration: Codable {
    enum CodingKeys: String, CodingKey { 
        case id = "Id"
        case isEnabled = "IsEnabled"
        case destination = "Destination"
        case schedule = "Schedule"
        case filter = "Filter"
        case includedObjectVersions = "IncludedObjectVersions"
        case optionalFields = "OptionalFields"
    }
}


/// The container that stores the customer master key (CMK) used for SSE-KMS encryption.
public struct SSEKMS: Sendable {

    /// The ID of the key that is managed by Key Management Service (KMS).
    public var keyId: Swift.String?

    public init( 
        keyId: Swift.String? = nil,
    ) { 
        self.keyId = keyId
    }
}

extension SSEKMS: Codable {
    enum CodingKeys: String, CodingKey { 
        case keyId = "KeyId"
    
    }
}




/// The request for the PutBucketInventory operation.
public struct PutBucketInventoryRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// The name of the inventory.
    public var inventoryId: Swift.String?
    
    /// Request body schema.
    public var inventoryConfiguration: InventoryConfiguration?
    

    public init( 
        bucket: Swift.String? = nil,
        inventoryId: Swift.String? = nil,
        inventoryConfiguration: InventoryConfiguration? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.inventoryId = inventoryId
        self.inventoryConfiguration = inventoryConfiguration
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the PutBucketInventory operation.
public struct PutBucketInventoryResult : ResultModel {
    public var commonProp: ResultModelProp = .init()

}

/// The request for the GetBucketInventory operation.
public struct GetBucketInventoryRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// The name of the inventory to be queried.
    public var inventoryId: Swift.String?
    

    public init( 
        bucket: Swift.String? = nil,
        inventoryId: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.inventoryId = inventoryId
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the GetBucketInventory operation.
public struct GetBucketInventoryResult : ResultModel {
    public var commonProp: ResultModelProp = .init()
 
    /// The inventory task configured for a bucket.
    public var inventoryConfiguration: InventoryConfiguration?
     
}

/// The request for the ListBucketInventory operation.
public struct ListBucketInventoryRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// Specify the start position of the list operation. You can obtain this token from the NextContinuationToken field of last ListBucketInventory's result.
    public var continuationToken: Swift.String?
    

    public init( 
        bucket: Swift.String? = nil,
        continuationToken: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.continuationToken = continuationToken
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the ListBucketInventory operation.
public struct ListBucketInventoryResult : ResultModel {
    public var commonProp: ResultModelProp = .init()
 
    /// The container that stores inventory configuration list.
    public var listInventoryConfigurationsResult: ListInventoryConfigurationsResult?
     
}

/// The request for the DeleteBucketInventory operation.
public struct DeleteBucketInventoryRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// The name of the inventory that you want to delete.
    public var inventoryId: Swift.String?
    

    public init( 
        bucket: Swift.String? = nil,
        inventoryId: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.inventoryId = inventoryId
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the DeleteBucketInventory operation.
public struct DeleteBucketInventoryResult : ResultModel {
    public var commonProp: ResultModelProp = .init()

}

