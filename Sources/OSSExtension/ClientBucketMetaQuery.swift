import AlibabaCloudOSS
import Foundation

extension Client {

    /// Queries the information about the metadata index library of a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func getMetaQueryStatus(
        _ request: GetMetaQueryStatusRequest,
        _ options: OperationOptions? = nil
    ) async throws -> GetMetaQueryStatusResult {

        var input = OperationInput(
            operationName: "GetMetaQueryStatus",
            method: "GET",
            parameters: [ 
                "metaQuery": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeGetMetaQueryStatus, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = GetMetaQueryStatusResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetMetaQueryStatus])

        return result
    }
    
    /// Disables the metadata management feature for an Object Storage Service (OSS) bucket. After the metadata management feature is disabled for a bucket, OSS automatically deletes the metadata index library of the bucket and you cannot perform metadata indexing.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func closeMetaQuery(
        _ request: CloseMetaQueryRequest,
        _ options: OperationOptions? = nil
    ) async throws -> CloseMetaQueryResult {

        var input = OperationInput(
            operationName: "CloseMetaQuery",
            method: "POST",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "comp": "delete", 
                "metaQuery": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeCloseMetaQuery, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = CloseMetaQueryResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeCloseMetaQuery])

        return result
    }
    
    /// Queries the objects in a bucket that meet the specified conditions by using the data indexing feature. The information about the objects is listed based on the specified fields and sorting methods.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func doMetaQuery(
        _ request: DoMetaQueryRequest,
        _ options: OperationOptions? = nil
    ) async throws -> DoMetaQueryResult {

        var input = OperationInput(
            operationName: "DoMetaQuery",
            method: "POST",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "comp": "query", 
                "metaQuery": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        try request.metaQuery.ensureRequired(field: "request.metaQuery")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeDoMetaQuery, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = DoMetaQueryResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeDoMetaQuery])

        return result
    }
    
    /// Enables metadata management for a bucket. After you enable the metadata management feature for a bucket, Object Storage Service (OSS) creates a metadata index library for the bucket and creates metadata indexes for all objects in the bucket. After the metadata index library is created, OSS continues to perform quasi-real-time scans on incremental objects in the bucket and creates metadata indexes for the incremental objects.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func openMetaQuery(
        _ request: OpenMetaQueryRequest,
        _ options: OperationOptions? = nil
    ) async throws -> OpenMetaQueryResult {

        var input = OperationInput(
            operationName: "OpenMetaQuery",
            method: "POST",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "comp": "add", 
                "metaQuery": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeOpenMetaQuery, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = OpenMetaQueryResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeOpenMetaQuery])

        return result
    }
    
}
