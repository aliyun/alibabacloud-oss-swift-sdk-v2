import AlibabaCloudOSS
import Foundation
import XMLCoder


// MARK: - PutBucketLogging
extension Serde {
    static func serializePutBucketLogging (
        _ request: inout PutBucketLoggingRequest,
        _ input: inout OperationInput
    ) throws {
        
        let data: Data = try XMLEncoder().encode(request.bucketLoggingStatus, withRootKey: "BucketLoggingStatus")
        input.body = .data(data)
        
    }

    static func deserializePutBucketLogging (
        _ result: inout PutBucketLoggingResult,
        _ output: inout OperationOutput
    ) throws {
        
    }
}


// MARK: - GetBucketLogging
extension Serde {
    static func serializeGetBucketLogging (
        _ request: inout GetBucketLoggingRequest,
        _ input: inout OperationInput
    ) throws {
        
    }

    static func deserializeGetBucketLogging (
        _ result: inout GetBucketLoggingResult,
        _ output: inout OperationOutput
    ) throws {
        
        guard let data = try output.body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }
        let bucketLoggingStatus = try XMLDecoder().decode(BucketLoggingStatus.self, from: data)
        result.bucketLoggingStatus = bucketLoggingStatus
         
    }
}


// MARK: - DeleteBucketLogging
extension Serde {
    static func serializeDeleteBucketLogging (
        _ request: inout DeleteBucketLoggingRequest,
        _ input: inout OperationInput
    ) throws {
        
    }

    static func deserializeDeleteBucketLogging (
        _ result: inout DeleteBucketLoggingResult,
        _ output: inout OperationOutput
    ) throws {
        
    }
}


// MARK: - PutUserDefinedLogFieldsConfig
extension Serde {
    static func serializePutUserDefinedLogFieldsConfig (
        _ request: inout PutUserDefinedLogFieldsConfigRequest,
        _ input: inout OperationInput
    ) throws {
        
        let data: Data = try XMLEncoder().encode(request.userDefinedLogFieldsConfiguration, withRootKey: "UserDefinedLogFieldsConfiguration")
        input.body = .data(data)
        
    }

    static func deserializePutUserDefinedLogFieldsConfig (
        _ result: inout PutUserDefinedLogFieldsConfigResult,
        _ output: inout OperationOutput
    ) throws {
        
    }
}


// MARK: - GetUserDefinedLogFieldsConfig
extension Serde {
    static func serializeGetUserDefinedLogFieldsConfig (
        _ request: inout GetUserDefinedLogFieldsConfigRequest,
        _ input: inout OperationInput
    ) throws {
        
    }

    static func deserializeGetUserDefinedLogFieldsConfig (
        _ result: inout GetUserDefinedLogFieldsConfigResult,
        _ output: inout OperationOutput
    ) throws {
        
        guard let data = try output.body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }
        let userDefinedLogFieldsConfiguration = try XMLDecoder().decode(UserDefinedLogFieldsConfiguration.self, from: data)
        result.userDefinedLogFieldsConfiguration = userDefinedLogFieldsConfiguration
         
    }
}


// MARK: - DeleteUserDefinedLogFieldsConfig
extension Serde {
    static func serializeDeleteUserDefinedLogFieldsConfig (
        _ request: inout DeleteUserDefinedLogFieldsConfigRequest,
        _ input: inout OperationInput
    ) throws {
        
    }

    static func deserializeDeleteUserDefinedLogFieldsConfig (
        _ result: inout DeleteUserDefinedLogFieldsConfigResult,
        _ output: inout OperationOutput
    ) throws {
        
    }
}


