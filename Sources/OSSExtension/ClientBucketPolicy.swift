import AlibabaCloudOSS
import Foundation

extension Client {

    /// Configures a policy for a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func putBucketPolicy(
        _ request: PutBucketPolicyRequest,
        _ options: OperationOptions? = nil
    ) async throws -> PutBucketPolicyResult {

        var input = OperationInput(
            operationName: "PutBucketPolicy",
            method: "PUT",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "policy": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        try request.body.ensureRequired(field: "request.body")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializePutBucketPolicy, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = PutBucketPolicyResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializePutBucketPolicy])

        return result
    }
    
    /// Queries the policies configured for a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func getBucketPolicy(
        _ request: GetBucketPolicyRequest,
        _ options: OperationOptions? = nil
    ) async throws -> GetBucketPolicyResult {

        var input = OperationInput(
            operationName: "GetBucketPolicy",
            method: "GET",
            parameters: [ 
                "policy": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeGetBucketPolicy, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = GetBucketPolicyResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketPolicy])

        return result
    }
    
    /// Deletes a policy for a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func deleteBucketPolicy(
        _ request: DeleteBucketPolicyRequest,
        _ options: OperationOptions? = nil
    ) async throws -> DeleteBucketPolicyResult {

        var input = OperationInput(
            operationName: "DeleteBucketPolicy",
            method: "DELETE",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "policy": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeDeleteBucketPolicy, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = DeleteBucketPolicyResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeDeleteBucketPolicy])

        return result
    }
    
    /// Checks whether the current bucket policy allows public access.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func getBucketPolicyStatus(
        _ request: GetBucketPolicyStatusRequest,
        _ options: OperationOptions? = nil
    ) async throws -> GetBucketPolicyStatusResult {

        var input = OperationInput(
            operationName: "GetBucketPolicyStatus",
            method: "GET",
            parameters: [ 
                "policyStatus": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeGetBucketPolicyStatus, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = GetBucketPolicyStatusResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketPolicyStatus])

        return result
    }
    
}
