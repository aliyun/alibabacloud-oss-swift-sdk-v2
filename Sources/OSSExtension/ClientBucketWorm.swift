import AlibabaCloudOSS
import Foundation

extension Client {

    /// Creates a retention policy.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func initiateBucketWorm(
        _ request: InitiateBucketWormRequest,
        _ options: OperationOptions? = nil
    ) async throws -> InitiateBucketWormResult {

        var input = OperationInput(
            operationName: "InitiateBucketWorm",
            method: "POST",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "worm": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        try request.initiateWormConfiguration.ensureRequired(field: "request.initiateWormConfiguration")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeInitiateBucketWorm, Serde.addContentMd5])

        var output = try await invokeOperation(input, options)

        var result = InitiateBucketWormResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeInitiateBucketWorm])

        return result
    }
    
    /// Deletes an unlocked retention policy for a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func abortBucketWorm(
        _ request: AbortBucketWormRequest,
        _ options: OperationOptions? = nil
    ) async throws -> AbortBucketWormResult {

        var input = OperationInput(
            operationName: "AbortBucketWorm",
            method: "DELETE",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "worm": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeAbortBucketWorm, Serde.addContentMd5])

        var output = try await invokeOperation(input, options)

        var result = AbortBucketWormResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeAbortBucketWorm])

        return result
    }
    
    /// Locks a retention policy.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func completeBucketWorm(
        _ request: CompleteBucketWormRequest,
        _ options: OperationOptions? = nil
    ) async throws -> CompleteBucketWormResult {

        var input = OperationInput(
            operationName: "CompleteBucketWorm",
            method: "POST",
            headers: [
                "Content-Type": "application/xml"
            ],
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        try request.wormId.ensureRequired(field: "request.wormId")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeCompleteBucketWorm, Serde.addContentMd5])

        var output = try await invokeOperation(input, options)

        var result = CompleteBucketWormResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeCompleteBucketWorm])

        return result
    }
    
    /// Extends the retention period of objects in a bucket for which a retention policy is locked.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func extendBucketWorm(
        _ request: ExtendBucketWormRequest,
        _ options: OperationOptions? = nil
    ) async throws -> ExtendBucketWormResult {

        var input = OperationInput(
            operationName: "ExtendBucketWorm",
            method: "POST",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "wormExtend": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        try request.wormId.ensureRequired(field: "request.wormId")
        try request.extendWormConfiguration.ensureRequired(field: "request.extendWormConfiguration")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeExtendBucketWorm, Serde.addContentMd5])

        var output = try await invokeOperation(input, options)

        var result = ExtendBucketWormResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeExtendBucketWorm])

        return result
    }
    
    /// Queries the retention policy configured for a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func getBucketWorm(
        _ request: GetBucketWormRequest,
        _ options: OperationOptions? = nil
    ) async throws -> GetBucketWormResult {

        var input = OperationInput(
            operationName: "GetBucketWorm",
            method: "GET",
            parameters: [ 
                "worm": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeGetBucketWorm, Serde.addContentMd5])

        var output = try await invokeOperation(input, options)

        var result = GetBucketWormResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketWorm])

        return result
    }
    
}
