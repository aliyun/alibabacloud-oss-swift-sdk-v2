import AlibabaCloudOSS
import Foundation



/// The specified field configurations of real-time logs in a bucket.
public struct UserDefinedLogFieldsConfiguration: Sendable {

    /// The container that stores the configurations of custom request headers.
    public var headerSet: HeaderSet?

    /// The container that stores the configurations of custom URL parameters.
    public var paramSet: ParamSet?

    public init( 
        headerSet: HeaderSet? = nil,
        paramSet: ParamSet? = nil
    ) { 
        self.headerSet = headerSet
        self.paramSet = paramSet
    }
}

extension UserDefinedLogFieldsConfiguration: Codable {
    enum CodingKeys: String, CodingKey { 
        case headerSet = "HeaderSet"
    
        case paramSet = "ParamSet"
    
    }
}


/// The container that stores the information about access log collection.
public struct LoggingEnabled: Sendable {

    /// The prefix of the log objects. This parameter can be left empty.
    public var targetPrefix: Swift.String?

    /// The bucket that stores access logs.
    public var targetBucket: Swift.String?

    public init( 
        targetBucket: Swift.String? = nil,
        targetPrefix: Swift.String? = nil
    ) {
        self.targetPrefix = targetPrefix
        self.targetBucket = targetBucket
    }
}

extension LoggingEnabled: Codable {
    enum CodingKeys: String, CodingKey { 
        case targetBucket = "TargetBucket"
        case targetPrefix = "TargetPrefix"
    }
}


/// Indicates the container used to store access logging configuration of a bucket.
public struct BucketLoggingStatus: Sendable {

    /// Indicates the container used to store access logging information. This element is returned if it is enabled and is not returned if it is disabled.
    public var loggingEnabled: LoggingEnabled?

    public init( 
        loggingEnabled: LoggingEnabled? = nil
    ) { 
        self.loggingEnabled = loggingEnabled
    }
}

extension BucketLoggingStatus: Codable {
    enum CodingKeys: String, CodingKey { 
        case loggingEnabled = "LoggingEnabled"
    
    }
}


/// The container that stores the configurations of custom request headers.
public struct HeaderSet: Sendable {

    /// The list of the custom request headers.
    public var headers: [Swift.String]?

    public init( 
        headers: [Swift.String]? = nil
    ) { 
        self.headers = headers
    }
}

extension HeaderSet: Codable {
    enum CodingKeys: String, CodingKey { 
        case headers = "header"
    
    }
}


/// The container that stores the configurations of custom URL parameters.
public struct ParamSet: Sendable {

    /// The list of the custom URL parameters.
    public var parameters: [Swift.String]?

    public init( 
        parameters: [Swift.String]? = nil
    ) { 
        self.parameters = parameters
    }
}

extension ParamSet: Codable {
    enum CodingKeys: String, CodingKey { 
        case parameters = "parameter"
    
    }
}




/// The request for the PutBucketLogging operation.
public struct PutBucketLoggingRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// The request body schema.
    public var bucketLoggingStatus: BucketLoggingStatus?
    

    public init( 
        bucket: Swift.String? = nil,
        bucketLoggingStatus: BucketLoggingStatus? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.bucketLoggingStatus = bucketLoggingStatus
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the PutBucketLogging operation.
public struct PutBucketLoggingResult : ResultModel {
    public var commonProp: ResultModelProp = .init()

}

/// The request for the GetBucketLogging operation.
public struct GetBucketLoggingRequest : RequestModel {
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

/// The result for the GetBucketLogging operation.
public struct GetBucketLoggingResult : ResultModel {
    public var commonProp: ResultModelProp = .init()
 
    /// Indicates the container used to store access logging configuration of a bucket.
    public var bucketLoggingStatus: BucketLoggingStatus?
     
}

/// The request for the DeleteBucketLogging operation.
public struct DeleteBucketLoggingRequest : RequestModel {
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

/// The result for the DeleteBucketLogging operation.
public struct DeleteBucketLoggingResult : ResultModel {
    public var commonProp: ResultModelProp = .init()

}

/// The request for the PutUserDefinedLogFieldsConfig operation.
public struct PutUserDefinedLogFieldsConfigRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// The container that stores the specified log configurations.
    public var userDefinedLogFieldsConfiguration: UserDefinedLogFieldsConfiguration?
    

    public init( 
        bucket: Swift.String? = nil,
        userDefinedLogFieldsConfiguration: UserDefinedLogFieldsConfiguration? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.userDefinedLogFieldsConfiguration = userDefinedLogFieldsConfiguration
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the PutUserDefinedLogFieldsConfig operation.
public struct PutUserDefinedLogFieldsConfigResult : ResultModel {
    public var commonProp: ResultModelProp = .init()

}

/// The request for the GetUserDefinedLogFieldsConfig operation.
public struct GetUserDefinedLogFieldsConfigRequest : RequestModel {
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

/// The result for the GetUserDefinedLogFieldsConfig operation.
public struct GetUserDefinedLogFieldsConfigResult : ResultModel {
    public var commonProp: ResultModelProp = .init()
 
    /// The container for the user-defined logging configuration.
    public var userDefinedLogFieldsConfiguration: UserDefinedLogFieldsConfiguration?
     
}

/// The request for the DeleteUserDefinedLogFieldsConfig operation.
public struct DeleteUserDefinedLogFieldsConfigRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// 
    public var bucket: Swift.String? 
    

    public init( 
        bucket: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the DeleteUserDefinedLogFieldsConfig operation.
public struct DeleteUserDefinedLogFieldsConfigResult : ResultModel {
    public var commonProp: ResultModelProp = .init()

}

