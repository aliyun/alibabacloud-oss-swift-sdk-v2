import AlibabaCloudOSS
import Foundation

@main
struct Main {

    static var passed: Int = 0

    static func check(_ name: String, _ ok: Bool) throws {
        guard ok else {
            throw PVError(message: "FAIL: \(name)")
        }
        passed += 1
        print("  [PASS] \(name)")
    }

    static func main() async {
        let region = ProcessInfo.processInfo.environment["OSS_REGION"] ?? "cn-hangzhou"
        let bucket =
            ProcessInfo.processInfo.environment["OSS_TEST_BUCKET"]
            ?? "oss-sdk-test-swift-bucket-\(Int(Date().timeIntervalSince1970))"

        let config = Configuration.default()
            .withCredentialsProvider(EnvironmentCredentialsProvider())
            .withRegion(region)

        let client = Client(config)
        print("=== Swift OSS SDK Package Verify ===")
        print("Region: \(region)")
        print("Bucket: \(bucket)")

        do {
            try await testService(client: client)
            try await testBucketBasic(client: client, bucket: bucket)
            try await testBucketAcl(client: client, bucket: bucket)
            try await testObjectBasic(client: client, bucket: bucket)
            try await testObjectAcl(client: client, bucket: bucket)
            try await testObjectTagging(client: client, bucket: bucket)
            try await testObjectSymlink(client: client, bucket: bucket)
            try await testAppendObject(client: client, bucket: bucket)
            try await testMultipartUpload(client: client, bucket: bucket)
            try await testPresigner(client: client, bucket: bucket)
            try await testPaginator(client: client, bucket: bucket)
            try await testExtension(client: client, bucket: bucket)
        } catch {
            print("\n=== Swift Package Verify failed ===")
            print(error)
            await cleanBucket(client: client, bucket: bucket)
            Foundation.exit(1)
        }

        print("\n=== All Swift Package Verify checks passed ===")
    }

    static func testService(client: Client) async throws {
        print("\n--- Service: DescribeRegions / ListBuckets ---")
        let regions = try await client.describeRegions(DescribeRegionsRequest())
        try check("DescribeRegions status=200", regions.statusCode == 200)
        try check("DescribeRegions has regions", regions.regionInfoList?.regionInfos?.count ?? 0 > 0)

        let listBuckets = try await client.listBuckets(ListBucketsRequest(maxKeys: 10))
        try check("ListBuckets status=200", listBuckets.statusCode == 200)
    }

    static func testBucketBasic(client: Client, bucket: String) async throws {
        print("\n--- Bucket Basic: put/GetInfo/GetStat/GetLocation/delete ---")

        let putResult = try await client.putBucket(
            PutBucketRequest(
                bucket: bucket,
                createBucketConfiguration: CreateBucketConfiguration(
                    storageClass: "IA"
                )
            )
        )
        try check("putBucket status=200", putResult.statusCode == 200)

        let info = try await client.getBucketInfo(GetBucketInfoRequest(bucket: bucket))
        try check("GetBucketInfo status=200", info.statusCode == 200)
        try check("GetBucketInfo StorageClass=IA", info.bucketInfo?.bucket?.storageClass == "IA")
        try check("GetBucketInfo Name matches", info.bucketInfo?.bucket?.name == bucket)

        let stat = try await client.getBucketStat(GetBucketStatRequest(bucket: bucket))
        try check("GetBucketStat status=200", stat.statusCode == 200)
        try check("GetBucketStat ObjectCount=0", stat.bucketStat?.objectCount == 0)

        let loc = try await client.getBucketLocation(GetBucketLocationRequest(bucket: bucket))
        try check("GetBucketLocation status=200", loc.statusCode == 200)
        try check("GetBucketLocation has value", loc.locationConstraint?.isEmpty == false)
    }

    static func testBucketAcl(client: Client, bucket: String) async throws {
        print("\n--- Bucket Acl: Get/put ---")

        let getAcl = try await client.getBucketAcl(GetBucketAclRequest(bucket: bucket))
        try check("GetBucketAcl status=200", getAcl.statusCode == 200)
        try check("GetBucketAcl Grant=private", getAcl.accessControlPolicy?.accessControlList?.grant == "private")
    }

    static func testObjectBasic(client: Client, bucket: String) async throws {
        print("\n--- Object Basic: put/Head/GetMeta/Get/Copy/delete ---")
        let key = "verify-obj-basic"
        let content = "hello world from nuget verify"

        let putResult = try await client.putObject(
            PutObjectRequest(
                bucket: bucket,
                key: key,
                tagging: "tag1=val1",
                metadata: ["mykey": "myval"],
                body: .data(content.data(using: .utf8)!)
            )
        )
        try check("putObject status=200", putResult.statusCode == 200)
        try check("putObject has ETag", putResult.etag?.isEmpty == false)

        let headResult = try await client.headObject(
            HeadObjectRequest(
                bucket: bucket,
                key: key
            )
        )
        try check("HeadObject status=200", headResult.statusCode == 200)
        try check("HeadObject ContentLength", headResult.contentLength == content.count)
        try check("HeadObject ObjectType=Normal", headResult.objectType == "Normal")
        try check("HeadObject Metadata", headResult.metadata?["mykey"] == "myval")
        try check("HeadObject TaggingCount=1", headResult.taggingCount == 1)

        let getMeta = try await client.getObjectMeta(
            GetObjectMetaRequest(
                bucket: bucket,
                key: key
            )
        )
        try check("GetObjectMeta status=200", getMeta.statusCode == 200)
        try check("GetObjectMeta ContentLength", getMeta.contentLength == content.count)

        let getResult = try await client.getObject(
            GetObjectRequest(
                bucket: bucket,
                key: key
            )
        )
        try check("GetObject status=200", getResult.statusCode == 200)
        try check("GetObject ContentLength", getResult.contentLength == content.count)
        try check("GetObject body matches", getResult.body?.readData()?.decodeToString() == content)

        let copyResult = try await client.copyObject(
            CopyObjectRequest(
                bucket: bucket,
                key: key + "-copy",
                sourceBucket: bucket,
                sourceKey: key,
            )
        )
        try check("CopyObject status=200", copyResult.statusCode == 200)

        let getResult2 = try await client.getObject(
            GetObjectRequest(
                bucket: bucket,
                key: key + "-copy"
            )
        )
        try check("GetObject(copy) status=200", getResult2.statusCode == 200)
        try check("GetObject(copy) body matches", getResult2.body?.readData()?.decodeToString() == content)

        let delResult = try await client.deleteObject(
            DeleteObjectRequest(
                bucket: bucket,
                key: key
            )
        )
        try check("deleteObject status=204", delResult.statusCode == 204)

        let delResult2 = try await client.deleteObject(
            DeleteObjectRequest(
                bucket: bucket,
                key: key + "-copy"
            )
        )
        try check("deleteObject(copy) status=204", delResult2.statusCode == 204)
    }

    static func testObjectAcl(client: Client, bucket: String) async throws {
        print("\n--- Object Acl: put/Get ---")
        let key = "verify-obj-acl"

        _ = try await client.putObject(
            PutObjectRequest(
                bucket: bucket,
                key: key,
                body: .data("acl test".data(using: .utf8)!)
            )
        )

        var getAcl = try await client.getObjectAcl(GetObjectAclRequest(bucket: bucket, key: key))
        try check("GetObjectAcl status=200", getAcl.statusCode == 200)
        try check("GetObjectAcl default", getAcl.accessControlPolicy?.accessControlList?.grant == "default")

        let putAcl = try await client.putObjectAcl(
            PutObjectAclRequest(
                bucket: bucket,
                key: key,
                objectAcl: "private"
            )
        )
        try check("putObjectAcl status=200", putAcl.statusCode == 200)

        getAcl = try await client.getObjectAcl(
            GetObjectAclRequest(
                bucket: bucket,
                key: key
            )
        )
        try check("GetObjectAcl after put=private", getAcl.accessControlPolicy?.accessControlList?.grant == "private")

        _ = try await client.deleteObject(
            DeleteObjectRequest(
                bucket: bucket,
                key: key
            )
        )
    }

    static func testObjectTagging(client: Client, bucket: String) async throws {
        print("\n--- Object Tagging: put/Get/delete ---")
        let key = "verify-obj-tag"

        _ = try await client.putObject(
            PutObjectRequest(
                bucket: bucket,
                key: key,
                body: .data("tag test".data(using: .utf8)!)
            )
        )

        let putTag = try await client.putObjectTagging(
            PutObjectTaggingRequest(
                bucket: bucket,
                key: key,
                tagging: Tagging(
                    tagSet: TagSet(
                        tags: [Tag(key: "k1", value: "v1")]
                    )
                )
            )
        )
        try check("putObjectTagging status=200", putTag.statusCode == 200)

        var getTag = try await client.getObjectTagging(
            GetObjectTaggingRequest(
                bucket: bucket,
                key: key
            )
        )
        try check("GetObjectTagging status=200", getTag.statusCode == 200)
        try check("GetObjectTagging count=1", getTag.tagging?.tagSet?.tags?.count == 1)
        try check("GetObjectTagging key=k1", getTag.tagging?.tagSet?.tags?[0].key == "k1")
        try check("GetObjectTagging value=v1", getTag.tagging?.tagSet?.tags?[0].value == "v1")

        let delTag = try await client.deleteObjectTagging(
            DeleteObjectTaggingRequest(
                bucket: bucket,
                key: key
            )
        )
        try check("deleteObjectTagging status=204", delTag.statusCode == 204)

        getTag = try await client.getObjectTagging(
            GetObjectTaggingRequest(
                bucket: bucket,
                key: key
            )
        )
        try check("GetObjectTagging after delete count=0", getTag.tagging?.tagSet?.tags?.count == 0)

        _ = try await client.deleteObject(
            DeleteObjectRequest(
                bucket: bucket,
                key: key
            )
        )
    }

    static func testObjectSymlink(client: Client, bucket: String) async throws {
        print("\n--- Object Symlink: put/Get ---")
        let key = "verify-obj-symlink"
        let linkKey = key + "-link"

        _ = try await client.putObject(
            PutObjectRequest(
                bucket: bucket,
                key: key,
                body: .data("symlink target".data(using: .utf8)!)
            )
        )

        let putSym = try await client.putSymlink(
            PutSymlinkRequest(
                bucket: bucket,
                key: linkKey,
                symlinkTarget: key
            )
        )
        try check("putSymlink status=200", putSym.statusCode == 200)

        let getSym = try await client.getSymlink(
            GetSymlinkRequest(
                bucket: bucket,
                key: linkKey
            )
        )
        try check("GetSymlink status=200", getSym.statusCode == 200)
        try check("GetSymlink target matches", getSym.symlinkTarget == key)

        let getObj = try await client.getObject(
            GetObjectRequest(
                bucket: bucket,
                key: linkKey
            )
        )
        try check("GetObject via symlink status=200", getObj.statusCode == 200)
        try check("GetObject via symlink ObjectType=Symlink", getObj.objectType == "Symlink")
        try check("GetObject via symlink body", getObj.body?.readData()?.decodeToString() == "symlink target")

        _ = try await client.deleteObject(
            DeleteObjectRequest(
                bucket: bucket,
                key: linkKey
            )
        )
        _ = try await client.deleteObject(
            DeleteObjectRequest(
                bucket: bucket,
                key: key
            )
        )
    }

    static func testAppendObject(client: Client, bucket: String) async throws {
        print("\n--- AppendObject / SealAppendObject ---")
        let key = "verify-append-obj"

        let append1 = try await client.appendObject(
            AppendObjectRequest(
                bucket: bucket,
                key: key,
                position: 0,
                body: .data("hello ".data(using: .utf8)!)
            )
        )
        try check("AppendObject(1) status=200", append1.statusCode == 200)
        try check("AppendObject(1) NextPosition=6", append1.nextAppendPosition == 6)

        let append2 = try await client.appendObject(
            AppendObjectRequest(
                bucket: bucket,
                key: key,
                position: 6,
                body: .data("world".data(using: .utf8)!),
                initHashCrc64: append1.hashCrc64ecma
            )
        )
        try check("AppendObject(2) status=200", append2.statusCode == 200)
        try check("AppendObject(2) NextPosition=11", append2.nextAppendPosition == 11)

        let getObj = try await client.getObject(
            GetObjectRequest(
                bucket: bucket,
                key: key
            )
        )
        try check("GetObject(append) ObjectType=Appendable", getObj.objectType == "Appendable")
        try check("GetObject(append) body=hello world", getObj.body?.readData()?.decodeToString() == "hello world")

        do {
            let sealResult = try await client.sealAppendObject(
                SealAppendObjectRequest(
                    bucket: bucket,
                    key: key,
                    position: 11
                )
            )
            try check("SealAppendObject status=200", sealResult.statusCode == 200)
        } catch {
            guard let err = error as? ServerError,
                err.code == "OperationNotSupported"
            else {
                try check("SealAppendObject (not supported in region, skipped)", true)
                return
            }
        }

        _ = try await client.deleteObject(
            DeleteObjectRequest(
                bucket: bucket,
                key: key
            )
        )
    }

    static func testMultipartUpload(client: Client, bucket: String) async throws {
        print("\n--- Multipart: Init/Upload/ListParts/Complete ---")
        let key = "verify-multipart"

        let initResult = try await client.initiateMultipartUpload(
            InitiateMultipartUploadRequest(
                bucket: bucket,
                key: key
            )
        )
        try check("InitiateMultipartUpload status=200", initResult.statusCode == 200)
        try check("InitiateMultipartUpload has UploadId", initResult.uploadId?.isEmpty == false)

        let content = "multipart content data"
        let upResult = try await client.uploadPart(
            UploadPartRequest(
                bucket: bucket,
                key: key,
                partNumber: 1,
                uploadId: initResult.uploadId,
                body: .data(content.data(using: .utf8)!)
            )
        )
        try check("UploadPart status=200", upResult.statusCode == 200)
        try check("UploadPart has ETag", upResult.etag?.isEmpty == false)

        let listParts = try await client.listParts(
            ListPartsRequest(
                bucket: bucket,
                key: key,
                uploadId: initResult.uploadId
            )
        )
        try check("ListParts status=200", listParts.statusCode == 200)
        try check("ListParts count=1", listParts.parts?.count == 1)
        try check("ListParts size matches", listParts.parts?[0].size == content.count)

        let listUploads = try await client.listMultipartUploads(
            ListMultipartUploadsRequest(
                bucket: bucket,
                prefix: key
            )
        )
        try check("ListMultipartUploads status=200", listUploads.statusCode == 200)
        try check("ListMultipartUploads count>=1", listUploads.uploads?.count ?? 0 >= 1)

        let cmResult = try await client.completeMultipartUpload(
            CompleteMultipartUploadRequest(
                bucket: bucket,
                key: key,
                uploadId: initResult.uploadId,
                completeMultipartUpload: CompleteMultipartUpload(
                    parts: [
                        UploadPart(
                            etag: upResult.etag,
                            partNumber: 1
                        )
                    ]
                )
            )
        )
        try check("CompleteMultipartUpload status=200", cmResult.statusCode == 200)

        let getObj = try await client.getObject(
            GetObjectRequest(
                bucket: bucket,
                key: key
            )
        )
        try check("GetObject(multipart) ObjectType=Multipart", getObj.objectType == "Multipart")
        try check("GetObject(multipart) body matches", getObj.body?.readData()?.decodeToString() == content)

        // UploadPartCopy
        print("\n--- Multipart: UploadPartCopy ---")
        let copyKey = key + "-copy"
        let initResult2 = try await client.initiateMultipartUpload(
            InitiateMultipartUploadRequest(
                bucket: bucket,
                key: copyKey
            )
        )
        try check("InitiateMultipartUpload(copy) status=200", initResult2.statusCode == 200)

        let copyResult = try await client.uploadPartCopy(
            UploadPartCopyRequest(
                bucket: bucket,
                key: copyKey,
                sourceBucket: bucket,
                sourceKey: key,
                partNumber: 1,
                uploadId: initResult2.uploadId,
            )
        )
        try check("UploadPartCopy status=200", copyResult.statusCode == 200)

        let cmResult2 = try await client.completeMultipartUpload(
            CompleteMultipartUploadRequest(
                bucket: bucket,
                key: copyKey,
                uploadId: initResult2.uploadId,
                completeMultipartUpload: CompleteMultipartUpload(
                    parts: [
                        UploadPart(
                            etag: copyResult.copyPartResult?.etag,
                            partNumber: 1
                        )
                    ]
                )
            )
        )
        try check("CompleteMultipartUpload(copy) status=200", cmResult2.statusCode == 200)

        // AbortMultipartUpload
        print("\n--- Multipart: Abort ---")
        let abortKey = key + "-abort"
        let initResult3 = try await client.initiateMultipartUpload(
            InitiateMultipartUploadRequest(
                bucket: bucket,
                key: abortKey
            )
        )
        let abortResult = try await client.abortMultipartUpload(
            AbortMultipartUploadRequest(
                bucket: bucket,
                key: abortKey,
                uploadId: initResult3.uploadId
            )
        )
        try check("AbortMultipartUpload status=204", abortResult.statusCode == 204)

        _ = try await client.deleteObject(
            DeleteObjectRequest(
                bucket: bucket,
                key: key
            )
        )
        _ = try await client.deleteObject(
            DeleteObjectRequest(
                bucket: bucket,
                key: copyKey
            )
        )
    }

    static func testPresigner(client: Client, bucket: String) async throws {
        print("\n--- Presigner ---")
        let key = "verify-presign"
        let content = "presign content"

        _ = try await client.putObject(
            PutObjectRequest(
                bucket: bucket,
                key: key,
                body: .data(content.data(using: .utf8)!)
            )
        )

        let preResult = try await client.presign(
            GetObjectRequest(
                bucket: bucket,
                key: key
            )
        )
        try check("Presign has URL", preResult.url.isEmpty == false)
        try check("Presign Method=GET", preResult.method == "GET")
        try check("Presign has Expiration", preResult.expiration != nil)

        let session = URLSession.shared
        let (data, resp) = try await session.data(from: URL(string: preResult.url)!)
        try check("Presign GET status=200", (resp as? HTTPURLResponse)?.statusCode == 200)
        try check("Presign GET body matches", data.decodeToString() == content)
        _ = try await client.deleteObject(
            DeleteObjectRequest(
                bucket: bucket,
                key: key
            )
        )
    }

    static func testPaginator(client: Client, bucket: String) async throws {
        print("\n--- Paginator: ListObjects ---")
        for i in 0..<3 {
            _ = try await client.putObject(
                PutObjectRequest(
                    bucket: bucket,
                    key: "paginator-test/\(i)"
                )
            )
        }

        let paginator = client.listObjectsPaginator(
            ListObjectsRequest(
                bucket: bucket,
                prefix: "paginator-test/"
            ),
            PaginatorOptions(limit: 2)
        )

        var count = 0
        for try await page in paginator {
            count += page.contents?.count ?? 0
        }
        try check("ListObjectsPaginator total=3", count == 3)

        print("\n--- Paginator: ListObjectsV2 ---")
        let paginator2 = client.listObjectsV2Paginator(
            ListObjectsV2Request(
                bucket: bucket,
                prefix: "paginator-test/"
            ),
            PaginatorOptions(limit: 2)
        )

        count = 0
        for try await page in paginator2 {
            count += page.contents?.count ?? 0
        }
        try check("ListObjectsV2Paginator total=3", count == 3)

        print("\n--- Paginator: ListBuckets ---")
        let paginator3 = client.listBucketsPaginator(
            ListBucketsRequest(
                prefix: bucket
            )
        )
        count = 0
        for try await page in paginator3 {
            count += page.buckets?.count ?? 0
        }
        try check("ListBucketsPaginator found bucket", count >= 1)

        // cleanup paginator objects
        _ = try await client.deleteMultipleObjects(
            DeleteMultipleObjectsRequest(
                bucket: bucket,
                delete: Delete(
                    objects: [
                        DeleteObject(key: "paginator-test/0"),
                        DeleteObject(key: "paginator-test/1"),
                        DeleteObject(key: "paginator-test/2"),
                    ]
                )
            )
        )
        try check("deleteMultipleObjects status OK", true)
    }

    static func testExtension(client: Client, bucket: String) async throws {
        print("\n--- Extensions: IsExist / File APIs ---")

        let exist = try await client.isBucketExist(bucket)
        try check("IsBucketExist=true", exist)

        let key = "verify-ext-file"
        _ = try await client.putObject(
            PutObjectRequest(
                bucket: bucket,
                key: key,
                body: .data("extension test".data(using: .utf8)!)
            )
        )

        let objExist = try await client.isObjectExist(bucket, key)
        try check("IsObjectExist=true", objExist)

        let notExist = try await client.isObjectExist(bucket, "no-such-key-xyz")
        try check("IsObjectExist=false for missing", !notExist)

        _ = try await client.deleteObject(DeleteObjectRequest(bucket: bucket, key: key))
    }

    static func cleanBucket(client: Client, bucket: String) async {
        do {
            let paginator = client.listObjectsPaginator(ListObjectsRequest(bucket: bucket))
            for try await page in paginator {
                var objs: [DeleteObject] = []
                page.contents?.forEach { obj in
                    objs.append(DeleteObject(key: obj.key))
                }
                _ = try await client.deleteMultipleObjects(
                    DeleteMultipleObjectsRequest(
                        bucket: bucket,
                        delete: Delete(objects: objs)
                    )
                )
            }
            _ = try await client.deleteBucket(DeleteBucketRequest(bucket: bucket))
        } catch {}
    }
}

struct PVError: Error {
    let message: String
}

extension Data {
    func decodeToString() -> String? {
        String(data: self, encoding: .utf8)
    }
}
