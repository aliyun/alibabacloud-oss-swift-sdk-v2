import AlibabaCloudOSS
import AlibabaCloudOSSExtension
import XCTest

final class ClientBucketPolicyTests: BaseTestCase {
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
    
    // MARK: - PutBucketCors
    
    func testPutAndGetBucketPolicySuccess() async throws {
        let policy: [String : Any] = ["Version": "1",
                                      "Statement": [["Action": ["oss:PutObject",
                                                                "oss:GetObject"],
                                                     "Effect": "Deny",
                                                     "Principal": ["1234567890"],
                                                     "Resource": ["acs:oss:*:1234567890:*/*"]]
                                                   ]]
        let json = try JSONSerialization.data(withJSONObject: policy)
        
        await assertNoThrow(try await client?.putBucketPolicy(
            PutBucketPolicyRequest(
                bucket: bucketName,
                body: .data(json)
            )
        ))
        
        let result = try await client?.getBucketPolicy(
            GetBucketPolicyRequest(bucket: bucketName)
        )
        XCTAssertNotNil(result?.body)
        
        let getPolicy = try JSONSerialization.jsonObject(with: result!.body!.readData()!) as? [String: Any]
        XCTAssertEqual(getPolicy?["Version"] as? String, policy["Version"] as? String)
        XCTAssertEqual((getPolicy?["Statement"] as? [[String: Any]])?.first?["Action"] as? [String], (policy["Statement"] as? [[String: Any]])?.first?["Action"] as? [String])
        XCTAssertEqual((getPolicy?["Statement"] as? [[String: Any]])?.first?["Effect"] as? String, (policy["Statement"] as? [[String: Any]])?.first?["Effect"] as? String)
        XCTAssertEqual((getPolicy?["Statement"] as? [[String: Any]])?.first?["Principal"] as? [String], (policy["Statement"] as? [[String: Any]])?.first?["Principal"] as? [String])
        XCTAssertEqual((getPolicy?["Statement"] as? [[String: Any]])?.first?["Resource"] as? [String], (policy["Statement"] as? [[String: Any]])?.first?["Resource"] as? [String])
    }
    
    func testPutBucketPolicyFail() async throws {
        var request = PutBucketPolicyRequest()
        try await assertThrowsAsyncError(await client?.putBucketPolicy(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = PutBucketPolicyRequest(bucket: bucketName)
        try await assertThrowsAsyncError(await client?.putBucketPolicy(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.body.")
        }
        
        request = PutBucketPolicyRequest(bucket: bucketName, body: .data(Data()))
        try await assertThrowsAsyncError(await client?.putBucketPolicy(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 400)
            XCTAssertEqual(serverError?.code, "InvalidPolicyDocument")
        }
    }
    
    func testGetBucketPolicyFail() async throws {
        var request = GetBucketPolicyRequest()
        try await assertThrowsAsyncError(await client?.getBucketPolicy(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = GetBucketPolicyRequest(bucket: bucketName)
        try await assertThrowsAsyncError(await client?.getBucketPolicy(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
    
    func testGetBucketPolicyStatusSuccess() async throws {
        let policy: [String : Any] = ["Version": "1",
                                      "Statement": [["Action": ["oss:PutObject",
                                                                "oss:GetObject"],
                                                     "Effect": "Allow",
                                                     "Principal": ["*"],
                                                     "Resource": ["acs:oss:*:1234567890:*/*"]]
                                                   ]]
        let json = try JSONSerialization.data(withJSONObject: policy)
        await assertNoThrow(try await client?.putBucketPolicy(
            PutBucketPolicyRequest(
                bucket: bucketName,
                body: .data(json)
            )
        ))
        
        let result = try await client?.getBucketPolicyStatus(
            GetBucketPolicyStatusRequest(bucket: bucketName)
        )
        XCTAssertEqual(result?.policyStatus?.isPublic, true)
    }
    
    func testGetBucketPolicyStatusFail() async throws {
        var request = GetBucketPolicyStatusRequest()
        try await assertThrowsAsyncError(await client?.getBucketPolicyStatus(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = GetBucketPolicyStatusRequest(bucket: randomBucketName())
        try await assertThrowsAsyncError(await client?.getBucketPolicyStatus(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
    
    func testDeleteBucketPolicySuccess() async throws {
        let policy: [String : Any] = ["Version": "1",
                                      "Statement": [["Action": ["oss:PutObject",
                                                                "oss:GetObject"],
                                                     "Effect": "Deny",
                                                     "Principal": ["1234567890"],
                                                     "Resource": ["acs:oss:*:1234567890:*/*"]]
                                                   ]]
        let json = try JSONSerialization.data(withJSONObject: policy)
        await assertNoThrow(try await client?.putBucketPolicy(
            PutBucketPolicyRequest(
                bucket: bucketName,
                body: .data(json)
            )
        ))
        
        let result = try await client?.getBucketPolicy(
            GetBucketPolicyRequest(bucket: bucketName)
        )
        XCTAssertNotNil(result?.body)
        
        await assertNoThrow(try await client?.deleteBucketPolicy(
            DeleteBucketPolicyRequest(bucket: bucketName)
        ))
        
        await assertThrowsAsyncError(try await client?.getBucketPolicy(
            GetBucketPolicyRequest(bucket: bucketName)
        )) {
            let error = $0 as? ServerError
            XCTAssertEqual(error?.statusCode, 404)
        }
    }

    func testDeleteBucketPolicyFail() async throws {
        var request = DeleteBucketPolicyRequest()
        try await assertThrowsAsyncError(await client?.deleteBucketPolicy(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = DeleteBucketPolicyRequest(bucket: randomBucketName())
        try await assertThrowsAsyncError(await client?.deleteBucketPolicy(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
}
