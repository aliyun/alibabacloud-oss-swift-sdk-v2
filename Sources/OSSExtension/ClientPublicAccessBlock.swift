import AlibabaCloudOSS
import Foundation

extension Client {

    /// Queries the Block Public Access configurations of OSS resources.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func getPublicAccessBlock(
        _ request: GetPublicAccessBlockRequest,
        _ options: OperationOptions? = nil
    ) async throws -> GetPublicAccessBlockResult {

        var input = OperationInput(
            operationName: "GetPublicAccessBlock",
            method: "GET",
            parameters: [ 
                "publicAccessBlock": "", 
            ]
        ) 

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeGetPublicAccessBlock, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = GetPublicAccessBlockResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetPublicAccessBlock])

        return result
    }
    
    /// Enables or disables Block Public Access for Object Storage Service (OSS) resources.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func putPublicAccessBlock(
        _ request: PutPublicAccessBlockRequest,
        _ options: OperationOptions? = nil
    ) async throws -> PutPublicAccessBlockResult {

        var input = OperationInput(
            operationName: "PutPublicAccessBlock",
            method: "PUT",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "publicAccessBlock": "", 
            ]
        ) 
        try request.publicAccessBlockConfiguration.ensureRequired(field: "request.publicAccessBlockConfiguration")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializePutPublicAccessBlock, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = PutPublicAccessBlockResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializePutPublicAccessBlock])

        return result
    }
    
    /// Deletes the Block Public Access configurations of OSS resources.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func deletePublicAccessBlock(
        _ request: DeletePublicAccessBlockRequest,
        _ options: OperationOptions? = nil
    ) async throws -> DeletePublicAccessBlockResult {

        var input = OperationInput(
            operationName: "DeletePublicAccessBlock",
            method: "DELETE",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "publicAccessBlock": "", 
            ]
        ) 

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeDeletePublicAccessBlock, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = DeletePublicAccessBlockResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeDeletePublicAccessBlock])

        return result
    }
    
}
