
import AlibabaCloudOSS
import AlibabaCloudOSSExtension
import Crypto
import XCTest
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

public class BaseTestCase: XCTestCase {
    private let _endpoint: String = "" // your endpoint
    private let _region: String = "" // your region
    private let _accessKeyId: String = "" // your access key id
    private let _accessKeySecret: String = "" // your access key secret
    private let _ramRoleArn: String = "" // the ram role arn
    private let _userId: String = "" // the uid

    private var _client: Client? = nil
    private var _invalidClient: Client? = nil

    let bucketNamePrefix = "swift-sdk-test-bucket-"
    let objectNamePrefix = "swift-sdk-test-object-"
    let fileNamePrefix = "swift-sdk-test-file-"

    let tempDir = NSTemporaryDirectory() + "swift-sdk-test_" + NSUUID().uuidString
    #if os(Windows)
        let pathSeparator = "\\"
    #else
        let pathSeparator = "/"
    #endif

    var endpoint: String {
        if !_endpoint.isEmpty {
            return _endpoint
        }
        return ProcessInfo.processInfo.environment["OSS_TEST_ENDPOINT"] ?? ""
    }

    var region: String {
        if !_region.isEmpty {
            return _region
        }
        return ProcessInfo.processInfo.environment["OSS_TEST_REGION"] ?? ""
    }

    var accessKeyId: String {
        if !_accessKeyId.isEmpty {
            return _accessKeyId
        }
        return ProcessInfo.processInfo.environment["OSS_TEST_ACCESS_KEY_ID"] ?? ""
    }

    var accessKeySecret: String {
        if !_accessKeySecret.isEmpty {
            return _accessKeySecret
        }
        return ProcessInfo.processInfo.environment["OSS_TEST_ACCESS_KEY_SECRET"] ?? ""
    }

    var ramRoleArn: String {
        if !_ramRoleArn.isEmpty {
            return _ramRoleArn
        }
        return ProcessInfo.processInfo.environment["OSS_TEST_RAM_ROLE_ARN"] ?? ""
    }

    var userId: String {
        if !_userId.isEmpty {
            return _userId
        }
        return ProcessInfo.processInfo.environment["OSS_TEST_USER_ID"] ?? ""
    }

    var payerAccessKeyId: String {
        return ProcessInfo.processInfo.environment["OSS_TEST_PAYER_ACCESS_KEY_ID"] ?? ""
    }

    var payerAccessKeySecret: String {
        return ProcessInfo.processInfo.environment["OSS_TEST_PAYER_ACCESS_KEY_SECRET"] ?? ""
    }

    var payerUid: String {
        return ProcessInfo.processInfo.environment["OSS_TEST_PAYER_UID"] ?? ""
    }

    var callback: String {
        return ProcessInfo.processInfo.environment["OSS_TEST_CALLBACK_URL"] ?? ""
    }


    var bucketName = "object-extension-test-\(Int(Date().timeIntervalSince1970))"

    var client: Client?

    override public func setUp() async throws {
        try await super.setUp()
    }

    override public func tearDown() async throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try await cleanBuckets(bucketNamePrefix)
    }

    public func getDefaultClient() -> Client {
        if _client != nil {
            return _client!
        }

        let credentialsProvider = StaticCredentialsProvider(
            accessKeyId: accessKeyId,
            accessKeySecret: accessKeySecret
        )
        let config = Configuration.default()
        config.withCredentialsProvider(credentialsProvider)
        config.withEndpoint(endpoint)
        config.withRegion(region)
#if canImport(os)
        config.withLogger(LogAgentOSLog(level: .debug))
#endif

        _client = Client(config)

        return _client!
    }

    public func getClient(_ region: String, _ endpoint: String) -> Client {
        let credentialsProvider = StaticCredentialsProvider(
            accessKeyId: accessKeyId,
            accessKeySecret: accessKeySecret
        )
        let config = Configuration.default()
        config.withCredentialsProvider(credentialsProvider)
        config.withEndpoint(endpoint)
        config.withRegion(region)

        return Client(config)
    }

    public func getInvalidAkClient() -> Client {
        if _invalidClient != nil {
            return _invalidClient!
        }

        let credentialsProvider = StaticCredentialsProvider(
            accessKeyId: "invalid-ak",
            accessKeySecret: "invalid-sk"
        )
        let config = Configuration.default()
        config.withCredentialsProvider(credentialsProvider)
        config.withEndpoint(endpoint)
        config.withRegion(region)

        _invalidClient = Client(config)

        return _invalidClient!
    }

    static let random_str_char = "abcdefghijklmnopqrstuvwxyz"
    public func randomStr(_ length: Int) -> String {
        var ranStr = ""
        for _ in 0 ..< length {
            let index = Int.random(in: 0 ..< BaseTestCase.random_str_char.count)
            ranStr.append(BaseTestCase.random_str_char[BaseTestCase.random_str_char.index(BaseTestCase.random_str_char.startIndex, offsetBy: index)])
        }
        return ranStr
    }

    public func randomBucketName() -> String {
        let ranStr = randomStr(6)
        return "\(bucketNamePrefix)\(ranStr)-\(Int(Date().timeIntervalSince1970))"
    }

    public func randomObjectName() -> String {
        let ranStr = randomStr(6)
        return "\(objectNamePrefix)\(ranStr)-\(Int(Date().timeIntervalSince1970))"
    }

    public func randomFileName() -> String {
        let ranStr = randomStr(6)
        return "\(fileNamePrefix)\(ranStr)-\(Int(Date().timeIntervalSince1970))"
    }

    public func createBucket(client: Client, bucket: String) async throws {
        let putBucketRequest = PutBucketRequest(bucket: bucket)
        let _ = try await client.putBucket(putBucketRequest)
    }

    public func cleanBuckets(_ prefix: String) async throws {
        var listBucketsRequest = ListBucketsRequest()
        listBucketsRequest.prefix = prefix
        let listBucketsResult = try await client?.listBuckets(listBucketsRequest)

        if let buckets = listBucketsResult?.buckets {
            for bucket in buckets {
                try await cleanBucket(bucket)
            }
        }
    }

    public func cleanBucket(_ bucket: BucketSummary) async throws {
        guard let region = bucket.region,
              let endpoint = bucket.extranetEndpoint
        else {
            return
        }
        let client = getClient(region, endpoint)

        try await cleanBucket(client: client, bucket: bucket.name!)
    }

    func cleanBucket(client: Client, bucket: String) async throws {
        // delete version
        let listVersionRequest = ListObjectVersionsRequest(bucket: bucket)
        let listVersionResult = try await client.listObjectVersions(listVersionRequest)
        if let versions = listVersionResult.versions {
            var objects: [DeleteObject] = []
            for version in versions {
                let object = DeleteObject(key: version.key, versionId: version.versionId)
                objects.append(object)
            }
            let deleteRequest = DeleteMultipleObjectsRequest(bucket: bucket, objects: objects)
            try await assertNoThrow(await client.deleteMultipleObjects(deleteRequest))
        }
        if let deleteMarkers = listVersionResult.deleteMarkers {
            var objects: [DeleteObject] = []
            for deleteMarker in deleteMarkers {
                let object = DeleteObject(key: deleteMarker.key, versionId: deleteMarker.versionId)
                objects.append(object)
            }
            let deleteRequest = DeleteMultipleObjectsRequest(bucket: bucket, objects: objects)
            try await assertNoThrow(await client.deleteMultipleObjects(deleteRequest))
        }

        // delete object
        let listRequest = ListObjectsV2Request(bucket: bucket)
        let result = try await client.listObjectsV2(listRequest)

        if let contents = result.contents {
            var objects: [DeleteObject] = []
            for content in contents {
                let object = DeleteObject(key: content.key)
                objects.append(object)
            }
            let deleteRequest = DeleteMultipleObjectsRequest(bucket: bucket, objects: objects)
            try await assertNoThrow(await client.deleteMultipleObjects(deleteRequest))
        }

        // delete uploads
        let listUploadsRequest = ListMultipartUploadsRequest(bucket: bucket)
        let listResult = try await client.listMultipartUploads(listUploadsRequest)

        if let uploads = listResult.uploads {
            for upload in uploads {
                let abortRequest = AbortMultipartUploadRequest(bucket: bucket,
                                                               key: upload.key,
                                                               uploadId: upload.uploadId)
                try await assertNoThrow(await client.abortMultipartUpload(abortRequest))
            }
        }

        // delete bucket
        let deleteBucketRequest = DeleteBucketRequest(bucket: bucket)
        let _ = try await client.deleteBucket(deleteBucketRequest)
    }

    func createTestFile(_ fileName: String, _ contents: Data) -> String? {
        do {
            let path = "\(tempDir)\(pathSeparator)\(fileName)"
            try FileManager.default.createDirectory(atPath: tempDir, withIntermediateDirectories: false, attributes: nil)
            if FileManager.default.createFile(atPath: path, contents: contents, attributes: nil) {
                return path
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }

    @nonobjc
    func createTestFile(_ fileName: String, _ size: Int) -> String? {
        do {
            let path = "\(tempDir)\(pathSeparator)\(fileName)"
            try FileManager.default.createDirectory(atPath: tempDir, withIntermediateDirectories: false, attributes: nil)
            let contents = randomStr(size).data(using: .utf8)
            if FileManager.default.createFile(atPath: path, contents: contents, attributes: nil) {
                return path
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }

    func removeTestFile(_ location: String) {
        try? FileManager.default.removeItem(atPath: location)
    }
}

struct RamRoleArnCredentialProvider: CredentialsProvider {
    
    private var roleSessionName: String
    private var regionId: String
    private var durationSeconds: Int
    private let accessKeyId: String
    private let accessKeySecret: String

    private var roleArn: String
    private var policy: String?

    public init(
        accessKeyId: String,
        accessKeySecret: String,
        roleArn: String,
        regionId: String,
        policy: String? = nil,
        roleSessionName: String = "defaultSessionName",
        durationSeconds: Int = 3600
    ) {
        self.accessKeyId = accessKeyId
        self.accessKeySecret = accessKeySecret
        self.roleArn = roleArn
        self.regionId = regionId
        self.policy = policy
        self.roleSessionName =  roleSessionName
        self.durationSeconds = durationSeconds
    }

    public func getCredentials() async throws -> AlibabaCloudOSS.Credentials {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        var params: [URLQueryItem] = []
        params.append(URLQueryItem(name: "Action", value: "AssumeRole"))
        params.append(URLQueryItem(name: "Format", value: "JSON"))
        params.append(URLQueryItem(name: "Version", value: "2015-04-01"))
        params.append(URLQueryItem(name: "DurationSeconds", value: "\(durationSeconds)"))
        params.append(URLQueryItem(name: "RoleArn", value: roleArn))
        params.append(URLQueryItem(name: "AccessKeyId", value: accessKeyId))
        params.append(URLQueryItem(name: "RegionId", value: regionId))
        params.append(URLQueryItem(name: "RoleSessionName", value: roleSessionName))
        params.append(URLQueryItem(name: "SignatureVersion", value: "1.0"))
        params.append(URLQueryItem(name: "SignatureMethod", value: "HMAC-SHA1"))
        params.append(URLQueryItem(name: "Timestamp", value: dateFormatter.string(from: Date())))
        params.append(URLQueryItem(name: "SignatureNonce", value: (String(TimeInterval(Date().timeIntervalSince1970)) + UUID().uuidString).data(using: .utf8)?.calculateMd5().compactMap { String(format: "%02x", $0) }.joined()))
        if let policy = policy {
            params.append(URLQueryItem(name: "Policy", value: policy))
        }

        let stringToSign = "GET&%2F&".appending(
            params.compactMap {
                if let value = $0.value?.urlEncode(),
                   !value.isEmpty {
                    return "\($0.name)=\(value)".urlEncode()
                }
                return nil
            }.sorted(by: <).joined(separator: "%26")
        )
        
        let signature = Data(HMAC<Insecure.SHA1>.authenticationCode(for: stringToSign.data(using: .utf8)!, using: SymmetricKey(data: (accessKeySecret + "&").data(using: .utf8)!)))
        params.append(URLQueryItem(name: "Signature", value: signature.base64EncodedString()))

        do {
            var components = URLComponents(string: "https://sts.aliyuncs.com")
            components?.queryItems = params
            
            var request = URLRequest(url: components!.url!)
            request.httpMethod = "GET"
            request.setValue("sts.aliyuncs.com", forHTTPHeaderField: "host")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            if let object = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.init(rawValue: 0))) as? [String: Any] ,
               let credentials = object["Credentials"] as? [String: String] {
                if let accessKey = credentials["AccessKeyId"],
                   let secretKey = credentials["AccessKeySecret"],
                   let expirationTime = credentials["Expiration"],
                   let token = credentials["SecurityToken"] {
                    let credentials = Credentials(accessKeyId: accessKey,
                                                  accessKeySecret: secretKey,
                                                  securityToken: token,
                                                  expiration: dateFormatter.date(from: expirationTime))
                    return credentials
                }
            }
            throw ClientError.credentialsFetchError()
        } catch {
            throw ClientError.credentialsFetchError(innerError: error)
        }
    }
    
}

func assertThrowsAsyncError<T>(
    _ expression: @autoclosure () async throws -> T,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line,
    _ errorHandler: (_ error: Error) -> Void = { _ in }
) async {
    do {
        _ = try await expression()
        // expected error to be thrown, but it was not
        let customMessage = message()
        if customMessage.isEmpty {
            XCTFail("Asynchronous call did not throw an error.", file: file, line: line)
        } else {
            XCTFail(customMessage, file: file, line: line)
        }
    } catch {
        errorHandler(error)
    }
}

func assertNoThrow<T>(
    _ expression: @autoclosure () async throws -> T,
    file: StaticString = #filePath,
    line: UInt = #line
) async {
    do {
        _ = try await expression()
    } catch {
        XCTFail("Throw an error.", file: file, line: line)
    }
}

let FileDir: String = NSTemporaryDirectory()

enum FileName: String {
    case small
    case middle
    case big
    case picture

    func filePath() -> String {
        return FileDir.appending(rawValue)
    }

    func fileUrl() -> URL {
        return URL(fileURLWithPath: FileDir.appending(rawValue))
    }
}

actor ArrayActor<T> {
    public private(set) var elements: [T] = []

    func append(_ element: T) {
        elements.append(element)
    }
}
