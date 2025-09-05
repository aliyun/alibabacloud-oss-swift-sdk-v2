import AlibabaCloudOSS
import Foundation

extension Client {

    /// Queries the Block Public Access configurations of a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func getBucketPublicAccessBlock(
        _ request: GetBucketPublicAccessBlockRequest,
        _ options: OperationOptions? = nil
    ) async throws -> GetBucketPublicAccessBlockResult {

        var input = OperationInput(
            operationName: "GetBucketPublicAccessBlock",
            method: "GET",
            parameters: [ 
                "publicAccessBlock": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeGetBucketPublicAccessBlock, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = GetBucketPublicAccessBlockResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketPublicAccessBlock])

        return result
    }
    
    /// Enables or disables Block Public Access for a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func putBucketPublicAccessBlock(
        _ request: PutBucketPublicAccessBlockRequest,
        _ options: OperationOptions? = nil
    ) async throws -> PutBucketPublicAccessBlockResult {

        var input = OperationInput(
            operationName: "PutBucketPublicAccessBlock",
            method: "PUT",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "publicAccessBlock": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        try request.publicAccessBlockConfiguration.ensureRequired(field: "request.publicAccessBlockConfiguration")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializePutBucketPublicAccessBlock, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = PutBucketPublicAccessBlockResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializePutBucketPublicAccessBlock])

        return result
    }
    
    /// Deletes the Block Public Access configurations of a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func deleteBucketPublicAccessBlock(
        _ request: DeleteBucketPublicAccessBlockRequest,
        _ options: OperationOptions? = nil
    ) async throws -> DeleteBucketPublicAccessBlockResult {

        var input = OperationInput(
            operationName: "DeleteBucketPublicAccessBlock",
            method: "DELETE",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "publicAccessBlock": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeDeleteBucketPublicAccessBlock, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = DeleteBucketPublicAccessBlockResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeDeleteBucketPublicAccessBlock])

        return result
    }
    
}
