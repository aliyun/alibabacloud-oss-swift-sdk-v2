import AlibabaCloudOSS
import AlibabaCloudOSSExtension
import XCTest

final class ClientBucketTransferaccelerationTests: BaseTestCase {
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

    func testPutAndGetBucketTransferAccelerationSuccess() async throws {
        await assertNoThrow(try await client?.putBucketTransferAcceleration(
            PutBucketTransferAccelerationRequest(
                bucket: bucketName,
                transferAccelerationConfiguration: TransferAccelerationConfiguration(enabled: true)
            )
        ))
        
        let result = try await client?.getBucketTransferAcceleration(
            GetBucketTransferAccelerationRequest(
                bucket: bucketName
            )
        )
        XCTAssertEqual(result?.transferAccelerationConfiguration?.enabled, true)
    }

    func testPutBucketTransferAccelerationFail() async throws {
        try await assertThrowsAsyncError(await client?.putBucketTransferAcceleration(PutBucketTransferAccelerationRequest())) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }

        try await assertThrowsAsyncError(await client?.putBucketTransferAcceleration(PutBucketTransferAccelerationRequest(bucket: bucketName))) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.transferAccelerationConfiguration.")
        }

        try await assertThrowsAsyncError(await client?.putBucketTransferAcceleration(
            PutBucketTransferAccelerationRequest(
                bucket: randomBucketName(),
                transferAccelerationConfiguration: TransferAccelerationConfiguration(enabled: true)
            )
        )) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
    
    func testGetBucketTransferAccelerationFail() async throws {
        try await assertThrowsAsyncError(await client?.getBucketTransferAcceleration(GetBucketTransferAccelerationRequest())) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }

        try await assertThrowsAsyncError(await client?.getBucketTransferAcceleration(
            GetBucketTransferAccelerationRequest(
                bucket: bucketName
            )
        )) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
            XCTAssertEqual(serverError?.code, "NoSuchTransferAccelerationConfiguration")
            XCTAssertEqual(serverError?.message, "The bucket you specified does not have transfer acceleration configuration.")
        }
    }
}
