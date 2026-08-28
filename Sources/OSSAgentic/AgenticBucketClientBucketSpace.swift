import AlibabaCloudOSS
import Foundation

public extension AgenticBucketClient {
    /// Lists the BucketSpaces of an AgenticBucket.
    func listBucketSpaces(
        _ request: ListBucketSpacesRequest,
        _ options: OperationOptions? = nil
    ) async throws -> ListBucketSpacesResult {
        var input = OperationInput(
            operationName: "ListBucketSpaces",
            method: "GET",
            headers: ["Content-Type": "application/xml"],
            parameters: [
                "agenticBucket": "",
                "bucketSpace": "",
            ]
        )
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [serializeListBucketSpaces, Serde.addContentMd5])

        var output = try await invokeOperation(input, options)

        var result = ListBucketSpacesResult()
        try Serde.deserializeOutput(&result, &output, [deserializeListBucketSpaces])

        return result
    }
}
