@testable import AlibabaCloudOSS
import XCTest

class SerdeBucketBasicTests: XCTestCase {
    func testDeserializeGetBucketStat() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = GetBucketStatResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketStat]))

        // body is unexpected
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data("<a></a>".data(using: .utf8)!))
        result = GetBucketStatResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketStat]))

        // normal
        let storage = 1600
        let objectCount = 230
        let multipartUploadCount = 40
        let liveChannelCount = 4
        let lastModifiedTime = 1_643_341_269
        let standardStorage = 430
        let standardObjectCount = 66
        let infrequentAccessStorage = 2_359_296
        let infrequentAccessRealStorage = 360
        let infrequentAccessObjectCount = 54
        let archiveStorage = 2_949_120
        let archiveRealStorage = 450
        let archiveObjectCount = 74
        let coldArchiveStorage = 2_359_296
        let coldArchiveRealStorage = 360
        let coldArchiveObjectCount = 36
        let deepColdArchiveStorage = 2_359_296
        let deepColdArchiveRealStorage = 360
        let deepColdArchiveObjectCount = 36
        let deleteMarkerCount = 12
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <BucketStat>
          <Storage>\(storage)</Storage>
          <ObjectCount>\(objectCount)</ObjectCount>
          <MultipartUploadCount>\(multipartUploadCount)</MultipartUploadCount>
          <LiveChannelCount>\(liveChannelCount)</LiveChannelCount>
          <LastModifiedTime>\(lastModifiedTime)</LastModifiedTime>
          <StandardStorage>\(standardStorage)</StandardStorage>
          <StandardObjectCount>\(standardObjectCount)</StandardObjectCount>
          <InfrequentAccessStorage>\(infrequentAccessStorage)</InfrequentAccessStorage>
          <InfrequentAccessRealStorage>\(infrequentAccessRealStorage)</InfrequentAccessRealStorage>
          <InfrequentAccessObjectCount>\(infrequentAccessObjectCount)</InfrequentAccessObjectCount>
          <ArchiveStorage>\(archiveStorage)</ArchiveStorage>
          <ArchiveRealStorage>\(archiveRealStorage)</ArchiveRealStorage>
          <ArchiveObjectCount>\(archiveObjectCount)</ArchiveObjectCount>
          <ColdArchiveStorage>\(coldArchiveStorage)</ColdArchiveStorage>
          <ColdArchiveRealStorage>\(coldArchiveRealStorage)</ColdArchiveRealStorage>
          <ColdArchiveObjectCount>\(coldArchiveObjectCount)</ColdArchiveObjectCount>
          <DeleteMarkerCount>\(deleteMarkerCount)</DeleteMarkerCount>
          <DeepColdArchiveStorage>\(deepColdArchiveStorage)</DeepColdArchiveStorage>
          <DeepColdArchiveRealStorage>\(deepColdArchiveRealStorage)</DeepColdArchiveRealStorage>
          <DeepColdArchiveObjectCount>\(deepColdArchiveObjectCount)</DeepColdArchiveObjectCount>
        </BucketStat>
        """.trim()

        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = GetBucketStatResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketStat]))
        XCTAssertEqual(result.bucketStat?.storage, storage)
        XCTAssertEqual(result.bucketStat?.objectCount, objectCount)
        XCTAssertEqual(result.bucketStat?.multipartUploadCount, multipartUploadCount)
        XCTAssertEqual(result.bucketStat?.liveChannelCount, liveChannelCount)
        XCTAssertEqual(result.bucketStat?.lastModifiedTime, lastModifiedTime)
        XCTAssertEqual(result.bucketStat?.standardStorage, standardStorage)
        XCTAssertEqual(result.bucketStat?.standardObjectCount, standardObjectCount)
        XCTAssertEqual(result.bucketStat?.infrequentAccessStorage, infrequentAccessStorage)
        XCTAssertEqual(result.bucketStat?.infrequentAccessRealStorage, infrequentAccessRealStorage)
        XCTAssertEqual(result.bucketStat?.infrequentAccessObjectCount, infrequentAccessObjectCount)
        XCTAssertEqual(result.bucketStat?.archiveStorage, archiveStorage)
        XCTAssertEqual(result.bucketStat?.archiveRealStorage, archiveRealStorage)
        XCTAssertEqual(result.bucketStat?.archiveObjectCount, archiveObjectCount)
        XCTAssertEqual(result.bucketStat?.coldArchiveStorage, coldArchiveStorage)
        XCTAssertEqual(result.bucketStat?.coldArchiveRealStorage, coldArchiveRealStorage)
        XCTAssertEqual(result.bucketStat?.coldArchiveObjectCount, coldArchiveObjectCount)
        XCTAssertEqual(result.bucketStat?.deleteMarkerCount, deleteMarkerCount)
        XCTAssertEqual(result.bucketStat?.deepColdArchiveStorage, deepColdArchiveStorage)
        XCTAssertEqual(result.bucketStat?.deepColdArchiveRealStorage, deepColdArchiveRealStorage)
        XCTAssertEqual(result.bucketStat?.deepColdArchiveObjectCount, deepColdArchiveObjectCount)
    }

    func testSerializePutBucket() throws {
        var input = OperationInput()
        let acl = "private"
        let resourceGroupId = "resourceGroupId"
        let bucketTagging = "bucketTagging"
        let storageClass = "Archive"
        let dataRedundancyType = "ZRS"

        var request = PutBucketRequest()
        try Serde.serializeInput(&request, &input, [Serde.serializePutBucket])
        XCTAssertNil(input.headers["x-oss-acl"])
        XCTAssertNil(input.headers["x-oss-resource-group-id"])
        XCTAssertNil(input.headers["x-oss-bucket-tagging"])
        XCTAssertNil(input.headers["x-oss-agentic-bucket"])
        XCTAssertNil(input.body)

        let agenticBucket = "my-agentic-bucket"

        request = PutBucketRequest()
        request.acl = acl
        request.resourceGroupId = resourceGroupId
        request.bucketTagging = bucketTagging
        request.agenticBucket = agenticBucket

        var createBucketConfiguration = CreateBucketConfiguration()
        createBucketConfiguration.storageClass = storageClass
        createBucketConfiguration.dataRedundancyType = dataRedundancyType
        request.createBucketConfiguration = createBucketConfiguration

        try Serde.serializeInput(&request, &input, [Serde.serializePutBucket])
        XCTAssertEqual(input.headers["x-oss-acl"], acl)
        XCTAssertEqual(input.headers["x-oss-resource-group-id"], resourceGroupId)
        XCTAssertEqual(input.headers["x-oss-bucket-tagging"], bucketTagging)
        XCTAssertEqual(input.headers["x-oss-agentic-bucket"], agenticBucket)
        XCTAssertEqual(try input.body?.readData()?.base64EncodedString(),
                       "<?xml version=\"1.0\" encoding=\"UTF-8\"?><CreateBucketConfiguration><StorageClass>\(storageClass)</StorageClass><DataRedundancyType>\(dataRedundancyType)</DataRedundancyType></CreateBucketConfiguration>".trim().data(using: .utf8)?.base64EncodedString())
    }

    func testSerializeListObjects() throws {
        var input = OperationInput()

        var request = ListObjectsRequest()
        try Serde.serializeInput(&request, &input, [Serde.serializeListObjects])
        XCTAssertNil(input.parameters["delimiter"] as Any?)
        XCTAssertNil(input.parameters["marker"] as Any?)
        XCTAssertNil(input.parameters["max-keys"] as Any?)
        XCTAssertNil(input.parameters["prefix"] as Any?)
        XCTAssertNil(input.parameters["encoding-type"] as Any?)

        request = ListObjectsRequest()
        request.delimiter = "delimiter"
        request.marker = "marker"
        request.encodingType = "encodingType"
        request.prefix = "prefix"
        request.maxKeys = 10
        try Serde.serializeInput(&request, &input, [Serde.serializeListObjects])
        XCTAssertEqual(input.parameters["delimiter"], request.delimiter)
        XCTAssertEqual(input.parameters["marker"], request.marker)
        XCTAssertEqual(Int(input.parameters["max-keys"]!!), request.maxKeys)
        XCTAssertEqual(input.parameters["prefix"], request.prefix)
        XCTAssertEqual(input.parameters["encoding-type"], request.encodingType)
    }

    func testDeserializeListObjects() throws {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = ListObjectsResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeListObjects]))

        // body is unexpected
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data("<a></a>".data(using: .utf8)!))
        result = ListObjectsResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeListObjects]))

        // normal
        let name = "examplebucket"
        let prefix = "Prefix/"
        let maxKeys = 100
        let marker = "marker"
        let nextMarker = "nextMarker"
        let delimiter = "delimiter"
        let isTruncated = false
        let encodingType = "url"
        var contents = [["Key": "fun%2Fmovie%2F001.avi",
                         "TransitionTime": "2024-04-23T07:21:42.000Z",
                         "LastModified": "2012-02-24T08:43:07.000Z",
                         "ETag": "\"5B3C1A2E053D763E1B002CC607C5A0FE1****\"",
                         "Type": "Normal",
                         "Size": "344606",
                         "StorageClass": "Standard",
                         "Owner": ["ID": "0022012****",
                                   "DisplayName": "user-example"]]]
        let commonPrefixes = [["Prefix": "a%2Fb%2F"]]

        // one result
        var xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
        xml.append("<ListBucketResult xmlns=\"http://doc.oss-cn-hangzhou.aliyuncs.com\">")
        xml.append("<Name>\(name.urlEncode()!)</Name>")
        xml.append("<Prefix>\(prefix)</Prefix>")
        xml.append("<Marker>\(marker)</Marker>")
        xml.append("<NextMarker>\(nextMarker)</NextMarker>")
        xml.append("<MaxKeys>\(maxKeys)</MaxKeys>")
        xml.append("<Delimiter>\(delimiter)</Delimiter>")
        xml.append("<IsTruncated>\(isTruncated)</IsTruncated>")
        xml.append("<EncodingType>\(encodingType)</EncodingType>")
        for content in contents {
            xml.append("<Contents>")
            xml.append("<Key>\(content["Key"]!)</Key>")
            xml.append("<ETag>\(content["ETag"]!)</ETag>")
            xml.append("<TransitionTime>\(content["TransitionTime"]!)</TransitionTime>")
            xml.append("<LastModified>\(content["LastModified"]!)</LastModified>")
            xml.append("<Type>\(content["Type"]!)</Type>")
            xml.append("<Size>\(content["Size"]!)</Size>")
            xml.append("<StorageClass>\(content["StorageClass"]!)</StorageClass>")
            xml.append("<Owner>")
            xml.append("<ID>\((content["Owner"] as! [String: String])["ID"]!)</ID>")
            xml.append("<DisplayName>\((content["Owner"] as! [String: String])["DisplayName"]!)</DisplayName>")
            xml.append("</Owner>")
            xml.append("</Contents>")
        }
        for commonPrefix in commonPrefixes {
            xml.append("<CommonPrefixes>")
            xml.append("<Prefix>\(commonPrefix["Prefix"]!)</Prefix>")
            xml.append("</CommonPrefixes>")
        }
        xml.append("</ListBucketResult>")

        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = ListObjectsResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeListObjects]))
        XCTAssertEqual(result.delimiter, delimiter)
        XCTAssertEqual(result.isTruncated, isTruncated)
        XCTAssertEqual(result.marker, marker)
        XCTAssertEqual(result.nextMarker, nextMarker)
        XCTAssertEqual(result.maxKeys, maxKeys)
        XCTAssertEqual(result.name, name)
        XCTAssertEqual(result.prefix, prefix)
        XCTAssertEqual(result.encodingType, encodingType)

        for content in contents {
            for object in result.contents! {
                if (content["Key"] as! String) == object.key {
                    XCTAssertEqual((content["Key"] as! String).removingPercentEncoding, object.key)
                    XCTAssertEqual(DateFormatter.iso8601DateTimeSeconds.date(from: content["TransitionTime"] as! String), object.transitionTime)
                    XCTAssertEqual(DateFormatter.iso8601DateTimeSeconds.date(from: content["LastModified"] as! String), object.lastModified)
                    XCTAssertEqual(content["ETag"] as? String, object.etag)
                    XCTAssertEqual(content["Type"] as? String, object.type)
                    XCTAssertEqual(Int(content["Size"] as! String), object.size)
                    XCTAssertEqual(content["StorageClass"] as? String, object.storageClass)
                    XCTAssertEqual((content["Owner"] as! [String: String])["ID"]!, object.owner?.id)
                    XCTAssertEqual((content["Owner"] as! [String: String])["DisplayName"], object.owner?.displayName)
                }
            }
        }
        for commonPrefix in commonPrefixes {
            XCTAssertTrue(result.commonPrefixes!.contains(where: {
                $0.prefix == commonPrefix["Prefix"]!.removingPercentEncoding
            }))
        }

        // multiple results
        contents = [["Key": "fun/movie/001.avi",
                     "TransitionTime": "2024-04-23T07:21:42.000Z",
                     "LastModified": "2012-02-24T08:43:07.000Z",
                     "ETag": "\"5B3C1A2E053D763E1B002CC607C5A0FE1****\"",
                     "Type": "Normal",
                     "Size": "344606",
                     "StorageClass": "Standard",
                     "Owner": ["ID": "0022012****",
                               "DisplayName": "user-example"]],
                    ["Key": "fun/movie/002.avi",
                     "TransitionTime": "2024-04-23T07:22:42.000Z",
                     "LastModified": "2012-02-24T08:45:07.000Z",
                     "ETag": "\"6B3C1A2E053D763E1B002CC607C5A0FE1****\"",
                     "Type": "Normal",
                     "Size": "444606",
                     "StorageClass": "Archive",
                     "Owner": ["ID": "0022012****",
                               "DisplayName": "user-example"]]]

        xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
        xml.append("<ListBucketResult xmlns=\"http://doc.oss-cn-hangzhou.aliyuncs.com\">")
        xml.append("<Name>\(name)</Name>")
        xml.append("<Prefix>\(prefix)</Prefix>")
        xml.append("<Marker>\(marker)</Marker>")
        xml.append("<NextMarker>\(nextMarker)</NextMarker>")
        xml.append("<MaxKeys>\(maxKeys)</MaxKeys>")
        xml.append("<Delimiter>\(delimiter)</Delimiter>")
        xml.append("<IsTruncated>\(isTruncated)</IsTruncated>")
        xml.append("<EncodingType>\(encodingType)</EncodingType>")
        for content in contents {
            xml.append("<Contents>")
            xml.append("<Key>\(content["Key"]!)</Key>")
            xml.append("<ETag>\(content["ETag"]!)</ETag>")
            xml.append("<TransitionTime>\(content["TransitionTime"]!)</TransitionTime>")
            xml.append("<LastModified>\(content["LastModified"]!)</LastModified>")
            xml.append("<Type>\(content["Type"]!)</Type>")
            xml.append("<Size>\(content["Size"]!)</Size>")
            xml.append("<StorageClass>\(content["StorageClass"]!)</StorageClass>")
            xml.append("<Owner>")
            xml.append("<ID>\((content["Owner"] as! [String: String])["ID"]!)</ID>")
            xml.append("<DisplayName>\((content["Owner"] as! [String: String])["DisplayName"]!)</DisplayName>")
            xml.append("</Owner>")
            xml.append("</Contents>")
        }
        for commonPrefix in commonPrefixes {
            xml.append("<CommonPrefixes>")
            xml.append("<Prefix>\(commonPrefix["Prefix"]!)</Prefix>")
            xml.append("</CommonPrefixes>")
        }
        xml.append("</ListBucketResult>")

        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = ListObjectsResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeListObjects]))
        XCTAssertEqual(result.delimiter, delimiter)
        XCTAssertEqual(result.isTruncated, isTruncated)
        XCTAssertEqual(result.marker, marker)
        XCTAssertEqual(result.nextMarker, nextMarker)
        XCTAssertEqual(result.maxKeys, maxKeys)
        XCTAssertEqual(result.name, name)
        XCTAssertEqual(result.prefix, prefix)
        XCTAssertEqual(result.encodingType, encodingType)
        XCTAssertEqual(result.contents?.count, contents.count)

        for content in contents {
            for object in result.contents! {
                if (content["Key"] as! String) == object.key {
                    XCTAssertEqual(content["Key"] as? String, object.key)
                    XCTAssertEqual(DateFormatter.iso8601DateTimeSeconds.date(from: content["TransitionTime"] as! String), object.transitionTime)
                    XCTAssertEqual(DateFormatter.iso8601DateTimeSeconds.date(from: content["LastModified"] as! String), object.lastModified)
                    XCTAssertEqual(content["ETag"] as? String, object.etag)
                    XCTAssertEqual(content["Type"] as? String, object.type)
                    XCTAssertEqual(Int(content["Size"] as! String), object.size)
                    XCTAssertEqual(content["StorageClass"] as? String, object.storageClass)
                    XCTAssertEqual((content["Owner"] as! [String: String])["ID"]!, object.owner?.id)
                    XCTAssertEqual((content["Owner"] as! [String: String])["DisplayName"], object.owner?.displayName)
                }
            }
        }
        for commonPrefix in commonPrefixes {
            XCTAssertTrue(result.commonPrefixes!.contains(where: {
                $0.prefix == commonPrefix["Prefix"]!.removingPercentEncoding
            }))
        }
    }

    func testSerializeListObjectsV2() throws {
        var input = OperationInput()

        var request = ListObjectsV2Request()
        try Serde.serializeInput(&request, &input, [Serde.serializeListObjectsV2])
        XCTAssertNil(input.parameters["delimiter"] as Any?)
        XCTAssertNil(input.parameters["marker"] as Any?)
        XCTAssertNil(input.parameters["max-keys"] as Any?)
        XCTAssertNil(input.parameters["prefix"] as Any?)
        XCTAssertNil(input.parameters["encoding-type"] as Any?)

        request = ListObjectsV2Request()
        request.delimiter = "delimiter"
        request.encodingType = "url"
        request.prefix = "prefix"
        request.maxKeys = 10
        request.continuationToken = "marker"
        request.fetchOwner = true
        request.startAfter = "startAfter"
        try Serde.serializeInput(&request, &input, [Serde.serializeListObjectsV2])
        XCTAssertEqual(input.parameters["delimiter"], request.delimiter)
        XCTAssertEqual(Int(input.parameters["max-keys"]!!), request.maxKeys)
        XCTAssertEqual(input.parameters["prefix"], request.prefix)
        XCTAssertEqual(input.parameters["encoding-type"], request.encodingType)
        XCTAssertEqual(input.parameters["continuation-token"], request.continuationToken)
        XCTAssertEqual(input.parameters["start-after"], request.startAfter)
        XCTAssertEqual(Bool(input.parameters["fetch-owner"]!!), request.fetchOwner)
    }

    func testDeserializeListObjectsV2() throws {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = ListObjectsV2Result()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeListObjectsV2]))

        // body is unexpected
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data("<a></a>".data(using: .utf8)!))
        result = ListObjectsV2Result()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeListObjectsV2]))

        // normal
        // one result and url encode
        let name = "examplebucket"
        var prefix = "prefix%2F"
        let maxKeys = 100
        let encodingType = "url"
        let isTruncated = false
        let keyCount = 6
        let delimiter = "delimiter"
        let startAfter = "startAfter"
        let continuationToken = "continuationToken"
        let nextContinuationToken = "nextContinuationToken"

        var contents = [["Key": "fun%2Fmovie%2F001.avi",
                         "TransitionTime": "2024-04-23T07:21:42.000Z",
                         "LastModified": "2012-02-24T08:43:07.000Z",
                         "ETag": "\"5B3C1A2E053D763E1B002CC607C5A0FE1****\"",
                         "Type": "Normal",
                         "Size": "344606",
                         "StorageClass": "Standard",
                         "Owner": ["ID": "0022012****",
                                   "DisplayName": "user-example"]]]
        var commonPrefixes = [["Prefix": "a%2Fb%2F"]]

        var xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
        xml.append("<ListBucketResult xmlns=\"http://doc.oss-cn-hangzhou.aliyuncs.com\">")
        xml.append("<Name>\(name)</Name>")
        xml.append("<Prefix>\(prefix)</Prefix>")
        xml.append("<MaxKeys>\(maxKeys)</MaxKeys>")
        xml.append("<EncodingType>\(encodingType)</EncodingType>")
        xml.append("<IsTruncated>\(isTruncated)</IsTruncated>")
        xml.append("<KeyCount>\(keyCount)</KeyCount>")
        xml.append("<Delimiter>\(delimiter)</Delimiter>")
        xml.append("<StartAfter>\(startAfter)</StartAfter>")
        xml.append("<ContinuationToken>\(continuationToken)</ContinuationToken>")
        xml.append("<NextContinuationToken>\(nextContinuationToken)</NextContinuationToken>")
        for content in contents {
            xml.append("<Contents>")
            xml.append("<Key>\(content["Key"]!)</Key>")
            xml.append("<ETag>\(content["ETag"]!)</ETag>")
            xml.append("<TransitionTime>\(content["TransitionTime"]!)</TransitionTime>")
            xml.append("<LastModified>\(content["LastModified"]!)</LastModified>")
            xml.append("<Type>\(content["Type"]!)</Type>")
            xml.append("<Size>\(content["Size"]!)</Size>")
            xml.append("<StorageClass>\(content["StorageClass"]!)</StorageClass>")
            xml.append("<Owner>")
            xml.append("<ID>\((content["Owner"] as! [String: String])["ID"]!)</ID>")
            xml.append("<DisplayName>\((content["Owner"] as! [String: String])["DisplayName"]!)</DisplayName>")
            xml.append("</Owner>")
            xml.append("</Contents>")
        }
        for commonPrefix in commonPrefixes {
            xml.append("<CommonPrefixes>")
            xml.append("<Prefix>\(commonPrefix["Prefix"]!)</Prefix>")
            xml.append("</CommonPrefixes>")
        }
        xml.append("</ListBucketResult>")

        output = OperationOutput(statusCode: 200,
                                 headers: ["x-oss-request-id": "5C06A3B67B8B5A3DA422299D"],
                                 body: .data(xml.data(using: .utf8)!))
        result = ListObjectsV2Result()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeListObjectsV2]))
        XCTAssertEqual(result.delimiter, delimiter)
        XCTAssertEqual(result.isTruncated, isTruncated)
        XCTAssertEqual(result.startAfter, startAfter)
        XCTAssertEqual(result.continuationToken, continuationToken)
        XCTAssertEqual(result.nextContinuationToken, nextContinuationToken)
        XCTAssertEqual(result.keyCount, keyCount)
        XCTAssertEqual(result.maxKeys, maxKeys)
        XCTAssertEqual(result.name, name)
        XCTAssertEqual(result.prefix, prefix.removingPercentEncoding)
        XCTAssertEqual(result.encodingType, encodingType)
        XCTAssertEqual(result.contents?.count, contents.count)

        for content in contents {
            for object in result.contents! {
                if (content["Key"] as! String) == object.key {
                    XCTAssertEqual((content["Key"] as! String).removingPercentEncoding, object.key)
                    XCTAssertEqual(DateFormatter.iso8601DateTimeSeconds.date(from: content["TransitionTime"] as! String), object.transitionTime)
                    XCTAssertEqual(DateFormatter.iso8601DateTimeSeconds.date(from: content["LastModified"] as! String), object.lastModified)
                    XCTAssertEqual(content["ETag"] as? String, object.etag)
                    XCTAssertEqual(content["Type"] as? String, object.type)
                    XCTAssertEqual(Int(content["Size"] as! String), object.size)
                    XCTAssertEqual(content["StorageClass"] as? String, object.storageClass)
                    XCTAssertEqual((content["Owner"] as! [String: String])["ID"]!, object.owner?.id)
                    XCTAssertEqual((content["Owner"] as! [String: String])["DisplayName"], object.owner?.displayName)
                }
            }
        }
        for commonPrefix in commonPrefixes {
            XCTAssertTrue(result.commonPrefixes!.contains(where: {
                $0.prefix == commonPrefix["Prefix"]!.removingPercentEncoding
            }))
        }

        // multipart result
        prefix = "prefix/"
        contents = [["Key": "fun/movie/001.avi",
                     "TransitionTime": "2024-04-23T07:21:42.000Z",
                     "LastModified": "2012-02-24T08:43:07.000Z",
                     "ETag": "\"5B3C1A2E053D763E1B002CC607C5A0FE1****\"",
                     "Type": "Normal",
                     "Size": "344606",
                     "StorageClass": "Standard",
                     "Owner": ["ID": "0022012****",
                               "DisplayName": "user-example"]],
                    ["Key": "fun/movie/002.avi",
                     "TransitionTime": "2024-04-23T07:22:42.000Z",
                     "LastModified": "2012-02-24T08:45:07.000Z",
                     "ETag": "\"6B3C1A2E053D763E1B002CC607C5A0FE1****\"",
                     "Type": "Normal",
                     "Size": "444606",
                     "StorageClass": "Archive",
                     "Owner": ["ID": "0022012****",
                               "DisplayName": "user-example"]]]
        commonPrefixes = [["Prefix": "a/b/"]]

        xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
        xml.append("<ListBucketResult xmlns=\"http://doc.oss-cn-hangzhou.aliyuncs.com\">")
        xml.append("<Name>\(name)</Name>")
        xml.append("<Prefix>\(prefix)</Prefix>")
        xml.append("<MaxKeys>\(maxKeys)</MaxKeys>")
        xml.append("<EncodingType>\(encodingType)</EncodingType>")
        xml.append("<IsTruncated>\(isTruncated)</IsTruncated>")
        xml.append("<KeyCount>\(keyCount)</KeyCount>")
        xml.append("<Delimiter>\(delimiter)</Delimiter>")
        xml.append("<StartAfter>\(startAfter)</StartAfter>")
        xml.append("<ContinuationToken>\(continuationToken)</ContinuationToken>")
        xml.append("<NextContinuationToken>\(nextContinuationToken)</NextContinuationToken>")
        for content in contents {
            xml.append("<Contents>")
            xml.append("<Key>\(content["Key"]!)</Key>")
            xml.append("<ETag>\(content["ETag"]!)</ETag>")
            xml.append("<TransitionTime>\(content["TransitionTime"]!)</TransitionTime>")
            xml.append("<LastModified>\(content["LastModified"]!)</LastModified>")
            xml.append("<Type>\(content["Type"]!)</Type>")
            xml.append("<Size>\(content["Size"]!)</Size>")
            xml.append("<StorageClass>\(content["StorageClass"]!)</StorageClass>")
            xml.append("<Owner>")
            xml.append("<ID>\((content["Owner"] as! [String: String])["ID"]!)</ID>")
            xml.append("<DisplayName>\((content["Owner"] as! [String: String])["DisplayName"]!)</DisplayName>")
            xml.append("</Owner>")
            xml.append("</Contents>")
        }
        for commonPrefix in commonPrefixes {
            xml.append("<CommonPrefixes>")
            xml.append("<Prefix>\(commonPrefix["Prefix"]!)</Prefix>")
            xml.append("</CommonPrefixes>")
        }
        xml.append("</ListBucketResult>")

        output = OperationOutput(statusCode: 200,
                                 headers: ["x-oss-request-id": "5C06A3B67B8B5A3DA422299D"],
                                 body: .data(xml.data(using: .utf8)!))
        result = ListObjectsV2Result()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeListObjectsV2]))
        XCTAssertEqual(result.delimiter, delimiter)
        XCTAssertEqual(result.isTruncated, isTruncated)
        XCTAssertEqual(result.startAfter, startAfter)
        XCTAssertEqual(result.continuationToken, continuationToken)
        XCTAssertEqual(result.nextContinuationToken, nextContinuationToken)
        XCTAssertEqual(result.keyCount, keyCount)
        XCTAssertEqual(result.maxKeys, maxKeys)
        XCTAssertEqual(result.name, name)
        XCTAssertEqual(result.prefix, prefix)
        XCTAssertEqual(result.encodingType, encodingType)
        XCTAssertEqual(result.contents?.count, contents.count)

        for content in contents {
            for object in result.contents! {
                if (content["Key"] as! String) == object.key {
                    XCTAssertEqual(content["Key"] as? String, object.key)
                    XCTAssertEqual(DateFormatter.iso8601DateTimeSeconds.date(from: content["TransitionTime"] as! String), object.transitionTime)
                    XCTAssertEqual(DateFormatter.iso8601DateTimeSeconds.date(from: content["LastModified"] as! String), object.lastModified)
                    XCTAssertEqual(content["ETag"] as? String, object.etag)
                    XCTAssertEqual(content["Type"] as? String, object.type)
                    XCTAssertEqual(Int(content["Size"] as! String), object.size)
                    XCTAssertEqual(content["StorageClass"] as? String, object.storageClass)
                    XCTAssertEqual((content["Owner"] as! [String: String])["ID"]!, object.owner?.id)
                    XCTAssertEqual((content["Owner"] as! [String: String])["DisplayName"], object.owner?.displayName)
                }
            }
        }
        for commonPrefix in commonPrefixes {
            XCTAssertTrue(result.commonPrefixes!.contains(where: {
                $0.prefix == commonPrefix["Prefix"]!
            }))
        }
    }

    func testDeserializeGetBucketInfo() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = GetBucketInfoResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketInfo]))

        // body is unexpected
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data("<a></a>".data(using: .utf8)!))
        result = GetBucketInfoResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketInfo]))

        // normal
        let accessMonitor = "Enabled"
        let creationDate = "2013-07-31T10:56:21.000Z"
        let extranetEndpoint = "oss-cn-hangzhou.aliyuncs.com"
        let intranetEndpoint = "oss-cn-hangzhou-internal.aliyuncs.com"
        let location = "oss-cn-hangzhou"
        let storageClass = "Standard"
        let transferAcceleration = "Disabled"
        let crossRegionReplication = "Disabled"
        let name = "oss-example"
        let resourceGroupId = "rg-aek27tc********"
        let displayName = "username"
        let id = "27183473914****"
        let accessControlList = "private"
        let comment = "test"
        let logBucket = "examplebucket"
        let logPrefix = "log/"
        let blockPublicAccess = true
        let dataRedundancyType = "LRS"
        let versioning = "Enabled"
        let kMSDataEncryption = "SM4"
        let kMSMasterKeyID = "kMSMasterKeyID"
        let sSEAlgorithm = "KMS"

        var bodyString = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
        bodyString.append("<BucketInfo>")
        bodyString.append("<Bucket>")
        bodyString.append("<AccessMonitor>\(accessMonitor)</AccessMonitor>")
        bodyString.append("<CreationDate>\(creationDate)</CreationDate>")
        bodyString.append("<ExtranetEndpoint>\(extranetEndpoint)</ExtranetEndpoint>")
        bodyString.append("<IntranetEndpoint>\(intranetEndpoint)</IntranetEndpoint>")
        bodyString.append("<Location>\(location)</Location>")
        bodyString.append("<StorageClass>\(storageClass)</StorageClass>")
        bodyString.append("<TransferAcceleration>\(transferAcceleration)</TransferAcceleration>")
        bodyString.append("<CrossRegionReplication>\(crossRegionReplication)</CrossRegionReplication>")
        bodyString.append("<Name>\(name)</Name>")
        bodyString.append("<ResourceGroupId>\(resourceGroupId)</ResourceGroupId>")
        bodyString.append("<Owner>")
        bodyString.append("<DisplayName>\(displayName)</DisplayName>")
        bodyString.append("<ID>\(id)</ID>")
        bodyString.append("</Owner>")
        bodyString.append("<AccessControlList>")
        bodyString.append("<Grant>\(accessControlList)</Grant>")
        bodyString.append("</AccessControlList>")
        bodyString.append("<Comment>\(comment)</Comment>")
        bodyString.append("<BlockPublicAccess>\(blockPublicAccess)</BlockPublicAccess>")
        bodyString.append("<DataRedundancyType>\(dataRedundancyType)</DataRedundancyType>")
        bodyString.append("<Versioning>\(versioning)</Versioning>")
        bodyString.append("<BucketPolicy>")
        bodyString.append("<LogBucket>\(logBucket)</LogBucket>")
        bodyString.append("<LogPrefix>\(logPrefix)</LogPrefix>")
        bodyString.append("</BucketPolicy>")
        bodyString.append("<ServerSideEncryptionRule>")
        bodyString.append("<SSEAlgorithm>\(sSEAlgorithm)</SSEAlgorithm>")
        bodyString.append("<KMSMasterKeyID>\(kMSMasterKeyID)</KMSMasterKeyID>")
        bodyString.append("<KMSDataEncryption>\(kMSDataEncryption)</KMSDataEncryption>")
        bodyString.append("</ServerSideEncryptionRule>")
        bodyString.append("<BucketResourceType>AgenticBucketSpace</BucketResourceType>")
        bodyString.append("<AgenticBucketName>my-agentic-1234567890-cn-hangzhou-ab-apsr</AgenticBucketName>")
        bodyString.append("</Bucket>")
        bodyString.append("</BucketInfo>")

        output = OperationOutput(statusCode: 200,
                                 headers: ["x-oss-request-id": "5C06A3B67B8B5A3DA422299D"],
                                 body: .data(bodyString.data(using: .utf8)!))
        result = GetBucketInfoResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketInfo]))
        XCTAssertEqual(accessMonitor, result.bucketInfo?.bucket?.accessMonitor)
        XCTAssertEqual(creationDate.toDate(), result.bucketInfo?.bucket?.creationDate)
        XCTAssertEqual(extranetEndpoint, result.bucketInfo?.bucket?.extranetEndpoint)
        XCTAssertEqual(intranetEndpoint, result.bucketInfo?.bucket?.intranetEndpoint)
        XCTAssertEqual(location, result.bucketInfo?.bucket?.location)
        XCTAssertEqual(storageClass, result.bucketInfo?.bucket?.storageClass)
        XCTAssertEqual(transferAcceleration, result.bucketInfo?.bucket?.transferAcceleration)
        XCTAssertEqual(crossRegionReplication, result.bucketInfo?.bucket?.crossRegionReplication)
        XCTAssertEqual(name, result.bucketInfo?.bucket?.name)
        XCTAssertEqual(resourceGroupId, result.bucketInfo?.bucket?.resourceGroupId)
        XCTAssertEqual(displayName, result.bucketInfo?.bucket?.owner?.displayName)
        XCTAssertEqual(id, result.bucketInfo?.bucket?.owner?.id)
        XCTAssertEqual(accessControlList, result.bucketInfo?.bucket?.accessControlList?.grant)
        XCTAssertEqual(comment, result.bucketInfo?.bucket?.comment)
        XCTAssertEqual(logBucket, result.bucketInfo?.bucket?.bucketPolicy?.logBucket)
        XCTAssertEqual(logPrefix, result.bucketInfo?.bucket?.bucketPolicy?.logPrefix)
        XCTAssertEqual(blockPublicAccess, result.bucketInfo?.bucket?.blockPublicAccess)
        XCTAssertEqual(dataRedundancyType, result.bucketInfo?.bucket?.dataRedundancyType)
        XCTAssertEqual(versioning, result.bucketInfo?.bucket?.versioning)
        XCTAssertEqual(kMSDataEncryption, result.bucketInfo?.bucket?.serverSideEncryptionRule?.kMSDataEncryption)
        XCTAssertEqual(kMSMasterKeyID, result.bucketInfo?.bucket?.serverSideEncryptionRule?.kMSMasterKeyID)
        XCTAssertEqual(sSEAlgorithm, result.bucketInfo?.bucket?.serverSideEncryptionRule?.sSEAlgorithm)
        XCTAssertEqual("AgenticBucketSpace", result.bucketInfo?.bucket?.bucketResourceType)
        XCTAssertEqual("my-agentic-1234567890-cn-hangzhou-ab-apsr", result.bucketInfo?.bucket?.agenticBucketName)
    }

    func testDeserializeGetBucketLocation() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = GetBucketLocationResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketLocation]))

        // body is unexpected
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data("<a></a>".data(using: .utf8)!))
        result = GetBucketLocationResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketLocation])) {
            let clientError = $0 as? ClientError
            XCTAssertTrue(clientError?.message.contains("Not found root tag <LocationConstraint>.") ?? false)
        }
        XCTAssertNil(result.locationConstraint)

        // normal
        let location = "oss-cn-hangzhou"
        var bodyString = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
        bodyString.append("<LocationConstraint>\(location)</LocationConstraint>")
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(bodyString.data(using: .utf8)!))
        result = GetBucketLocationResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketLocation]))
        XCTAssertEqual(location, result.locationConstraint)
    }
}
