import AlibabaCloudOSS
import AlibabaCloudOSSExtension
import XCTest

final class ClientAccessPointTests: BaseTestCase {
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
        
    func testCreateGetAndDeleteAccessPointSuccess() async throws {
        let accessPointName = randomStr(6)
        // CreateAccessPoint
        try await assertNoThrow(await client?.createAccessPoint(CreateAccessPointRequest(
            bucket: bucketName,
            createAccessPointConfiguration: CreateAccessPointConfiguration(
                accessPointName: accessPointName,
                networkOrigin: "internet",
            )
        )))
        
        // GetAccessPoint
        var result = try await client?.getAccessPoint(
            GetAccessPointRequest(
                bucket: bucketName,
                accessPointName: accessPointName
            )
        )
        XCTAssertNotNil(result?.endpoints?.internalEndpoint)
        XCTAssertNotNil(result?.endpoints?.publicEndpoint)
        XCTAssertNotNil(result?.accessPointArn)
        XCTAssertNotNil(result?.accessPointName)
        XCTAssertNotNil(result?.accountId)
        XCTAssertNotNil(result?.alias)
        XCTAssertNotNil(result?.bucket)
        XCTAssertNotNil(result?.creationDate)
        XCTAssertEqual(result?.networkOrigin, "internet")
        XCTAssertNotNil(result?.publicAccessBlockConfiguration?.blockPublicAccess)
        
        // ListAccessPoints
        let listResult = try await client?.listAccessPoints(
            ListAccessPointsRequest(maxKeys: 1)
        )
        XCTAssertEqual(listResult?.maxKeys, 1)
        XCTAssertEqual(listResult?.isTruncated, false)
        XCTAssertNotNil(listResult?.accountId)
        XCTAssertNil(listResult?.nextContinuationToken)
        XCTAssertEqual(listResult?.accessPoints?.accessPoints?.count, 1)
        XCTAssertNotNil(listResult?.accessPoints?.accessPoints?.first?.accessPointName)
        XCTAssertNotNil(listResult?.accessPoints?.accessPoints?.first?.alias)
        XCTAssertNotNil(listResult?.accessPoints?.accessPoints?.first?.bucket)
        XCTAssertNotNil(listResult?.accessPoints?.accessPoints?.first?.networkOrigin)
        XCTAssertNotNil(listResult?.accessPoints?.accessPoints?.first?.status)

        repeat {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            result = try await client?.getAccessPoint(
                GetAccessPointRequest(
                    bucket: bucketName,
                    accessPointName: accessPointName
                )
            )
        } while result?.status != "enable"
        
        // DeleteAccessPoint
        try await assertNoThrow(await client?.deleteAccessPoint(DeleteAccessPointRequest(
            bucket: bucketName,
            accessPointName: accessPointName
        )))
        repeat {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            do {
                let _ = try await client?.getAccessPoint(
                    GetAccessPointRequest(
                        bucket: bucketName,
                        accessPointName: accessPointName
                    )
                )
            } catch {
                let serverError = error as? ServerError
                if serverError?.statusCode == 404 {
                    break
                }
            }
        } while true
    }
    
    func testCreateAccessPointFail() async throws {
        var request = CreateAccessPointRequest()
        try await assertThrowsAsyncError(await client?.createAccessPoint(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = CreateAccessPointRequest(bucket: bucketName)
        try await assertThrowsAsyncError(await client?.createAccessPoint(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.createAccessPointConfiguration.")
        }
        
        request = CreateAccessPointRequest(
            bucket: bucketName,
            createAccessPointConfiguration: CreateAccessPointConfiguration()
        )
        try await assertThrowsAsyncError(await client?.createAccessPoint(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 400)
            XCTAssertEqual(serverError?.code, "MalformedXML")
        }
    }
    
    func testGetAccessPointFail() async throws {
        var request = GetAccessPointRequest()
        try await assertThrowsAsyncError(await client?.getAccessPoint(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = GetAccessPointRequest(
            bucket: bucketName,
            accessPointName: "error"
        )
        try await assertThrowsAsyncError(await client?.getAccessPoint(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
    
    func testDeleteAccessPointFail() async throws {
        var request = DeleteAccessPointRequest()
        try await assertThrowsAsyncError(await client?.deleteAccessPoint(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = DeleteAccessPointRequest(
            bucket: bucketName,
            accessPointName: "error"
        )
        try await assertThrowsAsyncError(await client?.deleteAccessPoint(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
    
    func testPutGetAndDeleteAccessPointPolicy() async throws {
        let accessPointName = randomStr(6)
        // CreateAccessPoint
        let createResult = try await client?.createAccessPoint(CreateAccessPointRequest(
            bucket: bucketName,
            createAccessPointConfiguration: CreateAccessPointConfiguration(
                accessPointName: accessPointName,
                networkOrigin: "internet",
            )
        ))
        
        let policy: [String : Any] = ["Version": "1",
                                      "Statement": [["Action": ["oss:PutObject",
                                                                "oss:GetObject"],
                                                     "Effect": "Deny",
                                                     "Principal": ["1234567890"],
                                                     "Resource": [createResult!.accessPointArn!]]
                                                   ]]
        // PutAccessPointPolicy
        try await assertNoThrow(await client?.putAccessPointPolicy(
            PutAccessPointPolicyRequest(
                bucket: bucketName,
                accessPointName: accessPointName,
                body: .data(try JSONSerialization.data(withJSONObject: policy))
            )
        ))
        
        // GetAccessPointPolicy
        let getPolicyResult = try await client?.getAccessPointPolicy(
            GetAccessPointPolicyRequest(
                bucket: bucketName,
                accessPointName: accessPointName
            )
        )
        XCTAssertNotNil(getPolicyResult?.body)
        let getPolicy = try JSONSerialization.jsonObject(with: getPolicyResult!.body!.readData()!) as? [String: Any]
        XCTAssertEqual(getPolicy?["Version"] as? String, policy["Version"] as? String)
        XCTAssertEqual((getPolicy?["Statement"] as? [[String: Any]])?.first?["Action"] as? [String], (policy["Statement"] as? [[String: Any]])?.first?["Action"] as? [String])
        XCTAssertEqual((getPolicy?["Statement"] as? [[String: Any]])?.first?["Effect"] as? String, (policy["Statement"] as? [[String: Any]])?.first?["Effect"] as? String)
        XCTAssertEqual((getPolicy?["Statement"] as? [[String: Any]])?.first?["Principal"] as? [String], (policy["Statement"] as? [[String: Any]])?.first?["Principal"] as? [String])
        XCTAssertEqual((getPolicy?["Statement"] as? [[String: Any]])?.first?["Resource"] as? [String], (policy["Statement"] as? [[String: Any]])?.first?["Resource"] as? [String])
        
        // DeleteAccessPointPolicy
        try await assertNoThrow(await client?.deleteAccessPointPolicy(
            DeleteAccessPointPolicyRequest(
                bucket: bucketName,
                accessPointName: accessPointName
            )
        ))
        
        var result: GetAccessPointResult?
        repeat {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            result = try await client?.getAccessPoint(
                GetAccessPointRequest(
                    bucket: bucketName,
                    accessPointName: accessPointName
                )
            )
        } while result?.status != "enable"
        
        // DeleteAccessPoint
        try await assertNoThrow(await client?.deleteAccessPoint(DeleteAccessPointRequest(
            bucket: bucketName,
            accessPointName: accessPointName
        )))
        repeat {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            do {
                let _ = try await client?.getAccessPoint(
                    GetAccessPointRequest(
                        bucket: bucketName,
                        accessPointName: accessPointName
                    )
                )
            } catch {
                let serverError = error as? ServerError
                if serverError?.statusCode == 404 {
                    break
                }
            }
        } while true
    }
    
    func testPutAccessPointPolicyFail() async throws {
        var request = PutAccessPointPolicyRequest()
        try await assertThrowsAsyncError(await client?.putAccessPointPolicy(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }

        request = PutAccessPointPolicyRequest(
            bucket: bucketName,
            accessPointName: "error",
        )
        try await assertThrowsAsyncError(await client?.putAccessPointPolicy(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 400)
            XCTAssertEqual(serverError?.code, "InvalidPolicyDocument")
        }
    }
    
    func testGetAccessPointPolicyFail() async throws {
        var request = GetAccessPointPolicyRequest()
        try await assertThrowsAsyncError(await client?.getAccessPointPolicy(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = GetAccessPointPolicyRequest(
            bucket: bucketName,
            accessPointName: "error"
        )
        try await assertThrowsAsyncError(await client?.getAccessPointPolicy(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
    
    func testDeleteAccessPointPolicyFail() async throws {
        var request = DeleteAccessPointPolicyRequest()
        try await assertThrowsAsyncError(await client?.deleteAccessPointPolicy(request)) {
            let clientError = $0 as? ClientError
            XCTAssertEqual(clientError?.message, "Missing required field, request.bucket.")
        }
        
        request = DeleteAccessPointPolicyRequest(
            bucket: bucketName,
            accessPointName: "error"
        )
        try await assertThrowsAsyncError(await client?.deleteAccessPointPolicy(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 404)
        }
    }
}
