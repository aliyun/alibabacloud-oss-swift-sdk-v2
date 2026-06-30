import AlibabaCloudOSS
import XCTest

final class ClientObjectACLTests: BaseTestCase {
    override func setUp() async throws {
        try await super.setUp()

        client = getDefaultClient()
        bucketName = randomBucketName()

        let requst = PutBucketRequest(bucket: bucketName)
        try await assertNoThrow(await client?.putBucket(requst))
    }

    override func tearDown() async throws {
        try await cleanBucket(client: client!, bucket: bucketName)
        try await super.tearDown()
    }

    // MARK: - test ObjectACL

    func testObjectACLSuccess() async throws {
        let objectKey = "testPutObjectACL"

        let putObject = PutObjectRequest(bucket: bucketName,
                                         key: objectKey)
        try await assertNoThrow(await client?.putObject(putObject))

        var getACLRequest = GetObjectAclRequest(bucket: bucketName,
                                                key: objectKey)
        var getACLResult = try await client?.getObjectAcl(getACLRequest)
        XCTAssertEqual(getACLResult?.accessControlPolicy?.accessControlList?.grant, "default")

        // private
        var putACLRequest = PutObjectAclRequest(bucket: bucketName,
                                                key: objectKey,
                                                objectAcl: "private")
        try await assertNoThrow(await client?.putObjectAcl(putACLRequest))

        getACLRequest = GetObjectAclRequest(bucket: bucketName, key: objectKey)
        getACLResult = try await client?.getObjectAcl(getACLRequest)
        XCTAssertEqual(getACLResult?.accessControlPolicy?.accessControlList?.grant, putACLRequest.objectAcl)

        // default
        putACLRequest = PutObjectAclRequest(bucket: bucketName,
                                            key: objectKey,
                                            objectAcl: "default")
        try await assertNoThrow(await client?.putObjectAcl(putACLRequest))

        getACLRequest = GetObjectAclRequest(bucket: bucketName, key: objectKey)
        getACLResult = try await client?.getObjectAcl(getACLRequest)
        XCTAssertEqual(getACLResult?.accessControlPolicy?.accessControlList?.grant, putACLRequest.objectAcl)
    }

    func testObjectACLFail() async throws {
        let objectKey = "testPutObjectACL"

        let putObject = PutObjectRequest(bucket: bucketName,
                                         key: objectKey)
        try await assertNoThrow(await client?.putObject(putObject))

        // PutObjectAcl
        // bucket is nil
        try await assertThrowsAsyncError(await client?.putObjectAcl(PutObjectAclRequest())) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Missing required field, request.bucket.", clientError?.message)
        }

        // invalid bucket name
        try await assertThrowsAsyncError(await client?.putObjectAcl(PutObjectAclRequest(bucket: "!@#$", key: objectKey))) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Bucket name is invalid, got !@#$.", clientError?.message)
        }

        // object key is nil
        try await assertThrowsAsyncError(await client?.putObjectAcl(PutObjectAclRequest(bucket: bucketName))) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Missing required field, request.key.", clientError?.message)
        }

        // invalid argument
        let request = PutObjectAclRequest(bucket: bucketName,
                                          key: objectKey,
                                          objectAcl: "invalid")
        try await assertThrowsAsyncError(await client?.putObjectAcl(request)) {
            let serverError = $0 as! ServerError
            XCTAssertEqual(serverError.statusCode, 400)
            XCTAssertEqual(serverError.code, "InvalidArgument")
            XCTAssertEqual(serverError.message, "no such object access control exists")
            XCTAssertEqual(serverError.ec, "0017-00000104")
            XCTAssertNotNil(serverError.requestId)
        }

        // GetObjectAcl
        // bucket is nil
        try await assertThrowsAsyncError(await client?.getObjectAcl(GetObjectAclRequest())) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Missing required field, request.bucket.", clientError?.message)
        }

        // invalid bucket name
        try await assertThrowsAsyncError(await client?.getObjectAcl(GetObjectAclRequest(bucket: "!@#$", key: objectKey))) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Bucket name is invalid, got !@#$.", clientError?.message)
        }

        // object key is nil
        try await assertThrowsAsyncError(await client?.getObjectAcl(GetObjectAclRequest(bucket: bucketName))) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Missing required field, request.key.", clientError?.message)
        }

        // invalid argument
        let getAclrequest = GetObjectAclRequest(bucket: bucketName,
                                                key: "invalid")
        try await assertThrowsAsyncError(await client?.getObjectAcl(getAclrequest)) {
            let serverError = $0 as! ServerError
            XCTAssertEqual(serverError.statusCode, 404)
            XCTAssertEqual(serverError.code, "NoSuchKey")
            XCTAssertEqual(serverError.message, "The specified key does not exist.")
            XCTAssertEqual(serverError.ec, "0026-00000001")
            XCTAssertNotNil(serverError.requestId)
        }
    }
}
