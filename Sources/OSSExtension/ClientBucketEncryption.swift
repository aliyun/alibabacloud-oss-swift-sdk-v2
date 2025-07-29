import AlibabaCloudOSS
import Foundation

extension Client {

    /// Configures encryption rules for a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func putBucketEncryption(
        _ request: PutBucketEncryptionRequest,
        _ options: OperationOptions? = nil
    ) async throws -> PutBucketEncryptionResult {

        var input = OperationInput(
            operationName: "PutBucketEncryption",
            method: "PUT",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "encryption": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        try request.serverSideEncryptionRule.ensureRequired(field: "request.serverSideEncryptionRule")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializePutBucketEncryption, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = PutBucketEncryptionResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializePutBucketEncryption])

        return result
    }
    
    /// Queries the encryption rules configured for a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func getBucketEncryption(
        _ request: GetBucketEncryptionRequest,
        _ options: OperationOptions? = nil
    ) async throws -> GetBucketEncryptionResult {

        var input = OperationInput(
            operationName: "GetBucketEncryption",
            method: "GET",
            parameters: [ 
                "encryption": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeGetBucketEncryption, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = GetBucketEncryptionResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketEncryption])

        return result
    }
    
    /// Deletes encryption rules for a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func deleteBucketEncryption(
        _ request: DeleteBucketEncryptionRequest,
        _ options: OperationOptions? = nil
    ) async throws -> DeleteBucketEncryptionResult {

        var input = OperationInput(
            operationName: "DeleteBucketEncryption",
            method: "DELETE",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "encryption": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeDeleteBucketEncryption, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = DeleteBucketEncryptionResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeDeleteBucketEncryption])

        return result
    }
    
}
