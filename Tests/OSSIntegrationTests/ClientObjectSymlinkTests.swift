
import AlibabaCloudOSS
import XCTest

final class ClientObjectSymlinkTests: BaseTestCase {
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

    // MARK: - test Symlink

    func testPutSymlink() async throws {
        let objectName = randomBucketName()
        let objectKey = objectName
        let objectSymlinkKey = objectName + "-link"
        let content = "hello oss".data(using: .utf8)!

        let putObject = PutObjectRequest(bucket: bucketName,
                                         key: objectKey,
                                         body: .data(content))
        try await assertNoThrow(await client?.putObject(putObject))

        let putSymlinkRequest = PutSymlinkRequest(bucket: bucketName,
                                                  key: objectSymlinkKey,
                                                  symlinkTarget: objectKey)
        try await assertNoThrow(await client?.putSymlink(putSymlinkRequest))

        let getResult = try await client?.getObject(GetObjectRequest(bucket: bucketName, key: objectSymlinkKey))
        XCTAssertEqual(getResult?.statusCode, 200)
        switch getResult?.body {
        case let .data(data):
            XCTAssertEqual(content, data)
        default:
            XCTFail("getResult?.body is not data")
        }
    }

    func testPutSymlinkWithStorageClass() async throws {
        let objectKey = "testPutSymlinkWithStorageClass"
        let objectSymlinkKey = "testPutSymlinkWithStorageClassKey"
        let content = "hello oss".data(using: .utf8)!

        let putObject = PutObjectRequest(bucket: bucketName,
                                         key: objectKey,
                                         body: .data(content))
        try await assertNoThrow(await client?.putObject(putObject))

        var putSymlinkRequest = PutSymlinkRequest(bucket: bucketName,
                                                  key: objectSymlinkKey,
                                                  symlinkTarget: objectKey)
        putSymlinkRequest.storageClass = "Archive"
        try await assertNoThrow(await client?.putSymlink(putSymlinkRequest))
    }

    func testPutSymlinkWithACL() async throws {
        let objectKey = "testPutSymlinkWithACL"
        let objectSymlinkKey = "testPutSymlinkWithACLKey"
        let content = "hello oss".data(using: .utf8)!

        let putObject = PutObjectRequest(bucket: bucketName,
                                         key: objectKey,
                                         body: .data(content))
        try await assertNoThrow(await client?.putObject(putObject))

        var putSymlinkRequest = PutSymlinkRequest(bucket: bucketName,
                                                  key: objectSymlinkKey,
                                                  symlinkTarget: objectKey)
        putSymlinkRequest.objectAcl = "private"
        try await assertNoThrow(await client?.putSymlink(putSymlinkRequest))

        let getACLRequest = GetObjectAclRequest(bucket: bucketName, key: objectSymlinkKey)
        let getACLResult = try await client?.getObjectAcl(getACLRequest)
        XCTAssertEqual(getACLResult?.accessControlPolicy?.accessControlList?.grant, putSymlinkRequest.objectAcl)

        let getRequest = GetObjectRequest(bucket: bucketName,
                                          key: objectSymlinkKey)
        let getResult = try await client?.getObject(getRequest)
        XCTAssertEqual(getResult?.statusCode, 200)
        switch getResult?.body {
        case let .data(data):
            XCTAssertEqual(content, data)
        default:
            XCTFail("getResult?.body is not data")
        }
    }

    func testPutSymlinkWithForbidOverwrite() async throws {
        let objectKey = "testPutSymlinkWithForbidOverwrite"
        let objectSymlinkKey = "testPutSymlinkWithForbidOverwriteKey"
        let content = "hello oss".data(using: .utf8)!
        let contentSymlink = "hello Symlink".data(using: .utf8)!

        var putObject = PutObjectRequest(bucket: bucketName,
                                         key: objectKey,
                                         body: .data(content))
        try await assertNoThrow(await client?.putObject(putObject))

        putObject = PutObjectRequest(bucket: bucketName,
                                     key: objectSymlinkKey,
                                     body: .data(contentSymlink))
        try await assertNoThrow(await client?.putObject(putObject))

        var putSymlinkRequest = PutSymlinkRequest(bucket: bucketName,
                                                  key: objectSymlinkKey,
                                                  symlinkTarget: objectKey)
        putSymlinkRequest.forbidOverwrite = true
        try await assertThrowsAsyncError(await client?.putSymlink(putSymlinkRequest)) { error in
            let serverError = error as! ServerError
            XCTAssertEqual(serverError.statusCode, 409)
        }

        var getRequest = GetObjectRequest(bucket: bucketName,
                                          key: objectSymlinkKey)
        var getResult = try await client?.getObject(getRequest)
        XCTAssertEqual(getResult?.statusCode, 200)
        switch getResult?.body {
        case let .data(data):
            XCTAssertEqual(contentSymlink, data)
        default:
            XCTFail("getResult?.body is not data")
        }

        putSymlinkRequest = PutSymlinkRequest(bucket: bucketName,
                                              key: objectSymlinkKey,
                                              symlinkTarget: objectKey)
        try await assertNoThrow(await client?.putSymlink(putSymlinkRequest))

        getRequest = GetObjectRequest(bucket: bucketName,
                                      key: objectSymlinkKey)
        getResult = try await client?.getObject(getRequest)
        XCTAssertEqual(getResult?.statusCode, 200)
        switch getResult?.body {
        case let .data(data):
            XCTAssertEqual(content, data)
        default:
            XCTFail("getResult?.body is not data")
        }
    }

    func testGetSymlink() async throws {
        let objectKey = "testGetSymlink"
        let objectSymlinkKey = "testGetSymlinkKey"

        let putObject = PutObjectRequest(bucket: bucketName,
                                         key: objectKey)
        try await assertNoThrow(await client?.putObject(putObject))

        let putSymlinkRequest = PutSymlinkRequest(bucket: bucketName,
                                                  key: objectSymlinkKey,
                                                  symlinkTarget: objectKey)
        try await assertNoThrow(await client?.putSymlink(putSymlinkRequest))

        let GetSymlinkRequest = GetSymlinkRequest(bucket: bucketName, key: objectSymlinkKey)
        let GetSymlinkResult = try await client?.getSymlink(GetSymlinkRequest)
        XCTAssertEqual(GetSymlinkResult?.statusCode, 200)
        XCTAssertEqual(GetSymlinkResult?.symlinkTarget, objectKey)
    }
}
