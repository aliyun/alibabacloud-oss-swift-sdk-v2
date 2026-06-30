import AlibabaCloudOSS
import XCTest

final class ClientBucketBasicTests: BaseTestCase {
    override func setUp() async throws {
        try await super.setUp()
    }

    override func tearDown() async throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try await super.tearDown()
    }

    // MARK: - test PutBucket

    func testPutBucketSuccess() async throws {
        // default
        let client = getDefaultClient()
        var bucket = randomBucketName()

        var request = PutBucketRequest(bucket: bucket)
        var result = try await client.putBucket(request)
        XCTAssertEqual(result.statusCode, 200)

        try await cleanBucket(client: client, bucket: bucket)

        // config
        bucket = randomBucketName()
        request = PutBucketRequest(bucket: bucket)
        request.acl = "public-read-write"
        request.createBucketConfiguration = CreateBucketConfiguration(storageClass: "Archive",
                                                                      dataRedundancyType: "ZRS")
        result = try await client.putBucket(request)
        XCTAssertEqual(result.statusCode, 200)

        let getbucketInfoRequest = GetBucketInfoRequest(bucket: bucket)
        let getbucketInfoResult = try await client.getBucketInfo(getbucketInfoRequest)
        XCTAssertEqual(getbucketInfoResult.bucketInfo?.bucket?.storageClass, request.createBucketConfiguration?.storageClass)
        XCTAssertEqual(getbucketInfoResult.bucketInfo?.bucket?.dataRedundancyType, request.createBucketConfiguration?.dataRedundancyType)
        XCTAssertEqual(getbucketInfoResult.bucketInfo?.bucket?.accessControlList?.grant, request.acl)

        try await cleanBucket(client: client, bucket: bucket)
    }

    func testPutBucketFail() async throws {
        // default
        let client = getDefaultClient()
        let bucket = randomBucketName()

        // bucket is nil
        try await assertThrowsAsyncError(await client.putBucket(PutBucketRequest())) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Missing required field, request.bucket.", clientError?.message)
        }

        // invalid bucket name
        try await assertThrowsAsyncError(await client.putBucket(PutBucketRequest(bucket: "!@#$"))) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Bucket name is invalid, got !@#$.", clientError?.message)
        }

        // invalid argument
        var request = PutBucketRequest(bucket: bucket)
        request.createBucketConfiguration = CreateBucketConfiguration(storageClass: "storageClass")
        try await assertThrowsAsyncError(await client.putBucket(request)) {
            let serverError = $0 as! ServerError
            XCTAssertEqual(serverError.statusCode, 400)
            XCTAssertEqual(serverError.code, "InvalidArgument")
            XCTAssertEqual(serverError.message, "No such bucket storage class exists.")
            XCTAssertEqual(serverError.ec, "0013-00000101")
            XCTAssertNotNil(serverError.requestId)
        }

        try await createBucket(client: client, bucket: bucket)
    }

    // MARK: - test DeleteBucket

    func testDeleteBucketSuccess() async throws {
        // default
        let client = getDefaultClient()
        let bucket = randomBucketName()

        try await createBucket(client: client, bucket: bucket)

        let deleteReuqest = DeleteBucketRequest(bucket: bucket)
        try await assertNoThrow(await client.deleteBucket(deleteReuqest))
    }

    func testDeleteBucketFail() async throws {
        // default
        let client = getDefaultClient()

        // bucket is nil
        try await assertThrowsAsyncError(await client.deleteBucket(DeleteBucketRequest())) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Missing required field, request.bucket.", clientError?.message)
        }

        // invalid bucket name
        try await assertThrowsAsyncError(await client.deleteBucket(DeleteBucketRequest(bucket: "!@#$"))) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Bucket name is invalid, got !@#$.", clientError?.message)
        }

        // bucket is no-exist
        let deleteReuqest = DeleteBucketRequest(bucket: "no-exist")
        try await assertThrowsAsyncError(await client.deleteBucket(deleteReuqest)) { error in
            let serverError = error as! ServerError
            XCTAssertEqual(serverError.statusCode, 404)
            XCTAssertEqual(serverError.code, "NoSuchBucket")
            XCTAssertEqual(serverError.message, "The specified bucket does not exist.")
            XCTAssertEqual(serverError.ec, "0015-00000101")
            XCTAssertNotNil(serverError.requestId)
        }
    }

    // MARK: - test GetBucketInfo

    func testGetBucketInfoSuccess() async throws {
        // default
        let client = getDefaultClient()
        var bucket = randomBucketName()

        bucket = randomBucketName()
        var request = PutBucketRequest(bucket: bucket)
        request.acl = "public-read-write"
        request.createBucketConfiguration = CreateBucketConfiguration(storageClass: "Archive",
                                                                      dataRedundancyType: "ZRS")
        let result = try await client.putBucket(request)
        XCTAssertEqual(result.statusCode, 200)

        let getbucketInfoRequest = GetBucketInfoRequest(bucket: bucket)
        let getbucketInfoResult = try await client.getBucketInfo(getbucketInfoRequest)
        XCTAssertEqual(getbucketInfoResult.bucketInfo?.bucket?.storageClass, request.createBucketConfiguration?.storageClass)
        XCTAssertEqual(getbucketInfoResult.bucketInfo?.bucket?.dataRedundancyType, request.createBucketConfiguration?.dataRedundancyType)
        XCTAssertEqual(getbucketInfoResult.bucketInfo?.bucket?.accessControlList?.grant, request.acl)
        XCTAssertEqual(getbucketInfoResult.bucketInfo?.bucket?.name, bucket)
        XCTAssertEqual(getbucketInfoResult.bucketInfo?.bucket?.accessMonitor, "Disabled")
        XCTAssertEqual(getbucketInfoResult.bucketInfo?.bucket?.blockPublicAccess, true)
        XCTAssertNotNil(getbucketInfoResult.bucketInfo?.bucket?.creationDate)
        XCTAssertEqual(getbucketInfoResult.bucketInfo?.bucket?.crossRegionReplication, "Disabled")
        XCTAssertNil(getbucketInfoResult.bucketInfo?.bucket?.comment)
        XCTAssertTrue(getbucketInfoResult.bucketInfo!.bucket!.extranetEndpoint!.hasSuffix(".aliyuncs.com"))
        XCTAssertTrue(getbucketInfoResult.bucketInfo!.bucket!.intranetEndpoint!.hasSuffix(".aliyuncs.com"))
        XCTAssertTrue(getbucketInfoResult.bucketInfo!.bucket!.location!.hasPrefix("oss-"))
        XCTAssertNotNil(getbucketInfoResult.bucketInfo?.bucket?.resourceGroupId, bucket)
        XCTAssertEqual(getbucketInfoResult.bucketInfo?.bucket?.transferAcceleration, "Disabled")
        XCTAssertNil(getbucketInfoResult.bucketInfo?.bucket?.versioning)
        XCTAssertNil(getbucketInfoResult.bucketInfo?.bucket?.serverSideEncryptionRule?.kMSDataEncryption)
        XCTAssertNil(getbucketInfoResult.bucketInfo?.bucket?.serverSideEncryptionRule?.kMSMasterKeyID)
        XCTAssertEqual(getbucketInfoResult.bucketInfo?.bucket?.serverSideEncryptionRule?.sSEAlgorithm, "None")
        XCTAssertNil(getbucketInfoResult.bucketInfo?.bucket?.bucketPolicy?.logBucket, bucket)
        XCTAssertNil(getbucketInfoResult.bucketInfo?.bucket?.bucketPolicy?.logPrefix, bucket)
        XCTAssertNotNil(getbucketInfoResult.bucketInfo?.bucket?.owner?.displayName, bucket)
        XCTAssertNotNil(getbucketInfoResult.bucketInfo?.bucket?.owner?.id, bucket)

        try await cleanBucket(client: client, bucket: bucket)
    }

    func testGetBucketInfoFail() async throws {
        // default
        let client = getDefaultClient()

        // bucket is nil
        try await assertThrowsAsyncError(await client.getBucketInfo(GetBucketInfoRequest())) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Missing required field, request.bucket.", clientError?.message)
        }

        // invalid bucket name
        try await assertThrowsAsyncError(await client.getBucketInfo(GetBucketInfoRequest(bucket: "!@#$"))) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Bucket name is invalid, got !@#$.", clientError?.message)
        }

        // bucket is no-exist
        let request = GetBucketInfoRequest(bucket: "no-exist")
        try await assertThrowsAsyncError(await client.getBucketInfo(request)) { error in
            let serverError = error as! ServerError
            XCTAssertEqual(serverError.statusCode, 404)
            XCTAssertEqual(serverError.code, "NoSuchBucket")
            XCTAssertEqual(serverError.message, "The specified bucket does not exist.")
            XCTAssertEqual(serverError.ec, "0015-00000101")
            XCTAssertNotNil(serverError.requestId)
        }
    }

    // MARK: - test ListObjectV2

    func testListObjectsV2Success() async throws {
        // default
        let client = getDefaultClient()
        let bucket = randomBucketName()
        let content = "hello oss".data(using: .utf8)!
        let objectPrefixKey = "testListObjects"
        var objectKeys: [String] = []

        try await createBucket(client: client, bucket: bucket)

        // one object
        var request = ListObjectsV2Request(bucket: bucket)
        var result = try await client.listObjectsV2(request)
        XCTAssertEqual(result.statusCode, 200)
        XCTAssertNil(result.contents)

        var putRequest = PutObjectRequest(bucket: bucket,
                                          key: objectPrefixKey + "/a",
                                          body: .data(content))
        putRequest.storageClass = "Archive"
        try await assertNoThrow(await client.putObject(putRequest))

        let restoreObjectRequest = RestoreObjectRequest(bucket: bucket,
                                                        key: objectPrefixKey + "/a")
        try await assertNoThrow(await client.restoreObject(restoreObjectRequest))

        request = ListObjectsV2Request(bucket: bucket)
        request.encodingType = "url"
        result = try await client.listObjectsV2(request)
        XCTAssertEqual(result.statusCode, 200)
        XCTAssertFalse(result.isTruncated!)
        XCTAssertEqual(result.keyCount, 1)
        XCTAssertEqual(result.maxKeys, 100)
        XCTAssertNil(result.delimiter)
        XCTAssertNil(result.continuationToken)
        XCTAssertEqual(result.encodingType, "url")
        XCTAssertNil(result.nextContinuationToken)
        XCTAssertNil(result.startAfter)
        XCTAssertNil(result.prefix)
        XCTAssertEqual(result.name, bucket)
        XCTAssertNil(result.commonPrefixes)
        XCTAssertEqual(result.contents?.count, 1)
        for objectContent in result.contents! {
            XCTAssertEqual(objectContent.key, putRequest.key)
            XCTAssertNotNil(objectContent.lastModified)
            XCTAssertNotNil(objectContent.etag)
            XCTAssertNotNil(objectContent.size)
            XCTAssertNotNil(objectContent.storageClass)
            XCTAssertNil(objectContent.owner?.displayName)
            XCTAssertNil(objectContent.owner?.id)
            XCTAssertNil(objectContent.transitionTime)
            XCTAssertNotNil(objectContent.restoreInfo)
        }

        // multipart list & set prefix/maxKeys/fetchOwner
        for i in 0 ..< 20 {
            let objectKey = objectPrefixKey + "-\(i)"
            let putRequest = PutObjectRequest(bucket: bucket,
                                              key: objectKey,
                                              body: .data(content))
            let _ = try await client.putObject(putRequest)
            objectKeys.append(objectKey)
        }

        var token: String? = nil
        var isTruncated = true
        var listObjectKeys: [String] = []
        repeat {
            request = ListObjectsV2Request(bucket: bucket)
            request.prefix = objectPrefixKey + "-"
            request.maxKeys = 10
            request.fetchOwner = true
            request.continuationToken = token
            request.encodingType = "url"
            result = try await client.listObjectsV2(request)
            XCTAssertEqual(result.statusCode, 200)
            XCTAssertTrue(20 - listObjectKeys.count > 10 ? result.isTruncated! : result.isTruncated! == false)
            XCTAssertEqual(result.keyCount, 21 - listObjectKeys.count > 10 ? 10 : 1)
            XCTAssertEqual(result.maxKeys, request.maxKeys)
            XCTAssertNil(result.delimiter)
            XCTAssertEqual(result.continuationToken, request.continuationToken)
            XCTAssertEqual(result.encodingType, "url")
            XCTAssertTrue((20 - listObjectKeys.count > 10) ? result.nextContinuationToken != nil : result.nextContinuationToken == nil)
            XCTAssertNil(result.startAfter)
            XCTAssertEqual(result.prefix, request.prefix)
            XCTAssertEqual(result.name, bucket)
            XCTAssertNil(result.commonPrefixes)
            XCTAssertEqual(result.contents?.count, 21 - listObjectKeys.count > 10 ? 10 : 1)
            for objectContent in result.contents! {
                listObjectKeys.append(objectContent.key!)
                XCTAssertNotNil(objectContent.lastModified)
                XCTAssertNotNil(objectContent.etag)
                XCTAssertNotNil(objectContent.size)
                XCTAssertNotNil(objectContent.storageClass)
                XCTAssertNotNil(objectContent.owner?.displayName)
                XCTAssertNotNil(objectContent.owner?.id)
                XCTAssertNil(objectContent.transitionTime)
            }
            isTruncated = result.isTruncated!
            token = result.nextContinuationToken
        } while isTruncated

        for objectKey in objectKeys {
            XCTAssertTrue(listObjectKeys.contains(objectKey))
        }

        // test startAfter
        let startAfter = objectPrefixKey + "-2"

        request = ListObjectsV2Request(bucket: bucket)
        request.startAfter = startAfter
        result = try await client.listObjectsV2(request)
        XCTAssertEqual(result.startAfter, request.startAfter)
        listObjectKeys = []
        for objectContent in result.contents! {
            listObjectKeys.append(objectContent.key!)
        }

        for objectKey in objectKeys {
            if objectKey > startAfter {
                XCTAssertTrue(listObjectKeys.contains(objectKey))
            } else {
                XCTAssertFalse(listObjectKeys.contains(objectKey))
            }
        }

        // test delimiter
        var delimiter = "1"

        request = ListObjectsV2Request(bucket: bucket)
        request.delimiter = delimiter
        result = try await client.listObjectsV2(request)
        XCTAssertEqual(result.delimiter, delimiter)
        XCTAssertEqual(result.commonPrefixes?.count, 1)
        XCTAssertEqual(result.commonPrefixes?.first?.prefix, objectPrefixKey + "-1")
        listObjectKeys = []
        for objectContent in result.contents! {
            listObjectKeys.append(objectContent.key!)
        }

        for objectKey in objectKeys {
            if objectKey.hasPrefix("testListObjects-1") {
                XCTAssertFalse(listObjectKeys.contains(objectKey))
            } else {
                XCTAssertTrue(listObjectKeys.contains(objectKey))
            }
        }

        delimiter = "2"
        request = ListObjectsV2Request(bucket: bucket)
        request.delimiter = delimiter
        result = try await client.listObjectsV2(request)
        XCTAssertEqual(result.delimiter, delimiter)
        XCTAssertEqual(result.commonPrefixes?.count, 2)
        for commonPrefix in result.commonPrefixes! {
            XCTAssertTrue(["testListObjects-2", "testListObjects-12"].contains(commonPrefix.prefix))
        }
        listObjectKeys = []
        for objectContent in result.contents! {
            listObjectKeys.append(objectContent.key!)
        }

        for objectKey in objectKeys {
            if objectKey.hasPrefix("testListObjects-12") ||
                objectKey.hasPrefix("testListObjects-2")
            {
                XCTAssertFalse(listObjectKeys.contains(objectKey))
            } else {
                XCTAssertTrue(listObjectKeys.contains(objectKey))
            }
        }

        try await cleanBucket(client: client, bucket: bucket)
    }

    func testListObjectV2Fail() async throws {
        // default
        let client = getDefaultClient()

        // bucket is nil
        try await assertThrowsAsyncError(await client.listObjectsV2(ListObjectsV2Request())) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Missing required field, request.bucket.", clientError?.message)
        }

        // invalid bucket name
        try await assertThrowsAsyncError(await client.listObjectsV2(ListObjectsV2Request(bucket: "!@#$"))) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Bucket name is invalid, got !@#$.", clientError?.message)
        }

        // bucket is no-exist
        let request = ListObjectsV2Request(bucket: "no-exist")
        try await assertThrowsAsyncError(await client.listObjectsV2(request)) { error in
            let serverError = error as! ServerError
            XCTAssertEqual(serverError.statusCode, 404)
            XCTAssertEqual(serverError.code, "NoSuchBucket")
            XCTAssertEqual(serverError.message, "The specified bucket does not exist.")
            XCTAssertEqual(serverError.ec, "0015-00000101")
            XCTAssertNotNil(serverError.requestId)
        }
    }

    // MARK: - ListObject

    func testListObjectSuccess() async throws {
        // default
        let client = getDefaultClient()
        let bucket = randomBucketName()
        let content = "hello oss".data(using: .utf8)!
        let objectPrefixKey = "testListObjects"
        var objectKeys: [String] = []

        try await createBucket(client: client, bucket: bucket)

        // one object
        var request = ListObjectsRequest(bucket: bucket)
        var result = try await client.listObjects(request)
        XCTAssertEqual(result.statusCode, 200)
        XCTAssertNil(result.contents)

        var putRequest = PutObjectRequest(bucket: bucket,
                                          key: objectPrefixKey + "/a",
                                          body: .data(content))
        putRequest.storageClass = "Archive"
        try await assertNoThrow(await client.putObject(putRequest))

        let restoreObjectRequest = RestoreObjectRequest(bucket: bucket,
                                                        key: objectPrefixKey + "/a")
        try await assertNoThrow(await client.restoreObject(restoreObjectRequest))

        request = ListObjectsRequest(bucket: bucket)
        request.encodingType = "url"
        result = try await client.listObjects(request)
        XCTAssertEqual(result.statusCode, 200)
        XCTAssertFalse(result.isTruncated!)
        XCTAssertEqual(result.maxKeys, 100)
        XCTAssertNil(result.delimiter)
        XCTAssertNil(result.marker)
        XCTAssertEqual(result.encodingType, "url")
        XCTAssertNil(result.nextMarker)
        XCTAssertNil(result.prefix)
        XCTAssertEqual(result.name, bucket)
        XCTAssertNil(result.commonPrefixes)
        XCTAssertEqual(result.contents?.count, 1)
        for objectContent in result.contents! {
            XCTAssertEqual(objectContent.key, putRequest.key)
            XCTAssertNotNil(objectContent.lastModified)
            XCTAssertNotNil(objectContent.etag)
            XCTAssertEqual(objectContent.size, content.count)
            XCTAssertEqual(objectContent.storageClass, putRequest.storageClass)
            XCTAssertNotNil(objectContent.owner?.displayName)
            XCTAssertNotNil(objectContent.owner?.id)
            XCTAssertNotNil(objectContent.restoreInfo)
        }

        // multipart list & set prefix/maxKeys/fetchOwner
        for i in 0 ..< 20 {
            let objectKey = objectPrefixKey + "-\(i)"
            let putRequest = PutObjectRequest(bucket: bucket,
                                              key: objectKey,
                                              body: .data(content))
            try await assertNoThrow(await client.putObject(putRequest))
            objectKeys.append(objectKey)
        }

        var marker: String? = nil
        var isTruncated = true
        var listObjectKeys: [String] = []
        repeat {
            request = ListObjectsRequest(bucket: bucket)
            request.prefix = objectPrefixKey + "-"
            request.maxKeys = 10
            request.marker = marker
            request.encodingType = "url"
            result = try await client.listObjects(request)
            XCTAssertEqual(result.statusCode, 200)
            XCTAssertTrue(20 - listObjectKeys.count > 10 ? result.isTruncated! : result.isTruncated! == false)
            XCTAssertEqual(result.maxKeys, request.maxKeys)
            XCTAssertNil(result.delimiter)
            XCTAssertEqual(result.marker, request.marker)
            XCTAssertEqual(result.encodingType, "url")
            XCTAssertTrue((20 - listObjectKeys.count > 10) ? result.nextMarker != nil : result.nextMarker == nil)
            XCTAssertEqual(result.prefix, request.prefix)
            XCTAssertEqual(result.name, bucket)
            XCTAssertNil(result.commonPrefixes)
            XCTAssertEqual(result.contents?.count, 21 - listObjectKeys.count > 10 ? 10 : 1)
            for objectContent in result.contents! {
                listObjectKeys.append(objectContent.key!)
                XCTAssertNotNil(objectContent.lastModified)
                XCTAssertNotNil(objectContent.etag)
                XCTAssertNotNil(objectContent.size)
                XCTAssertNotNil(objectContent.storageClass)
                XCTAssertNotNil(objectContent.owner?.displayName)
                XCTAssertNotNil(objectContent.owner?.id)
            }
            isTruncated = result.isTruncated!
            marker = result.nextMarker
        } while isTruncated

        for objectKey in objectKeys {
            XCTAssertTrue(listObjectKeys.contains(objectKey))
        }

        // test delimiter
        var delimiter = "1"

        request = ListObjectsRequest(bucket: bucket)
        request.delimiter = delimiter
        result = try await client.listObjects(request)
        XCTAssertEqual(result.delimiter, delimiter)
        XCTAssertEqual(result.commonPrefixes?.count, 1)
        XCTAssertEqual(result.commonPrefixes?.first?.prefix, objectPrefixKey + "-1")
        listObjectKeys = []
        for objectContent in result.contents! {
            listObjectKeys.append(objectContent.key!)
        }

        for objectKey in objectKeys {
            if objectKey.hasPrefix("testListObjects-1") {
                XCTAssertFalse(listObjectKeys.contains(objectKey))
            } else {
                XCTAssertTrue(listObjectKeys.contains(objectKey))
            }
        }

        delimiter = "2"
        request = ListObjectsRequest(bucket: bucket)
        request.delimiter = delimiter
        result = try await client.listObjects(request)
        XCTAssertEqual(result.delimiter, delimiter)
        XCTAssertEqual(result.commonPrefixes?.count, 2)
        for commonPrefix in result.commonPrefixes! {
            XCTAssertTrue(["testListObjects-2", "testListObjects-12"].contains(commonPrefix.prefix))
        }
        listObjectKeys = []
        for objectContent in result.contents! {
            listObjectKeys.append(objectContent.key!)
        }

        for objectKey in objectKeys {
            if objectKey.hasPrefix("testListObjects-12") ||
                objectKey.hasPrefix("testListObjects-2")
            {
                XCTAssertFalse(listObjectKeys.contains(objectKey))
            } else {
                XCTAssertTrue(listObjectKeys.contains(objectKey))
            }
        }

        try await cleanBucket(client: client, bucket: bucket)
    }

    func testListObjectFail() async throws {
        // default
        let client = getDefaultClient()

        // bucket is nil
        try await assertThrowsAsyncError(await client.listObjects(ListObjectsRequest())) {
            switch $0 {
            case let cerr as ClientError:
                XCTAssertEqual("Missing required field, request.bucket.", cerr.message)
            default:
                XCTFail()
            }
        }

        // invalid bucket name
        try await assertThrowsAsyncError(await client.listObjects(ListObjectsRequest(bucket: "!@#$"))) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Bucket name is invalid, got !@#$.", clientError?.message)
        }

        // bucket is no-exist
        let request = ListObjectsRequest(bucket: "no-exist")
        try await assertThrowsAsyncError(await client.listObjects(request)) { error in
            let serverError = error as! ServerError
            XCTAssertEqual(serverError.statusCode, 404)
            XCTAssertEqual(serverError.code, "NoSuchBucket")
            XCTAssertEqual(serverError.message, "The specified bucket does not exist.")
            XCTAssertEqual(serverError.ec, "0015-00000101")
            XCTAssertNotNil(serverError.requestId)
        }
    }

    // MARK: - test GetBucketLocation

    func testGetBucketLocationSuccess() async throws {
        let client = getDefaultClient()
        let bucket = randomBucketName()

        let putBucketRequest = PutBucketRequest(bucket: bucket)
        try await assertNoThrow(await client.putBucket(putBucketRequest))

        let request = GetBucketLocationRequest(bucket: bucket)
        let result = try await client.getBucketLocation(request)
        XCTAssertEqual("oss-\(region)", result.locationConstraint)
    }

    func testGetBucketLocationFail() async throws {
        // default
        let client = getDefaultClient()

        // bucket is nil
        try await assertThrowsAsyncError(await client.getBucketLocation(GetBucketLocationRequest())) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Missing required field, request.bucket.", clientError?.message)
        }

        // invalid bucket name
        try await assertThrowsAsyncError(await client.getBucketLocation(GetBucketLocationRequest(bucket: "!@#$"))) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Bucket name is invalid, got !@#$.", clientError?.message)
        }

        // bucket is no-exist
        let request = GetBucketLocationRequest(bucket: "no-exist")
        try await assertThrowsAsyncError(await client.getBucketLocation(request)) { error in
            let serverError = error as! ServerError
            XCTAssertEqual(serverError.statusCode, 404)
            XCTAssertEqual(serverError.code, "NoSuchBucket")
            XCTAssertEqual(serverError.message, "The specified bucket does not exist.")
            XCTAssertEqual(serverError.ec, "0015-00000101")
            XCTAssertNotNil(serverError.requestId)
        }
    }

    // MARK: - test GetBucketStat

    func testGetBucketStatSuccess() async throws {
        // default
        let actor = ValueActor(value: getDefaultClient())
        let bucket = randomBucketName()
        let objectKeyPrefix = "objectkey-"
        let content = "hello oss".data(using: .utf8)!
        let fileCount = 10

        let putBucketRequest = PutBucketRequest(bucket: bucket)
        try await assertNoThrow(await actor.getValue().putBucket(putBucketRequest))

        let objectKeys = ArrayActor<String>()
        await withThrowingTaskGroup(of: Void.self) {
            for i in 0 ..< fileCount {
                $0.addTask {
                    let objectKey = "\(objectKeyPrefix)\(i)"
                    let putObjectRequest = PutObjectRequest(bucket: bucket,
                                                            key: objectKey,
                                                            body: .data(content))
                    try await assertNoThrow(await actor.getValue().putObject(putObjectRequest))
                    await objectKeys.append(objectKey)
                }
            }
        }

        let request = GetBucketStatRequest(bucket: bucket)
        let result = try await actor.getValue().getBucketStat(request)
        XCTAssertEqual(result.bucketStat?.objectCount, fileCount)
        XCTAssertNotNil(result.bucketStat?.storage)
        XCTAssertNotNil(result.bucketStat?.archiveObjectCount)
        XCTAssertNotNil(result.bucketStat?.archiveRealStorage)
        XCTAssertNotNil(result.bucketStat?.archiveStorage)
        XCTAssertNotNil(result.bucketStat?.coldArchiveObjectCount)
        XCTAssertNotNil(result.bucketStat?.coldArchiveRealStorage)
        XCTAssertNotNil(result.bucketStat?.coldArchiveStorage)
        XCTAssertNotNil(result.bucketStat?.deepColdArchiveObjectCount)
        XCTAssertNotNil(result.bucketStat?.deepColdArchiveRealStorage)
        XCTAssertNotNil(result.bucketStat?.deepColdArchiveStorage)
        XCTAssertNotNil(result.bucketStat?.deleteMarkerCount)
        XCTAssertNotNil(result.bucketStat?.infrequentAccessStorage)
        XCTAssertNotNil(result.bucketStat?.infrequentAccessObjectCount)
        XCTAssertNotNil(result.bucketStat?.infrequentAccessRealStorage)
        XCTAssertNotNil(result.bucketStat?.liveChannelCount)
        XCTAssertNotNil(result.bucketStat?.multipartUploadCount)
        XCTAssertNotNil(result.bucketStat?.standardObjectCount)
        XCTAssertNotNil(result.bucketStat?.standardStorage)
        XCTAssertNotNil(result.bucketStat?.multipartPartCount)

        try await cleanBucket(client: actor.getValue(), bucket: bucket)
    }

    func testGetBucketStatFail() async throws {
        // default
        let client = getDefaultClient()

        // bucket is nil
        try await assertThrowsAsyncError(await client.getBucketStat(GetBucketStatRequest())) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Missing required field, request.bucket.", clientError?.message)
        }

        // invalid bucket name
        try await assertThrowsAsyncError(await client.getBucketStat(GetBucketStatRequest(bucket: "!@#$"))) {
            let clientError = $0 as? ClientError
            XCTAssertEqual("Bucket name is invalid, got !@#$.", clientError?.message)
        }

        // bucket is no-exist
        let request = GetBucketStatRequest(bucket: "no-exist")
        try await assertThrowsAsyncError(await client.getBucketStat(request)) { error in
            let serverError = error as! ServerError
            XCTAssertEqual(serverError.statusCode, 404)
            XCTAssertEqual(serverError.code, "NoSuchBucket")
            XCTAssertEqual(serverError.message, "The specified bucket does not exist.")
            XCTAssertEqual(serverError.ec, "0015-00000101")
            XCTAssertNotNil(serverError.requestId)
        }
    }
}
