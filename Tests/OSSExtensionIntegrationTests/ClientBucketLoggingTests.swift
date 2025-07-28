import AlibabaCloudOSS
import AlibabaCloudOSSExtension
import XCTest

final class ClientBucketLoggingTests: BaseTestCase {
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
        
    func testPutAndGetBucketLoggingSuccess() async throws {
        let targetBucket = randomBucketName()
        try await createBucket(client: client!, bucket: targetBucket)
        
        try await assertNoThrow(await client?.putBucketLogging(
            PutBucketLoggingRequest(
                bucket: bucketName,
                bucketLoggingStatus: BucketLoggingStatus(loggingEnabled: LoggingEnabled(targetBucket: targetBucket, targetPrefix: "targetPrefix"))
            )
        ))
        
        let result = try await client?.getBucketLogging(
            GetBucketLoggingRequest(bucket: bucketName)
        )
        XCTAssertEqual(result?.bucketLoggingStatus?.loggingEnabled?.targetBucket, targetBucket)
        XCTAssertEqual(result?.bucketLoggingStatus?.loggingEnabled?.targetPrefix, "targetPrefix")
        
        try await cleanBucket(client: client!, bucket: targetBucket)
    }
    
    func testPutBucketLoggingFail() async throws {
        var request = PutBucketLoggingRequest()
        try await assertThrowsAsyncError(await client?.putBucketLogging(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = PutBucketLoggingRequest(bucket: bucketName)
        try await assertThrowsAsyncError(await client?.putBucketLogging(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucketLoggingStatus.")
        }
        
        request = PutBucketLoggingRequest(
            bucket: bucketName,
            bucketLoggingStatus: BucketLoggingStatus(loggingEnabled: LoggingEnabled(targetBucket: randomBucketName()))
        )
        try await assertThrowsAsyncError(await client?.putBucketLogging(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 400)
            XCTAssertEqual(serverError?.code, "InvalidTargetBucketForLogging")
        }
    }
    
    func testGetBucketLoggingFail() async throws {
        var request = GetBucketLoggingRequest()
        try await assertThrowsAsyncError(await client?.getBucketLogging(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = GetBucketLoggingRequest(bucket: randomBucketName())
        try await assertThrowsAsyncError(await client?.getBucketLogging(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
    
    func testDeleteBucketLoggingSuccess() async throws {
        let targetBucket = randomBucketName()
        try await createBucket(client: client!, bucket: targetBucket)
        
        // put logging
        try await assertNoThrow(await client?.putBucketLogging(
            PutBucketLoggingRequest(
                bucket: bucketName,
                bucketLoggingStatus: BucketLoggingStatus(loggingEnabled: LoggingEnabled(targetBucket: targetBucket, targetPrefix: "targetPrefix"))
            )
        ))
        
        // get logging
        var result = try await client?.getBucketLogging(
            GetBucketLoggingRequest(bucket: bucketName)
        )
        XCTAssertEqual(result?.bucketLoggingStatus?.loggingEnabled?.targetBucket, targetBucket)
        XCTAssertEqual(result?.bucketLoggingStatus?.loggingEnabled?.targetPrefix, "targetPrefix")
        
        // delete logging
        try await assertNoThrow(await client?.deleteBucketLogging(
            DeleteBucketLoggingRequest(bucket: bucketName)
        ))
        
        // get logging
        result = try await client?.getBucketLogging(
            GetBucketLoggingRequest(bucket: bucketName)
        )
        XCTAssertNil(result?.bucketLoggingStatus?.loggingEnabled?.targetBucket)
        XCTAssertNil(result?.bucketLoggingStatus?.loggingEnabled?.targetPrefix)
        
        try await cleanBucket(client: client!, bucket: targetBucket)
    }
    
    func testDeleteBucketLoggingFail() async throws {
        var request = DeleteBucketLoggingRequest()
        try await assertThrowsAsyncError(await client?.deleteBucketLogging(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = DeleteBucketLoggingRequest(bucket: randomBucketName())
        try await assertThrowsAsyncError(await client?.deleteBucketLogging(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
    
    func testPutAndGetUserDefinedLogFieldsConfigSuccess() async throws {
        try await assertNoThrow(await client?.putUserDefinedLogFieldsConfig(
            PutUserDefinedLogFieldsConfigRequest(
                bucket: bucketName,
                userDefinedLogFieldsConfiguration: UserDefinedLogFieldsConfiguration(
                    headerSet: HeaderSet(headers: ["header1", "header2", "header3"]),
                    paramSet: ParamSet(parameters: ["param1", "param2"])
                )
            )
        ))
        
        let result = try await client?.getUserDefinedLogFieldsConfig(
            GetUserDefinedLogFieldsConfigRequest(bucket: bucketName)
        )
        XCTAssertEqual(result?.userDefinedLogFieldsConfiguration?.headerSet?.headers, ["header1", "header2", "header3"])
        XCTAssertEqual(result?.userDefinedLogFieldsConfiguration?.paramSet?.parameters, ["param1", "param2"])
    }
    
    func testPutUserDefinedLogFieldsConfigFail() async throws {
        var request = PutUserDefinedLogFieldsConfigRequest()
        try await assertThrowsAsyncError(await client?.putUserDefinedLogFieldsConfig(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = PutUserDefinedLogFieldsConfigRequest(bucket: bucketName)
        try await assertThrowsAsyncError(await client?.putUserDefinedLogFieldsConfig(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.userDefinedLogFieldsConfiguration.")
        }
        
        request = PutUserDefinedLogFieldsConfigRequest(
            bucket: bucketName,
            userDefinedLogFieldsConfiguration: UserDefinedLogFieldsConfiguration()
        )
        try await assertThrowsAsyncError(await client?.putUserDefinedLogFieldsConfig(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 400)
            XCTAssertEqual(serverError?.code, "InvalidArgument")
        }
    }
    
    func testGetUserDefinedLogFieldsConfigFail() async throws {
        var request = GetUserDefinedLogFieldsConfigRequest()
        try await assertThrowsAsyncError(await client?.getUserDefinedLogFieldsConfig(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = GetUserDefinedLogFieldsConfigRequest(bucket: bucketName)
        try await assertThrowsAsyncError(await client?.getUserDefinedLogFieldsConfig(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
    
    func testDeleteUserDefinedLogFieldsConfigSuccess() async throws {
        // PutUserDefinedLogFieldsConfig
        try await assertNoThrow(await client?.putUserDefinedLogFieldsConfig(
            PutUserDefinedLogFieldsConfigRequest(
                bucket: bucketName,
                userDefinedLogFieldsConfiguration: UserDefinedLogFieldsConfiguration(
                    headerSet: HeaderSet(headers: ["header1", "header2", "header3"]),
                    paramSet: ParamSet(parameters: ["param1", "param2"])
                )
            )
        ))
        
        // GetUserDefinedLogFieldsConfig
        let result = try await client?.getUserDefinedLogFieldsConfig(
            GetUserDefinedLogFieldsConfigRequest(bucket: bucketName)
        )
        XCTAssertEqual(result?.userDefinedLogFieldsConfiguration?.headerSet?.headers, ["header1", "header2", "header3"])
        XCTAssertEqual(result?.userDefinedLogFieldsConfiguration?.paramSet?.parameters, ["param1", "param2"])
        
        // DeleteUserDefinedLogFieldsConfig
        try await assertNoThrow(await client?.deleteUserDefinedLogFieldsConfig(
            DeleteUserDefinedLogFieldsConfigRequest(bucket: bucketName)
        ))

        // GetUserDefinedLogFieldsConfig
        try await assertThrowsAsyncError(await client?.getUserDefinedLogFieldsConfig(
            GetUserDefinedLogFieldsConfigRequest(bucket: bucketName)
        )) {
            let error = $0 as? ServerError
            XCTAssertEqual(error?.statusCode, 404)
        }
    }
    
    func testDeleteUserDefinedLogFieldsConfigFail() async throws {
        var request = DeleteUserDefinedLogFieldsConfigRequest()
        try await assertThrowsAsyncError(await client?.deleteUserDefinedLogFieldsConfig(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = DeleteUserDefinedLogFieldsConfigRequest(bucket: randomBucketName())
        try await assertThrowsAsyncError(await client?.deleteUserDefinedLogFieldsConfig(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
}
