import AlibabaCloudOSS
import Foundation

extension Client {

    /// Modifies the access tracking status of a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func putBucketAccessMonitor(
        _ request: PutBucketAccessMonitorRequest,
        _ options: OperationOptions? = nil
    ) async throws -> PutBucketAccessMonitorResult {

        var input = OperationInput(
            operationName: "PutBucketAccessMonitor",
            method: "PUT",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "accessmonitor": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        try request.accessMonitorConfiguration.ensureRequired(field: "request.accessMonitorConfiguration")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializePutBucketAccessMonitor, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = PutBucketAccessMonitorResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializePutBucketAccessMonitor])

        return result
    }
    
    /// Queries the access tracking status of a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func getBucketAccessMonitor(
        _ request: GetBucketAccessMonitorRequest,
        _ options: OperationOptions? = nil
    ) async throws -> GetBucketAccessMonitorResult {

        var input = OperationInput(
            operationName: "GetBucketAccessMonitor",
            method: "GET",
            parameters: [ 
                "accessmonitor": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeGetBucketAccessMonitor, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = GetBucketAccessMonitorResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketAccessMonitor])

        return result
    }
    
}
