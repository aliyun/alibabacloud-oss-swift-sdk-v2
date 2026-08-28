import Foundation

///
public enum BucketVersioningStatusType: String {
    case enabled = "Enabled"
    case suspended = "Suspended"
}

/// The configurations of the bucket storage class and redundancy type.
public struct CreateBucketConfiguration: Sendable {
    /// The storage class of the bucket. Valid values:*   Standard (default)*   IA*   Archive*   ColdArchive
    /// Sees StorageClassType for supported values.
    public var storageClass: Swift.String?

    /// The redundancy type of the bucket.*   LRS (default)    LRS stores multiple copies of your data on multiple devices in the same zone. LRS ensures data durability and availability even if hardware failures occur on two devices.*   ZRS    ZRS stores multiple copies of your data across three zones in the same region. Even if a zone becomes unavailable due to unexpected events, such as power outages and fires, data can still be accessed.  You cannot set the redundancy type of Archive buckets to ZRS.
    /// Sees DataRedundancyType for supported values.
    public var dataRedundancyType: Swift.String?

    public init(
        storageClass: Swift.String? = nil,
        dataRedundancyType: Swift.String? = nil
    ) {
        self.storageClass = storageClass
        self.dataRedundancyType = dataRedundancyType
    }
}

/// The container that stores all information returned for the GetBucketStat request.
public struct BucketStat: Sendable {
    /// The total number of objects in the bucket.
    public var objectCount: Swift.Int?

    /// The actual storage usage of IA objects in the bucket. Unit: bytes.
    public var infrequentAccessRealStorage: Swift.Int?

    /// The number of IA objects in the bucket.
    public var infrequentAccessObjectCount: Swift.Int?

    /// The actual storage usage of Archive objects in the bucket. Unit: bytes.
    public var archiveRealStorage: Swift.Int?

    /// The number of Cold Archive objects in the bucket.
    public var coldArchiveObjectCount: Swift.Int?

    /// The actual storage usage of Deep Cold Archive objects in the bucket. Unit: bytes.
    public var deepColdArchiveRealStorage: Swift.Int?

    /// The billed storage usage of IA objects in the bucket. Unit: bytes.
    public var infrequentAccessStorage: Swift.Int?

    /// The number of Archive objects in the bucket.
    public var archiveObjectCount: Swift.Int?

    /// The number of Deep Cold Archive objects in the bucket.
    public var deepColdArchiveObjectCount: Swift.Int?

    /// The number of multipart upload tasks that have been initiated but are not completed or canceled.
    public var multipartUploadCount: Swift.Int?

    /// The number of mulitpart parts in the bucket.
    public var multipartPartCount: Swift.Int?

    /// The number of deletemarker in the bucket.
    public var deleteMarkerCount: Swift.Int?

    /// The time when the obtained information was last modified. The value of this parameter is a UNIX timestamp. Unit: seconds.
    public var lastModifiedTime: Swift.Int?

    /// The storage usage of Standard objects in the bucket. Unit: bytes.
    public var standardStorage: Swift.Int?

    /// The actual storage usage of Cold Archive objects in the bucket. Unit: bytes.
    public var coldArchiveRealStorage: Swift.Int?

    /// The storage usage of the bucket. Unit: bytes.
    public var storage: Swift.Int?

    /// The number of LiveChannels in the bucket.
    public var liveChannelCount: Swift.Int?

    /// The number of Standard objects in the bucket.
    public var standardObjectCount: Swift.Int?

    /// The billed storage usage of Archive objects in the bucket. Unit: bytes.
    public var archiveStorage: Swift.Int?

    /// The billed storage usage of Cold Archive objects in the bucket. Unit: bytes.
    public var coldArchiveStorage: Swift.Int?

    /// The billed storage usage of Deep Cold Archive objects in the bucket. Unit: bytes.
    public var deepColdArchiveStorage: Swift.Int?

    public init(
        objectCount: Swift.Int? = nil,
        infrequentAccessRealStorage: Swift.Int? = nil,
        infrequentAccessObjectCount: Swift.Int? = nil,
        archiveRealStorage: Swift.Int? = nil,
        coldArchiveObjectCount: Swift.Int? = nil,
        deepColdArchiveRealStorage: Swift.Int? = nil,
        infrequentAccessStorage: Swift.Int? = nil,
        archiveObjectCount: Swift.Int? = nil,
        deepColdArchiveObjectCount: Swift.Int? = nil,
        multipartUploadCount: Swift.Int? = nil,
        multipartPartCount: Swift.Int? = nil,
        deleteMarkerCount: Swift.Int? = nil,
        lastModifiedTime: Swift.Int? = nil,
        standardStorage: Swift.Int? = nil,
        coldArchiveRealStorage: Swift.Int? = nil,
        storage: Swift.Int? = nil,
        liveChannelCount: Swift.Int? = nil,
        standardObjectCount: Swift.Int? = nil,
        archiveStorage: Swift.Int? = nil,
        coldArchiveStorage: Swift.Int? = nil,
        deepColdArchiveStorage: Swift.Int? = nil
    ) {
        self.objectCount = objectCount
        self.infrequentAccessRealStorage = infrequentAccessRealStorage
        self.infrequentAccessObjectCount = infrequentAccessObjectCount
        self.archiveRealStorage = archiveRealStorage
        self.coldArchiveObjectCount = coldArchiveObjectCount
        self.deepColdArchiveRealStorage = deepColdArchiveRealStorage
        self.infrequentAccessStorage = infrequentAccessStorage
        self.archiveObjectCount = archiveObjectCount
        self.deepColdArchiveObjectCount = deepColdArchiveObjectCount
        self.multipartUploadCount = multipartUploadCount
        self.multipartPartCount = multipartPartCount
        self.deleteMarkerCount = deleteMarkerCount
        self.lastModifiedTime = lastModifiedTime
        self.standardStorage = standardStorage
        self.coldArchiveRealStorage = coldArchiveRealStorage
        self.storage = storage
        self.liveChannelCount = liveChannelCount
        self.standardObjectCount = standardObjectCount
        self.archiveStorage = archiveStorage
        self.coldArchiveStorage = coldArchiveStorage
        self.deepColdArchiveStorage = deepColdArchiveStorage
    }
}

/// The character that is used to group the objects that you want to list by name. Objects whose names contain the same string that stretches from the specified prefix to the first occurrence of the delimiter are grouped as a CommonPrefixes element.
public struct CommonPrefix: Sendable {
    /// The prefix that must be included in the names of objects you want to list.
    public var prefix: Swift.String?

    public init(
        prefix: Swift.String? = nil
    ) {
        self.prefix = prefix
    }
}

/// The log configurations of the bucket.
public struct BucketPolicy: Sendable {
    /// The name of the bucket that stores the logs.
    public var logBucket: Swift.String?

    /// The directory in which logs are stored.
    public var logPrefix: Swift.String?

    public init(
        logBucket: Swift.String? = nil,
        logPrefix: Swift.String? = nil
    ) {
        self.logBucket = logBucket
        self.logPrefix = logPrefix
    }
}

/// The container that stores the bucket information.
public struct Bucket: Sendable {
    /// The redundancy type of the bucket.
    /// Sees DataRedundancyType for supported values.
    public var dataRedundancyType: Swift.String?

    /// The public endpoint of the bucket.
    public var extranetEndpoint: Swift.String?

    /// The name of the bucket.
    public var name: Swift.String?

    /// The storage class of the bucket.
    /// Sees StorageClassType for supported values.
    public var storageClass: Swift.String?

    /// The owner of the bucket.
    public var owner: Owner?

    /// Indicates whether cross-region replication (CRR) is enabled for the bucket.Valid values:*   Enabled            *   Disabled
    public var crossRegionReplication: Swift.String?

    /// The ID of the resource group to which the bucket belongs.
    public var resourceGroupId: Swift.String?

    /// Indicates whether transfer acceleration is enabled for the bucket.Valid values:*   Enabled            *   Disabled
    public var transferAcceleration: Swift.String?

    /// The versioning status of the bucket.
    /// Sees BucketVersioningStatusType for supported values.
    public var versioning: Swift.String?

    /// The region in which the bucket is located.
    public var location: Swift.String?

    /// The server-side encryption configurations of the bucket.
    public var serverSideEncryptionRule: ServerSideEncryptionRule?

    /// The description of the bucket.
    public var comment: Swift.String?

    ///
    public var blockPublicAccess: Swift.Bool?

    /// Indicates whether access tracking is enabled for the bucket.Valid values:*   Enabled            *   Disabled
    public var accessMonitor: Swift.String?

    /// The internal endpoint of the bucket.
    public var intranetEndpoint: Swift.String?

    /// The ACL of the bucket.
    public var accessControlList: AccessControlList?

    /// The log configurations of the bucket.
    public var bucketPolicy: BucketPolicy?

    /// The time when the bucket is created. The time is in UTC.
    public var creationDate: Foundation.Date?

    /// The resource type of the bucket.
    public var bucketResourceType: Swift.String?

    /// The agentic bucket name associated with this bucket.
    public var agenticBucketName: Swift.String?

    public init(
        dataRedundancyType: Swift.String? = nil,
        extranetEndpoint: Swift.String? = nil,
        name: Swift.String? = nil,
        storageClass: Swift.String? = nil,
        owner: Owner? = nil,
        crossRegionReplication: Swift.String? = nil,
        resourceGroupId: Swift.String? = nil,
        transferAcceleration: Swift.String? = nil,
        versioning: Swift.String? = nil,
        location: Swift.String? = nil,
        serverSideEncryptionRule: ServerSideEncryptionRule? = nil,
        comment: Swift.String? = nil,
        blockPublicAccess: Swift.Bool? = nil,
        accessMonitor: Swift.String? = nil,
        intranetEndpoint: Swift.String? = nil,
        accessControlList: AccessControlList? = nil,
        bucketPolicy: BucketPolicy? = nil,
        creationDate: Foundation.Date? = nil,
        bucketResourceType: Swift.String? = nil,
        agenticBucketName: Swift.String? = nil
    ) {
        self.dataRedundancyType = dataRedundancyType
        self.extranetEndpoint = extranetEndpoint
        self.name = name
        self.storageClass = storageClass
        self.owner = owner
        self.crossRegionReplication = crossRegionReplication
        self.resourceGroupId = resourceGroupId
        self.transferAcceleration = transferAcceleration
        self.versioning = versioning
        self.location = location
        self.serverSideEncryptionRule = serverSideEncryptionRule
        self.comment = comment
        self.blockPublicAccess = blockPublicAccess
        self.accessMonitor = accessMonitor
        self.intranetEndpoint = intranetEndpoint
        self.accessControlList = accessControlList
        self.bucketPolicy = bucketPolicy
        self.creationDate = creationDate
        self.bucketResourceType = bucketResourceType
        self.agenticBucketName = agenticBucketName
    }
}

/// The container that stores the returned object metadata.
public struct ObjectSummary: Sendable {
    /// The type of the object. An object has one of the following types:*   Normal: The object is created by using simple upload.*   Multipart: The object is created by using multipart upload.*   Appendable: The object is created by using append upload. An appendable object can be appended.
    public var type: Swift.String?

    /// The size of the object. Unit: bytes.
    public var size: Swift.Int?

    /// The container that stores the information about the bucket owner.
    public var owner: Owner?

    ///
    public var transitionTime: Foundation.Date?

    /// The name of the object.
    public var key: Swift.String?

    /// The entity tag (ETag). An ETag is created when the object is created to identify the content of an object.*   For an object that is created by calling the PutObject operation, the ETag value of the object is the MD5 hash of the object content.*   For an object that is created by using another method, the ETag value is not the MD5 hash of the object content but a unique value calculated based on a specific rule.*   The ETag of an object can be used to check whether the object content changes. However, we recommend that you use the MD5 hash of an object rather than the ETag value of the object to verify data integrity.
    public var etag: Swift.String?

    ///
    public var restoreInfo: Swift.String?

    /// The time when the object was last modified.
    public var lastModified: Foundation.Date?

    /// The storage class of the object.
    /// Sees StorageClassType for supported values.
    public var storageClass: Swift.String?

    public init(
        type: Swift.String? = nil,
        size: Swift.Int? = nil,
        owner: Owner? = nil,
        transitionTime: Foundation.Date? = nil,
        key: Swift.String? = nil,
        etag: Swift.String? = nil,
        restoreInfo: Swift.String? = nil,
        lastModified: Foundation.Date? = nil,
        storageClass: Swift.String? = nil
    ) {
        self.type = type
        self.size = size
        self.owner = owner
        self.transitionTime = transitionTime
        self.key = key
        self.etag = etag
        self.restoreInfo = restoreInfo
        self.lastModified = lastModified
        self.storageClass = storageClass
    }
}

/// The server-side encryption configurations of the bucket.
public struct ServerSideEncryptionRule: Sendable {
    /// The algorithm that is used to encrypt objects. If you do not configure this parameter, objects are encrypted by using AES-256. This parameter is valid only when SSEAlgorithm is set to KMS.Valid value: SM4.
    public var kMSDataEncryption: Swift.String?

    /// The default server-side encryption method.Valid values: KMS, AES-256, and SM4.
    public var sSEAlgorithm: Swift.String?

    /// The key that is managed by Key Management Service (KMS).
    public var kMSMasterKeyID: Swift.String?

    public init(
        kMSDataEncryption: Swift.String? = nil,
        sSEAlgorithm: Swift.String? = nil,
        kMSMasterKeyID: Swift.String? = nil
    ) {
        self.kMSDataEncryption = kMSDataEncryption
        self.sSEAlgorithm = sSEAlgorithm
        self.kMSMasterKeyID = kMSMasterKeyID
    }
}

/// The container that stores the information about the bucket.
public struct BucketInfo: Sendable {
    /// The container that stores the bucket information.
    public var bucket: Bucket?

    public init(
        bucket: Bucket? = nil
    ) {
        self.bucket = bucket
    }
}

/// The request for the GetBucketStat operation.
public struct GetBucketStatRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The bucket about which you want to query the information.
    public var bucket: Swift.String?

    public init(
        bucket: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.bucket = bucket
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the GetBucketStat operation.
public struct GetBucketStatResult: ResultModel {
    public var commonProp: ResultModelProp = .init()

    /// The container that stores all information returned for the GetBucketStat request.
    public var bucketStat: BucketStat?
}

/// The request for the PutBucket operation.
public struct PutBucketRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket. The name of a bucket must comply with the following naming conventions:
    ///     The name can contain only lowercase letters, digits, and hyphens (-).
    ///     It must start and end with a lowercase letter or a digit.
    ///     The name must be 3 to 63 characters in length.
    public var bucket: Swift.String?

    /// The access control list (ACL) of the bucket to be created. Valid values:
    ///     public-read-write
    ///     public-read
    ///     private (default)
    /// For more information, see [Bucket ACL](~~31843~~).
    /// Sees BucketACLType for supported values.
    public var acl: Swift.String?

    /// The ID of the resource group.
    /// If you include the header in the request and specify the ID of the resource group, the bucket that you create belongs to the resource group. If the specified resource group ID is rg-default-id, the bucket that you create belongs to the default resource group.
    /// If you do not include the header in the request, the bucket that you create belongs to the default resource group.You can obtain the ID of a resource group in the Resource Management console or by calling the ListResourceGroups operation.
    /// For more information, see [View basic information of a resource group](~~151181~~) and [ListResourceGroups](~~158855~~).  You cannot configure a resource group for an Anywhere Bucket.
    public var resourceGroupId: Swift.String?

    /// The tagging of the bucket.
    public var bucketTagging: Swift.String?

    /// The container that stores the request body.
    public var createBucketConfiguration: CreateBucketConfiguration?

    /// The agentic bucket name.
    public var agenticBucket: Swift.String?

    public init(
        bucket: Swift.String? = nil,
        acl: Swift.String? = nil,
        resourceGroupId: Swift.String? = nil,
        bucketTagging: Swift.String? = nil,
        createBucketConfiguration: CreateBucketConfiguration? = nil,
        agenticBucket: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.bucket = bucket
        self.acl = acl
        self.resourceGroupId = resourceGroupId
        self.bucketTagging = bucketTagging
        self.createBucketConfiguration = createBucketConfiguration
        self.agenticBucket = agenticBucket
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the PutBucket operation.
public struct PutBucketResult: ResultModel {
    public var commonProp: ResultModelProp = .init()
}

/// The request for the DeleteBucket operation.
public struct DeleteBucketRequest: RequestModel {
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

/// The result for the DeleteBucket operation.
public struct DeleteBucketResult: ResultModel {
    public var commonProp: ResultModelProp = .init()
}

/// The request for the ListObjects operation.
public struct ListObjectsRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String?

    /// The character that is used to group objects by name. If you specify delimiter in the request, the response contains CommonPrefixes. The objects whose names contain the same string from the prefix to the next occurrence of the delimiter are grouped as a single result element in CommonPrefixes.
    public var delimiter: Swift.String?

    /// The name of the object after which the GetBucket (ListObjects) operation begins. If this parameter is specified, objects whose names are alphabetically after the value of marker are returned.The objects are returned by page based on marker. The value of marker can be up to 1,024 bytes.If the value of marker does not exist in the list when you perform a conditional query, the GetBucket (ListObjects) operation starts from the object whose name is alphabetically after the value of marker.
    public var marker: Swift.String?

    /// The maximum number of objects that can be returned. If the number of objects to be returned exceeds the value of max-keys specified in the request, NextMarker is included in the returned response. The value of NextMarker is used as the value of marker for the next request.Valid values: 1 to 999.Default value: 100.
    public var maxKeys: Swift.Int?

    /// The prefix that must be contained in names of the returned objects.*   The value of prefix can be up to 1,024 bytes in length.*   If you specify prefix, the names of the returned objects contain the prefix.If you set prefix to a directory name, the object whose names start with this prefix are listed. The objects consist of all recursive objects and subdirectories in this directory.If you set prefix to a directory name and set delimiter to a forward slash (/), only the objects in the directory are listed. The subdirectories in the directory are listed in CommonPrefixes. Recursive objects and subdirectories in the subdirectories are not listed.For example, a bucket contains the following three objects: fun/test.jpg, fun/movie/001.avi, and fun/movie/007.avi. If prefix is set to fun/, the three objects are returned. If prefix is set to fun/ and delimiter is set to a forward slash (/), fun/test.jpg and fun/movie/ are returned.
    public var prefix: Swift.String?

    /// The encoding format of the content in the response.  The value of Delimiter, Marker, Prefix, NextMarker, and Key are UTF-8 encoded. If the values of Delimiter, Marker, Prefix, NextMarker, and Key contain a control character that is not supported by Extensible Markup Language (XML) 1.0, you can specify encoding-type to encode the value in the response.
    /// Sees EncodingType for supported values.
    public var encodingType: Swift.String?

    public init(
        bucket: Swift.String? = nil,
        delimiter: Swift.String? = nil,
        marker: Swift.String? = nil,
        maxKeys: Swift.Int? = nil,
        prefix: Swift.String? = nil,
        encodingType: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.bucket = bucket
        self.delimiter = delimiter
        self.marker = marker
        self.maxKeys = maxKeys
        self.prefix = prefix
        self.encodingType = encodingType
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the ListObjects operation.
public struct ListObjectsResult: ResultModel {
    public var commonProp: ResultModelProp = .init()

    /// The prefix in the names of the returned objects.
    public var prefix: Swift.String?

    /// The maximum number of returned objects in the response.
    public var maxKeys: Swift.Int?

    /// Indicates whether the returned results are truncated. Valid values:- true- false
    public var isTruncated: Swift.Bool?

    /// The name of the object after which the list operation begins.
    public var marker: Swift.String?

    /// The position from which the next list operation starts.
    public var nextMarker: Swift.String?

    /// The encoding type of the content in the response. If you specify encoding-type in the request, the values of Delimiter, StartAfter, Prefix, NextContinuationToken, and Key are encoded in the response.
    public var encodingType: Swift.String?

    /// The name of the bucket.
    public var name: Swift.String?

    /// The container that stores the metadata of the returned objects.
    public var contents: [ObjectSummary]?

    /// Objects whose names contain the same string that ranges from the prefix to the next occurrence of the delimiter are grouped as a single result element
    public var commonPrefixes: [CommonPrefix]?

    /// The character that is used to group objects by name. The objects whose names contain the same string from the prefix to the next occurrence of the delimiter are grouped as a single result element in CommonPrefixes.
    public var delimiter: Swift.String?
}

/// The request for the ListObjectsV2 operation.
public struct ListObjectsV2Request: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String?

    /// The character that is used to group objects by name. If you specify delimiter in the request, the response contains CommonPrefixes. The objects whose names contain the same string from the prefix to the next occurrence of the delimiter are grouped as a single result element in CommonPrefixes.
    public var delimiter: Swift.String?

    /// The maximum number of objects to be returned.Valid values: 1 to 999.Default value: 100.  If the number of returned objects exceeds the value of max-keys, the response contains NextContinuationToken.Use the value of NextContinuationToken as the value of continuation-token in the next request.
    public var maxKeys: Swift.Int?

    /// The prefix that must be contained in names of the returned objects.*   The value of prefix can be up to 1,024 bytes in length.*   If you specify prefix, the names of the returned objects contain the prefix.If you set prefix to a directory name, the objects whose names start with this prefix are listed. The objects consist of all objects and subdirectories in this directory.If you set prefix to a directory name and set delimiter to a forward slash (/), only the objects in the directory are listed. The subdirectories in the directory are returned in CommonPrefixes. Objects and subdirectories in the subdirectories are not listed.For example, a bucket contains the following three objects: fun/test.jpg, fun/movie/001.avi, and fun/movie/007.avi. If prefix is set to fun/, the three objects are returned. If prefix is set to fun/ and delimiter is set to a forward slash (/), fun/test.jpg and fun/movie/ are returned.
    public var prefix: Swift.String?

    /// The encoding format of the returned objects in the response.  The values of Delimiter, StartAfter, Prefix, NextContinuationToken, and Key are UTF-8 encoded. If the value of Delimiter, StartAfter, Prefix, NextContinuationToken, or Key contains a control character that is not supported by Extensible Markup Language (XML) 1.0, you can specify encoding-type to encode the value in the response.
    /// Sees EncodingType for supported values.
    public var encodingType: Swift.String?

    /// Specifies whether to include the information about the bucket owner in the response. Valid values:*   true*   false
    public var fetchOwner: Swift.Bool?

    /// The name of the object after which the list operation begins. If this parameter is specified, objects whose names are alphabetically after the value of start-after are returned.The objects are returned by page based on start-after. The value of start-after can be up to 1,024 bytes in length.If the value of start-after does not exist when you perform a conditional query, the list starts from the object whose name is alphabetically after the value of start-after.
    public var startAfter: Swift.String?

    /// The token from which the list operation starts. You can obtain the token from NextContinuationToken in the response of the ListObjectsV2 request.
    public var continuationToken: Swift.String?

    public init(
        bucket: Swift.String? = nil,
        delimiter: Swift.String? = nil,
        maxKeys: Swift.Int? = nil,
        prefix: Swift.String? = nil,
        encodingType: Swift.String? = nil,
        fetchOwner: Swift.Bool? = nil,
        startAfter: Swift.String? = nil,
        continuationToken: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.bucket = bucket
        self.delimiter = delimiter
        self.maxKeys = maxKeys
        self.prefix = prefix
        self.encodingType = encodingType
        self.fetchOwner = fetchOwner
        self.startAfter = startAfter
        self.continuationToken = continuationToken
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the ListObjectsV2 operation.
public struct ListObjectsV2Result: ResultModel {
    public var commonProp: ResultModelProp = .init()

    /// The prefix in the names of the returned objects.
    public var prefix: Swift.String?

    /// If start-after is specified in the request, the response contains StartAfter.
    public var startAfter: Swift.String?

    /// The maximum number of returned objects in the response.
    public var maxKeys: Swift.Int?

    /// Indicates whether the returned results are truncated. Valid values:- true- false
    public var isTruncated: Swift.Bool?

    /// The number of objects returned for this request. If delimiter is specified in the request, the value of KeyCount is the sum of the values of Key and CommonPrefixes.
    public var keyCount: Swift.Int?

    /// The encoding type of the content in the response. If you specify encoding-type in the request, the values of Delimiter, StartAfter, Prefix, NextContinuationToken, and Key are encoded in the response.
    public var encodingType: Swift.String?

    /// The name of the bucket.
    public var name: Swift.String?

    /// If continuation-token is specified in the request, the response contains ContinuationToken.
    public var continuationToken: Swift.String?

    /// The token from which the next list operation starts. Use the value of NextContinuationToken as the value of continuation-token in the next request.
    public var nextContinuationToken: Swift.String?

    /// The container that stores the metadata of the returned objects.
    public var contents: [ObjectSummary]?

    /// Objects whose names contain the same string that ranges from the prefix to the next occurrence of the delimiter are grouped as a single result element
    public var commonPrefixes: [CommonPrefix]?

    /// The character that is used to group objects by name. The objects whose names contain the same string from the prefix to the next occurrence of the delimiter are grouped as a single result element in CommonPrefixes.
    public var delimiter: Swift.String?
}

/// The request for the GetBucketInfo operation.
public struct GetBucketInfoRequest: RequestModel {
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

/// The result for the GetBucketInfo operation.
public struct GetBucketInfoResult: ResultModel {
    public var commonProp: ResultModelProp = .init()

    /// The container that stores the information about the bucket.
    public var bucketInfo: BucketInfo?
}

/// The request for the GetBucketLocation operation.
public struct GetBucketLocationRequest: RequestModel {
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

/// The result for the GetBucketLocation operation.
public struct GetBucketLocationResult: ResultModel {
    public var commonProp: ResultModelProp = .init()

    /// The region in which the bucket resides.Examples: oss-cn-hangzhou, oss-cn-shanghai, oss-cn-qingdao, oss-cn-beijing, oss-cn-zhangjiakou, oss-cn-hongkong, oss-cn-shenzhen, oss-us-west-1, oss-us-east-1, and oss-ap-southeast-1.For more information about the regions in which buckets reside, see [Regions and endpoints](~~31837~~).
    public var locationConstraint: Swift.String?
}
