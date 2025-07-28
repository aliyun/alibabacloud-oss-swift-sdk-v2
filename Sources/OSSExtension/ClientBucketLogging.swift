import AlibabaCloudOSS
import Foundation

extension Client {

    /// Enables logging for a bucket. After you enable logging for a bucket, Object Storage Service (OSS) generates logs every hour based on the defined naming rule and stores the logs as objects in the specified destination bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func putBucketLogging(
        _ request: PutBucketLoggingRequest,
        _ options: OperationOptions? = nil
    ) async throws -> PutBucketLoggingResult {

        var input = OperationInput(
            operationName: "PutBucketLogging",
            method: "PUT",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "logging": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        try request.bucketLoggingStatus.ensureRequired(field: "request.bucketLoggingStatus")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializePutBucketLogging, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = PutBucketLoggingResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializePutBucketLogging])

        return result
    }
    
    /// Queries the configurations of access log collection of a bucket. Only the owner of a bucket can query the configurations of access log collection of the bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func getBucketLogging(
        _ request: GetBucketLoggingRequest,
        _ options: OperationOptions? = nil
    ) async throws -> GetBucketLoggingResult {

        var input = OperationInput(
            operationName: "GetBucketLogging",
            method: "GET",
            parameters: [ 
                "logging": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeGetBucketLogging, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = GetBucketLoggingResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketLogging])

        return result
    }
    
    /// Disables the logging feature for a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func deleteBucketLogging(
        _ request: DeleteBucketLoggingRequest,
        _ options: OperationOptions? = nil
    ) async throws -> DeleteBucketLoggingResult {

        var input = OperationInput(
            operationName: "DeleteBucketLogging",
            method: "DELETE",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "logging": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeDeleteBucketLogging, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = DeleteBucketLoggingResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeDeleteBucketLogging])

        return result
    }
    
    /// Customizes the user_defined_log_fields field in real-time logs by adding custom request headers or query parameters to the field for subsequent analysis of requests.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func putUserDefinedLogFieldsConfig(
        _ request: PutUserDefinedLogFieldsConfigRequest,
        _ options: OperationOptions? = nil
    ) async throws -> PutUserDefinedLogFieldsConfigResult {

        var input = OperationInput(
            operationName: "PutUserDefinedLogFieldsConfig",
            method: "PUT",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "userDefinedLogFieldsConfig": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        try request.userDefinedLogFieldsConfiguration.ensureRequired(field: "request.userDefinedLogFieldsConfiguration")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializePutUserDefinedLogFieldsConfig, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = PutUserDefinedLogFieldsConfigResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializePutUserDefinedLogFieldsConfig])

        return result
    }
    
    /// Queries the custom configurations of the user_defined_log_fields field in the real-time logs of a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func getUserDefinedLogFieldsConfig(
        _ request: GetUserDefinedLogFieldsConfigRequest,
        _ options: OperationOptions? = nil
    ) async throws -> GetUserDefinedLogFieldsConfigResult {

        var input = OperationInput(
            operationName: "GetUserDefinedLogFieldsConfig",
            method: "GET",
            parameters: [ 
                "userDefinedLogFieldsConfig": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeGetUserDefinedLogFieldsConfig, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = GetUserDefinedLogFieldsConfigResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetUserDefinedLogFieldsConfig])

        return result
    }
    
    /// Deletes the custom configurations of the user_defined_log_fields field in the real-time logs of a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func deleteUserDefinedLogFieldsConfig(
        _ request: DeleteUserDefinedLogFieldsConfigRequest,
        _ options: OperationOptions? = nil
    ) async throws -> DeleteUserDefinedLogFieldsConfigResult {

        var input = OperationInput(
            operationName: "DeleteUserDefinedLogFieldsConfig",
            method: "DELETE",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "userDefinedLogFieldsConfig": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeDeleteUserDefinedLogFieldsConfig, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = DeleteUserDefinedLogFieldsConfigResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeDeleteUserDefinedLogFieldsConfig])

        return result
    }
    
}
