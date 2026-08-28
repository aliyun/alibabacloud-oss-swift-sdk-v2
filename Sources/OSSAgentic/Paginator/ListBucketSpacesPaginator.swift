import AlibabaCloudOSS
import Foundation

public struct ListBucketSpacesPaginator: AsyncSequence {
    public typealias Element = ListBucketSpacesResult

    let client: AgenticBucketClient
    let request: ListBucketSpacesRequest

    public init(
        client: AgenticBucketClient,
        request: ListBucketSpacesRequest,
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
        let sequence: ListBucketSpacesPaginator
        var request: ListBucketSpacesRequest?

        init(sequence: ListBucketSpacesPaginator) {
            self.sequence = sequence
            request = sequence.request
        }

        public mutating func next() async throws -> ListBucketSpacesResult? {
            if let request = request {
                let result = try await sequence.client.listBucketSpaces(request)
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
