@testable import AlibabaCloudOSS
import XCTest

final class SignerV1Tests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - sign

    func testAuthHeader() async throws {
        let ak = "ak"
        let sk = "sk"
        let signTime = Date(timeIntervalSince1970: 1_672_223_261)

        let credentials = Credentials(accessKeyId: ak,
                                      accessKeySecret: sk)
        var signingContext = SigningContext(bucket: "examplebucket",
                                            key: "nelson",
                                            signTime: signTime,
                                            credentials: credentials)
        let signer = SignerV1()

        // case 1
        var uri = URL(string: "http://examplebucket.oss-cn-hangzhou.aliyuncs.com")!
        var request = RequestMessage(method: "PUT", requestUri: uri)
        request.headers["Content-MD5"] = "eB5eJF1ptWaXm4bijSPyxw=="
        request.headers["Content-Type"] = "text/html"
        request.headers["x-oss-meta-author"] = "alice"
        request.headers["x-oss-meta-magic"] = "abracadabra"
        request.headers["x-oss-date"] = "Wed, 28 Dec 2022 10:27:41 GMT"
        request = try await signer.sign(request: request,
                                        signingContext: &signingContext)
        XCTAssertEqual(request.headers["Authorization"], "OSS ak:kSHKmLxlyEAKtZPkJhG9bZb5k7M=")

        // With Signed Parameter
        uri = URL(string: "http://examplebucket.oss-cn-hangzhou.aliyuncs.com?acl")!
        request = RequestMessage(method: "PUT", requestUri: uri)
        request.headers["Content-MD5"] = "eB5eJF1ptWaXm4bijSPyxw=="
        request.headers["Content-Type"] = "text/html"
        request.headers["x-oss-meta-author"] = "alice"
        request.headers["x-oss-meta-magic"] = "abracadabra"
        request.headers["x-oss-date"] = "Wed, 28 Dec 2022 10:27:41 GMT"
        request = try await signer.sign(request: request,
                                        signingContext: &signingContext)
        XCTAssertEqual(request.headers["Authorization"], "OSS ak:/afkugFbmWDQ967j1vr6zygBLQk=")

        // With signed & non-signed Parameter & non-signed headers
        uri = URL(string: "http://examplebucket.oss-cn-hangzhou.aliyuncs.com?acl&non-resousce=123")!
        request = RequestMessage(method: "PUT", requestUri: uri)
        request.headers["Content-MD5"] = "eB5eJF1ptWaXm4bijSPyxw=="
        request.headers["Content-Type"] = "text/html"
        request.headers["x-oss-meta-author"] = "alice"
        request.headers["x-oss-meta-magic"] = "abracadabra"
        request.headers["x-oss-date"] = "Wed, 28 Dec 2022 10:27:41 GMT"
        request.headers["User-Agent"] = "test"
        request = try await signer.sign(request: request,
                                        signingContext: &signingContext)
        XCTAssertEqual(request.headers["Authorization"], "OSS ak:/afkugFbmWDQ967j1vr6zygBLQk=")

        // With sub-resource
        uri = URL(string: "http://examplebucket.oss-cn-hangzhou.aliyuncs.com?resourceGroup&non-resousce=null")!
        signingContext = SigningContext(bucket: "examplebucket",
                                        signTime: signTime,
                                        credentials: credentials,
                                        subResource: ["resourceGroup"])
        request = RequestMessage(method: "GET", requestUri: uri)
        request.headers["x-oss-date"] = "Wed, 28 Dec 2022 10:27:41 GMT"
        request = try await signer.sign(request: request,
                                        signingContext: &signingContext)
        XCTAssertEqual(request.headers["Authorization"], "OSS ak:vkQmfuUDyi1uDi3bKt67oemssIs=")
    }

    func testAuthHeaderToken() async throws {
        let ak = "ak"
        let sk = "sk"
        let token = "token"
        let signTime = Date(timeIntervalSince1970: 1_672_223_261)

        let credentials = Credentials(accessKeyId: ak,
                                      accessKeySecret: sk,
                                      securityToken: token)
        var signingContext = SigningContext(bucket: "examplebucket",
                                            key: "nelson",
                                            signTime: signTime,
                                            credentials: credentials)
        let signer = SignerV1()

        // case 1
        let uri = URL(string: "http://examplebucket.oss-cn-hangzhou.aliyuncs.com")!
        var request = RequestMessage(method: "PUT", requestUri: uri)
        request.headers["Content-MD5"] = "eB5eJF1ptWaXm4bijSPyxw=="
        request.headers["Content-Type"] = "text/html"
        request.headers["x-oss-meta-author"] = "alice"
        request.headers["x-oss-meta-magic"] = "abracadabra"
        request.headers["x-oss-date"] = "Wed, 28 Dec 2022 10:27:41 GMT"
        request = try await signer.sign(request: request,
                                        signingContext: &signingContext)
        XCTAssertEqual(request.headers["Authorization"], "OSS ak:H3PAlN3Vucn74tPVEqaQC4AnLwQ=")
        XCTAssertEqual(request.headers["x-oss-security-token"], token)
    }

    func testAuthQuery() async throws {
        let ak = "ak"
        let sk = "sk"
        let signTime = Date(timeIntervalSince1970: 1_699_807_420)

        let credentials = Credentials(accessKeyId: ak,
                                      accessKeySecret: sk)
        var signingContext = SigningContext(bucket: "bucket",
                                            key: "key",
                                            signTime: signTime,
                                            credentials: credentials,
                                            expirationTime: signTime)
        signingContext.authHeader = false
        let signer = SignerV1()

        // case 1
        let uri = URL(string: "http://bucket.oss-cn-hangzhou.aliyuncs.com/key?versionId=versionId")!
        var request = RequestMessage(method: "GET", requestUri: uri)
        request = try await signer.sign(request: request,
                                        signingContext: &signingContext)
        XCTAssertEqual(request.requestUri.queryItems?["OSSAccessKeyId"], "ak")
        XCTAssertEqual(request.requestUri.queryItems?["Expires"], "1699807420")
        XCTAssertEqual(request.requestUri.queryItems?["Signature"], "dcLTea%2BYh9ApirQ8o8dOPqtvJXQ%3D")
        XCTAssertEqual(request.requestUri.queryItems?["versionId"], "versionId")
    }

    func testAuthQueryToken() async throws {
        let ak = "ak"
        let sk = "sk"
        let token = "token"
        let signTime = Date(timeIntervalSince1970: 1_699_808_204)

        let credentials = Credentials(accessKeyId: ak,
                                      accessKeySecret: sk,
                                      securityToken: token)
        var signingContext = SigningContext(bucket: "bucket",
                                            key: "key+123",
                                            signTime: signTime,
                                            credentials: credentials,
                                            expirationTime: signTime)
        signingContext.authHeader = false
        let signer = SignerV1()

        // case 1
        let uri = URL(string: "http://bucket.oss-cn-hangzhou.aliyuncs.com/key%2B123?versionId=versionId")!
        var request = RequestMessage(method: "GET", requestUri: uri)
        request = try await signer.sign(request: request,
                                        signingContext: &signingContext)
        XCTAssertEqual(request.requestUri.queryItems?["OSSAccessKeyId"], "ak")
        XCTAssertEqual(request.requestUri.queryItems?["Expires"], "1699808204")
        XCTAssertEqual(request.requestUri.queryItems?["Signature"], "jzKYRrM5y6Br0dRFPaTGOsbrDhY%3D")
        XCTAssertEqual(request.requestUri.queryItems?["versionId"], "versionId")
        XCTAssertTrue(request.requestUri.absoluteString.contains("/key%2B123"))
    }
}

extension [URLQueryItem] {
    subscript(_ name: String) -> String? {
        get {
            if let index = firstIndex(where: { $0.name == name }) {
                return self[index].value
            }
            return nil
        }
        set {
            if let index = firstIndex(where: { $0.name == name }) {
                if let value = newValue {
                    self[index] = URLQueryItem(name: name, value: value)
                } else {
                    remove(at: index)
                }
            } else if let value = newValue {
                append(URLQueryItem(name: name, value: value))
            }
        }
    }
}
