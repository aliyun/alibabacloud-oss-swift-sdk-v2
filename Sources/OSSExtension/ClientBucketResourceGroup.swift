import AlibabaCloudOSS
import Foundation

extension Client {

    /// Queries the ID of the resource group to which a bucket belongs.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func getBucketResourceGroup(
        _ request: GetBucketResourceGroupRequest,
        _ options: OperationOptions? = nil
    ) async throws -> GetBucketResourceGroupResult {

        var input = OperationInput(
            operationName: "GetBucketResourceGroup",
            method: "GET",
            parameters: [ 
                "resourceGroup": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeGetBucketResourceGroup, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = GetBucketResourceGroupResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketResourceGroup])

        return result
    }
    
    /// Modifies the ID of the resource group to which a bucket belongs.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func putBucketResourceGroup(
        _ request: PutBucketResourceGroupRequest,
        _ options: OperationOptions? = nil
    ) async throws -> PutBucketResourceGroupResult {

        var input = OperationInput(
            operationName: "PutBucketResourceGroup",
            method: "PUT",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "resourceGroup": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        try request.bucketResourceGroupConfiguration.ensureRequired(field: "request.bucketResourceGroupConfiguration")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializePutBucketResourceGroup, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = PutBucketResourceGroupResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializePutBucketResourceGroup])

        return result
    }
    
}
