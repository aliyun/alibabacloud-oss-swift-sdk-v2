import AlibabaCloudOSS
import Foundation

extension Client {

    /// Configures an inventory for a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func putBucketInventory(
        _ request: PutBucketInventoryRequest,
        _ options: OperationOptions? = nil
    ) async throws -> PutBucketInventoryResult {

        var input = OperationInput(
            operationName: "PutBucketInventory",
            method: "PUT",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "inventory": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        try request.inventoryConfiguration.ensureRequired(field: "request.inventoryConfiguration")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializePutBucketInventory, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = PutBucketInventoryResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializePutBucketInventory])

        return result
    }
    
    /// Queries the inventories that are configured for a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func getBucketInventory(
        _ request: GetBucketInventoryRequest,
        _ options: OperationOptions? = nil
    ) async throws -> GetBucketInventoryResult {

        var input = OperationInput(
            operationName: "GetBucketInventory",
            method: "GET",
            parameters: [ 
                "inventory": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeGetBucketInventory, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = GetBucketInventoryResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketInventory])

        return result
    }
    
    /// Queries all inventories in a bucket at a time.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func listBucketInventory(
        _ request: ListBucketInventoryRequest,
        _ options: OperationOptions? = nil
    ) async throws -> ListBucketInventoryResult {

        var input = OperationInput(
            operationName: "ListBucketInventory",
            method: "GET",
            parameters: [ 
                "inventory": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeListBucketInventory, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = ListBucketInventoryResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeListBucketInventory])

        return result
    }
    
    /// Deletes an inventory for a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func deleteBucketInventory(
        _ request: DeleteBucketInventoryRequest,
        _ options: OperationOptions? = nil
    ) async throws -> DeleteBucketInventoryResult {

        var input = OperationInput(
            operationName: "DeleteBucketInventory",
            method: "DELETE",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "inventory": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeDeleteBucketInventory, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = DeleteBucketInventoryResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeDeleteBucketInventory])

        return result
    }
    
}
