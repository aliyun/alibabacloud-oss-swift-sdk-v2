import AlibabaCloudOSS
import Foundation

public extension AgenticBucketClient {
    /// Creates an AgenticBucket.
    func createAgenticBucket(
        _ request: CreateAgenticBucketRequest,
        _ options: OperationOptions? = nil
    ) async throws -> CreateAgenticBucketResult {
        var input = OperationInput(
            operationName: "CreateAgenticBucket",
            method: "PUT",
            headers: ["Content-Type": "application/xml"],
            parameters: ["agenticBucket": ""]
        )
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [serializeCreateAgenticBucket, Serde.addContentMd5])

        var output = try await invokeOperation(input, options)

        var result = CreateAgenticBucketResult()
        try Serde.deserializeOutput(&result, &output, [deserializeCreateAgenticBucket])

        return result
    }

    /// Deletes an AgenticBucket.
    func deleteAgenticBucket(
        _ request: DeleteAgenticBucketRequest,
        _ options: OperationOptions? = nil
    ) async throws -> DeleteAgenticBucketResult {
        var input = OperationInput(
            operationName: "DeleteAgenticBucket",
            method: "DELETE",
            headers: ["Content-Type": "application/xml"],
            parameters: ["agenticBucket": ""]
        )
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [serializeDeleteAgenticBucket, Serde.addContentMd5])

        var output = try await invokeOperation(input, options)

        var result = DeleteAgenticBucketResult()
        try Serde.deserializeOutput(&result, &output, [deserializeDeleteAgenticBucket])

        return result
    }

    /// Queries the information about an AgenticBucket.
    func getAgenticBucket(
        _ request: GetAgenticBucketRequest,
        _ options: OperationOptions? = nil
    ) async throws -> GetAgenticBucketResult {
        var input = OperationInput(
            operationName: "GetAgenticBucket",
            method: "GET",
            headers: ["Content-Type": "application/xml"],
            parameters: ["agenticBucket": ""]
        )
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [serializeGetAgenticBucket, Serde.addContentMd5])

        var output = try await invokeOperation(input, options)

        var result = GetAgenticBucketResult()
        try Serde.deserializeOutput(&result, &output, [deserializeGetAgenticBucket])

        return result
    }

    /// Lists AgenticBuckets. This operation targets the regional host and takes no bucket.
    func listAgenticBuckets(
        _ request: ListAgenticBucketsRequest,
        _ options: OperationOptions? = nil
    ) async throws -> ListAgenticBucketsResult {
        var input = OperationInput(
            operationName: "ListAgenticBuckets",
            method: "GET",
            headers: ["Content-Type": "application/xml"],
            parameters: ["agenticBucket": ""]
        )

        var req = request
        try Serde.serializeInput(&req, &input, [serializeListAgenticBuckets, Serde.addContentMd5])

        var output = try await invokeOperation(input, options)

        var result = ListAgenticBucketsResult()
        try Serde.deserializeOutput(&result, &output, [deserializeListAgenticBuckets])

        return result
    }

    /// Sets the status of an AgenticBucket.
    func putAgenticBucketStatus(
        _ request: PutAgenticBucketStatusRequest,
        _ options: OperationOptions? = nil
    ) async throws -> PutAgenticBucketStatusResult {
        var input = OperationInput(
            operationName: "PutAgenticBucketStatus",
            method: "PUT",
            headers: ["Content-Type": "application/xml"],
            parameters: [
                "agenticBucket": "",
                "status": "",
            ]
        )
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        try request.status.ensureRequired(field: "request.status")

        var req = request
        try Serde.serializeInput(&req, &input, [serializePutAgenticBucketStatus, Serde.addContentMd5])

        var output = try await invokeOperation(input, options)

        var result = PutAgenticBucketStatusResult()
        try Serde.deserializeOutput(&result, &output, [deserializePutAgenticBucketStatus])

        return result
    }
}
