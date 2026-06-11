import AlibabaCloudOSS
import Foundation

extension Client {

    /// List Storage Redundancy Conversion Tasks for a Bucket
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func listBucketDataRedundancyTransition(
        _ request: ListBucketDataRedundancyTransitionRequest,
        _ options: OperationOptions? = nil
    ) async throws -> ListBucketDataRedundancyTransitionResult {

        var input = OperationInput(
            operationName: "ListBucketDataRedundancyTransition",
            method: "GET",
            parameters: [ 
                "redundancyTransition": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeListBucketDataRedundancyTransition, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = ListBucketDataRedundancyTransitionResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeListBucketDataRedundancyTransition])

        return result
    }
    
    /// Queries the redundancy type conversion tasks of a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func getBucketDataRedundancyTransition(
        _ request: GetBucketDataRedundancyTransitionRequest,
        _ options: OperationOptions? = nil
    ) async throws -> GetBucketDataRedundancyTransitionResult {

        var input = OperationInput(
            operationName: "GetBucketDataRedundancyTransition",
            method: "GET",
            parameters: [ 
                "redundancyTransition": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeGetBucketDataRedundancyTransition, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = GetBucketDataRedundancyTransitionResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketDataRedundancyTransition])

        return result
    }
    
    /// Creates a redundancy type conversion task for a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func createBucketDataRedundancyTransition(
        _ request: CreateBucketDataRedundancyTransitionRequest,
        _ options: OperationOptions? = nil
    ) async throws -> CreateBucketDataRedundancyTransitionResult {

        var input = OperationInput(
            operationName: "CreateBucketDataRedundancyTransition",
            method: "POST",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "redundancyTransition": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeCreateBucketDataRedundancyTransition, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = CreateBucketDataRedundancyTransitionResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeCreateBucketDataRedundancyTransition])

        return result
    }
    
    /// Deletes a redundancy type conversion task of a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func deleteBucketDataRedundancyTransition(
        _ request: DeleteBucketDataRedundancyTransitionRequest,
        _ options: OperationOptions? = nil
    ) async throws -> DeleteBucketDataRedundancyTransitionResult {

        var input = OperationInput(
            operationName: "DeleteBucketDataRedundancyTransition",
            method: "DELETE",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "redundancyTransition": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeDeleteBucketDataRedundancyTransition, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = DeleteBucketDataRedundancyTransitionResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeDeleteBucketDataRedundancyTransition])

        return result
    }
    
    /// List Storage Redundancy Conversion Tasks for a User
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func listUserDataRedundancyTransition(
        _ request: ListUserDataRedundancyTransitionRequest,
        _ options: OperationOptions? = nil
    ) async throws -> ListUserDataRedundancyTransitionResult {

        var input = OperationInput(
            operationName: "ListBucketDataRedundancyTransition",
            method: "GET",
            parameters: [
                "redundancyTransition": "",
            ]
        )

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeListUserDataRedundancyTransition, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = ListUserDataRedundancyTransitionResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeListUserDataRedundancyTransition])

        return result
    }
}
