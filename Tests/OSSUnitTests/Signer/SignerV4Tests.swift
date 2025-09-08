@testable import AlibabaCloudOSS
import XCTest

class SignerV4Tests: XCTestCase {
    func testAuthHeader() async throws {
        let credentials = Credentials(accessKeyId: "ak", accessKeySecret: "sk")
        let path = "1234+-/123/1.txt"
        let host = "http://bucket.oss-cn-hangzhou.aliyuncs.com"
        let parameters: [String: String?] = [
            "param1": "value1",
            "+param1": "value3",
            "|param1": "value4",
            "+param2": "",
            "|param2": "",
            "param2": "",
        ]
        let queries = parameters.map { k, v in
            if let name = k.urlEncode() {
                let value = v?.urlEncode()
                return "\(name)=\(value ?? "")"
            } else {
                return ""
            }
        }.joined(separator: "&")

        let uri = URL(string: "\(host)/\(path.urlEncodePath()!)?\(queries)")!

        var request = RequestMessage(method: "PUT", requestUri: uri)
        request.headers = [
            "x-oss-head1": "value",
            "abc": "value",
            "ZAbc": "value",
            "XYZ": "value",
            "content-type": "text/plain",
            "x-oss-content-sha256": "UNSIGNED-PAYLOAD",
        ]

        let signTime = Date(timeIntervalSince1970: 1_702_743_657.0)

        var signingContext = SigningContext(
            bucket: "bucket",
            key: "1234+-/123/1.txt",
            region: "cn-hangzhou",
            product: "oss",
            signTime: signTime,
            credentials: credentials
        )
        let signer = SignerV4()
        request = try await signer.sign(request: request, signingContext: &signingContext)
        let urlStr = request.requestUri.absoluteString

        let authPat = "OSS4-HMAC-SHA256 Credential=ak/20231216/cn-hangzhou/oss/aliyun_v4_request,Signature=e21d18daa82167720f9b1047ae7e7f1ce7cb77a31e8203a7d5f4624fa0284afe"
        XCTAssertEqual(authPat, request.headers["Authorization"]!)

        XCTAssertTrue(urlStr.contains("bucket.oss-cn-hangzhou.aliyuncs.com/1234%2B-/123/1.txt?"))
        XCTAssertTrue(urlStr.contains("%2Bparam2="))
        XCTAssertTrue(urlStr.contains("%2Bparam1=value3"))
    }

    func testAuthHeaderToken() async throws {
        let credentials = Credentials(accessKeyId: "ak", accessKeySecret: "sk", securityToken: "token")
        let path = "1234+-/123/1.txt"
        let host = "http://bucket.oss-cn-hangzhou.aliyuncs.com"
        let parameters: [String: String?] = [
            "param1": "value1",
            "+param1": "value3",
            "|param1": "value4",
            "+param2": "",
            "|param2": "",
            "param2": "",
        ]
        let queries = parameters.map { k, v in
            if let name = k.urlEncode() {
                let value = v?.urlEncode()
                return "\(name)=\(value ?? "")"
            } else {
                return ""
            }
        }.joined(separator: "&")

        let uri = URL(string: "\(host)/\(path.urlEncodePath()!)?\(queries)")!

        var request = RequestMessage(method: "PUT", requestUri: uri)
        request.headers = [
            "x-oss-head1": "value",
            "abc": "value",
            "ZAbc": "value",
            "XYZ": "value",
            "content-type": "text/plain",
            "x-oss-content-sha256": "UNSIGNED-PAYLOAD",
        ]

        let signTime = Date(timeIntervalSince1970: 1_702_784_856.0)

        var signingContext = SigningContext(
            bucket: "bucket",
            key: "1234+-/123/1.txt",
            region: "cn-hangzhou",
            product: "oss",
            signTime: signTime,
            credentials: credentials
        )
        let signer = SignerV4()
        request = try await signer.sign(request: request, signingContext: &signingContext)
        let urlStr = request.requestUri.absoluteString

        let authPat = "OSS4-HMAC-SHA256 Credential=ak/20231217/cn-hangzhou/oss/aliyun_v4_request,Signature=b94a3f999cf85bcdc00d332fbd3734ba03e48382c36fa4d5af5df817395bd9ea"
        XCTAssertEqual(authPat, request.headers["Authorization"]!)

        XCTAssertTrue(urlStr.contains("bucket.oss-cn-hangzhou.aliyuncs.com/1234%2B-/123/1.txt?"))
        XCTAssertTrue(urlStr.contains("%2Bparam2="))
        XCTAssertTrue(urlStr.contains("%2Bparam1=value3"))
    }

    func testAuthHeaderWithAdditionalHeaders() async throws {
        let credentials = Credentials(accessKeyId: "ak", accessKeySecret: "sk")
        let path = "1234+-/123/1.txt"
        let host = "http://bucket.oss-cn-hangzhou.aliyuncs.com"
        let parameters: [String: String?] = [
            "param1": "value1",
            "+param1": "value3",
            "|param1": "value4",
            "+param2": "",
            "|param2": "",
            "param2": "",
        ]
        let queries = parameters.map { k, v in
            if let name = k.urlEncode() {
                let value = v?.urlEncode()
                return "\(name)=\(value ?? "")"
            } else {
                return ""
            }
        }.joined(separator: "&")

        let uri = URL(string: "\(host)/\(path.urlEncodePath()!)?\(queries)")!

        // case 1
        var request = RequestMessage(method: "PUT", requestUri: uri)
        request.headers = [
            "x-oss-head1": "value",
            "abc": "value",
            "ZAbc": "value",
            "XYZ": "value",
            "content-type": "text/plain",
            "x-oss-content-sha256": "UNSIGNED-PAYLOAD",
        ]

        let signTime = Date(timeIntervalSince1970: 1_702_747_512.0)

        var signingContext = SigningContext(
            bucket: "bucket",
            key: "1234+-/123/1.txt",
            region: "cn-hangzhou",
            product: "oss",
            signTime: signTime,
            credentials: credentials,
            additionalHeaderNames: ["ZAbc", "abc"]
        )
        let signer = SignerV4()
        request = try await signer.sign(request: request, signingContext: &signingContext)
        let urlStr = request.requestUri.absoluteString

        let authPat = "OSS4-HMAC-SHA256 Credential=ak/20231216/cn-hangzhou/oss/aliyun_v4_request,AdditionalHeaders=abc;zabc,Signature=4a4183c187c07c8947db7620deb0a6b38d9fbdd34187b6dbaccb316fa251212f"
        XCTAssertEqual(authPat, request.headers["Authorization"]!)

        XCTAssertTrue(urlStr.contains("bucket.oss-cn-hangzhou.aliyuncs.com/1234%2B-/123/1.txt?"))
        XCTAssertTrue(urlStr.contains("%2Bparam2="))
        XCTAssertTrue(urlStr.contains("%2Bparam1=value3"))

        // with default signed header
        var request1 = RequestMessage(method: "PUT", requestUri: uri)
        request1.headers = [
            "x-oss-head1": "value",
            "abc": "value",
            "ZAbc": "value",
            "XYZ": "value",
            "content-type": "text/plain",
            "x-oss-content-sha256": "UNSIGNED-PAYLOAD",
        ]

        let signTime1 = Date(timeIntervalSince1970: 1_702_747_512.0)

        var signingContext1 = SigningContext(
            bucket: "bucket",
            key: "1234+-/123/1.txt",
            region: "cn-hangzhou",
            product: "oss",
            signTime: signTime1,
            credentials: credentials,
            additionalHeaderNames: ["x-oss-no-exist", "ZAbc", "x-oss-head1", "abc"]
        )
        request1 = try await signer.sign(request: request1, signingContext: &signingContext1)
        // authPat = "OSS4-HMAC-SHA256 Credential=ak/20231216/cn-hangzhou/oss/aliyun_v4_request,AdditionalHeaders=abc;zabc,Signature=4a4183c187c07c8947db7620deb0a6b38d9fbdd34187b6dbaccb316fa251212f"
        XCTAssertEqual(authPat, request1.headers["Authorization"]!)
    }

    func testAuthQuery() async throws {
        let credentials = Credentials(accessKeyId: "ak", accessKeySecret: "sk")
        let path = "1234+-/123/1.txt"
        let host = "http://bucket.oss-cn-hangzhou.aliyuncs.com"
        let parameters: [String: String?] = [
            "param1": "value1",
            "+param1": "value3",
            "|param1": "value4",
            "+param2": "",
            "|param2": "",
            "param2": "",
        ]
        let queries = parameters.map { k, v in
            if let name = k.urlEncode() {
                let value = v?.urlEncode()
                return "\(name)=\(value ?? "")"
            } else {
                return ""
            }
        }.joined(separator: "&")

        let uri = URL(string: "\(host)/\(path.urlEncodePath()!)?\(queries)")!

        var request = RequestMessage(method: "PUT", requestUri: uri)
        request.headers = [
            "x-oss-head1": "value",
            "abc": "value",
            "ZAbc": "value",
            "XYZ": "value",
            "content-type": "application/octet-stream",
        ]

        let signTime = Date(timeIntervalSince1970: 1_702_781_677.0)
        let expirationTime = Date(timeIntervalSince1970: 1_702_782_276.0)

        var signingContext = SigningContext(
            bucket: "bucket",
            key: "1234+-/123/1.txt",
            region: "cn-hangzhou",
            product: "oss",
            signTime: signTime,
            credentials: credentials
        )
        signingContext.expirationTime = expirationTime
        signingContext.authHeader = false
        let signer = SignerV4()
        request = try await signer.sign(request: request, signingContext: &signingContext)
        let urlStr = request.requestUri.absoluteString

        XCTAssertTrue(urlStr.contains("x-oss-signature-version=OSS4-HMAC-SHA256"))
        XCTAssertTrue(urlStr.contains("x-oss-expires=599"))
        XCTAssertTrue(urlStr.contains("x-oss-credential=ak%2F20231217%2Fcn-hangzhou%2Foss%2Faliyun_v4_request"))
        XCTAssertTrue(urlStr.contains("x-oss-signature=a39966c61718be0d5b14e668088b3fa07601033f6518ac7b523100014269c0fe"))
        XCTAssertFalse(urlStr.contains("x-oss-additional-headers"))

        XCTAssertTrue(urlStr.contains("bucket.oss-cn-hangzhou.aliyuncs.com/1234%2B-/123/1.txt?"))
        XCTAssertTrue(urlStr.contains("%2Bparam2=&"))
        XCTAssertTrue(urlStr.contains("%2Bparam1=value3&"))
    }

    func testAuthQueryToken() async throws {
        let credentials = Credentials(accessKeyId: "ak", accessKeySecret: "sk", securityToken: "token")
        let path = "1234+-/123/1.txt"
        let host = "http://bucket.oss-cn-hangzhou.aliyuncs.com"
        let parameters: [String: String?] = [
            "param1": "value1",
            "+param1": "value3",
            "|param1": "value4",
            "+param2": "",
            "|param2": "",
            "param2": "",
        ]
        let queries = parameters.map { k, v in
            if let name = k.urlEncode() {
                let value = v?.urlEncode()
                return "\(name)=\(value ?? "")"
            } else {
                return ""
            }
        }.joined(separator: "&")

        let uri = URL(string: "\(host)/\(path.urlEncodePath()!)?\(queries)")!

        var request = RequestMessage(method: "PUT", requestUri: uri)
        request.headers = [
            "x-oss-head1": "value",
            "abc": "value",
            "ZAbc": "value",
            "XYZ": "value",
            "content-type": "application/octet-stream",
        ]

        let signTime = Date(timeIntervalSince1970: 1_702_785_388.0)
        let expirationTime = Date(timeIntervalSince1970: 1_702_785_987.0)

        var signingContext = SigningContext(
            bucket: "bucket",
            key: "1234+-/123/1.txt",
            region: "cn-hangzhou",
            product: "oss",
            signTime: signTime,
            credentials: credentials
        )
        signingContext.expirationTime = expirationTime
        signingContext.authHeader = false
        let signer = SignerV4()
        request = try await signer.sign(request: request, signingContext: &signingContext)
        let urlStr = request.requestUri.absoluteString

        XCTAssertTrue(urlStr.contains("x-oss-signature-version=OSS4-HMAC-SHA256"))
        XCTAssertTrue(urlStr.contains("x-oss-date=20231217T035628Z"))
        XCTAssertTrue(urlStr.contains("x-oss-expires=599"))
        XCTAssertTrue(urlStr.contains("x-oss-credential=ak%2F20231217%2Fcn-hangzhou%2Foss%2Faliyun_v4_request"))
        XCTAssertTrue(urlStr.contains("x-oss-signature=3817ac9d206cd6dfc90f1c09c00be45005602e55898f26f5ddb06d7892e1f8b5"))
        XCTAssertTrue(urlStr.contains("x-oss-security-token=token"))
        XCTAssertFalse(urlStr.contains("x-oss-additional-headers"))

        XCTAssertTrue(urlStr.contains("bucket.oss-cn-hangzhou.aliyuncs.com/1234%2B-/123/1.txt?"))
        XCTAssertTrue(urlStr.contains("%2Bparam2=&"))
        XCTAssertTrue(urlStr.contains("%2Bparam1=value3&"))
    }

    func testAuthQueryWithAdditionalHeaders() async throws {
        let credentials = Credentials(accessKeyId: "ak", accessKeySecret: "sk")
        let path = "1234+-/123/1.txt"
        let host = "http://bucket.oss-cn-hangzhou.aliyuncs.com"
        let parameters: [String: String?] = [
            "param1": "value1",
            "+param1": "value3",
            "|param1": "value4",
            "+param2": "",
            "|param2": "",
            "param2": "",
        ]
        let queries = parameters.map { k, v in
            if let name = k.urlEncode() {
                let value = v?.urlEncode()
                return "\(name)=\(value ?? "")"
            } else {
                return ""
            }
        }.joined(separator: "&")

        let uri = URL(string: "\(host)/\(path.urlEncodePath()!)?\(queries)")!

        // case 1
        var request = RequestMessage(method: "PUT", requestUri: uri)
        request.headers = [
            "x-oss-head1": "value",
            "abc": "value",
            "ZAbc": "value",
            "XYZ": "value",
            "content-type": "application/octet-stream",
        ]

        let signTime = Date(timeIntervalSince1970: 1_702_783_809.0)
        let expirationTime = Date(timeIntervalSince1970: 1_702_784_408.0)

        var signingContext = SigningContext(
            bucket: "bucket",
            key: "1234+-/123/1.txt",
            region: "cn-hangzhou",
            product: "oss",
            signTime: signTime,
            credentials: credentials,
            additionalHeaderNames: ["ZAbc", "abc"]
        )
        signingContext.expirationTime = expirationTime
        signingContext.authHeader = false
        let signer = SignerV4()
        request = try await signer.sign(request: request, signingContext: &signingContext)
        let urlStr = request.requestUri.absoluteString

        XCTAssertTrue(urlStr.contains("x-oss-signature-version=OSS4-HMAC-SHA256"))
        XCTAssertTrue(urlStr.contains("x-oss-date=20231217T033009Z"))
        XCTAssertTrue(urlStr.contains("x-oss-expires=599"))
        XCTAssertTrue(urlStr.contains("x-oss-credential=ak%2F20231217%2Fcn-hangzhou%2Foss%2Faliyun_v4_request"))
        XCTAssertTrue(urlStr.contains("x-oss-signature=6bd984bfe531afb6db1f7550983a741b103a8c58e5e14f83ea474c2322dfa2b7"))
        XCTAssertTrue(urlStr.contains("x-oss-additional-headers=abc%3Bzabc"))

        XCTAssertTrue(urlStr.contains("bucket.oss-cn-hangzhou.aliyuncs.com/1234%2B-/123/1.txt?"))
        XCTAssertTrue(urlStr.contains("%2Bparam2=&"))
        XCTAssertTrue(urlStr.contains("%2Bparam1=value3&"))

        // with default signed header
        var request1 = RequestMessage(method: "PUT", requestUri: uri)
        request1.headers = [
            "x-oss-head1": "value",
            "abc": "value",
            "ZAbc": "value",
            "XYZ": "value",
            "content-type": "application/octet-stream",
        ]

        var signingContext1 = SigningContext(
            bucket: "bucket",
            key: "1234+-/123/1.txt",
            region: "cn-hangzhou",
            product: "oss",
            signTime: signTime,
            credentials: credentials,
            additionalHeaderNames: ["x-oss-no-exist", "abc", "x-oss-head1", "ZAbc"]
        )
        signingContext1.expirationTime = expirationTime
        signingContext1.authHeader = false
        request1 = try await signer.sign(request: request, signingContext: &signingContext1)
        let urlStr1 = request1.requestUri.absoluteString

        XCTAssertTrue(urlStr1.contains("x-oss-signature-version=OSS4-HMAC-SHA256"))
        XCTAssertTrue(urlStr1.contains("x-oss-date=20231217T033009Z"))
        XCTAssertTrue(urlStr1.contains("x-oss-expires=599"))
        XCTAssertTrue(urlStr1.contains("x-oss-credential=ak%2F20231217%2Fcn-hangzhou%2Foss%2Faliyun_v4_request"))
        XCTAssertTrue(urlStr1.contains("x-oss-signature=6bd984bfe531afb6db1f7550983a741b103a8c58e5e14f83ea474c2322dfa2b7"))
        XCTAssertTrue(urlStr1.contains("x-oss-additional-headers=abc%3Bzabc"))

        XCTAssertTrue(urlStr1.contains("bucket.oss-cn-hangzhou.aliyuncs.com/1234%2B-/123/1.txt?"))
        XCTAssertTrue(urlStr1.contains("%2Bparam2=&"))
        XCTAssertTrue(urlStr1.contains("%2Bparam1=value3&"))
    }
}
