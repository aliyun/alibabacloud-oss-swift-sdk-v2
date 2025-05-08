import AlibabaCloudOSS
import XCTest

class ClientPaginatorTests: BaseTestCase {
    func testListBucketsPaginatorSuccess() async throws {
        let client = getDefaultClient()
        let baseBucket = randomBucketName()
        var buckets: [String] = []

        for i in 0 ..< 10 {
            let bucketName = baseBucket + "-\(i)"
            try await createBucket(client: client, bucket: bucketName)
            buckets.append(bucketName)
        }

        var listResultBuckets: [String] = []
        var request = ListBucketsRequest()
        for try await result in client.listBucketsPaginator(request) {
            for bucket in result.buckets! {
                if bucket.name?.hasPrefix(baseBucket) ?? false {
                    listResultBuckets.append(bucket.name!)
                }
            }
        }
        XCTAssertEqual(listResultBuckets.count, buckets.count)
        for bucket in buckets {
            XCTAssertTrue(listResultBuckets.contains(bucket))
        }

        listResultBuckets = []
        request = ListBucketsRequest(prefix: baseBucket)
        for try await result in client.listBucketsPaginator(request, PaginatorOptions(limit: 5)) {
            XCTAssertEqual(result.buckets?.count, 5)
            for bucket in result.buckets! {
                if bucket.name?.hasPrefix(baseBucket) ?? false {
                    listResultBuckets.append(bucket.name!)
                }
            }
        }
        XCTAssertEqual(listResultBuckets.count, buckets.count)
        for bucket in buckets {
            XCTAssertTrue(listResultBuckets.contains(bucket))
        }

        for bucket in buckets {
            let deleteBucketRequest = DeleteBucketRequest(bucket: bucket)
            try await assertNoThrow(await client.deleteBucket(deleteBucketRequest))
        }
    }

    func testListBucketsPaginatorFail() async throws {
        // default
        let credentialsProvider = AnonymousCredentialsProvider()
        let config = Configuration.default()
        config.withCredentialsProvider(credentialsProvider)
        config.withEndpoint(endpoint)
        config.withRegion(region)
        let client = Client(config)

        let request = ListBucketsRequest()
        do {
            for try await _ in client.listBucketsPaginator(request) {}
            XCTFail("should throw a error")
        } catch {
            let serverError = error as? ServerError
            XCTAssertEqual(serverError?.statusCode, 403)
            XCTAssertEqual(serverError?.code, "AccessDenied")
        }
    }

    func testListObjectsPaginatorSuccess() async throws {
        let client = getDefaultClient()
        let bucket = randomBucketName()
        let baseKey = randomObjectName()

        try await createBucket(client: client, bucket: bucket)

        var objects: [String] = []
        for i in 0 ..< 20 {
            let key = baseKey + "-\(i)"
            let request = PutObjectRequest(bucket: bucket,
                                           key: key,
                                           body: .data("hello oss".data(using: .utf8)!))
            try await assertNoThrow(await client.putObject(request))
            objects.append(key)
        }

        var listResultObjects: [String] = []
        var request = ListObjectsRequest(bucket: bucket)
        for try await result in client.listObjectsPaginator(request) {
            XCTAssertEqual(result.contents?.count, 20)
            for object in result.contents ?? [] {
                listResultObjects.append(object.key!)
            }
        }
        XCTAssertEqual(listResultObjects.count, objects.count)
        for object in objects {
            XCTAssertTrue(listResultObjects.contains(object))
        }

        listResultObjects = []
        request = ListObjectsRequest(bucket: bucket)
        for try await result in client.listObjectsPaginator(request, PaginatorOptions(limit: 5)) {
            XCTAssertEqual(result.contents?.count, 5)
            for object in result.contents ?? [] {
                listResultObjects.append(object.key!)
            }
        }
        XCTAssertEqual(listResultObjects.count, objects.count)
        for object in objects {
            XCTAssertTrue(listResultObjects.contains(object))
        }

        try await cleanBucket(client: client, bucket: bucket)
    }

    func testListObjectsPaginatorFail() async throws {
        // default
        var client = getDefaultClient()
        let bucket = randomBucketName()

        try await createBucket(client: client, bucket: bucket)

        // client error
        var request = ListObjectsRequest()
        do {
            for try await _ in client.listObjectsPaginator(request) {}
            XCTFail("should throw a error")
        } catch {
            let clientError = error as? ClientError
            XCTAssertEqual("Missing required field, request.bucket.", clientError?.message)
        }

        // server error
        let credentialsProvider = AnonymousCredentialsProvider()
        let config = Configuration.default()
        config.withCredentialsProvider(credentialsProvider)
        config.withEndpoint(endpoint)
        config.withRegion(region)
        client = Client(config)

        request = ListObjectsRequest(bucket: bucket)
        do {
            for try await _ in client.listObjectsPaginator(request) {}
            XCTFail("should throw a error")
        } catch {
            let serverError = error as? ServerError
            XCTAssertEqual(serverError?.statusCode, 403)
            XCTAssertEqual(serverError?.code, "AccessDenied")
        }

        try await cleanBucket(client: getDefaultClient(), bucket: bucket)
    }

    func testListObjectsV2PaginatorSuccess() async throws {
        let client = getDefaultClient()
        let bucket = randomBucketName()
        let baseKey = randomObjectName()

        try await createBucket(client: client, bucket: bucket)

        var objects: [String] = []
        for i in 0 ..< 20 {
            let key = baseKey + "-\(i)"
            let request = PutObjectRequest(bucket: bucket,
                                           key: key,
                                           body: .data("hello oss".data(using: .utf8)!))
            try await assertNoThrow(await client.putObject(request))
            objects.append(key)
        }

        var listResultObjects: [String] = []
        var request = ListObjectsV2Request(bucket: bucket)
        for try await result in client.listObjectsV2Paginator(request) {
            XCTAssertEqual(result.contents?.count, 20)
            for object in result.contents ?? [] {
                listResultObjects.append(object.key!)
            }
        }
        XCTAssertEqual(listResultObjects.count, objects.count)
        for object in objects {
            XCTAssertTrue(listResultObjects.contains(object))
        }

        listResultObjects = []
        request = ListObjectsV2Request(bucket: bucket)
        for try await result in client.listObjectsV2Paginator(request, PaginatorOptions(limit: 5)) {
            XCTAssertEqual(result.contents?.count, 5)
            for object in result.contents ?? [] {
                listResultObjects.append(object.key!)
            }
        }
        XCTAssertEqual(listResultObjects.count, objects.count)
        for object in objects {
            XCTAssertTrue(listResultObjects.contains(object))
        }

        try await cleanBucket(client: client, bucket: bucket)
    }

    func testListObjectsV2PaginatorFail() async throws {
        // default
        var client = getDefaultClient()
        let bucket = randomBucketName()

        try await createBucket(client: client, bucket: bucket)

        // client error
        var request = ListObjectsV2Request()
        do {
            for try await _ in client.listObjectsV2Paginator(request) {}
            XCTFail("should throw a error")
        } catch {
            switch error {
            case let cerr as ClientError:
                XCTAssertEqual("Missing required field, request.bucket.", cerr.message)
            default:
                XCTFail()
            }
        }

        // server error
        let credentialsProvider = AnonymousCredentialsProvider()
        let config = Configuration.default()
        config.withCredentialsProvider(credentialsProvider)
        config.withEndpoint(endpoint)
        config.withRegion(region)
        client = Client(config)

        request = ListObjectsV2Request(bucket: bucket)
        do {
            for try await _ in client.listObjectsV2Paginator(request) {}
            XCTFail("should throw a error")
        } catch {
            let serverError = error as? ServerError
            XCTAssertEqual(serverError?.statusCode, 403)
            XCTAssertEqual(serverError?.code, "AccessDenied")
        }

        try await cleanBucket(client: getDefaultClient(), bucket: bucket)
    }
    
    func testListObjectVersionsPaginatorSuccess() async throws {
        let client = getDefaultClient()
        let bucket = randomBucketName()
        let baseKey = randomObjectName()

        try await createBucket(client: client, bucket: bucket)
        
        await assertNoThrow(try await client.putBucketVersioning(
            PutBucketVersioningRequest(
                bucket: bucket,
                versioningConfiguration: VersioningConfiguration(status: "Enabled")
            )
        ))

        var objects: [String] = []
        var deleteMarkers: [String] = []
        for i in 0 ..< 20 {
            let key = baseKey + "-\(i)"
            let request = PutObjectRequest(bucket: bucket,
                                           key: key,
                                           body: .data("hello oss".data(using: .utf8)!))
            try await assertNoThrow(await client.putObject(request))
            if i >= 10 {
                try await assertNoThrow(await client.deleteObject(
                    DeleteObjectRequest(
                        bucket: bucket,
                        key: key
                    )
                ))
                deleteMarkers.append(key)
            }
            objects.append(key)
        }

        var listResultVersions: [String] = []
        var listResultMarkers: [String] = []
        var request = ListObjectVersionsRequest(bucket: bucket)
        for try await result in client.listObjectVersionsPaginator(request) {
            XCTAssertEqual(result.versions?.count, 20)
            XCTAssertEqual(result.deleteMarkers?.count, 10)
            for object in result.versions ?? [] {
                listResultVersions.append(object.key!)
            }
            for marker in result.deleteMarkers ?? [] {
                listResultMarkers.append(marker.key!)
            }
        }
        XCTAssertEqual(listResultVersions.count, objects.count)
        XCTAssertEqual(listResultMarkers.count, deleteMarkers.count)
        for object in objects {
            XCTAssertTrue(listResultVersions.contains(object))
        }
        for deleteMarker in deleteMarkers {
            XCTAssertTrue(listResultVersions.contains(deleteMarker))
        }

        listResultVersions = []
        listResultMarkers = []
        request = ListObjectVersionsRequest(bucket: bucket)
        for try await result in client.listObjectVersionsPaginator(request, PaginatorOptions(limit: 5)) {
            XCTAssertEqual((result.versions?.count ?? 0) + (result.deleteMarkers?.count ?? 0), 5)
            for object in result.versions ?? [] {
                listResultVersions.append(object.key!)
            }
            for marker in result.deleteMarkers ?? [] {
                listResultMarkers.append(marker.key!)
            }
        }
        XCTAssertEqual(listResultVersions.count, objects.count)
        XCTAssertEqual(listResultMarkers.count, deleteMarkers.count)
        for object in objects {
            XCTAssertTrue(listResultVersions.contains(object))
        }
        for deleteMarker in deleteMarkers {
            XCTAssertTrue(listResultVersions.contains(deleteMarker))
        }

        try await cleanBucket(client: client, bucket: bucket)
    }

    func testListObjectVersionsPaginatorFail() async throws {
        // default
        var client = getDefaultClient()
        let bucket = randomBucketName()

        try await createBucket(client: client, bucket: bucket)

        // client error
        var request = ListObjectVersionsRequest()
        do {
            for try await _ in client.listObjectVersionsPaginator(request) {}
            XCTFail("should throw a error")
        } catch {
            let clientError = error as? ClientError
            XCTAssertEqual("Missing required field, request.bucket.", clientError?.message)
        }

        // server error
        let credentialsProvider = AnonymousCredentialsProvider()
        let config = Configuration.default()
        config.withCredentialsProvider(credentialsProvider)
        config.withEndpoint(endpoint)
        config.withRegion(region)
        client = Client(config)

        request = ListObjectVersionsRequest(bucket: bucket)
        do {
            for try await _ in client.listObjectVersionsPaginator(request) {}
            XCTFail("should throw a error")
        } catch {
            let serverError = error as? ServerError
            XCTAssertEqual(serverError?.statusCode, 403)
            XCTAssertEqual(serverError?.code, "AccessDenied")
        }

        try await cleanBucket(client: getDefaultClient(), bucket: bucket)
    }

    func testListPartsPaginatorSuccess() async throws {
        let client = getDefaultClient()
        let bucket = randomBucketName()
        let key = randomObjectName()

        try await createBucket(client: client, bucket: bucket)

        let initRequest = InitiateMultipartUploadRequest(bucket: bucket, key: key)
        let initResult = try await client.initiateMultipartUpload(initRequest)

        var parts: [Int] = []
        for i in 1 ..< 21 {
            let request = UploadPartRequest(bucket: bucket,
                                            key: key,
                                            partNumber: i,
                                            uploadId: initResult.uploadId!,
                                            body: .data("hello oss".data(using: .utf8)!))
            try await assertNoThrow(await client.uploadPart(request))
            parts.append(i)
        }

        var listResultParts: [Int] = []
        var request = ListPartsRequest(bucket: bucket,
                                       key: key,
                                       uploadId: initResult.uploadId!)
        for try await result in client.listPartsPaginator(request) {
            XCTAssertEqual(result.parts?.count, 20)
            for object in result.parts ?? [] {
                listResultParts.append(object.partNumber!)
            }
        }
        XCTAssertEqual(listResultParts.count, parts.count)
        for object in parts {
            XCTAssertTrue(listResultParts.contains(object))
        }

        listResultParts = []
        request = ListPartsRequest(bucket: bucket,
                                   key: key,
                                   uploadId: initResult.uploadId!)
        for try await result in client.listPartsPaginator(request, PaginatorOptions(limit: 5)) {
            XCTAssertEqual(result.parts?.count, 5)
            for object in result.parts ?? [] {
                listResultParts.append(object.partNumber!)
            }
        }
        XCTAssertEqual(listResultParts.count, parts.count)
        for object in parts {
            XCTAssertTrue(listResultParts.contains(object))
        }

        try await cleanBucket(client: client, bucket: bucket)
    }

    func testListPartsPaginatorFail() async throws {
        // default
        var client = getDefaultClient()
        let bucket = randomBucketName()
        let key = randomObjectName()

        try await createBucket(client: client, bucket: bucket)

        let initRequest = InitiateMultipartUploadRequest(bucket: bucket, key: key)
        let initResult = try await client.initiateMultipartUpload(initRequest)

        // client error
        var request = ListPartsRequest(bucket: bucket,
                                       key: key)
        do {
            for try await _ in client.listPartsPaginator(request) {}
            XCTFail("should throw a error")
        } catch {
            let clientError = error as? ClientError
            XCTAssertEqual("Missing required field, request.uploadId.", clientError?.message)
        }

        // server error
        let credentialsProvider = AnonymousCredentialsProvider()
        let config = Configuration.default()
        config.withCredentialsProvider(credentialsProvider)
        config.withEndpoint(endpoint)
        config.withRegion(region)
        client = Client(config)

        request = ListPartsRequest(bucket: bucket,
                                   key: key,
                                   uploadId: initResult.uploadId!)
        do {
            for try await _ in client.listPartsPaginator(request) {}
            XCTFail("should throw a error")
        } catch {
            let serverError = error as? ServerError
            XCTAssertEqual(serverError?.statusCode, 403)
            XCTAssertEqual(serverError?.code, "AccessDenied")
        }

        try await cleanBucket(client: getDefaultClient(), bucket: bucket)
    }

    func testListMultipartUploadsPaginatorSuccess() async throws {
        let client = getDefaultClient()
        let bucket = randomBucketName()
        let baseKey = randomObjectName()

        try await createBucket(client: client, bucket: bucket)

        var uploads: [String] = []
        for i in 0 ..< 20 {
            let key = baseKey + "-\(i)"
            let initRequest = InitiateMultipartUploadRequest(bucket: bucket, key: key)
            let initResult = try await client.initiateMultipartUpload(initRequest)
            uploads.append(initResult.uploadId!)
        }

        var listResultUploads: [String] = []
        var request = ListMultipartUploadsRequest(bucket: bucket)
        for try await result in client.listMultipartUploadsPaginator(request) {
            XCTAssertEqual(result.uploads?.count, 20)
            for object in result.uploads ?? [] {
                listResultUploads.append(object.uploadId!)
            }
        }
        XCTAssertEqual(listResultUploads.count, uploads.count)
        for upload in uploads {
            XCTAssertTrue(listResultUploads.contains(upload))
        }

        listResultUploads = []
        request = ListMultipartUploadsRequest(bucket: bucket)
        for try await result in client.listMultipartUploadsPaginator(request, PaginatorOptions(limit: 5)) {
            XCTAssertEqual(result.uploads?.count, 5)
            for object in result.uploads ?? [] {
                listResultUploads.append(object.uploadId!)
            }
        }
        XCTAssertEqual(listResultUploads.count, uploads.count)
        for upload in uploads {
            XCTAssertTrue(listResultUploads.contains(upload))
        }

        try await cleanBucket(client: client, bucket: bucket)
    }

    func testListMultipartUploadsPaginatorFail() async throws {
        // default
        var client = getDefaultClient()
        let bucket = randomBucketName()

        try await createBucket(client: client, bucket: bucket)

        // client error
        var request = ListMultipartUploadsRequest()
        do {
            for try await _ in client.listMultipartUploadsPaginator(request) {}
            XCTFail("should throw a error")
        } catch {
            let clientError = error as? ClientError
            XCTAssertEqual("Missing required field, request.bucket.", clientError?.message)
        }

        // server error
        let credentialsProvider = AnonymousCredentialsProvider()
        let config = Configuration.default()
        config.withCredentialsProvider(credentialsProvider)
        config.withEndpoint(endpoint)
        config.withRegion(region)
        client = Client(config)

        request = ListMultipartUploadsRequest(bucket: bucket)
        do {
            for try await _ in client.listMultipartUploadsPaginator(request) {}
            XCTFail("should throw a error")
        } catch {
            let serverError = error as? ServerError
            XCTAssertEqual(serverError?.statusCode, 403)
            XCTAssertEqual(serverError?.code, "AccessDenied")
        }

        try await cleanBucket(client: getDefaultClient(), bucket: bucket)
    }
}
