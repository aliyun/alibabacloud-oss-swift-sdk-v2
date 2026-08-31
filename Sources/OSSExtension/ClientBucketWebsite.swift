import AlibabaCloudOSS
import Foundation

extension Client {

    /// Queries the static website hosting status and redirection rules configured for a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func getBucketWebsite(
        _ request: GetBucketWebsiteRequest,
        _ options: OperationOptions? = nil
    ) async throws -> GetBucketWebsiteResult {

        var input = OperationInput(
            operationName: "GetBucketWebsite",
            method: "GET",
            parameters: [ 
                "website": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeGetBucketWebsite, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = GetBucketWebsiteResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketWebsite])

        return result
    }
    
    /// Enables the static website hosting mode for a bucket and configures redirection rules for the bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func putBucketWebsite(
        _ request: PutBucketWebsiteRequest,
        _ options: OperationOptions? = nil
    ) async throws -> PutBucketWebsiteResult {

        var input = OperationInput(
            operationName: "PutBucketWebsite",
            method: "PUT",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "website": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        try request.websiteConfiguration.ensureRequired(field: "request.websiteConfiguration")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializePutBucketWebsite, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = PutBucketWebsiteResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializePutBucketWebsite])

        return result
    }
    
    /// Disables the static website hosting mode and deletes the redirection rules for a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func deleteBucketWebsite(
        _ request: DeleteBucketWebsiteRequest,
        _ options: OperationOptions? = nil
    ) async throws -> DeleteBucketWebsiteResult {

        var input = OperationInput(
            operationName: "DeleteBucketWebsite",
            method: "DELETE",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "website": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeDeleteBucketWebsite, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = DeleteBucketWebsiteResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeDeleteBucketWebsite])

        return result
    }
    
}
