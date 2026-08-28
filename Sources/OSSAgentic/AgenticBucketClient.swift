import AlibabaCloudOSS
import Foundation

/// A client for managing AgenticBuckets and listing their BucketSpaces.
///
/// The logical bucket name passed to each operation is rewritten to its physical form
/// `{prefix}-{accountId}-{region}-ab-apsr` before the request is signed and sent.
public final class AgenticBucketClient: @unchecked Sendable {
    let client: Client

    public init(_ config: Configuration, _ actions: ClientOptionsAction...) {
        client = makeScopedClient(config, suffix: "-ab-apsr", actions)
    }

    /// Invokes an operation against the AgenticBucket endpoint.
    public func invokeOperation(
        _ input: OperationInput,
        _ options: OperationOptions? = nil
    ) async throws -> OperationOutput {
        return try await client.invokeOperation(input, options)
    }
}
