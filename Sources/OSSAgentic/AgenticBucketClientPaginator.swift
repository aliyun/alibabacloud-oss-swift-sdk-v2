import AlibabaCloudOSS
import Foundation

public extension AgenticBucketClient {
    /// Returns a paginator for listing AgenticBuckets.
    func listAgenticBucketsPaginator(
        _ request: ListAgenticBucketsRequest,
        _ options: PaginatorOptions? = nil
    ) -> ListAgenticBucketsPaginator {
        return ListAgenticBucketsPaginator(client: self, request: request, options: options)
    }

    /// Returns a paginator for listing BucketSpaces.
    func listBucketSpacesPaginator(
        _ request: ListBucketSpacesRequest,
        _ options: PaginatorOptions? = nil
    ) -> ListBucketSpacesPaginator {
        return ListBucketSpacesPaginator(client: self, request: request, options: options)
    }
}
