import AlibabaCloudOSS
import Foundation

// MARK: - Shared value types

/// The configuration used to create an AgenticBucket.
public struct CreateAgenticBucketConfiguration: Sendable {
    /// The storage class of the AgenticBucket. Valid values: Standard, IA, Archive. Default: Standard.
    public var storageClass: Swift.String?

    /// The data redundancy type of the AgenticBucket. Valid values: LRS, ZRS. Default: LRS.
    public var dataRedundancyType: Swift.String?

    public init(
        storageClass: Swift.String? = nil,
        dataRedundancyType: Swift.String? = nil
    ) {
        self.storageClass = storageClass
        self.dataRedundancyType = dataRedundancyType
    }
}

/// The information about an AgenticBucket.
public struct AgenticBucketInfo: Sendable {
    /// The name of the AgenticBucket.
    public var name: Swift.String?

    /// The Alibaba Cloud account ID (UID) of the AgenticBucket owner.
    public var owner: Swift.String?

    /// The region in which the AgenticBucket is located.
    public var region: Swift.String?

    /// The storage class of the AgenticBucket.
    public var storageClass: Swift.String?

    /// The data redundancy type of the AgenticBucket.
    public var dataRedundancyType: Swift.String?

    /// The status of the AgenticBucket. Valid values: Enabled, Disabled.
    public var status: Swift.String?

    /// The resource type of the bucket. The fixed value is agentic.
    public var bucketResourceType: Swift.String?

    /// The time when the AgenticBucket was created.
    public var createTime: Swift.String?

    /// The access control list (ACL) of the AgenticBucket.
    public var acl: Swift.String?

    /// Whether public access is blocked. Valid values: true, false.
    public var publicAccessBlock: Swift.String?

    /// The server-side encryption configuration of the AgenticBucket.
    public var serverSideEncryptionRule: ServerSideEncryptionRule?

    /// The versioning status of the AgenticBucket.
    public var versioning: Swift.String?

    /// The bucket policy of the AgenticBucket.
    public var bucketPolicy: Swift.String?

    public init(
        name: Swift.String? = nil,
        owner: Swift.String? = nil,
        region: Swift.String? = nil,
        storageClass: Swift.String? = nil,
        dataRedundancyType: Swift.String? = nil,
        status: Swift.String? = nil,
        bucketResourceType: Swift.String? = nil,
        createTime: Swift.String? = nil,
        acl: Swift.String? = nil,
        publicAccessBlock: Swift.String? = nil,
        serverSideEncryptionRule: ServerSideEncryptionRule? = nil,
        versioning: Swift.String? = nil,
        bucketPolicy: Swift.String? = nil
    ) {
        self.name = name
        self.owner = owner
        self.region = region
        self.storageClass = storageClass
        self.dataRedundancyType = dataRedundancyType
        self.status = status
        self.bucketResourceType = bucketResourceType
        self.createTime = createTime
        self.acl = acl
        self.publicAccessBlock = publicAccessBlock
        self.serverSideEncryptionRule = serverSideEncryptionRule
        self.versioning = versioning
        self.bucketPolicy = bucketPolicy
    }
}

/// The summary of an AgenticBucket in the ListAgenticBuckets result.
public struct AgenticBucketSummary: Sendable {
    /// The name of the AgenticBucket.
    public var name: Swift.String?

    /// The storage class of the AgenticBucket.
    public var storageClass: Swift.String?

    /// The data redundancy type of the AgenticBucket.
    public var dataRedundancyType: Swift.String?

    /// The time when the AgenticBucket was created.
    public var createTime: Swift.String?

    public init(
        name: Swift.String? = nil,
        storageClass: Swift.String? = nil,
        dataRedundancyType: Swift.String? = nil,
        createTime: Swift.String? = nil
    ) {
        self.name = name
        self.storageClass = storageClass
        self.dataRedundancyType = dataRedundancyType
        self.createTime = createTime
    }
}

/// The summary of a BucketSpace in the ListBucketSpaces result.
public struct BucketSpaceSummary: Sendable {
    /// The name of the BucketSpace.
    public var name: Swift.String?

    /// The location of the BucketSpace, for example oss-cn-hangzhou.
    public var location: Swift.String?

    /// The time when the BucketSpace was created.
    public var creationDate: Swift.String?

    /// The storage class of the BucketSpace.
    public var storageClass: Swift.String?

    public init(
        name: Swift.String? = nil,
        location: Swift.String? = nil,
        creationDate: Swift.String? = nil,
        storageClass: Swift.String? = nil
    ) {
        self.name = name
        self.location = location
        self.creationDate = creationDate
        self.storageClass = storageClass
    }
}

// MARK: - CreateAgenticBucket

/// The request for the CreateAgenticBucket operation.
public struct CreateAgenticBucketRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The user-defined prefix of the AgenticBucket name. The physical bucket name is
    /// derived as {prefix}-{accountId}-{region}-ab-apsr.
    public var bucket: Swift.String?

    /// The container that stores the request body.
    public var createAgenticBucketConfiguration: CreateAgenticBucketConfiguration?

    public init(
        bucket: Swift.String? = nil,
        createAgenticBucketConfiguration: CreateAgenticBucketConfiguration? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.bucket = bucket
        self.createAgenticBucketConfiguration = createAgenticBucketConfiguration
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the CreateAgenticBucket operation.
public struct CreateAgenticBucketResult: ResultModel {
    public var commonProp: ResultModelProp = .init()
}

// MARK: - DeleteAgenticBucket

/// The request for the DeleteAgenticBucket operation.
public struct DeleteAgenticBucketRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The user-defined prefix of the AgenticBucket name.
    public var bucket: Swift.String?

    public init(
        bucket: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.bucket = bucket
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the DeleteAgenticBucket operation.
public struct DeleteAgenticBucketResult: ResultModel {
    public var commonProp: ResultModelProp = .init()
}

// MARK: - GetAgenticBucket

/// The request for the GetAgenticBucket operation.
public struct GetAgenticBucketRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The user-defined prefix of the AgenticBucket name.
    public var bucket: Swift.String?

    public init(
        bucket: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.bucket = bucket
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the GetAgenticBucket operation.
public struct GetAgenticBucketResult: ResultModel {
    public var commonProp: ResultModelProp = .init()

    /// The information about the AgenticBucket.
    public var agenticBucketInfo: AgenticBucketInfo?
}

// MARK: - ListAgenticBuckets

/// The request for the ListAgenticBuckets operation.
public struct ListAgenticBucketsRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The token from which the list operation continues.
    public var continuationToken: Swift.String?

    /// The maximum number of AgenticBuckets to return. Default: 100.
    public var maxKeys: Swift.Int?

    public init(
        continuationToken: Swift.String? = nil,
        maxKeys: Swift.Int? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.continuationToken = continuationToken
        self.maxKeys = maxKeys
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the ListAgenticBuckets operation.
public struct ListAgenticBucketsResult: ResultModel {
    public var commonProp: ResultModelProp = .init()

    /// The region in which the AgenticBuckets are located.
    public var region: Swift.String?

    /// The Alibaba Cloud account ID (UID) of the owner.
    public var owner: Swift.String?

    /// The token from which the list operation started.
    public var continuationToken: Swift.String?

    /// The token used to continue the next list operation.
    public var nextContinuationToken: Swift.String?

    /// Whether the returned result is truncated.
    public var isTruncated: Swift.Bool?

    /// The list of AgenticBuckets.
    public var agenticBuckets: [AgenticBucketSummary]?
}

// MARK: - PutAgenticBucketStatus

/// The request for the PutAgenticBucketStatus operation.
public struct PutAgenticBucketStatusRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The user-defined prefix of the AgenticBucket name.
    public var bucket: Swift.String?

    /// The status to set. Valid values: Enabled, Disabled.
    public var status: Swift.String?

    public init(
        bucket: Swift.String? = nil,
        status: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.bucket = bucket
        self.status = status
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the PutAgenticBucketStatus operation.
public struct PutAgenticBucketStatusResult: ResultModel {
    public var commonProp: ResultModelProp = .init()
}

// MARK: - ListBucketSpaces

/// The request for the ListBucketSpaces operation.
public struct ListBucketSpacesRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The user-defined prefix of the AgenticBucket name that owns the BucketSpaces.
    public var bucket: Swift.String?

    /// The prefix used to filter the returned BucketSpace names.
    public var prefix: Swift.String?

    /// The token from which the list operation continues.
    public var continuationToken: Swift.String?

    /// The name of the BucketSpace after which the list operation begins.
    public var startAfter: Swift.String?

    /// The maximum number of BucketSpaces to return. Default: 100.
    public var maxKeys: Swift.Int?

    public init(
        bucket: Swift.String? = nil,
        prefix: Swift.String? = nil,
        continuationToken: Swift.String? = nil,
        startAfter: Swift.String? = nil,
        maxKeys: Swift.Int? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.bucket = bucket
        self.prefix = prefix
        self.continuationToken = continuationToken
        self.startAfter = startAfter
        self.maxKeys = maxKeys
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the ListBucketSpaces operation.
public struct ListBucketSpacesResult: ResultModel {
    public var commonProp: ResultModelProp = .init()

    /// The container that stores the information about the owner.
    public var owner: Owner?

    /// The prefix used to filter the returned BucketSpace names.
    public var prefix: Swift.String?

    /// The maximum number of BucketSpaces returned.
    public var maxKeys: Swift.Int?

    /// The token from which the list operation started.
    public var continuationToken: Swift.String?

    /// The token used to continue the next list operation.
    public var nextContinuationToken: Swift.String?

    /// The name of the BucketSpace after which the list operation began.
    public var startAfter: Swift.String?

    /// Whether the returned result is truncated.
    public var isTruncated: Swift.Bool?

    /// The list of BucketSpaces.
    public var bucketSpaces: [BucketSpaceSummary]?
}
