import AlibabaCloudOSS
import Foundation



/// The container in which the redundancy type conversion task is stored.
public struct BucketDataRedundancyTransition: Sendable {
    
    /// The name of the bucket.
    public var bucket: Swift.String?
    
    /// The ID of the redundancy type conversion task. The ID can be used to view and delete the redundancy type conversion task.
    public var taskId: Swift.String?

    /// The state of the redundancy type change task. Valid values:QueueingProcessingFinished
    public var status: Swift.String?

    /// The time when the redundancy type change task was created.
    public var createTime: Swift.String?

    /// The time when the redundancy type change task was performed. This element is available when the task is in the Processing or Finished state.
    public var startTime: Swift.String?

    /// The time when the redundancy type change task was finished. This element is available when the task is in the Finished state.
    public var endTime: Swift.String?
    
    /// The progress of the redundancy type change task in percentage.
    /// Valid values: 0 to 100.
    /// This element is available when the task is in the Processing or Finished state.
    public var processPercentage: Int?

    // The estimated period of time that is required for the redundancy type change task. Unit: hours. This element is available when the task is in the Processing or Finished state.
    public var estimatedRemainingTime: Int64?

    init(
        bucket: String? = nil,
        taskId: String? = nil,
        status: String? = nil,
        createTime: String? = nil,
        startTime: String? = nil,
        endTime: String? = nil,
        processPercentage: Int? = nil,
        estimatedRemainingTime: Int64? = nil
    ) {
        self.bucket = bucket
        self.taskId = taskId
        self.status = status
        self.createTime = createTime
        self.startTime = startTime
        self.endTime = endTime
        self.processPercentage = processPercentage
        self.estimatedRemainingTime = estimatedRemainingTime
    }
}

extension BucketDataRedundancyTransition: Codable {
    enum CodingKeys: String, CodingKey { 
        case bucket = "Bucket"
        case taskId = "TaskId"
        case status = "Status"
        case createTime = "CreateTime"
        case startTime = "StartTime"
        case endTime = "EndTime"
        case processPercentage = "ProcessPercentage"
        case estimatedRemainingTime = "EstimatedRemainingTime"
    }
}


/// The container for listed redundancy type conversion tasks.
public struct ListBucketDataRedundancyTransition: Sendable {

    /// The information about the redundancy type conversion task.
    public var bucketDataRedundancyTransition: [BucketDataRedundancyTransition]?
    
    /// Indicates that this ListUserDataRedundancyTransition request contains subsequent results.
    /// You must set NextContinuationToken to continuation-token to continue obtaining the results.
    public var nextContinuationToken: String?

    /// Indicates whether the returned results are truncated.
    /// Valid values:true: indicates that not all results are returned for the request.
    /// false: indicates that all results are returned for the request.
    public var isTruncated: Bool?

    init(
        bucketDataRedundancyTransition: [BucketDataRedundancyTransition]? = nil,
        nextContinuationToken: String? = nil,
        isTruncated: Bool? = nil
    ) {
        self.bucketDataRedundancyTransition = bucketDataRedundancyTransition
        self.nextContinuationToken = nextContinuationToken
        self.isTruncated = isTruncated
    }
}

extension ListBucketDataRedundancyTransition: Codable {
    enum CodingKeys: String, CodingKey { 
        case bucketDataRedundancyTransition = "BucketDataRedundancyTransition"
        case nextContinuationToken = "NextContinuationToken"
        case isTruncated = "IsTruncated"
    }
}




/// The request for the ListBucketDataRedundancyTransition operation.
public struct ListBucketDataRedundancyTransitionRequest : RequestModel {
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

/// The result for the ListBucketDataRedundancyTransition operation.
public struct ListBucketDataRedundancyTransitionResult : ResultModel {
    public var commonProp: ResultModelProp = .init()
 
    /// The container for listed redundancy type conversion tasks.
    public var listBucketDataRedundancyTransition: ListBucketDataRedundancyTransition?
     
}

/// The request for the GetBucketDataRedundancyTransition operation.
public struct GetBucketDataRedundancyTransitionRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// The ID of the redundancy change task.
    public var redundancyTransitionTaskid: Swift.String?
    

    public init( 
        bucket: Swift.String? = nil,
        redundancyTransitionTaskid: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.redundancyTransitionTaskid = redundancyTransitionTaskid
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the GetBucketDataRedundancyTransition operation.
public struct GetBucketDataRedundancyTransitionResult : ResultModel {
    public var commonProp: ResultModelProp = .init()
 
    /// The container for a specific redundancy type change task.
    public var bucketDataRedundancyTransition: BucketDataRedundancyTransition?
     
}

/// The request for the CreateBucketDataRedundancyTransition operation.
public struct CreateBucketDataRedundancyTransitionRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// The redundancy type to which you want to convert the bucket. You can only convert the redundancy type of a bucket from LRS to ZRS.
    public var targetRedundancyType: Swift.String?
    

    public init( 
        bucket: Swift.String? = nil,
        targetRedundancyType: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.targetRedundancyType = targetRedundancyType
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the CreateBucketDataRedundancyTransition operation.
public struct CreateBucketDataRedundancyTransitionResult : ResultModel {
    public var commonProp: ResultModelProp = .init()
 
    /// The container in which the redundancy type conversion task is stored.
    public var bucketDataRedundancyTransition: BucketDataRedundancyTransition?
     
}

/// The request for the DeleteBucketDataRedundancyTransition operation.
public struct DeleteBucketDataRedundancyTransitionRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// The ID of the redundancy type change task.
    public var redundancyTransitionTaskid: Swift.String?
    

    public init( 
        bucket: Swift.String? = nil,
        redundancyTransitionTaskid: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.redundancyTransitionTaskid = redundancyTransitionTaskid
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the DeleteBucketDataRedundancyTransition operation.
public struct DeleteBucketDataRedundancyTransitionResult : ResultModel {
    public var commonProp: ResultModelProp = .init()

}

public struct ListUserDataRedundancyTransitionRequest: RequestModel {
    public var commonProp: RequestModelProp
    
    /// The token from which the list operation must start.
    public var continuationToken: String?

    /// The maximum number of redundancy type conversion tasks that can be returned. Valid values: 1 to 100.
    public var maxKeys: Int?
    
    public init(
        continuationToken: String? = nil,
        maxKeys: Int? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.continuationToken = continuationToken
        self.maxKeys = maxKeys
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

public struct ListUserDataRedundancyTransitionResult: ResultModel {
    public var commonProp: ResultModelProp = .init()
    
    /// The container in which the listed redundancy type conversion tasks are stored.
    public var listBucketDataRedundancyTransition: ListBucketDataRedundancyTransition?
}
