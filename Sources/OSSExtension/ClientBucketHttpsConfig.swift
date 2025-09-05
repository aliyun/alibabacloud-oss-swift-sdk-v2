import AlibabaCloudOSS
import Foundation

extension Client {

    /// Queries the Transport Layer Security (TLS) version configurations of a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func getBucketHttpsConfig(
        _ request: GetBucketHttpsConfigRequest,
        _ options: OperationOptions? = nil
    ) async throws -> GetBucketHttpsConfigResult {

        var input = OperationInput(
            operationName: "GetBucketHttpsConfig",
            method: "GET",
            parameters: [ 
                "httpsConfig": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeGetBucketHttpsConfig, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = GetBucketHttpsConfigResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketHttpsConfig])

        return result
    }
    
    /// Enables or disables Transport Layer Security (TLS) version management for a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func putBucketHttpsConfig(
        _ request: PutBucketHttpsConfigRequest,
        _ options: OperationOptions? = nil
    ) async throws -> PutBucketHttpsConfigResult {

        var input = OperationInput(
            operationName: "PutBucketHttpsConfig",
            method: "PUT",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "httpsConfig": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        try request.httpsConfiguration.ensureRequired(field: "request.httpsConfiguration")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializePutBucketHttpsConfig, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = PutBucketHttpsConfigResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializePutBucketHttpsConfig])

        return result
    }
    
}
