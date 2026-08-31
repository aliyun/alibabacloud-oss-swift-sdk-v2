import AlibabaCloudOSS
import Foundation

extension Client {

    /// Adds an image style to a bucket. An image style contains one or more image processing parameters.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func putStyle(
        _ request: PutStyleRequest,
        _ options: OperationOptions? = nil
    ) async throws -> PutStyleResult {

        var input = OperationInput(
            operationName: "PutStyle",
            method: "PUT",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "style": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        try request.style.ensureRequired(field: "request.style")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializePutStyle, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = PutStyleResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializePutStyle])

        return result
    }
    
    /// Queries all image styles that are created for a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func listStyle(
        _ request: ListStyleRequest,
        _ options: OperationOptions? = nil
    ) async throws -> ListStyleResult {

        var input = OperationInput(
            operationName: "ListStyle",
            method: "GET",
            parameters: [ 
                "style": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeListStyle, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = ListStyleResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeListStyle])

        return result
    }
    
    /// Queries the information about an image style of a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func getStyle(
        _ request: GetStyleRequest,
        _ options: OperationOptions? = nil
    ) async throws -> GetStyleResult {

        var input = OperationInput(
            operationName: "GetStyle",
            method: "GET",
            parameters: [ 
                "style": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeGetStyle, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = GetStyleResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetStyle])

        return result
    }
    
    /// Deletes an image style from a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func deleteStyle(
        _ request: DeleteStyleRequest,
        _ options: OperationOptions? = nil
    ) async throws -> DeleteStyleResult {

        var input = OperationInput(
            operationName: "DeleteStyle",
            method: "DELETE",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "style": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeDeleteStyle, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = DeleteStyleResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeDeleteStyle])

        return result
    }
    
}
