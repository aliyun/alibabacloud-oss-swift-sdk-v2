import AlibabaCloudOSS
@testable import AlibabaCloudOSSAgentic
import XCTest

final class SerdeAgenticBucketTests: XCTestCase {
    private func bodyString(_ input: OperationInput) -> String? {
        if case let .data(data) = input.body {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    private let emptyMd5 = "1B2M2Y8AsgTpgAmY7PhCfg=="

    // MARK: - CreateAgenticBucket

    func testSerializeCreateAgenticBucket() throws {
        // no configuration -> empty body, empty-body MD5
        var input = OperationInput()
        var request = CreateAgenticBucketRequest(bucket: "prefix")
        try Serde.serializeInput(&request, &input, [serializeCreateAgenticBucket, Serde.addContentMd5])
        XCTAssertNil(input.body)
        XCTAssertEqual(input.headers["Content-MD5"], emptyMd5)

        // with configuration -> xml body, computed MD5
        input = OperationInput()
        request = CreateAgenticBucketRequest(
            bucket: "prefix",
            createAgenticBucketConfiguration: CreateAgenticBucketConfiguration(
                storageClass: "IA",
                dataRedundancyType: "ZRS"
            )
        )
        try Serde.serializeInput(&request, &input, [serializeCreateAgenticBucket, Serde.addContentMd5])
        let body = bodyString(input)
        XCTAssertNotNil(body)
        XCTAssertTrue(body!.contains("<CreateAgenticBucketConfiguration>"))
        XCTAssertTrue(body!.contains("<StorageClass>IA</StorageClass>"))
        XCTAssertTrue(body!.contains("<DataRedundancyType>ZRS</DataRedundancyType>"))
        XCTAssertNotNil(input.headers["Content-MD5"])
        XCTAssertNotEqual(input.headers["Content-MD5"], emptyMd5)
    }

    func testDeserializeCreateAgenticBucket() throws {
        var output = OperationOutput(statusCode: 200, headers: ["x-oss-request-id": "id"])
        var result = CreateAgenticBucketResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [deserializeCreateAgenticBucket]))
        XCTAssertEqual(result.commonProp.statusCode, 200)
    }

    // MARK: - DeleteAgenticBucket

    func testSerializeDeleteAgenticBucket() throws {
        var input = OperationInput()
        var request = DeleteAgenticBucketRequest(bucket: "prefix")
        try Serde.serializeInput(&request, &input, [serializeDeleteAgenticBucket, Serde.addContentMd5])
        XCTAssertNil(input.body)
        XCTAssertEqual(input.headers["Content-MD5"], emptyMd5)
    }

    // MARK: - GetAgenticBucket

    func testSerializeGetAgenticBucket() throws {
        var input = OperationInput()
        var request = GetAgenticBucketRequest(bucket: "prefix")
        try Serde.serializeInput(&request, &input, [serializeGetAgenticBucket, Serde.addContentMd5])
        XCTAssertEqual(input.headers["Content-MD5"], emptyMd5)
    }

    func testDeserializeGetAgenticBucket() throws {
        // malformed body throws
        var output = OperationOutput(statusCode: 200, headers: [:],
                                     body: .data("<a></a>".data(using: .utf8)!))
        var result = GetAgenticBucketResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [deserializeGetAgenticBucket]))

        // nil body throws
        output = OperationOutput(statusCode: 200, headers: [:])
        result = GetAgenticBucketResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [deserializeGetAgenticBucket]))

        // normal, with nested SSE
        var xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
        xml.append("<AgenticBucketInfo>")
        xml.append("<Name>prefix-137-cn-hangzhou-ab-apsr</Name>")
        xml.append("<Owner>137</Owner>")
        xml.append("<Region>cn-hangzhou</Region>")
        xml.append("<StorageClass>Standard</StorageClass>")
        xml.append("<DataRedundancyType>LRS</DataRedundancyType>")
        xml.append("<Status>Enabled</Status>")
        xml.append("<BucketResourceType>agentic</BucketResourceType>")
        xml.append("<CreateTime>2024-01-01T00:00:00.000Z</CreateTime>")
        xml.append("<ACL>private</ACL>")
        xml.append("<PublicAccessBlock>true</PublicAccessBlock>")
        xml.append("<ServerSideEncryptionRule>")
        xml.append("<ApplyServerSideEncryptionByDefault>")
        xml.append("<SSEAlgorithm>KMS</SSEAlgorithm>")
        xml.append("<KMSMasterKeyID>key-123</KMSMasterKeyID>")
        xml.append("<KMSDataEncryption>SM4</KMSDataEncryption>")
        xml.append("</ApplyServerSideEncryptionByDefault>")
        xml.append("</ServerSideEncryptionRule>")
        xml.append("<Versioning>Enabled</Versioning>")
        xml.append("<BucketPolicy>{}</BucketPolicy>")
        xml.append("</AgenticBucketInfo>")
        output = OperationOutput(statusCode: 200, headers: [:], body: .data(xml.data(using: .utf8)!))
        result = GetAgenticBucketResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [deserializeGetAgenticBucket]))
        let info = result.agenticBucketInfo
        XCTAssertEqual(info?.name, "prefix-137-cn-hangzhou-ab-apsr")
        XCTAssertEqual(info?.owner, "137")
        XCTAssertEqual(info?.region, "cn-hangzhou")
        XCTAssertEqual(info?.storageClass, "Standard")
        XCTAssertEqual(info?.dataRedundancyType, "LRS")
        XCTAssertEqual(info?.status, "Enabled")
        XCTAssertEqual(info?.bucketResourceType, "agentic")
        XCTAssertEqual(info?.createTime, "2024-01-01T00:00:00.000Z")
        XCTAssertEqual(info?.acl, "private")
        XCTAssertEqual(info?.publicAccessBlock, "true")
        XCTAssertEqual(info?.serverSideEncryptionRule?.sSEAlgorithm, "KMS")
        XCTAssertEqual(info?.serverSideEncryptionRule?.kMSMasterKeyID, "key-123")
        XCTAssertEqual(info?.serverSideEncryptionRule?.kMSDataEncryption, "SM4")
        XCTAssertEqual(info?.versioning, "Enabled")
        XCTAssertEqual(info?.bucketPolicy, "{}")
    }

    // MARK: - ListAgenticBuckets

    func testSerializeListAgenticBuckets() throws {
        var input = OperationInput()
        var request = ListAgenticBucketsRequest()
        try Serde.serializeInput(&request, &input, [serializeListAgenticBuckets, Serde.addContentMd5])
        XCTAssertNil(input.parameters["continuation-token"] as Any?)
        XCTAssertNil(input.parameters["max-keys"] as Any?)
        XCTAssertEqual(input.headers["Content-MD5"], emptyMd5)

        input = OperationInput()
        request = ListAgenticBucketsRequest(continuationToken: "token", maxKeys: 50)
        try Serde.serializeInput(&request, &input, [serializeListAgenticBuckets, Serde.addContentMd5])
        XCTAssertEqual(input.parameters["continuation-token"], "token")
        XCTAssertEqual(input.parameters["max-keys"], "50")
    }

    func testDeserializeListAgenticBuckets() throws {
        // malformed body throws
        var output = OperationOutput(statusCode: 200, headers: [:],
                                     body: .data("<a></a>".data(using: .utf8)!))
        var result = ListAgenticBucketsResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [deserializeListAgenticBuckets]))

        // multiple items
        var xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
        xml.append("<ListAgenticBucketsResult>")
        xml.append("<Region>cn-hangzhou</Region>")
        xml.append("<Owner>137</Owner>")
        xml.append("<ContinuationToken></ContinuationToken>")
        xml.append("<NextContinuationToken>next</NextContinuationToken>")
        xml.append("<IsTruncated>true</IsTruncated>")
        xml.append("<AgenticBuckets>")
        xml.append("<AgenticBucket><Name>a</Name><StorageClass>Standard</StorageClass><DataRedundancyType>LRS</DataRedundancyType><CreateTime>2024-01-01T00:00:00.000Z</CreateTime></AgenticBucket>")
        xml.append("<AgenticBucket><Name>b</Name><StorageClass>IA</StorageClass><DataRedundancyType>ZRS</DataRedundancyType><CreateTime>2024-01-02T00:00:00.000Z</CreateTime></AgenticBucket>")
        xml.append("</AgenticBuckets>")
        xml.append("</ListAgenticBucketsResult>")
        output = OperationOutput(statusCode: 200, headers: [:], body: .data(xml.data(using: .utf8)!))
        result = ListAgenticBucketsResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [deserializeListAgenticBuckets]))
        XCTAssertEqual(result.region, "cn-hangzhou")
        XCTAssertEqual(result.owner, "137")
        XCTAssertEqual(result.nextContinuationToken, "next")
        XCTAssertEqual(result.isTruncated, true)
        XCTAssertEqual(result.agenticBuckets?.count, 2)
        XCTAssertEqual(result.agenticBuckets?[0].name, "a")
        XCTAssertEqual(result.agenticBuckets?[1].storageClass, "IA")

        // single item
        xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
        xml.append("<ListAgenticBucketsResult>")
        xml.append("<IsTruncated>false</IsTruncated>")
        xml.append("<AgenticBuckets>")
        xml.append("<AgenticBucket><Name>only</Name><StorageClass>Standard</StorageClass></AgenticBucket>")
        xml.append("</AgenticBuckets>")
        xml.append("</ListAgenticBucketsResult>")
        output = OperationOutput(statusCode: 200, headers: [:], body: .data(xml.data(using: .utf8)!))
        result = ListAgenticBucketsResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [deserializeListAgenticBuckets]))
        XCTAssertEqual(result.isTruncated, false)
        XCTAssertEqual(result.agenticBuckets?.count, 1)
        XCTAssertEqual(result.agenticBuckets?[0].name, "only")
    }

    // MARK: - PutAgenticBucketStatus

    func testSerializePutAgenticBucketStatus() throws {
        var input = OperationInput()
        var request = PutAgenticBucketStatusRequest(bucket: "prefix", status: "Disabled")
        try Serde.serializeInput(&request, &input, [serializePutAgenticBucketStatus, Serde.addContentMd5])
        let body = bodyString(input)
        XCTAssertNotNil(body)
        XCTAssertTrue(body!.contains("<AgenticBucketStatus>"))
        XCTAssertTrue(body!.contains("<Status>Disabled</Status>"))
        XCTAssertNotNil(input.headers["Content-MD5"])

        // no status -> empty body
        input = OperationInput()
        request = PutAgenticBucketStatusRequest(bucket: "prefix")
        try Serde.serializeInput(&request, &input, [serializePutAgenticBucketStatus, Serde.addContentMd5])
        XCTAssertNil(input.body)
        XCTAssertEqual(input.headers["Content-MD5"], emptyMd5)
    }

    // MARK: - ListBucketSpaces

    func testSerializeListBucketSpaces() throws {
        var input = OperationInput()
        var request = ListBucketSpacesRequest(bucket: "prefix")
        try Serde.serializeInput(&request, &input, [serializeListBucketSpaces, Serde.addContentMd5])
        XCTAssertNil(input.parameters["prefix"] as Any?)
        XCTAssertNil(input.parameters["continuation-token"] as Any?)
        XCTAssertNil(input.parameters["max-keys"] as Any?)
        XCTAssertEqual(input.headers["Content-MD5"], emptyMd5)

        input = OperationInput()
        request = ListBucketSpacesRequest(bucket: "prefix", prefix: "foo", continuationToken: "token", startAfter: "space-0", maxKeys: 20)
        try Serde.serializeInput(&request, &input, [serializeListBucketSpaces, Serde.addContentMd5])
        XCTAssertEqual(input.parameters["prefix"], "foo")
        XCTAssertEqual(input.parameters["continuation-token"], "token")
        XCTAssertEqual(input.parameters["start-after"], "space-0")
        XCTAssertEqual(input.parameters["max-keys"], "20")
    }

    func testDeserializeListBucketSpaces() throws {
        // malformed body throws
        var output = OperationOutput(statusCode: 200, headers: [:],
                                     body: .data("<a></a>".data(using: .utf8)!))
        var result = ListBucketSpacesResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [deserializeListBucketSpaces]))

        // normal, nested owner, multiple spaces
        var xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
        xml.append("<ListBucketSpacesResult>")
        xml.append("<Owner><ID>137</ID><DisplayName>acct</DisplayName></Owner>")
        xml.append("<Prefix>foo</Prefix>")
        xml.append("<MaxKeys>100</MaxKeys>")
        xml.append("<ContinuationToken></ContinuationToken>")
        xml.append("<NextContinuationToken>next</NextContinuationToken>")
        xml.append("<StartAfter>space-0</StartAfter>")
        xml.append("<IsTruncated>true</IsTruncated>")
        xml.append("<BucketSpaces>")
        xml.append("<BucketSpace><Name>s1</Name><Location>oss-cn-hangzhou</Location><CreationDate>2024-01-01T00:00:00.000Z</CreationDate><StorageClass>Standard</StorageClass></BucketSpace>")
        xml.append("<BucketSpace><Name>s2</Name><Location>oss-cn-hangzhou</Location><CreationDate>2024-01-02T00:00:00.000Z</CreationDate><StorageClass>IA</StorageClass></BucketSpace>")
        xml.append("</BucketSpaces>")
        xml.append("</ListBucketSpacesResult>")
        output = OperationOutput(statusCode: 200, headers: [:], body: .data(xml.data(using: .utf8)!))
        result = ListBucketSpacesResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [deserializeListBucketSpaces]))
        XCTAssertEqual(result.owner?.id, "137")
        XCTAssertEqual(result.owner?.displayName, "acct")
        XCTAssertEqual(result.prefix, "foo")
        XCTAssertEqual(result.maxKeys, 100)
        XCTAssertEqual(result.nextContinuationToken, "next")
        XCTAssertEqual(result.startAfter, "space-0")
        XCTAssertEqual(result.isTruncated, true)
        XCTAssertEqual(result.bucketSpaces?.count, 2)
        XCTAssertEqual(result.bucketSpaces?[0].name, "s1")
        XCTAssertEqual(result.bucketSpaces?[1].storageClass, "IA")

        // single space
        xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
        xml.append("<ListBucketSpacesResult>")
        xml.append("<IsTruncated>false</IsTruncated>")
        xml.append("<BucketSpaces>")
        xml.append("<BucketSpace><Name>only</Name><Location>oss-cn-hangzhou</Location></BucketSpace>")
        xml.append("</BucketSpaces>")
        xml.append("</ListBucketSpacesResult>")
        output = OperationOutput(statusCode: 200, headers: [:], body: .data(xml.data(using: .utf8)!))
        result = ListBucketSpacesResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [deserializeListBucketSpaces]))
        XCTAssertEqual(result.isTruncated, false)
        XCTAssertEqual(result.bucketSpaces?.count, 1)
        XCTAssertEqual(result.bucketSpaces?[0].name, "only")
    }
}
