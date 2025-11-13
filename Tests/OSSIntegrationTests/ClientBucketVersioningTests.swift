import AlibabaCloudOSS
import AlibabaCloudOSSExtension
import XCTest

final class ClientBucketVersioningTests: BaseTestCase {
    override func setUp() async throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try await super.setUp()
        bucketName = randomBucketName()
        client = getDefaultClient()

        try await createBucket(client: client!, bucket: bucketName)
    }

    override func tearDown() async throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try await cleanBucket(client: getDefaultClient(), bucket: bucketName)
        try await super.tearDown()
    }

    func testPutAndGetBucketVersioningSuccess() async throws {
        var getBucketVersioningRequest = GetBucketVersioningRequest(bucket: bucketName)
        var getBucketVersioningResult = try await client?.getBucketVersioning(getBucketVersioningRequest)
        XCTAssertEqual(getBucketVersioningResult?.statusCode, 200)
        XCTAssertNil(getBucketVersioningResult?.versioningConfiguration?.status)

        var putBucketVersioningRequest = PutBucketVersioningRequest(bucket: bucketName,
                                                                    versioningConfiguration: VersioningConfiguration(status: "Enabled"))
        try await assertNoThrow(await client?.putBucketVersioning(putBucketVersioningRequest))

        getBucketVersioningRequest = GetBucketVersioningRequest(bucket: bucketName)
        getBucketVersioningResult = try await client?.getBucketVersioning(getBucketVersioningRequest)
        XCTAssertEqual(getBucketVersioningResult?.statusCode, 200)
        XCTAssertEqual(getBucketVersioningResult?.versioningConfiguration?.status, "Enabled")

        putBucketVersioningRequest = PutBucketVersioningRequest(bucket: bucketName,
                                                                versioningConfiguration: VersioningConfiguration(status: "Suspended"))
        try await assertNoThrow(await client?.putBucketVersioning(putBucketVersioningRequest))

        getBucketVersioningRequest = GetBucketVersioningRequest(bucket: bucketName)
        getBucketVersioningResult = try await client?.getBucketVersioning(getBucketVersioningRequest)
        XCTAssertEqual(getBucketVersioningResult?.statusCode, 200)
        XCTAssertEqual(getBucketVersioningResult?.versioningConfiguration?.status, "Suspended")
    }

    func testPutBucketVersioningFail() async {
        var request = PutBucketVersioningRequest()
        try await assertThrowsAsyncError(await client?.putBucketVersioning(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }

        request = PutBucketVersioningRequest(bucket: bucketName)
        try await assertThrowsAsyncError(await client?.putBucketVersioning(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.versioningConfiguration.")
        }

        request = PutBucketVersioningRequest(bucket: bucketName,
                                             versioningConfiguration: VersioningConfiguration(status: "status"))
        try await assertThrowsAsyncError(await client?.putBucketVersioning(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 400)
            XCTAssertEqual(serverError?.code, "MalformedXML")
        }
    }

    func testGetBucketVersioningFail() async {
        let bucket = randomBucketName()
        var request = GetBucketVersioningRequest()
        try await assertThrowsAsyncError(await client?.getBucketVersioning(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }

        request = GetBucketVersioningRequest(bucket: bucket)
        try await assertThrowsAsyncError(await client?.getBucketVersioning(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }

    func testListObjectVersionsSuccess() async throws {
        let keyPrefix = "listObjectVersionsSuccess"
        let putBucketVersioningRequest = PutBucketVersioningRequest(bucket: bucketName,
                                                                    versioningConfiguration: VersioningConfiguration(status: "Enabled"))
        try await assertNoThrow(await client?.putBucketVersioning(putBucketVersioningRequest))

        var request = ListObjectVersionsRequest(bucket: bucketName)
        var result = try await client?.listObjectVersions(request)
        XCTAssertEqual(result?.statusCode, 200)
        XCTAssertNil(result?.versions)

        for i in 0 ..< 10 {
            let putRequest = PutObjectRequest(bucket: bucketName,
                                              key: keyPrefix + "-\(i)",
                                              body: .data("hello oss".data(using: .utf8)!))
            try await assertNoThrow(await client?.putObject(putRequest))
        }
        for i in 10 ..< 20 {
            var putRequest = PutObjectRequest(bucket: bucketName,
                                              key: keyPrefix + "-\(i)",
                                              body: .data("hello oss".data(using: .utf8)!))
            putRequest.storageClass = "Archive"
            try await assertNoThrow(await client?.putObject(putRequest))
        }

        request = ListObjectVersionsRequest(bucket: bucketName)
        result = try await client?.listObjectVersions(request)
        XCTAssertEqual(result?.statusCode, 200)
        XCTAssertEqual(result?.versions?.count, 20)
        for version in result!.versions! {
            let index = Int(version.key!.split(separator: "-").last!)!
            XCTAssertTrue(version.key?.hasPrefix(keyPrefix) ?? false)
            XCTAssertNotNil(version.eTag)
            XCTAssertNotNil(version.lastModified)
            XCTAssertNotNil(version.owner?.displayName)
            XCTAssertNotNil(version.owner?.id)
            if index < 10 {
                XCTAssertNotNil(version.storageClass)
            } else {
                XCTAssertEqual(version.storageClass, "Archive")
            }
            XCTAssertNotNil(version.size)
            XCTAssertNotNil(version.versionId)
        }

        // page
        var isTruncated = true
        repeat {
            request = ListObjectVersionsRequest(bucket: bucketName)
            request.maxKeys = 10
            request.keyMarker = result?.nextKeyMarker
            request.versionIdMarker = result?.nextVersionIdMarker
            result = try await client?.listObjectVersions(request)
            XCTAssertEqual(result?.statusCode, 200)
            XCTAssertEqual(result?.versions?.count, 10)
            isTruncated = result!.isTruncated!
            for version in result!.versions! {
                XCTAssertNotNil(version.eTag)
                XCTAssertNotNil(version.lastModified)
                XCTAssertNotNil(version.owner?.displayName)
                XCTAssertNotNil(version.owner?.id)
                XCTAssertNotNil(version.size)
                XCTAssertNotNil(version.versionId)
            }
        } while isTruncated

        // prefix
        request = ListObjectVersionsRequest(bucket: bucketName)
        request.prefix = keyPrefix + "-1"
        result = try await client?.listObjectVersions(request)
        XCTAssertEqual(result?.statusCode, 200)
        XCTAssertEqual(result?.versions?.count, 11)
        for version in result!.versions! {
            XCTAssertTrue(version.key?.hasPrefix(request.prefix!) ?? false)
            XCTAssertNotNil(version.eTag)
            XCTAssertNotNil(version.lastModified)
            XCTAssertNotNil(version.owner?.displayName)
            XCTAssertNotNil(version.owner?.id)
            XCTAssertNotNil(version.size)
            XCTAssertNotNil(version.versionId)
        }

        // deleteMarker
        var objects: [DeleteObject] = []
        for i in 0 ..< 10 {
            objects.append(DeleteObject(key: keyPrefix + "-\(i)"))
        }
        try await assertNoThrow(await client?.deleteMultipleObjects(DeleteMultipleObjectsRequest(
            bucket: bucketName,
            delete: Delete(
                objects: objects
            )
        )))
        request = ListObjectVersionsRequest(bucket: bucketName)
        result = try await client?.listObjectVersions(request)
        XCTAssertEqual(result?.statusCode, 200)
        XCTAssertEqual(result?.deleteMarkers?.count, 10)
        for deleteMarker in result!.deleteMarkers! {
            let index = Int(deleteMarker.key!.split(separator: "-").last!)!
            XCTAssertTrue(index < 10)
            XCTAssertNotNil(deleteMarker.lastModified)
            XCTAssertNotNil(deleteMarker.owner?.displayName)
            XCTAssertNotNil(deleteMarker.owner?.id)
            XCTAssertNotNil(deleteMarker.versionId)
        }

        // prefix
        request = ListObjectVersionsRequest(bucket: bucketName)
        request.delimiter = "1"
        result = try await client?.listObjectVersions(request)
        XCTAssertEqual(result?.statusCode, 200)
        for commonPrefix in result!.commonPrefixes! {
            XCTAssertEqual(commonPrefix.prefix, keyPrefix + "-1")
        }
    }

    func testListObjectVersionsFail() async throws {
        var request = ListObjectVersionsRequest()
        try await assertThrowsAsyncError(await client?.listObjectVersions(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }

        request = ListObjectVersionsRequest(bucket: bucketName, maxKeys: 10000)
        try await assertThrowsAsyncError(await client?.listObjectVersions(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 400)
            XCTAssertEqual(serverError?.code, "InvalidArgument")
        }
    }
}
