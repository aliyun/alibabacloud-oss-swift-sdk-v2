
import AlibabaCloudOSS
import XCTest

final class ClientBucketAclTests: BaseTestCase {
    func testBucketAclSuccess() async throws {
        // default
        let client = getDefaultClient()
        let bucket = randomBucketName()

        let result = try await client.putBucket(PutBucketRequest(bucket: bucket))
        XCTAssertNotNil(result)
        XCTAssertEqual(result.statusCode, 200)
        XCTAssertEqual(24, result.requestId.count)

        // get bucket acl
        var getBucketAclResult = try await client.getBucketAcl(GetBucketAclRequest(bucket: bucket))
        XCTAssertNotNil(getBucketAclResult)
        XCTAssertEqual(getBucketAclResult.statusCode, 200)
        XCTAssertEqual(24, getBucketAclResult.requestId.count)
        XCTAssertEqual("private", getBucketAclResult.accessControlPolicy?.accessControlList?.grant)

        // put bucket acl
        var putBucketAclRequest = PutBucketAclRequest(bucket: bucket)
        putBucketAclRequest.acl = "private"
        let putBucketAclResult = try await client.putBucketAcl(putBucketAclRequest)
        XCTAssertEqual(putBucketAclResult.statusCode, 200)
        XCTAssertEqual(24, putBucketAclResult.requestId.count)

        // get bucket acl
        getBucketAclResult = try await client.getBucketAcl(GetBucketAclRequest(bucket: bucket))
        XCTAssertNotNil(getBucketAclResult)
        XCTAssertEqual(getBucketAclResult.statusCode, 200)
        XCTAssertEqual(24, getBucketAclResult.requestId.count)
        XCTAssertEqual("private", getBucketAclResult.accessControlPolicy?.accessControlList?.grant)

        // delete bucket
        let _ = try await client.deleteBucket(DeleteBucketRequest(bucket: bucket))
    }

    func testBucketAclFail() async throws {
        let client = getDefaultClient()
        let bucket = randomBucketName()

        // bucket is nil
        try await assertThrowsAsyncError(await client.getBucketAcl(GetBucketAclRequest())) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Missing required field, request.bucket.", clientError?.message)
        }
        try await assertThrowsAsyncError(await client.putBucketAcl(PutBucketAclRequest())) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Missing required field, request.bucket.", clientError?.message)
        }

        // invalid bucket name
        try await assertThrowsAsyncError(await client.putBucketAcl(PutBucketAclRequest(bucket: "!@#$"))) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Bucket name is invalid, got !@#$.", clientError?.message)
        }

        // bucket is non-existent
        try await assertThrowsAsyncError(await client.getBucketAcl(GetBucketAclRequest(bucket: bucket))) {
            let serverError = $0 as! ServerError
            XCTAssertEqual(serverError.statusCode, 404)
            XCTAssertEqual(serverError.code, "NoSuchBucket")
            XCTAssertEqual(serverError.message, "The specified bucket does not exist.")
            XCTAssertEqual(serverError.ec, "0015-00000101")
            XCTAssertNotNil(serverError.requestId)
        }

        try await createBucket(client: client, bucket: bucket)

        // acl is invalid
        var putBucketACLRequest = PutBucketAclRequest(bucket: bucket)
        putBucketACLRequest.acl = "acl"
        try await assertThrowsAsyncError(await client.putBucketAcl(putBucketACLRequest)) {
            let serverError = $0 as! ServerError
            XCTAssertEqual(serverError.statusCode, 400)
            XCTAssertEqual(serverError.code, "InvalidArgument")
            XCTAssertEqual(serverError.message, "no such bucket access control exists")
            XCTAssertEqual(serverError.ec, "0015-00000204")
            XCTAssertNotNil(serverError.requestId)
        }

        let _ = try await client.deleteBucket(DeleteBucketRequest(bucket: bucket))
    }
}
