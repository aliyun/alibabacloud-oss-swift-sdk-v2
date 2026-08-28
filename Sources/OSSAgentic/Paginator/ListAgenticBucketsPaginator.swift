import AlibabaCloudOSS
import Foundation

public struct ListAgenticBucketsPaginator: AsyncSequence {
    public typealias Element = ListAgenticBucketsResult

    let client: AgenticBucketClient
    let request: ListAgenticBucketsRequest

    public init(
        client: AgenticBucketClient,
        request: ListAgenticBucketsRequest,
        options: PaginatorOptions? = nil
    ) {
        var request = request
        if let limit = options?.limit {
            request.maxKeys = limit
        }
        self.client = client
        self.request = request
    }

    public struct AsyncIterator: AsyncIteratorProtocol {
        let sequence: ListAgenticBucketsPaginator
        var request: ListAgenticBucketsRequest?

        init(sequence: ListAgenticBucketsPaginator) {
            self.sequence = sequence
            request = sequence.request
        }

        public mutating func next() async throws -> ListAgenticBucketsResult? {
            if let request = request {
                let result = try await sequence.client.listAgenticBuckets(request)
                if result.isTruncated ?? false {
                    self.request?.continuationToken = result.nextContinuationToken
                } else {
                    self.request = nil
                }
                return result
            }
            return nil
        }
    }

    public func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(sequence: self)
    }
}
