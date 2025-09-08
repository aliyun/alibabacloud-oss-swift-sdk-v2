import AlibabaCloudOSS
import Crypto
import XCTest

private struct SignatureImpl: SignatureDelegate {
    public func signature(info: [String: String]) async throws -> [String: String] {
        let region = info["region"] ?? ""
        let product = info["product"] ?? ""
        let date = info["date"] ?? ""
        let stringToSign = info["stringToSign"] ?? ""

        // setp 2
        let accessKeySecret = "sk"
        let sigingKey = calcSigningKey(
            accessKeySecret: accessKeySecret,
            region: region,
            product: product,
            date: date
        )

        // setp 3
        let signature = calcSignature(signingKey: sigingKey, signToString: stringToSign)

        return [
            "signature": signature,
        ]
    }

    func calcSigningKey(accessKeySecret: String, region: String, product: String, date: String) -> SymmetricKey {
        let kDate = HMAC<SHA256>.authenticationCode(
            for: date.data(using: .utf8)!,
            using: SymmetricKey(data: Array("aliyun_v4\(accessKeySecret)".utf8))
        )
        let kRegion = HMAC<SHA256>.authenticationCode(for: region.data(using: .utf8)!, using: SymmetricKey(data: kDate))
        let kProduct = HMAC<SHA256>.authenticationCode(for: product.data(using: .utf8)!, using: SymmetricKey(data: kRegion))
        let kSigning = HMAC<SHA256>.authenticationCode(for: [UInt8]("aliyun_v4_request".utf8), using: SymmetricKey(data: kProduct))
        return SymmetricKey(data: kSigning)
    }

    func calcSignature(signingKey: SymmetricKey, signToString: String) -> String {
        let kSignature = HMAC<SHA256>.authenticationCode(
            for: signToString.data(using: .utf8)!,
            using: signingKey
        )
        return kSignature.compactMap { String(format: "%02x", $0) }.joined()
    }
}

class RemoteSignerV4Tests: XCTestCase {
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
        let signer = RemoteSignerV4(delegate: SignatureImpl())
        request = try await signer.sign(request: request, signingContext: &signingContext)
        let urlStr = request.requestUri.absoluteString

        let authPat = "OSS4-HMAC-SHA256 Credential=ak/20231216/cn-hangzhou/oss/aliyun_v4_request,Signature=e21d18daa82167720f9b1047ae7e7f1ce7cb77a31e8203a7d5f4624fa0284afe"
        XCTAssertEqual(authPat, request.headers["Authorization"]!)

        XCTAssertTrue(urlStr.contains("bucket.oss-cn-hangzhou.aliyuncs.com/1234%2B-/123/1.txt?"))
        XCTAssertTrue(urlStr.contains("%2Bparam2="))
        XCTAssertTrue(urlStr.contains("%2Bparam1=value3"))
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
        let signer = RemoteSignerV4(delegate: SignatureImpl())
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
}
