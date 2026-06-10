import AlibabaCloudOSS
import Foundation

extension Client {

    /// Configures a lifecycle rule for a bucket. After you configure a lifecycle rule for a bucket, Object Storage Service (OSS) automatically deletes the objects that match the rule or converts the storage type of the objects based on the point in time that is specified in the lifecycle rule.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - options: Optional, operation options
    /// - Returns: The result instance.
    public func putBucketLifecycle(
        _ request: PutBucketLifecycleRequest,
        _ options: OperationOptions? = nil
    ) async throws -> PutBucketLifecycleResult {

        var input = OperationInput(
            operationName: "PutBucketLifecycle",
            method: "PUT",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "lifecycle": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        try request.lifecycleConfiguration.ensureRequired(field: "request.lifecycleConfiguration")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializePutBucketLifecycle, Serde.addContentMd5])

        var output = try await invokeOperation(input, options)

        var result = PutBucketLifecycleResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializePutBucketLifecycle])

        return result
    }
    
    /// Queries the lifecycle rules configured for a bucket. Only the owner of a bucket has the permissions to query the lifecycle rules configured for the bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - options: Optional, operation options
    /// - Returns: The result instance.
    public func getBucketLifecycle(
        _ request: GetBucketLifecycleRequest,
        _ options: OperationOptions? = nil
    ) async throws -> GetBucketLifecycleResult {

        var input = OperationInput(
            operationName: "GetBucketLifecycle",
            method: "GET",
            parameters: [ 
                "lifecycle": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeGetBucketLifecycle, Serde.addContentMd5])

        var output = try await invokeOperation(input, options)

        var result = GetBucketLifecycleResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketLifecycle])

        return result
    }
    
    /// Deletes the lifecycle rules of a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - options: Optional, operation options
    /// - Returns: The result instance.
    public func deleteBucketLifecycle(
        _ request: DeleteBucketLifecycleRequest,
        _ options: OperationOptions? = nil
    ) async throws -> DeleteBucketLifecycleResult {

        var input = OperationInput(
            operationName: "DeleteBucketLifecycle",
            method: "DELETE",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "lifecycle": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeDeleteBucketLifecycle, Serde.addContentMd5])

        var output = try await invokeOperation(input, options)

        var result = DeleteBucketLifecycleResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeDeleteBucketLifecycle])

        return result
    }
    
}
