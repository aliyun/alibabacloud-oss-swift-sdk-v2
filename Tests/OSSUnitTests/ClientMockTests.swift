@testable import AlibabaCloudOSS
import XCTest

final class ClientMockTests: XCTestCase {
    func testHttpProtocal() async throws {
        let mock = MockSendRequest()
        let credentialsProvider = StaticCredentialsProvider(accessKeyId: "ak", accessKeySecret: "sk")
        var config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withCredentialsProvider(credentialsProvider)
            .withRetryer(NopRetryer())
        var client = Client(config) { $0.executeMW = mock }

        XCTAssertNotNil(client)

        // defaut protocol is HTTPS
        mock.reset()
        mock.addResponse(make403Response())
        let _ = try? await client.putObject(PutObjectRequest(
            bucket: "bucket",
            key: "key+123 456",
            commonProp: RequestModelProp(
                parameters: [
                    "param": "12+456 789",
                ]
            )
        ))
        XCTAssertEqual(mock.requests.count, 1)
        XCTAssertEqual(
            "https://bucket.oss-cn-hangzhou.aliyuncs.com/key%2B123%20456?param=12%2B456%20789",
            mock.requests[0].requestUri.absoluteString
        )

        // set protocol to HTTP
        config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withCredentialsProvider(credentialsProvider)
            .withHttpProtocal(.http)
            .withRetryer(NopRetryer())
        client = Client(config) { $0.executeMW = mock }
        mock.reset()
        mock.addResponse(make403Response())
        _ = try? await client.putObject(PutObjectRequest(
            bucket: "bucket",
            key: "key+123 456",
            commonProp: RequestModelProp(
                parameters: [
                    "param": "12+456 789",
                ]
            )
        ))
        XCTAssertEqual(mock.requests.count, 1)
        XCTAssertEqual(
            "http://bucket.oss-cn-hangzhou.aliyuncs.com/key%2B123%20456?param=12%2B456%20789",
            mock.requests[0].requestUri.absoluteString
        )

        // set protocol from endpoint, no protocol in endpoint
        config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withEndpoint("oss-cn-hangzhou.aliyuncs.com")
            .withCredentialsProvider(credentialsProvider)
            .withRetryer(NopRetryer())
        client = Client(config) { $0.executeMW = mock }
        mock.reset()
        mock.addResponse(make403Response())
        _ = try? await client.putObject(PutObjectRequest(
            bucket: "bucket",
            key: "key+123 456",
            commonProp: RequestModelProp(
                parameters: [
                    "param": "12+456 789a",
                ]
            )
        ))
        XCTAssertEqual(mock.requests.count, 1)
        XCTAssertEqual(
            "https://bucket.oss-cn-hangzhou.aliyuncs.com/key%2B123%20456?param=12%2B456%20789a",
            mock.requests[0].requestUri.absoluteString
        )

        // set protocol from endpoint, with http protocol in endpoint
        config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withEndpoint("http://oss-cn-hangzhou.aliyuncs.com")
            .withCredentialsProvider(credentialsProvider)
            .withRetryer(NopRetryer())
        client = Client(config) { $0.executeMW = mock }
        mock.reset()
        mock.addResponse(make403Response())
        _ = try? await client.putObject(PutObjectRequest(
            bucket: "bucket",
            key: "key+123 456",
            commonProp: RequestModelProp(
                parameters: [
                    "param": "12+456 789b",
                ]
            )
        ))
        XCTAssertEqual(mock.requests.count, 1)
        XCTAssertEqual(
            "http://bucket.oss-cn-hangzhou.aliyuncs.com/key%2B123%20456?param=12%2B456%20789b",
            mock.requests[0].requestUri.absoluteString
        )

        // set protocol from endpoint, with https protocol in endpoint
        config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withEndpoint("https://oss-cn-hangzhou.aliyuncs.com")
            .withCredentialsProvider(credentialsProvider)
            .withRetryer(NopRetryer())
        client = Client(config) { $0.executeMW = mock }
        mock.reset()
        mock.addResponse(make403Response())
        _ = try? await client.putObject(PutObjectRequest(
            bucket: "bucket",
            key: "key+123 456",
            commonProp: RequestModelProp(
                parameters: [
                    "param": "12+456 789c",
                ]
            )
        ))
        XCTAssertEqual(mock.requests.count, 1)
        XCTAssertEqual(
            "https://bucket.oss-cn-hangzhou.aliyuncs.com/key%2B123%20456?param=12%2B456%20789c",
            mock.requests[0].requestUri.absoluteString
        )
    }

    func testAddressStyle() async throws {
        let mock = MockSendRequest()
        let credentialsProvider = StaticCredentialsProvider(accessKeyId: "ak", accessKeySecret: "sk")
        var config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withCredentialsProvider(credentialsProvider)
            .withRetryer(NopRetryer())
        var client = Client(config) { $0.executeMW = mock }

        XCTAssertNotNil(client)

        // virtualHosted, service
        mock.reset()
        mock.addResponse(make403Response())
        let _ = try? await client.listBuckets(ListBucketsRequest())
        XCTAssertEqual(mock.requests.count, 1)
        XCTAssertEqual(
            "https://oss-cn-hangzhou.aliyuncs.com/",
            mock.requests[0].requestUri.absoluteString
        )

        // virtualHosted, bucket only
        mock.reset()
        mock.addResponse(make403Response())
        let _ = try? await client.getBucketAcl(GetBucketAclRequest(
            bucket: "bucket"
        ))
        XCTAssertEqual(mock.requests.count, 1)
        XCTAssertEqual(
            "https://bucket.oss-cn-hangzhou.aliyuncs.com/?acl=",
            mock.requests[0].requestUri.absoluteString
        )

        // virtualHosted, bucket and key
        mock.reset()
        mock.addResponse(make403Response())
        let _ = try? await client.getObjectAcl(GetObjectAclRequest(
            bucket: "bucket",
            key: "key"
        ))
        XCTAssertEqual(mock.requests.count, 1)
        XCTAssertEqual(
            "https://bucket.oss-cn-hangzhou.aliyuncs.com/key?acl=",
            mock.requests[0].requestUri.absoluteString
        )

        // path, service
        config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withCredentialsProvider(credentialsProvider)
            .withUsePathStyle(true)
            .withRetryer(NopRetryer())
        client = Client(config) { $0.executeMW = mock }

        mock.reset()
        mock.addResponse(make403Response())
        let _ = try? await client.listBuckets(ListBucketsRequest())
        XCTAssertEqual(mock.requests.count, 1)
        XCTAssertEqual(
            "https://oss-cn-hangzhou.aliyuncs.com/",
            mock.requests[0].requestUri.absoluteString
        )

        // path, bucket only
        mock.reset()
        mock.addResponse(make403Response())
        let _ = try? await client.getBucketAcl(GetBucketAclRequest(
            bucket: "bucket"
        ))
        XCTAssertEqual(mock.requests.count, 1)
        XCTAssertEqual(
            "https://oss-cn-hangzhou.aliyuncs.com/bucket/?acl=",
            mock.requests[0].requestUri.absoluteString
        )

        // path, bucket and key
        mock.reset()
        mock.addResponse(make403Response())
        let _ = try? await client.getObjectAcl(GetObjectAclRequest(
            bucket: "bucket",
            key: "key"
        ))
        XCTAssertEqual(mock.requests.count, 1)
        XCTAssertEqual(
            "https://oss-cn-hangzhou.aliyuncs.com/bucket/key?acl=",
            mock.requests[0].requestUri.absoluteString
        )

        // cname, service
        config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withEndpoint("www.cname.com")
            .withCredentialsProvider(credentialsProvider)
            .withUseCname(true)
            .withRetryer(NopRetryer())
        client = Client(config) { $0.executeMW = mock }

        mock.reset()
        mock.addResponse(make403Response())
        let _ = try? await client.listBuckets(ListBucketsRequest())
        XCTAssertEqual(mock.requests.count, 1)
        XCTAssertEqual(
            "https://www.cname.com/",
            mock.requests[0].requestUri.absoluteString
        )

        // cname, bucket only
        mock.reset()
        mock.addResponse(make403Response())
        let _ = try? await client.getBucketAcl(GetBucketAclRequest(
            bucket: "bucket"
        ))
        XCTAssertEqual(mock.requests.count, 1)
        XCTAssertEqual(
            "https://www.cname.com/?acl=",
            mock.requests[0].requestUri.absoluteString
        )

        // path, bucket and key
        mock.reset()
        mock.addResponse(make403Response())
        let _ = try? await client.getObjectAcl(GetObjectAclRequest(
            bucket: "bucket",
            key: "key"
        ))
        XCTAssertEqual(mock.requests.count, 1)
        XCTAssertEqual(
            "https://www.cname.com/key?acl=",
            mock.requests[0].requestUri.absoluteString
        )
    }

    func testEndpontType() async throws {
        let mock = MockSendRequest()
        let credentialsProvider = StaticCredentialsProvider(accessKeyId: "ak", accessKeySecret: "sk")
        var config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withCredentialsProvider(credentialsProvider)
            .withRetryer(NopRetryer())
        var client = Client(config) { $0.executeMW = mock }

        XCTAssertNotNil(client)

        // default
        mock.reset()
        mock.addResponse(make403Response())
        let _ = try? await client.listBuckets(ListBucketsRequest())
        XCTAssertEqual(mock.requests.count, 1)
        XCTAssertEqual(
            "https://oss-cn-hangzhou.aliyuncs.com/",
            mock.requests[0].requestUri.absoluteString
        )

        // useInternalEndpoint
        config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withCredentialsProvider(credentialsProvider)
            .withUseInternalEndpoint(true)
            .withRetryer(NopRetryer())
        client = Client(config) { $0.executeMW = mock }
        mock.reset()
        mock.addResponse(make403Response())
        let _ = try? await client.listBuckets(ListBucketsRequest())
        XCTAssertEqual(mock.requests.count, 1)
        XCTAssertEqual(
            "https://oss-cn-hangzhou-internal.aliyuncs.com/",
            mock.requests[0].requestUri.absoluteString
        )

        // useAccelerateEndpoint
        config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withCredentialsProvider(credentialsProvider)
            .withUseAccelerateEndpoint(true)
            .withRetryer(NopRetryer())
        client = Client(config) { $0.executeMW = mock }
        mock.reset()
        mock.addResponse(make403Response())
        let _ = try? await client.listBuckets(ListBucketsRequest())
        XCTAssertEqual(mock.requests.count, 1)
        XCTAssertEqual(
            "https://oss-accelerate.aliyuncs.com/",
            mock.requests[0].requestUri.absoluteString
        )

        // useDualStackEndpoint
        config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withCredentialsProvider(credentialsProvider)
            .withUseDualStackEndpoint(true)
            .withRetryer(NopRetryer())
        client = Client(config) { $0.executeMW = mock }
        mock.reset()
        mock.addResponse(make403Response())
        let _ = try? await client.listBuckets(ListBucketsRequest())
        XCTAssertEqual(mock.requests.count, 1)
        XCTAssertEqual(
            "https://cn-hangzhou.oss.aliyuncs.com/",
            mock.requests[0].requestUri.absoluteString
        )

        // useDualStackEndpoint useAccelerateEndpoint useInternalEndpoint
        config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withCredentialsProvider(credentialsProvider)
            .withUseInternalEndpoint(true)
            .withUseDualStackEndpoint(true)
            .withUseAccelerateEndpoint(true)
            .withRetryer(NopRetryer())
        client = Client(config) { $0.executeMW = mock }
        mock.reset()
        mock.addResponse(make403Response())
        let _ = try? await client.listBuckets(ListBucketsRequest())
        XCTAssertEqual(mock.requests.count, 1)
        XCTAssertEqual(
            "https://cn-hangzhou.oss.aliyuncs.com/",
            mock.requests[0].requestUri.absoluteString
        )

        // useAccelerateEndpoint useInternalEndpoint
        config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withCredentialsProvider(credentialsProvider)
            .withUseInternalEndpoint(true)
            .withUseAccelerateEndpoint(true)
            .withRetryer(NopRetryer())
        client = Client(config) { $0.executeMW = mock }
        mock.reset()
        mock.addResponse(make403Response())
        let _ = try? await client.listBuckets(ListBucketsRequest())
        XCTAssertEqual(mock.requests.count, 1)
        XCTAssertEqual(
            "https://oss-cn-hangzhou-internal.aliyuncs.com/",
            mock.requests[0].requestUri.absoluteString
        )

        // endpoint
        config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withEndpoint("https://oss-cn-hangzhou.aliyuncs.com/")
            .withCredentialsProvider(credentialsProvider)
            .withUseInternalEndpoint(true)
            .withUseDualStackEndpoint(true)
            .withUseAccelerateEndpoint(true)
            .withRetryer(NopRetryer())
        client = Client(config) { $0.executeMW = mock }
        mock.reset()
        mock.addResponse(make403Response())
        let _ = try? await client.listBuckets(ListBucketsRequest())
        XCTAssertEqual(mock.requests.count, 1)
        XCTAssertEqual(
            "https://oss-cn-hangzhou.aliyuncs.com/",
            mock.requests[0].requestUri.absoluteString
        )
    }

    func testRetryerDefault() async throws {
        let mock = MockSendRequest()
        let credentialsProvider = StaticCredentialsProvider(accessKeyId: "ak", accessKeySecret: "sk")
        let config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withCredentialsProvider(credentialsProvider)
        let client = Client(config) { $0.executeMW = mock }

        XCTAssertNotNil(client)

        // default
        mock.reset()
        mock.addResponse(makeTimeTooSkewedResponse())
        mock.addResponse(makeTimeTooSkewedResponse())
        mock.addResponse(makeTimeTooSkewedResponse())
        mock.addResponse(makeTimeTooSkewedResponse())
        let _ = try? await client.listBuckets(ListBucketsRequest())
        XCTAssertEqual(mock.requests.count, 3)

        // don't retry
        mock.reset()
        mock.addResponse(make403Response())
        let _ = try? await client.listBuckets(ListBucketsRequest())
        XCTAssertEqual(mock.requests.count, 1)
    }

    func testRetryerWithDifferentByteStream() async throws {
        let data = "hello oss".data(using: .utf8)!
        let file = Utils.createTestFile(Utils.randomStr(5), data)
        let credentialsProvider = StaticCredentialsProvider(accessKeyId: "ak", accessKeySecret: "sk")
        let config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withCredentialsProvider(credentialsProvider)
            .withUploadCRC64Validation(false)
            .withDownloadCRC64Validation(false)
        var count = 0
        let mock = MockProcessRequest { _, _ in
            if count < 2 {
                count += 1
                return makeTimeTooSkewedResponse()
            } else {
                return ResponseMessage(statusCode: 200)
            }
        }
        let client = Client(config) { $0.executeMW = mock }
        XCTAssertNotNil(client)

        // data
        var request = PutObjectRequest(bucket: "bucket",
                                       key: "key",
                                       body: .data(data))
        try await assertNoThrow(await client.putObject(request))

        // file
        count = 0
        request = PutObjectRequest(bucket: "bucket",
                                   key: "key",
                                   body: .file(URL(fileURLWithPath: file!)))
        try await assertNoThrow(await client.putObject(request))

        // stream
        count = 0
        request = PutObjectRequest(bucket: "bucket",
                                   key: "key",
                                   body: .stream(InputStream(data: data)))
        try await assertThrowsAsyncError(await client.putObject(request)) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 403)
            XCTAssertEqual(serverError?.code, "RequestTimeTooSkewed")
        }

        Utils.removeTestFile(file!)
    }

    func testRetryerWithError() async throws {
        let mock = MockSendRequest()
        let credentialsProvider = StaticCredentialsProvider(accessKeyId: "ak", accessKeySecret: "sk")
        let config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withCredentialsProvider(credentialsProvider)
        let client = Client(config) { $0.executeMW = mock }
        XCTAssertNotNil(client)

        mock.reset()
        mock.addResponse(make403Response())
        try await assertThrowsAsyncError(await client.listBuckets(ListBucketsRequest())) {
            let serverError = $0 as? ServerError
            XCTAssertEqual(serverError?.statusCode, 403)
            XCTAssertEqual(serverError?.code, "InvalidAccessKeyId")
            XCTAssertEqual(serverError?.requestId, "id-1234")
        }
    }

    func testRetryerWithCancelTask() async throws {
        let credentialsProvider = StaticCredentialsProvider(accessKeyId: "ak", accessKeySecret: "sk")
        let config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withCredentialsProvider(credentialsProvider)
        let mock = MockProcessRequest { _, _ in
            try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
            return ResponseMessage()
        }
        let client = Client(config) { $0.executeMW = mock }
        XCTAssertNotNil(client)

        Task {
            try await assertThrowsAsyncError(await client.listBuckets(ListBucketsRequest())) {
                switch $0 {
                case is CancellationError:
                    break
                default:
                    XCTFail()
                }
            }
        }.cancel()
        try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
    }

    func testCrc64WithRetry() async throws {
        let data = "hello oss".data(using: .utf8)!
        let file = Utils.createTestFile(Utils.randomStr(5), data)
        let credentialsProvider = StaticCredentialsProvider(accessKeyId: "ak", accessKeySecret: "sk")
        let config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withCredentialsProvider(credentialsProvider)
        var count = 0
        let mock = MockProcessRequest { request, _ in
            if count < 2 {
                count += 1
                let _ = try request.content?.readData()
                return makeTimeTooSkewedResponse()
            } else {
                return ResponseMessage(statusCode: 200,
                                       headers: ["x-oss-hash-crc64ecma": "15021467531229347219"])
            }
        }
        let client = Client(config) { $0.executeMW = mock }
        XCTAssertNotNil(client)

        // upload data
        var request = PutObjectRequest(bucket: "bucket",
                                       key: "key",
                                       body: .data(data))
        try await assertNoThrow(await client.putObject(request))

        // upload file
        count = 0
        request = PutObjectRequest(bucket: "bucket",
                                   key: "key",
                                   body: .file(URL(fileURLWithPath: file!)))
        try await assertNoThrow(await client.putObject(request))

        Utils.removeTestFile(file!)
    }

    func testProgressWithRetry() async throws {
        let data = "hello oss".data(using: .utf8)!
        let credentialsProvider = StaticCredentialsProvider(accessKeyId: "ak", accessKeySecret: "sk")
        let config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withCredentialsProvider(credentialsProvider)
        var count = 0
        let mock = MockProcessRequest { request, context in
            var delegate = context.progressDelegate?.delegate
            if count < 2 {
                count += 1
                delegate?.onProgress(2, 2, 9)
                let _ = try request.content?.readData()
                return makeTimeTooSkewedResponse()
            } else {
                for i in stride(from: 2, to: 9, by: 2) {
                    delegate?.onProgress(2, Int64(i), 9)
                }
                return ResponseMessage(statusCode: 200,
                                       headers: ["x-oss-hash-crc64ecma": "15021467531229347219"])
            }
        }
        let client = Client(config) { $0.executeMW = mock }
        XCTAssertNotNil(client)

        // upload
        nonisolated(unsafe) var cc = 0
        var request = PutObjectRequest(bucket: "bucket",
                                       key: "key",
                                       body: .data(data))
        request.progress = ProgressClosure { bytesIncrement, totalBytesTransferred, totalBytesExpected in
            if cc < 3 {
                XCTAssertEqual(totalBytesTransferred, 2)
                cc += 1
            } else {
                XCTAssertLessThan(2, totalBytesTransferred)
            }
            XCTAssertEqual(bytesIncrement, 2)
            XCTAssertEqual(totalBytesExpected, 9)
        }
        try await assertNoThrow(await client.putObject(request))
    }

    func testFixTimeSkewed() async throws {
        let data = "hello oss".data(using: .utf8)!
        let credentialsProvider = StaticCredentialsProvider(accessKeyId: "ak", accessKeySecret: "sk")
        let config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withCredentialsProvider(credentialsProvider)
            .withRetryMaxAttempts(2)
        let date = Date(timeIntervalSince1970: TimeInterval(Int(Date().timeIntervalSince1970))).addingTimeInterval(60 * 60)

        // enable fix time
        var mock = MockProcessRequest { request, _ in
            let body =
                """
                <Error>
                <Code>RequestTimeTooSkewed</Code>\
                <Message>The difference between the request time and the current time is too large.</Message>\
                <RequestTime>\(request.headers["Date"]!)</RequestTime>\
                <ServerTime>\(DateFormatter.iso8601DateTimeSeconds.string(from: date))</ServerTime>
                </Error>
                """
            return ResponseMessage(statusCode: 403,
                                   headers: ["Date": DateFormatter.rfc5322DateTime.string(from: Date().addingTimeInterval(30 * 60))],
                                   content: .data(body.data(using: .utf8)!))
        }
        var client = Client(config) { $0.executeMW = mock; $0.featureFlags.insert(.correctClockSkew) }
        XCTAssertNotNil(client)

        // use body date
        var request = PutObjectRequest(bucket: "bucket",
                                       key: "key",
                                       body: .data(data))
        try await assertThrowsAsyncError(await client.putObject(request)) {
            let serverError = $0 as? ServerError
            let d = DateFormatter.rfc5322DateTime.date(from: serverError!.errorFields["RequestTime"]!)!
            XCTAssertLessThanOrEqual(date, d)
        }

        // use header date
        mock = MockProcessRequest { request, _ in
            let body =
                """
                <Error>
                <Code>RequestTimeTooSkewed</Code>\
                <Message>The difference between the request time and the current time is too large.</Message>\
                <RequestTime>\(request.headers["Date"]!)</RequestTime>\
                </Error>
                """
            return ResponseMessage(statusCode: 403,
                                   headers: ["Date": DateFormatter.rfc5322DateTime.string(from: date)],
                                   content: .data(body.data(using: .utf8)!))
        }
        client = Client(config) { $0.executeMW = mock; $0.featureFlags.insert(.correctClockSkew) }
        XCTAssertNotNil(client)

        request = PutObjectRequest(bucket: "bucket",
                                   key: "key",
                                   body: .data(data))
        try await assertThrowsAsyncError(await client.putObject(request)) {
            let serverError = $0 as? ServerError
            let d = DateFormatter.rfc5322DateTime.date(from: serverError!.errorFields["RequestTime"]!)!
            XCTAssertLessThanOrEqual(date, d)
        }

        // fix time for v4
        mock = MockProcessRequest { request, _ in
            let body =
                """
                <Error>
                <Code>InvalidArgument</Code>\
                <Message>Invalid signing date in Authorization header.</Message>\
                <RequestTime>\(request.headers["Date"]!)</RequestTime>\
                </Error>
                """
            return ResponseMessage(statusCode: 400,
                                   headers: ["Date": DateFormatter.rfc5322DateTime.string(from: date)],
                                   content: .data(body.data(using: .utf8)!))
        }
        client = Client(config) { $0.executeMW = mock; $0.featureFlags.insert(.correctClockSkew) }
        XCTAssertNotNil(client)

        request = PutObjectRequest(bucket: "bucket",
                                   key: "key",
                                   body: .data(data))
        try await assertThrowsAsyncError(await client.putObject(request)) {
            let serverError = $0 as? ServerError
            let d = DateFormatter.rfc5322DateTime.date(from: serverError!.errorFields["RequestTime"]!)!
            XCTAssertLessThanOrEqual(date, d)
        }

        // disable fix time
        mock = MockProcessRequest { request, _ in
            let body =
                """
                <Error>
                <Code>RequestTimeTooSkewed</Code>\
                <Message>The difference between the request time and the current time is too large.</Message>\
                <RequestTime>\(request.headers["Date"]!)</RequestTime>\
                <ServerTime>\(DateFormatter.iso8601DateTimeSeconds.string(from: date))</ServerTime>
                </Error>
                """
            return ResponseMessage(statusCode: 403,
                                   headers: ["Date": DateFormatter.rfc5322DateTime.string(from: date)],
                                   content: .data(body.data(using: .utf8)!))
        }
        client = Client(config) { $0.executeMW = mock; $0.featureFlags.remove(.correctClockSkew) }
        XCTAssertNotNil(client)

        request = PutObjectRequest(bucket: "bucket",
                                   key: "key",
                                   body: .data(data))
        try await assertThrowsAsyncError(await client.putObject(request)) {
            let serverError = $0 as? ServerError
            let d = DateFormatter.rfc5322DateTime.date(from: serverError!.errorFields["RequestTime"]!)!
            XCTAssertLessThan(d, date)
        }
    }

    func testUploadCheckCRC() async {
        let data = "hello oss".data(using: .utf8)!
        let credentialsProvider = StaticCredentialsProvider(accessKeyId: "ak", accessKeySecret: "sk")
        let config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withCredentialsProvider(credentialsProvider)
            .withUploadCRC64Validation(true)

        // consistent
        var mock = MockProcessRequest { _, _ in
            ResponseMessage(statusCode: 200,
                            headers: ["x-oss-hash-crc64ecma": "15021467531229347219"])
        }
        var client = Client(config) { $0.executeMW = mock }
        var request = PutObjectRequest(bucket: "bucket",
                                       key: "key",
                                       body: .data(data))
        try await assertNoThrow(await client.putObject(request))

        // inconsistent
        mock = MockProcessRequest { _, _ in
            ResponseMessage(statusCode: 200,
                            headers: ["x-oss-hash-crc64ecma": "123"])
        }
        client = Client(config) { $0.executeMW = mock }
        request = PutObjectRequest(bucket: "bucket",
                                   key: "key",
                                   body: .data(data))
        try await assertThrowsAsyncError(await client.putObject(request)) {
            let error = $0 as? ClientError
            XCTAssertEqual(error?.message.prefix(19), "crc is inconsistent")
        }
    }

    func testDownloadCheckCRC() async {
        let data = "hello oss".data(using: .utf8)!
        let credentialsProvider = StaticCredentialsProvider(accessKeyId: "ak", accessKeySecret: "sk")
        let config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withCredentialsProvider(credentialsProvider)
            .withDownloadCRC64Validation(true)

        // consistent
        var mock = MockProcessRequest { _, _ in
            ResponseMessage(statusCode: 200,
                            headers: ["x-oss-hash-crc64ecma": "15021467531229347219"],
                            content: .data(data))
        }
        var client = Client(config) { $0.executeMW = mock }
        var request = GetObjectRequest(bucket: "bucket",
                                       key: "key")
        try await assertNoThrow(await client.getObject(request))

        // inconsistent
        mock = MockProcessRequest { _, _ in
            ResponseMessage(statusCode: 200,
                            headers: ["x-oss-hash-crc64ecma": "123"],
                            content: .data(data))
        }
        client = Client(config) { $0.executeMW = mock }
        request = GetObjectRequest(bucket: "bucket",
                                   key: "key")
        try await assertThrowsAsyncError(await client.getObject(request)) {
            let error = $0 as? ClientError
            XCTAssertEqual(error?.message.prefix(19), "crc is inconsistent")
        }
    }
    
    func testUserAgent() async throws {
        var config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withCredentialsProvider(AnonymousCredentialsProvider())
            .withUserAgent("userAgent")
        
        // consistent
        let mock = MockProcessRequest { request, _ in
            ResponseMessage(statusCode: 200,
                            headers: request.headers)
        }
        var client = Client(config) { $0.executeMW = mock }
        let request = GetObjectRequest(bucket: "bucket",
                                       key: "key")
        var result = try await client.getObject(request)
        XCTAssertEqual("userAgent", result.headers?[caseInsensitive: "user-agent"]?.suffix(9))
        
        
        config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withCredentialsProvider(AnonymousCredentialsProvider())
        client = Client(config) { $0.executeMW = mock }
        result = try await client.getObject(request)
        XCTAssertNotNil(result.headers?[caseInsensitive: "user-agent"])
    }
    
    func testCname() async throws {
        let config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withEndpoint("www.cname.com")
            .withAdditionalHeaders(["additionalKey"])
            .withCredentialsProvider(StaticCredentialsProvider(accessKeyId: "ak", accessKeySecret: "sk"))
        
        // consistent
        let mock = MockProcessRequest { request, context in
            return ResponseMessage(statusCode: 200,
                                   headers: request.headers)
        }
        let client = Client(config) { $0.executeMW = mock }
        var request = GetObjectRequest(bucket: "bucket",
                                       key: "key")
        request.commonProp.headers = ["additionalKey": "additionalValue"]
        let result = try await client.getObject(request)
        XCTAssertEqual("additionalValue", result.headers?[caseInsensitive: "additionalKey"])
        XCTAssertTrue(result.headers?[caseInsensitive: "Authorization"]?.contains("AdditionalHeaders=additionalkey") ?? false)
    }
}

private class MockSendRequest: ExecuteMiddleware {
    var reponses: [ResponseMessage] = []
    var requests: [RequestMessage] = []

    public func execute(request: RequestMessage, context _: ExecuteContext) async throws -> ResponseMessage {
        requests.append(request)
        XCTAssertFalse(reponses.isEmpty)
        let response = reponses[0]
        reponses.remove(at: 0)
        return response
    }

    func addResponse(_ response: ResponseMessage) {
        reponses.append(response)
    }

    func reset() {
        requests = []
        reponses = []
    }
}

private class MockProcessRequest: ExecuteMiddleware {
    var process: (RequestMessage, ExecuteContext) async throws -> ResponseMessage
    init(process: @escaping (RequestMessage, ExecuteContext) async throws -> ResponseMessage) {
        self.process = process
    }

    public func execute(request: RequestMessage, context: ExecuteContext) async throws -> ResponseMessage {
        try await process(request, context)
    }

    func reset(process: @escaping (RequestMessage, ExecuteContext) async throws -> ResponseMessage) {
        self.process = process
    }
}

private func make403Response() -> ResponseMessage {
    let xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Error>
        <Code>InvalidAccessKeyId</Code>
        <Message>The OSS Access Key Id you provided does not exist in our records.</Message>
        <RequestId>id-1234</RequestId>
        <HostId>oss-cn-hangzhou.aliyuncs.com</HostId>
        <OSSAccessKeyId>ak</OSSAccessKeyId>
        <EC>0002-00000902</EC>
        <RecommendDoc>https://api.aliyun.com/troubleshoot?q=0002-00000902</RecommendDoc>
    </Error>
    """
    let data = xml.data(using: .utf8)!
    return ResponseMessage(
        statusCode: 403,
        headers: [
            "x-oss-request-id": "req-id-123",
            "Content-Type": "aplication/xml",
            "Content-Length": String(data.count),
        ],
        content: ByteStream.data(data),
        request: nil
    )
}

private func makeTimeTooSkewedResponse() -> ResponseMessage {
    let xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Error>
        <Code>RequestTimeTooSkewed</Code>
        <Message>The difference between the request time and the current time is too large.</Message>
        <RequestId>id-1234</RequestId>
        <HostId>oss-cn-hangzhou.aliyuncs.com</HostId>
        <RequestTime>2024-08-28T01:03:57.000Z</RequestTime>
        <ServerTime>2024-08-28T01:23:02.000Z</ServerTime>
        <EC>0002-00000504</EC>
        <RecommendDoc>https://api.aliyun.com/troubleshoot?q=0002-00000902</RecommendDoc>
    </Error>
    """
    let data = xml.data(using: .utf8)!
    return ResponseMessage(
        statusCode: 403,
        headers: [
            "x-oss-request-id": "req-id-123",
            "Content-Type": "aplication/xml",
            "Content-Length": String(data.count),
        ],
        content: ByteStream.data(data),
        request: nil
    )
}
