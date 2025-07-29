import AlibabaCloudOSS
import Foundation

extension Client {

    /// Configures a Referer whitelist for an Object Storage Service (OSS) bucket. You can specify whether to allow the requests whose Referer field is empty or whose query strings are truncated.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func putBucketReferer(
        _ request: PutBucketRefererRequest,
        _ options: OperationOptions? = nil
    ) async throws -> PutBucketRefererResult {

        var input = OperationInput(
            operationName: "PutBucketReferer",
            method: "PUT",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "referer": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        try request.refererConfiguration.ensureRequired(field: "request.refererConfiguration")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializePutBucketReferer, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = PutBucketRefererResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializePutBucketReferer])

        return result
    }
    
    /// Queries the hotlink protection configurations for a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func getBucketReferer(
        _ request: GetBucketRefererRequest,
        _ options: OperationOptions? = nil
    ) async throws -> GetBucketRefererResult {

        var input = OperationInput(
            operationName: "GetBucketReferer",
            method: "GET",
            parameters: [ 
                "referer": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeGetBucketReferer, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = GetBucketRefererResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketReferer])

        return result
    }
    
}
