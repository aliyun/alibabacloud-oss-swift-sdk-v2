import AlibabaCloudOSS
import Foundation
import XCTest
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

class ClientPresignerTests: BaseTestCase {
    func testPresignPutObject() async throws {
        let data = "hello oss".data(using: .utf8)!
        let client = getDefaultClient()
        let bucket = randomBucketName()
        let key = randomObjectName()

        try await createBucket(client: client, bucket: bucket)

        let expiration = Date().addingTimeInterval(10 * 60)
        let request = PutObjectRequest(bucket: bucket, key: key)
        let result = try await client.presign(request, expiration)
        XCTAssertEqual(result.method, "PUT")
        XCTAssertTrue(result.url.contains("x-oss-signature-version"))
        XCTAssertTrue(result.url.contains("x-oss-expires"))
        XCTAssertTrue(result.url.contains("x-oss-credential"))
        XCTAssertTrue(result.url.contains("x-oss-signature"))
        XCTAssertEqual(result.expiration, expiration)

        var urlRequest = URLRequest(url: URL(string: result.url)!)
        urlRequest.httpMethod = result.method
        for (key, value) in result.signedHeaders ?? [:] {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        let (_, response) = try await URLSession.shared.upload(for: urlRequest, from: data)
        XCTAssertEqual((response as! HTTPURLResponse).statusCode, 200)

        try await cleanBucket(client: client, bucket: bucket)
    }

    func testPresignGetObject() async throws {
        let content = "hello oss".data(using: .utf8)!
        let client = getDefaultClient()
        let bucket = randomBucketName()
        let key = randomObjectName()

        try await createBucket(client: client, bucket: bucket)
        let putRequest = PutObjectRequest(bucket: bucket,
                                          key: key,
                                          metadata: ["user" : "jack"],
                                          body: .data(content))
        try await assertNoThrow(await client.putObject(putRequest))

        let expiration = Date().addingTimeInterval(10 * 60)
        let request = GetObjectRequest(bucket: bucket, key: key)
        let result = try await client.presign(request, expiration)
        XCTAssertEqual(result.method, "GET")
        XCTAssertTrue(result.url.contains("x-oss-signature-version"))
        XCTAssertTrue(result.url.contains("x-oss-expires"))
        XCTAssertTrue(result.url.contains("x-oss-credential"))
        XCTAssertTrue(result.url.contains("x-oss-signature"))
        XCTAssertEqual(result.expiration, expiration)

        var urlRequest = URLRequest(url: URL(string: result.url)!)
        urlRequest.httpMethod = result.method
        for (key, value) in result.signedHeaders ?? [:] {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        XCTAssertEqual((response as! HTTPURLResponse).statusCode, 200)
        XCTAssertEqual(data.base64EncodedString(), data.base64EncodedString())

        try await cleanBucket(client: client, bucket: bucket)
    }

    func testPresignHeadObject() async throws {
        let data = "hello oss".data(using: .utf8)!
        let client = getDefaultClient()
        let bucket = randomBucketName()
        let key = randomObjectName()

        try await createBucket(client: client, bucket: bucket)
        let putRequest = PutObjectRequest(bucket: bucket,
                                          key: key,
                                          body: .data(data))
        try await assertNoThrow(await client.putObject(putRequest))

        let expiration = Date().addingTimeInterval(10 * 60)
        let request = HeadObjectRequest(bucket: bucket, key: key)
        let result = try await client.presign(request, expiration)
        XCTAssertEqual(result.method, "HEAD")
        XCTAssertTrue(result.url.contains("x-oss-signature-version"))
        XCTAssertTrue(result.url.contains("x-oss-expires"))
        XCTAssertTrue(result.url.contains("x-oss-credential"))
        XCTAssertTrue(result.url.contains("x-oss-signature"))
        XCTAssertEqual(result.expiration, expiration)

        var urlRequest = URLRequest(url: URL(string: result.url)!)
        urlRequest.httpMethod = result.method
        for (key, value) in result.signedHeaders ?? [:] {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        let (_, response) = try await URLSession.shared.data(for: urlRequest)
        XCTAssertEqual((response as! HTTPURLResponse).statusCode, 200)

        try await cleanBucket(client: client, bucket: bucket)
    }

    func testPresignInitiateMultipartUpload() async throws {
        let client = getDefaultClient()
        let bucket = randomBucketName()
        let key = randomObjectName()

        try await createBucket(client: client, bucket: bucket)

        let expiration = Date().addingTimeInterval(10 * 60)
        let request = InitiateMultipartUploadRequest(bucket: bucket, key: key)
        let result = try await client.presign(request, expiration)
        XCTAssertEqual(result.method, "POST")
        XCTAssertTrue(result.url.contains("x-oss-signature-version"))
        XCTAssertTrue(result.url.contains("x-oss-expires"))
        XCTAssertTrue(result.url.contains("x-oss-credential"))
        XCTAssertTrue(result.url.contains("x-oss-signature"))
        XCTAssertTrue(result.url.contains("uploads"))
        XCTAssertEqual(result.expiration, expiration)

        var urlRequest = URLRequest(url: URL(string: result.url)!)
        urlRequest.httpMethod = result.method
        for (key, value) in result.signedHeaders ?? [:] {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        let (_, response) = try await URLSession.shared.data(for: urlRequest)
        XCTAssertEqual((response as! HTTPURLResponse).statusCode, 200)

        try await cleanBucket(client: client, bucket: bucket)
    }

    func testPresignUploadPart() async throws {
        let data = "hello oss".data(using: .utf8)!
        let client = getDefaultClient()
        let bucket = randomBucketName()
        let key = randomObjectName()

        try await createBucket(client: client, bucket: bucket)
        let initUploadPartRequest = InitiateMultipartUploadRequest(bucket: bucket, key: key)
        let initUploadPartResult = try await client.initiateMultipartUpload(initUploadPartRequest)

        let expiration = Date().addingTimeInterval(10 * 60)
        let request = UploadPartRequest(bucket: bucket,
                                        key: key,
                                        partNumber: 1,
                                        uploadId: initUploadPartResult.uploadId!)
        let result = try await client.presign(request, expiration)
        XCTAssertEqual(result.method, "PUT")
        XCTAssertTrue(result.url.contains("x-oss-signature-version"))
        XCTAssertTrue(result.url.contains("x-oss-expires"))
        XCTAssertTrue(result.url.contains("x-oss-credential"))
        XCTAssertTrue(result.url.contains("x-oss-signature"))
        XCTAssertTrue(result.url.contains("uploadId"))
        XCTAssertTrue(result.url.contains("partNumber"))
        XCTAssertEqual(result.expiration, expiration)

        var urlRequest = URLRequest(url: URL(string: result.url)!)
        urlRequest.httpMethod = result.method
        for (key, value) in result.signedHeaders ?? [:] {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        let (_, response) = try await URLSession.shared.upload(for: urlRequest, from: data)
        XCTAssertEqual((response as! HTTPURLResponse).statusCode, 200)

        try await cleanBucket(client: client, bucket: bucket)
    }

    func testPresignCompleteMultipartUpload() async throws {
        let data = "hello oss".data(using: .utf8)!
        let client = getDefaultClient()
        let bucket = randomBucketName()
        let key = randomObjectName()

        try await createBucket(client: client, bucket: bucket)

        let initUploadPartRequest = InitiateMultipartUploadRequest(bucket: bucket, key: key)
        let initUploadPartResult = try await client.initiateMultipartUpload(initUploadPartRequest)

        let uploadPartRequest = UploadPartRequest(bucket: bucket,
                                                  key: key,
                                                  partNumber: 1,
                                                  uploadId: initUploadPartResult.uploadId!,
                                                  body: .data(data))
        try await assertNoThrow(await client.uploadPart(uploadPartRequest))

        let expiration = Date().addingTimeInterval(10 * 60)
        let request = CompleteMultipartUploadRequest(bucket: bucket,
                                                     key: key,
                                                     completeAll: "yes",
                                                     uploadId: initUploadPartResult.uploadId!)
        let result = try await client.presign(request, expiration)
        XCTAssertEqual(result.method, "POST")
        XCTAssertTrue(result.url.contains("x-oss-signature-version"))
        XCTAssertTrue(result.url.contains("x-oss-expires"))
        XCTAssertTrue(result.url.contains("x-oss-credential"))
        XCTAssertTrue(result.url.contains("x-oss-signature"))
        XCTAssertTrue(result.url.contains("uploadId"))
        XCTAssertEqual(result.expiration, expiration)

        var urlRequest = URLRequest(url: URL(string: result.url)!)
        urlRequest.httpMethod = result.method
        for (key, value) in result.signedHeaders ?? [:] {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        let (_, response) = try await URLSession.shared.data(for: urlRequest)
        XCTAssertEqual((response as! HTTPURLResponse).statusCode, 200)

        try await cleanBucket(client: client, bucket: bucket)
    }

    func testPresignAbortMultipartUpload() async throws {
        let data = "hello oss".data(using: .utf8)!
        let client = getDefaultClient()
        let bucket = randomBucketName()
        let key = randomObjectName()

        try await createBucket(client: client, bucket: bucket)

        let initUploadPartRequest = InitiateMultipartUploadRequest(bucket: bucket, key: key)
        let initUploadPartResult = try await client.initiateMultipartUpload(initUploadPartRequest)

        let uploadPartRequest = UploadPartRequest(bucket: bucket,
                                                  key: key,
                                                  partNumber: 1,
                                                  uploadId: initUploadPartResult.uploadId!,
                                                  body: .data(data))
        try await assertNoThrow(await client.uploadPart(uploadPartRequest))

        let expiration = Date().addingTimeInterval(10 * 60)
        let request = AbortMultipartUploadRequest(bucket: bucket,
                                                  key: key,
                                                  uploadId: initUploadPartResult.uploadId!)
        let result = try await client.presign(request, expiration)
        XCTAssertEqual(result.method, "DELETE")
        XCTAssertTrue(result.url.contains("x-oss-signature-version"))
        XCTAssertTrue(result.url.contains("x-oss-expires"))
        XCTAssertTrue(result.url.contains("x-oss-credential"))
        XCTAssertTrue(result.url.contains("x-oss-signature"))
        XCTAssertTrue(result.url.contains("uploadId"))
        XCTAssertEqual(result.expiration, expiration)

        var urlRequest = URLRequest(url: URL(string: result.url)!)
        urlRequest.httpMethod = result.method
        for (key, value) in result.signedHeaders ?? [:] {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        let (_, response) = try await URLSession.shared.data(for: urlRequest)
        XCTAssertEqual((response as! HTTPURLResponse).statusCode, 204)

        try await cleanBucket(client: client, bucket: bucket)
    }
}
