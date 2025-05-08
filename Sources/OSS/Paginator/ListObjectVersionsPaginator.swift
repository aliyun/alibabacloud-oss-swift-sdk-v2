import Foundation

public struct ListObjectVersionsPaginator: AsyncSequence {
    public typealias Element = ListObjectVersionsResult

    let client: Client
    let request: ListObjectVersionsRequest

    public init(
        client: Client,
        request: ListObjectVersionsRequest,
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
        let sequence: ListObjectVersionsPaginator
        var request: ListObjectVersionsRequest?

        init(sequence: ListObjectVersionsPaginator) {
            self.sequence = sequence
            request = sequence.request
        }

        public mutating func next() async throws -> ListObjectVersionsResult? {
            if let request = request {
                let result = try await sequence.client.listObjectVersions(request)
                // has next page
                if result.isTruncated ?? false {
                    self.request?.keyMarker = result.nextKeyMarker
                    self.request?.versionIdMarker = result.nextVersionIdMarker
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
