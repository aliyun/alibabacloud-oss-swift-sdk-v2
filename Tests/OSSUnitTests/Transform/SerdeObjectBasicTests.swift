
@testable import AlibabaCloudOSS
import XCTest

class SerdeObjectBasicTests: XCTestCase {
    func testSerializePutObject() throws {
        var input = OperationInput()

        var request = PutObjectRequest()
        try Serde.serializeInput(&request, &input, [Serde.serializePutObject])
        XCTAssertNil(input.headers["x-oss-forbid-overwrite"])
        XCTAssertNil(input.headers["x-oss-server-side-encryption"])
        XCTAssertNil(input.headers["x-oss-server-side-data-encryption"])
        XCTAssertNil(input.headers["x-oss-server-side-encryption-key-id"])
        XCTAssertNil(input.headers["x-oss-object-acl"])
        XCTAssertNil(input.headers["x-oss-storage-class"])
        XCTAssertNil(input.headers["x-oss-tagging"])
        XCTAssertFalse(input.headers.contains(where: { $0.key.hasPrefix("x-oss-meta-") }))
        XCTAssertNil(input.body)

        // normal
        let bucket = "bucket"
        let key = "key"
        let storageClass = "Archive"
        let tagging = "TagA=A&TagB=B"
        let objectAcl = "private"
        let forbidOverwrite = false
        let serverSideEncryption = "AES256"
        let serverSideDataEncryption = "SM4"
        let serverSideEncryptionKeyId = "9468da86-3509-4f8d-a61e-6eab1eac****"
        let body = "body"
        request = PutObjectRequest()
        request.bucket = bucket
        request.key = key
        request.storageClass = storageClass
        request.tagging = tagging
        request.objectAcl = objectAcl
        request.forbidOverwrite = forbidOverwrite
        request.serverSideEncryption = serverSideEncryption
        request.serverSideDataEncryption = serverSideDataEncryption
        request.serverSideEncryptionKeyId = serverSideEncryptionKeyId
        request.metadata = ["key": "value"]
        request.body = .data(body.data(using: .utf8)!)
        try Serde.serializeInput(&request, &input, [Serde.serializePutObject])
        XCTAssertEqual(input.headers["x-oss-forbid-overwrite"], forbidOverwrite.toString())
        XCTAssertEqual(input.headers["x-oss-server-side-encryption"], serverSideEncryption)
        XCTAssertEqual(input.headers["x-oss-server-side-data-encryption"], serverSideDataEncryption)
        XCTAssertEqual(input.headers["x-oss-server-side-encryption-key-id"], serverSideEncryptionKeyId)
        XCTAssertEqual(input.headers["x-oss-object-acl"], objectAcl)
        XCTAssertEqual(input.headers["x-oss-storage-class"], storageClass)
        XCTAssertEqual(input.headers["x-oss-tagging"], tagging)
        XCTAssertTrue(input.headers.contains(where: { $0.key == "x-oss-meta-key" }))
        XCTAssertEqual(try String(bytes: input.body!.readData()!, encoding: .utf8), body)
    }

    func testSerializeCopyObject() throws {
        var input = OperationInput()

        var request = CopyObjectRequest()
        try Serde.serializeInput(&request, &input, [Serde.serializeCopyObject])
        XCTAssertNil(input.headers["x-oss-copy-source"])
        XCTAssertNil(input.headers["x-oss-forbid-overwrite"])
        XCTAssertNil(input.headers["x-oss-copy-source-if-match"])
        XCTAssertNil(input.headers["x-oss-copy-source-if-none-match"])
        XCTAssertNil(input.headers["x-oss-copy-source-if-unmodified-since"])
        XCTAssertNil(input.headers["x-oss-copy-source-if-modified-since"])
        XCTAssertNil(input.headers["x-oss-metadata-directive"])
        XCTAssertNil(input.headers["x-oss-server-side-encryption"])
        XCTAssertNil(input.headers["x-oss-server-side-data-encryption"])
        XCTAssertNil(input.headers["x-oss-server-side-encryption-key-id"])
        XCTAssertNil(input.headers["x-oss-object-acl"])
        XCTAssertNil(input.headers["x-oss-storage-class"])
        XCTAssertNil(input.headers["x-oss-tagging"])
        XCTAssertNil(input.headers["x-oss-tagging-directive"])
        XCTAssertFalse(input.headers.contains(where: { $0.key.hasPrefix("x-oss-meta-") }))

        // normal
        request = CopyObjectRequest()
        request.sourceBucket = "bucket"
        request.sourceKey = "key"
        request.forbidOverwrite = true
        request.copySourceIfMatch = "5B3C1A2E053D763E1B002CC607C5****"
        request.copySourceIfNoneMatch = "5B3C1A2E053D763E1B002CC607C5****"
        request.copySourceIfModifiedSince = "Mon, 11 May 2020 08:16:23 GMT"
        request.copySourceIfUnmodifiedSince = "Mon, 11 May 2020 08:16:23 GMT"
        request.metadataDirective = "COPY"
        request.serverSideEncryption = "AES256"
        request.serverSideDataEncryption = "SM4"
        request.serverSideEncryptionKeyId = "9468da86-3509-4f8d-a61e-6eab1eac****"
        request.objectAcl = "private"
        request.storageClass = "Standard"
        request.tagging = "a:1"
        request.taggingDirective = "Copy"
        request.metadata = ["key": "value"]
        try Serde.serializeInput(&request, &input, [Serde.serializeCopyObject])
        XCTAssertEqual(input.headers["x-oss-copy-source"], "/\(request.sourceBucket!)/\(request.sourceKey!)")
        XCTAssertEqual(input.headers["x-oss-forbid-overwrite"], request.forbidOverwrite?.toString())
        XCTAssertEqual(input.headers["x-oss-copy-source-if-match"], request.copySourceIfMatch)
        XCTAssertEqual(input.headers["x-oss-copy-source-if-none-match"], request.copySourceIfNoneMatch)
        XCTAssertEqual(input.headers["x-oss-copy-source-if-unmodified-since"], request.copySourceIfModifiedSince)
        XCTAssertEqual(input.headers["x-oss-copy-source-if-modified-since"], request.copySourceIfUnmodifiedSince)
        XCTAssertEqual(input.headers["x-oss-metadata-directive"], request.metadataDirective)
        XCTAssertEqual(input.headers["x-oss-server-side-encryption"], request.serverSideEncryption)
        XCTAssertEqual(input.headers["x-oss-server-side-data-encryption"], request.serverSideDataEncryption)
        XCTAssertEqual(input.headers["x-oss-server-side-encryption-key-id"], request.serverSideEncryptionKeyId)
        XCTAssertEqual(input.headers["x-oss-object-acl"], request.objectAcl)
        XCTAssertEqual(input.headers["x-oss-storage-class"], request.storageClass)
        XCTAssertEqual(input.headers["x-oss-tagging"], request.tagging)
        XCTAssertEqual(input.headers["x-oss-tagging-directive"], request.taggingDirective)
        XCTAssertTrue(input.headers.contains(where: { $0.key == "x-oss-meta-key" }))
    }

    func testDeserializeCopyObject() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = CopyObjectResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeCopyObject])) {
            let clientError = $0 as? ClientError
            XCTAssertTrue(clientError?.message.contains("Can not get response body.") ?? false)
        }
        XCTAssertNil(result.etag)
        XCTAssertNil(result.lastModified)

        // body is unexpected
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data("<a></a>".data(using: .utf8)!))
        result = CopyObjectResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeCopyObject])) {
            let clientError = $0 as? ClientError
            XCTAssertTrue(clientError?.message.contains("Not found root tag <CopyObjectResult>") ?? false)
        }
        XCTAssertNil(result.etag)
        XCTAssertNil(result.lastModified)

        // normal
        let etag = "\"F2064A169EE92E9775EE5324D0B1****\""
        let lastModified = DateFormatter.iso8601DateTimeSeconds.string(from: Date())
        let body: Data? = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><CopyObjectResult><ETag>\(etag)</ETag><LastModified>\(lastModified)</LastModified></CopyObjectResult>".data(using: .utf8)
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(body!))
        result = CopyObjectResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeCopyObject]))
        XCTAssertEqual(etag, result.etag)
        XCTAssertEqual(lastModified, result.lastModified)
    }

    func testSerializeGetObject() throws {
        var input = OperationInput()

        var request = GetObjectRequest()
        try Serde.serializeInput(&request, &input, [Serde.serializeGetObject])
        XCTAssertNil(input.headers["Range"])
        XCTAssertNil(input.headers["If-Modified-Since"])
        XCTAssertNil(input.headers["If-Unmodified-Since"])
        XCTAssertNil(input.headers["If-Match"])
        XCTAssertNil(input.headers["If-None-Match"])
        XCTAssertNil(input.headers["Accept-Encoding"])
        XCTAssertNil(input.parameters["response-content-type"] as Any?)
        XCTAssertNil(input.parameters["response-content-language"] as Any?)
        XCTAssertNil(input.parameters["response-expires"] as Any?)
        XCTAssertNil(input.parameters["response-cache-control"] as Any?)
        XCTAssertNil(input.parameters["response-content-disposition"] as Any?)
        XCTAssertNil(input.parameters["response-content-encoding"] as Any?)
        XCTAssertNil(input.parameters["versionId"] as Any?)
        XCTAssertNil(input.headers["x-oss-tagging-directive"])

        // normal
        request = GetObjectRequest()
        request.range = "byte=0-1"
        request.ifMatch = "If-Match"
        request.ifNoneMatch = "If-None-Match"
        request.ifModifiedSince = "If-Modified-Since"
        request.ifUnmodifiedSince = "If-Unmodified-Since"
        request.acceptEncoding = "acceptEncoding"
        request.responseContentType = "txt"
        request.responseContentLanguage = "en"
        request.responseExpires = "Expires"
        request.responseCacheControl = "no-cache"
        request.responseContentEncoding = "utf-8"
        request.responseContentDisposition = "a.jpg"
        request.versionId = "versionId"
        try Serde.serializeInput(&request, &input, [Serde.serializeGetObject])
        XCTAssertEqual(input.headers["Range"], request.range)
        XCTAssertEqual(input.headers["If-Modified-Since"], request.ifModifiedSince)
        XCTAssertEqual(input.headers["If-Unmodified-Since"], request.ifUnmodifiedSince)
        XCTAssertEqual(input.headers["If-Match"], request.ifMatch)
        XCTAssertEqual(input.headers["If-None-Match"], request.ifNoneMatch)
        XCTAssertEqual(input.headers["Accept-Encoding"], request.acceptEncoding)
        XCTAssertEqual(input.parameters["response-content-type"], request.responseContentType)
        XCTAssertEqual(input.parameters["response-content-language"], request.responseContentLanguage)
        XCTAssertEqual(input.parameters["response-expires"], request.responseExpires)
        XCTAssertEqual(input.parameters["response-cache-control"], request.responseCacheControl)
        XCTAssertEqual(input.parameters["response-content-disposition"], request.responseContentDisposition)
        XCTAssertEqual(input.parameters["response-content-encoding"], request.responseContentEncoding)
        XCTAssertEqual(input.parameters["versionId"], request.versionId)
    }

    func testSerializeAppendObject() throws {
        var input = OperationInput()

        var request = AppendObjectRequest()
        try Serde.serializeInput(&request, &input, [Serde.serializeAppendObject])
        XCTAssertNil(input.headers["x-oss-server-side-encryption"])
        XCTAssertNil(input.headers["x-oss-object-acl"])
        XCTAssertNil(input.headers["x-oss-storage-class"])
        XCTAssertNil(input.headers["Cache-Control"])
        XCTAssertNil(input.headers["Content-Disposition"])
        XCTAssertNil(input.headers["Content-Encoding"])
        XCTAssertNil(input.headers["Content-MD5"])
        XCTAssertNil(input.headers["Expires"])
        XCTAssertNil(input.parameters["position"] as Any?)
        XCTAssertFalse(input.headers.contains(where: { $0.key.hasPrefix("x-oss-meta-") }))

        // normal
        request = AppendObjectRequest()
        request.serverSideEncryption = "serverSideEncryption"
        request.objectAcl = "private"
        request.storageClass = "Archive"
        request.cacheControl = "no-cache"
        request.contentDisposition = "a"
        request.contentEncoding = "utf-8"
        request.contentMd5 = "contentMd5"
        request.expires = "expires"
        request.position = 10
        request.metadata = ["key": "value"]
        try Serde.serializeInput(&request, &input, [Serde.serializeAppendObject])
        XCTAssertEqual(input.headers["x-oss-server-side-encryption"], request.serverSideEncryption)
        XCTAssertEqual(input.headers["x-oss-object-acl"], request.objectAcl)
        XCTAssertEqual(input.headers["x-oss-storage-class"], request.storageClass)
        XCTAssertEqual(input.headers["Cache-Control"], request.cacheControl)
        XCTAssertEqual(input.headers["Content-Disposition"], request.contentDisposition)
        XCTAssertEqual(input.headers["Content-Encoding"], request.contentEncoding)
        XCTAssertEqual(input.headers["Content-MD5"], request.contentMd5)
        XCTAssertEqual(input.headers["Expires"], request.expires)
        XCTAssertEqual(Int(input.parameters["position"]!!), request.position)
        XCTAssertTrue(input.headers.contains(where: { $0.key == "x-oss-meta-key" }))
    }

    func testSerializeDeleteObject() throws {
        var input = OperationInput()

        var request = DeleteObjectRequest()
        try Serde.serializeInput(&request, &input, [Serde.serializeDeleteObject])
        XCTAssertNil(input.parameters["versionId"] as Any?)

        // normal
        request = DeleteObjectRequest()
        request.versionId = "versionId"
        try Serde.serializeInput(&request, &input, [Serde.serializeDeleteObject])
        XCTAssertEqual(input.parameters["versionId"], request.versionId)
    }

    func testSerializeHeadObject() throws {
        var input = OperationInput()

        var request = HeadObjectRequest()
        try Serde.serializeInput(&request, &input, [Serde.serializeHeadObject])
        XCTAssertNil(input.headers["If-Modified-Since"])
        XCTAssertNil(input.headers["If-Unmodified-Since"])
        XCTAssertNil(input.headers["If-Match"])
        XCTAssertNil(input.headers["If-None-Match"])
        XCTAssertNil(input.parameters["versionId"] as Any?)

        // normal
        request = HeadObjectRequest()
        request.ifMatch = "ifMatch"
        request.ifNoneMatch = "ifNoneMatch"
        request.ifModifiedSince = "ifModifiedSince"
        request.ifUnmodifiedSince = "ifUnmodifiedSince"
        request.versionId = "versionId"
        try Serde.serializeInput(&request, &input, [Serde.serializeHeadObject])
        XCTAssertEqual(input.headers["If-Modified-Since"], request.ifModifiedSince)
        XCTAssertEqual(input.headers["If-Unmodified-Since"], request.ifUnmodifiedSince)
        XCTAssertEqual(input.headers["If-Match"], request.ifMatch)
        XCTAssertEqual(input.headers["If-None-Match"], request.ifNoneMatch)
        XCTAssertEqual(input.parameters["versionId"], request.versionId)
    }

    func testSerializeGetObjectMeta() throws {
        var input = OperationInput()

        var request = GetObjectMetaRequest()
        try Serde.serializeInput(&request, &input, [Serde.serializeGetObjectMeta])
        XCTAssertNil(input.parameters["versionId"] as Any?)

        // normal
        request = GetObjectMetaRequest()
        request.versionId = "versionId"
        try Serde.serializeInput(&request, &input, [Serde.serializeGetObjectMeta])
        XCTAssertEqual(input.parameters["versionId"], request.versionId)
    }

    func testSerializeDeleteMultipleObjects() throws {
        var input = OperationInput()

        var request = DeleteMultipleObjectsRequest()
        try Serde.serializeInput(&request, &input, [Serde.serializeDeleteMultipleObjects])
        XCTAssertNil(input.headers["Encoding-Type"])

        // normal
        request = DeleteMultipleObjectsRequest()
        request.encodingType = "url"
        request.delete = Delete(
            quiet: true,
            objects: [DeleteObject(key: "key1", versionId: "versionId1"),
                      DeleteObject(key: "key2", versionId: "versionId2")]
        )
        try Serde.serializeInput(&request, &input, [Serde.serializeDeleteMultipleObjects])
        XCTAssertNotNil(input.headers["Encoding-Type"])

        let xml =
            """
            <?xml version=\"1.0\" encoding=\"UTF-8\"?>\
            <Delete>\
            <Quiet>true</Quiet>\
            <Object>\
            <Key>key1</Key>\
            <VersionId>versionId1</VersionId>\
            </Object>\
            <Object>\
            <Key>key2</Key>\
            <VersionId>versionId2</VersionId>\
            </Object>\
            </Delete>
            """
        XCTAssertEqual(xml.data(using: .utf8)?.base64EncodedString(), try input.body?.readData()?.base64EncodedString())
    }

    func testSerializeDeleteMultipleObjectsWithQuietFalse() throws {
        var input = OperationInput()
        var request = DeleteMultipleObjectsRequest()
        request.delete = Delete(
            quiet: false,
            objects: [DeleteObject(key: "key1")]
        )
        try Serde.serializeInput(&request, &input, [Serde.serializeDeleteMultipleObjects])

        let xml =
            """
            <?xml version=\"1.0\" encoding=\"UTF-8\"?>\
            <Delete>\
            <Quiet>false</Quiet>\
            <Object>\
            <Key>key1</Key>\
            </Object>\
            </Delete>
            """
        XCTAssertEqual(xml.data(using: .utf8)?.base64EncodedString(), try input.body?.readData()?.base64EncodedString())
    }

    func testSerializeDeleteMultipleObjectsWithQuietNil() throws {
        var input = OperationInput()
        var request = DeleteMultipleObjectsRequest()
        request.delete = Delete(
            objects: [DeleteObject(key: "key1")]
        )
        try Serde.serializeInput(&request, &input, [Serde.serializeDeleteMultipleObjects])

        let xml =
            """
            <?xml version=\"1.0\" encoding=\"UTF-8\"?>\
            <Delete>\
            <Object>\
            <Key>key1</Key>\
            </Object>\
            </Delete>
            """
        XCTAssertEqual(xml.data(using: .utf8)?.base64EncodedString(), try input.body?.readData()?.base64EncodedString())
    }

    func testSerializeDeleteMultipleObjectsWithoutVersionId() throws {
        var input = OperationInput()
        var request = DeleteMultipleObjectsRequest()
        request.delete = Delete(
            quiet: true,
            objects: [DeleteObject(key: "key1"),
                      DeleteObject(key: "key2")]
        )
        try Serde.serializeInput(&request, &input, [Serde.serializeDeleteMultipleObjects])

        let xml =
            """
            <?xml version=\"1.0\" encoding=\"UTF-8\"?>\
            <Delete>\
            <Quiet>true</Quiet>\
            <Object>\
            <Key>key1</Key>\
            </Object>\
            <Object>\
            <Key>key2</Key>\
            </Object>\
            </Delete>
            """
        XCTAssertEqual(xml.data(using: .utf8)?.base64EncodedString(), try input.body?.readData()?.base64EncodedString())
    }

    func testSerializeDeleteMultipleObjectsWithSpecialCharacters() throws {
        var input = OperationInput()
        var request = DeleteMultipleObjectsRequest()
        request.delete = Delete(
            objects: [DeleteObject(key: "key&1<2>3\"4'5")]
        )
        try Serde.serializeInput(&request, &input, [Serde.serializeDeleteMultipleObjects])

        let xml =
            """
            <?xml version=\"1.0\" encoding=\"UTF-8\"?>\
            <Delete>\
            <Object>\
            <Key>key&amp;1&lt;2&gt;3&quot;4&apos;5</Key>\
            </Object>\
            </Delete>
            """
        XCTAssertEqual(xml.data(using: .utf8)?.base64EncodedString(), try input.body?.readData()?.base64EncodedString())
    }

    func testSerializeDeleteMultipleObjectsWithEmptyObjects() throws {
        var input = OperationInput()
        var request = DeleteMultipleObjectsRequest()
        request.delete = Delete(
            quiet: true,
            objects: []
        )
        try Serde.serializeInput(&request, &input, [Serde.serializeDeleteMultipleObjects])

        let xml =
            """
            <?xml version=\"1.0\" encoding=\"UTF-8\"?>\
            <Delete>\
            <Quiet>true</Quiet>\
            </Delete>
            """
        XCTAssertEqual(xml.data(using: .utf8)?.base64EncodedString(), try input.body?.readData()?.base64EncodedString())
    }

    func testSerializeDeleteMultipleObjectsWithDeleteNil() throws {
        var input = OperationInput()
        var request = DeleteMultipleObjectsRequest()
        request.delete = nil
        try Serde.serializeInput(&request, &input, [Serde.serializeDeleteMultipleObjects])

        let xml =
            """
            <?xml version=\"1.0\" encoding=\"UTF-8\"?>\
            <Delete>\
            </Delete>
            """
        XCTAssertEqual(xml.data(using: .utf8)?.base64EncodedString(), try input.body?.readData()?.base64EncodedString())
    }

    func testDeserializeDeleteMultipleObjects() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = DeleteMultipleObjectsResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeDeleteMultipleObjects])) {
            let clientError = $0 as? ClientError
            XCTAssertTrue(clientError?.message.contains("Can not get response body. ") ?? false)
        }
        XCTAssertNil(result.encodingType)
        XCTAssertNil(result.deletedObjects)

        // body is unexpected
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data("<a></a>".data(using: .utf8)!))
        result = DeleteMultipleObjectsResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeDeleteMultipleObjects])) {
            let clientError = $0 as? ClientError
            XCTAssertTrue(clientError?.message.contains("Not found root tag <DeleteResult>.") ?? false)
        }
        XCTAssertNil(result.encodingType)
        XCTAssertNil(result.deletedObjects)

        // normal
        let encodingType = "url"
        let body: Data? =
            """
            <DeleteResult xmlns=\"http://doc.oss-cn-hangzhou.aliyuncs.com\">\
            <Deleted>\
            <Key>/key1</Key>\
            <VersionId>versionId1</VersionId>\
            <DeleteMarker>true</DeleteMarker>\
            <DeleteMarkerVersionId>deleteMarkerVersionId1</DeleteMarkerVersionId>\
            </Deleted>\
            <Deleted>\
            <Key>%2Fkey2</Key>\
            <VersionId>versionId2</VersionId>\
            <DeleteMarker>false</DeleteMarker>\
            <DeleteMarkerVersionId>deleteMarkerVersionId2</DeleteMarkerVersionId>\
            </Deleted>\
            <EncodingType>url</EncodingType>
            </DeleteResult>
            """.data(using: .utf8)
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(body!))
        result = DeleteMultipleObjectsResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeDeleteMultipleObjects]))
        XCTAssertEqual(encodingType, result.encodingType)
        for delete in result.deletedObjects ?? [] {
            if delete.key == "/key1" {
                XCTAssertEqual(delete.versionId, "versionId1")
                XCTAssertTrue(delete.deleteMarker!)
                XCTAssertEqual(delete.deleteMarkerVersionId, "deleteMarkerVersionId1")
            } else {
                XCTAssertEqual(delete.key, "/key2")
                XCTAssertEqual(delete.versionId, "versionId2")
                XCTAssertFalse(delete.deleteMarker!)
                XCTAssertEqual(delete.deleteMarkerVersionId, "deleteMarkerVersionId2")
            }
        }
    }

    func testSerializeRestoreObject() throws {
        var input = OperationInput()

        var request = RestoreObjectRequest()
        try Serde.serializeInput(&request, &input, [Serde.serializeRestoreObject])
        XCTAssertNil(input.parameters["versionId"] as Any?)
        XCTAssertEqual(try input.body?.readData()?.base64EncodedString(), "<?xml version=\"1.0\" encoding=\"UTF-8\"?><RestoreRequest></RestoreRequest>".data(using: .utf8)?.base64EncodedString())

        // normal
        request = RestoreObjectRequest()
        request.versionId = "versionId"

        var restoreRequest = RestoreRequest()
        restoreRequest.days = 10
        restoreRequest.jobParameters = JobParameters(tier: "Standard")
        request.restoreRequest = restoreRequest
        try Serde.serializeInput(&request, &input, [Serde.serializeRestoreObject])

        var xmlBody = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
        xmlBody.append("<RestoreRequest>")
        xmlBody.append("<Days>\(restoreRequest.days!)</Days>")
        xmlBody.append("<JobParameters><Tier>\(restoreRequest.jobParameters!.tier!)</Tier></JobParameters>")
        xmlBody.append("</RestoreRequest>")
        XCTAssertEqual(input.parameters["versionId"], request.versionId)
        XCTAssertEqual(try input.body?.readData()?.base64EncodedString(), xmlBody.data(using: .utf8)?.base64EncodedString())
    }

    func testDeserializeHeadObject() throws {
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = HeadObjectResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output))
        XCTAssertNil(result.expiration)
        XCTAssertNil(result.restore)
        XCTAssertNil(result.contentMd5)
        XCTAssertNil(result.etag)
        XCTAssertNil(result.objectType)
        XCTAssertNil(result.processStatus)
        XCTAssertNil(result.requestCharged)
        XCTAssertNil(result.lastModified)
        XCTAssertNil(result.metadata)
        XCTAssertNil(result.taggingCount)
        XCTAssertNil(result.serverSideEncryption)
        XCTAssertNil(result.serverSideDataEncryption)
        XCTAssertNil(result.serverSideEncryptionKeyId)
        XCTAssertNil(result.nextAppendPosition)
        XCTAssertNil(result.hashCrc64ecma)
        XCTAssertNil(result.transitionTime)
        XCTAssertNil(result.storageClass)
        XCTAssertNil(result.contentLength)
        XCTAssertNil(result.contentType)
        XCTAssertNil(result.cacheControl)
        XCTAssertNil(result.contentDisposition)
        XCTAssertNil(result.contentEncoding)
        XCTAssertNil(result.expires)
        XCTAssertNil(result.versionId)

        // all headers
        output = OperationOutput(
            statusCode: 200,
            headers: [
                "x-oss-expiration": "expiration",
                "x-oss-restore": "restore",
                "Content-MD5": "contentMd5",
                "Etag": "ETag",
                "x-oss-object-type": "Normal",
                "x-oss-process-status": "processStatus",
                "x-oss-request-charged": "requestCharged",
                "Last-Modified": "Fri, 24 Feb 2012 06:07:48 GMT",
                "x-oss-meta-key-1": "value-1",
                "x-oss-meta-key2": "value-2",
                "x-oss-tagging-count": "2",
                "x-oss-server-side-encryption": "AES256",
                "x-oss-server-side-data-encryption": "SM4",
                "x-oss-server-side-encryption-key-id": "kms-id",
                "x-oss-next-append-position": "123",
                "x-oss-hash-crc64ecma": "123456",
                "x-oss-transition-time": "transition-time",
                "x-oss-storage-class": "IA",
                "Content-Length": "11111",
                "Content-Type": "image/jpg",
                "Cache-Control": "no-cache",
                "Content-Disposition": "1.jpg",
                "Content-Encoding": "gzip",
                "Expires": "Expires-time",
                "x-oss-version-id": "versionId-123",
            ]
        )
        result = HeadObjectResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output))
        XCTAssertEqual("expiration", result.expiration)
        XCTAssertEqual("restore", result.restore)
        XCTAssertEqual("contentMd5", result.contentMd5)
        XCTAssertEqual("ETag", result.etag)
        XCTAssertEqual("Normal", result.objectType)
        XCTAssertEqual("processStatus", result.processStatus)
        XCTAssertEqual("requestCharged", result.requestCharged)
        XCTAssertEqual("Fri, 24 Feb 2012 06:07:48 GMT", result.lastModified)
        XCTAssertEqual("value-1", result.metadata?["key-1"])
        XCTAssertEqual("value-2", result.metadata?["key2"])
        XCTAssertEqual(2, result.taggingCount)
        XCTAssertEqual("AES256", result.serverSideEncryption)
        XCTAssertEqual("SM4", result.serverSideDataEncryption)
        XCTAssertEqual("kms-id", result.serverSideEncryptionKeyId)
        XCTAssertEqual(123, result.nextAppendPosition)
        XCTAssertEqual(123_456, result.hashCrc64ecma)
        XCTAssertEqual("transition-time", result.transitionTime)
        XCTAssertEqual("IA", result.storageClass)
        XCTAssertEqual(11111, result.contentLength)
        XCTAssertEqual("image/jpg", result.contentType)
        XCTAssertEqual("no-cache", result.cacheControl)
        XCTAssertEqual("1.jpg", result.contentDisposition)
        XCTAssertEqual("gzip", result.contentEncoding)
        XCTAssertEqual("Expires-time", result.expires)
        XCTAssertEqual("versionId-123", result.versionId)

        // caseInsensitive
        // all headers
        output = OperationOutput(
            statusCode: 200,
            headers: [
                "X-Oss-expiration": "expiration",
                "X-Oss-restore": "restore",
                "content-md5": "contentMd5",
                "etag": "ETag",
                "X-Oss-object-type": "Normal",
                "X-Oss-process-status": "processStatus",
                "X-Oss-request-charged": "requestCharged",
                "last-modified": "Fri, 24 Feb 2012 06:07:48 GMT",
                "X-Oss-meta-key-1": "value-1",
                "X-Oss-meta-key2": "value-2",
                "X-Oss-tagging-count": "2",
                "X-Oss-server-side-encryption": "AES256",
                "X-Oss-server-side-data-encryption": "SM4",
                "X-Oss-server-side-encryption-key-id": "kms-id",
                "X-Oss-next-append-position": "123",
                "X-Oss-hash-crc64ecma": "123456",
                "X-Oss-transition-time": "transition-time",
                "X-Oss-storage-class": "IA",
                "content-Length": "11111",
                "content-Type": "image/jpg",
                "cache-Control": "no-cache",
                "content-Disposition": "1.jpg",
                "content-Encoding": "gzip",
                "expires": "Expires-time",
                "X-Oss-version-id": "versionId-123",
            ]
        )
        result = HeadObjectResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output))
        XCTAssertEqual("expiration", result.expiration)
        XCTAssertEqual("restore", result.restore)
        XCTAssertEqual("contentMd5", result.contentMd5)
        XCTAssertEqual("ETag", result.etag)
        XCTAssertEqual("Normal", result.objectType)
        XCTAssertEqual("processStatus", result.processStatus)
        XCTAssertEqual("requestCharged", result.requestCharged)
        XCTAssertEqual("Fri, 24 Feb 2012 06:07:48 GMT", result.lastModified)
        XCTAssertEqual("value-1", result.metadata?["key-1"])
        XCTAssertEqual("value-2", result.metadata?["key2"])
        XCTAssertEqual(2, result.taggingCount)
        XCTAssertEqual("AES256", result.serverSideEncryption)
        XCTAssertEqual("SM4", result.serverSideDataEncryption)
        XCTAssertEqual("kms-id", result.serverSideEncryptionKeyId)
        XCTAssertEqual(123, result.nextAppendPosition)
        XCTAssertEqual(123_456, result.hashCrc64ecma)
        XCTAssertEqual("transition-time", result.transitionTime)
        XCTAssertEqual("IA", result.storageClass)
        XCTAssertEqual(11111, result.contentLength)
        XCTAssertEqual("image/jpg", result.contentType)
        XCTAssertEqual("no-cache", result.cacheControl)
        XCTAssertEqual("1.jpg", result.contentDisposition)
        XCTAssertEqual("gzip", result.contentEncoding)
        XCTAssertEqual("Expires-time", result.expires)
        XCTAssertEqual("versionId-123", result.versionId)
    }
}
