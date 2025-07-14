import Foundation
import AlibabaCloudOSS

extension Client {

    /// Configures transfer acceleration for a bucket. After you enable transfer acceleration for a bucket, the object access speed is accelerated for users worldwide. The transfer acceleration feature is applicable to scenarios where data needs to be transferred over long geographical distances. This feature can also be used to download or upload objects that are gigabytes or terabytes in size.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func putBucketTransferAcceleration(
        _ request: PutBucketTransferAccelerationRequest,
        _ options: OperationOptions? = nil
    ) async throws -> PutBucketTransferAccelerationResult {

        var input = OperationInput(
            operationName: "PutBucketTransferAcceleration",
            method: "PUT",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "transferAcceleration": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        try request.transferAccelerationConfiguration.ensureRequired(field: "request.transferAccelerationConfiguration")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializePutBucketTransferAcceleration, Serde.addContentMd5])

        var output = try await invokeOperation(input, options)

        var result = PutBucketTransferAccelerationResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializePutBucketTransferAcceleration])

        return result
    }
    
    /// Queries the transfer acceleration configurations of a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func getBucketTransferAcceleration(
        _ request: GetBucketTransferAccelerationRequest,
        _ options: OperationOptions? = nil
    ) async throws -> GetBucketTransferAccelerationResult {

        var input = OperationInput(
            operationName: "GetBucketTransferAcceleration",
            method: "GET",
            parameters: [ 
                "transferAcceleration": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeGetBucketTransferAcceleration, Serde.addContentMd5])

        var output = try await invokeOperation(input, options)

        var result = GetBucketTransferAccelerationResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketTransferAcceleration])

        return result
    }
    
}
