import AlibabaCloudOSS
import Foundation

extension Client {

    /// Enables pay-by-requester for a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func putBucketRequestPayment(
        _ request: PutBucketRequestPaymentRequest,
        _ options: OperationOptions? = nil
    ) async throws -> PutBucketRequestPaymentResult {

        var input = OperationInput(
            operationName: "PutBucketRequestPayment",
            method: "PUT",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "requestPayment": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        try request.requestPaymentConfiguration.ensureRequired(field: "request.requestPaymentConfiguration")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializePutBucketRequestPayment, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = PutBucketRequestPaymentResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializePutBucketRequestPayment])

        return result
    }
    
    /// Queries pay-by-requester configurations for a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func getBucketRequestPayment(
        _ request: GetBucketRequestPaymentRequest,
        _ options: OperationOptions? = nil
    ) async throws -> GetBucketRequestPaymentResult {

        var input = OperationInput(
            operationName: "GetBucketRequestPayment",
            method: "GET",
            parameters: [ 
                "requestPayment": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeGetBucketRequestPayment, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = GetBucketRequestPaymentResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketRequestPayment])

        return result
    }
    
}
