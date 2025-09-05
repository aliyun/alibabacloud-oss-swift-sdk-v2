import AlibabaCloudOSS
import Foundation

extension Client {

    /// View storage space archive direct read status
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func getBucketArchiveDirectRead(
        _ request: GetBucketArchiveDirectReadRequest,
        _ options: OperationOptions? = nil
    ) async throws -> GetBucketArchiveDirectReadResult {

        var input = OperationInput(
            operationName: "GetBucketArchiveDirectRead",
            method: "GET",
            parameters: [ 
                "bucketArchiveDirectRead": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeGetBucketArchiveDirectRead, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = GetBucketArchiveDirectReadResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketArchiveDirectRead])

        return result
    }
    
    /// Enable or disable the storage space archive direct read function
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func putBucketArchiveDirectRead(
        _ request: PutBucketArchiveDirectReadRequest,
        _ options: OperationOptions? = nil
    ) async throws -> PutBucketArchiveDirectReadResult {

        var input = OperationInput(
            operationName: "PutBucketArchiveDirectRead",
            method: "PUT",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "bucketArchiveDirectRead": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        try request.archiveDirectReadConfiguration.ensureRequired(field: "request.archiveDirectReadConfiguration")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializePutBucketArchiveDirectRead, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = PutBucketArchiveDirectReadResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializePutBucketArchiveDirectRead])

        return result
    }
    
}
