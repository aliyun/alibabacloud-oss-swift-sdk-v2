import Foundation

public extension Client {
    /// Creates a paginator for ListBuckets
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - options: Optional, paginator options
    /// - Returns: A paginator instance.
    func listBucketsPaginator(
        _ request: ListBucketsRequest,
        _ options: PaginatorOptions? = nil
    ) -> ListBucketsPaginator {
        return ListBucketsPaginator(
            client: self,
            request: request,
            options: options
        )
    }

    /// Creates a paginator for ListMultipartUploads
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - options: Optional, paginator options
    /// - Returns: A paginator instance.
    func listMultipartUploadsPaginator(
        _ request: ListMultipartUploadsRequest,
        _ options: PaginatorOptions? = nil
    ) -> ListMultipartUploadsPaginator {
        return ListMultipartUploadsPaginator(
            client: self,
            request: request,
            options: options
        )
    }

    /// Creates a paginator for ListObjects
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - options: Optional, paginator options
    /// - Returns: A paginator instance.
    func listObjectsPaginator(
        _ request: ListObjectsRequest,
        _ options: PaginatorOptions? = nil
    ) -> ListObjectsPaginator {
        return ListObjectsPaginator(
            client: self,
            request: request,
            options: options
        )
    }

    /// Creates a paginator for ListObjectsV2
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - options: Optional, paginator options
    /// - Returns: A paginator instance.
    func listObjectsV2Paginator(
        _ request: ListObjectsV2Request,
        _ options: PaginatorOptions? = nil
    ) -> ListObjectsV2Paginator {
        return ListObjectsV2Paginator(
            client: self,
            request: request,
            options: options
        )
    }
    
    /// Creates a paginator for ListObjectVersions
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - options: Optional, paginator options
    /// - Returns: A paginator instance.
    func listObjectVersionsPaginator(
        _ request: ListObjectVersionsRequest,
        _ options: PaginatorOptions? = nil
    ) -> ListObjectVersionsPaginator {
        return ListObjectVersionsPaginator(
            client: self,
            request: request,
            options: options
        )
    }

    /// Creates a paginator for ListParts
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - options: Optional, paginator options
    /// - Returns: A paginator instance.
    func listPartsPaginator(
        _ request: ListPartsRequest,
        _ options: PaginatorOptions? = nil
    ) -> ListPartsPaginator {
        return ListPartsPaginator(
            client: self,
            request: request,
            options: options
        )
    }
}
