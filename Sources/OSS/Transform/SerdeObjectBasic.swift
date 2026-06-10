import Foundation

// MARK: - PutObject

extension Serde {
    static func serializePutObject(
        _ request: inout PutObjectRequest,
        _ input: inout OperationInput
    ) throws {
        if let value = request.forbidOverwrite {
            input.headers["x-oss-forbid-overwrite"] = String(value)
        }
        if let value = request.serverSideEncryption {
            input.headers["x-oss-server-side-encryption"] = value
        }
        if let value = request.serverSideDataEncryption {
            input.headers["x-oss-server-side-data-encryption"] = value
        }
        if let value = request.serverSideEncryptionKeyId {
            input.headers["x-oss-server-side-encryption-key-id"] = value
        }
        if let value = request.objectAcl {
            input.headers["x-oss-object-acl"] = value
        }
        if let value = request.storageClass {
            input.headers["x-oss-storage-class"] = value
        }
        if let value = request.tagging {
            input.headers["x-oss-tagging"] = value
        }
        if let value = request.cacheControl {
            input.headers["Cache-Control"] = value
        }
        if let value = request.contentDisposition {
            input.headers["Content-Disposition"] = value
        }
        if let value = request.contentEncoding {
            input.headers["Content-Encoding"] = value
        }
        if let value = request.expires {
            input.headers["Expires"] = value
        }
        if let value = request.contentMd5 {
            input.headers["Content-MD5"] = value
        }
        if let value = request.contentType {
            input.headers["Content-Type"] = value
        }
        if let value = request.callback {
            input.headers["x-oss-callback"] = value
        }
        if let value = request.callbackVar {
            input.headers["x-oss-callback-var"] = value
        }
        if let value = request.trafficLimit {
            input.headers["x-oss-traffic-limit"] = String(value)
        }

        if let value = request.metadata {
            for (k, v) in value {
                input.headers["x-oss-meta-\(k)"] = v
            }
        }

        input.body = request.body
    }

    static func deserializePutObject(
        _ result: inout PutObjectResult,
        _ output: inout OperationOutput
    ) throws {
        if let data = try output.body?.readData() {
            result.callbackResult = data
        }
    }
}

// MARK: - CopyObject

extension Serde {
    static func serializeCopyObject(
        _ request: inout CopyObjectRequest,
        _ input: inout OperationInput
    ) throws {
        if let sourceBucket = request.sourceBucket,
           let sourceKey = request.sourceKey
        {
            input.headers["x-oss-copy-source"] = "/\(sourceBucket)/\(sourceKey)"
        }

        if let value = request.forbidOverwrite {
            input.headers["x-oss-forbid-overwrite"] = value.toString()
        }

        if let value = request.copySourceIfMatch {
            input.headers["x-oss-copy-source-if-match"] = value
        }

        if let value = request.copySourceIfNoneMatch {
            input.headers["x-oss-copy-source-if-none-match"] = value
        }

        if let value = request.copySourceIfUnmodifiedSince {
            input.headers["x-oss-copy-source-if-unmodified-since"] = value
        }

        if let value = request.copySourceIfModifiedSince {
            input.headers["x-oss-copy-source-if-modified-since"] = value
        }

        if let value = request.metadataDirective {
            input.headers["x-oss-metadata-directive"] = value
        }

        if let value = request.serverSideEncryption {
            input.headers["x-oss-server-side-encryption"] = value
        }

        if let value = request.serverSideDataEncryption {
            input.headers["x-oss-server-side-data-encryption"] = value
        }

        if let value = request.serverSideEncryptionKeyId {
            input.headers["x-oss-server-side-encryption-key-id"] = value
        }

        if let value = request.objectAcl {
            input.headers["x-oss-object-acl"] = value
        }

        if let value = request.storageClass {
            input.headers["x-oss-storage-class"] = value
        }

        if let value = request.tagging {
            input.headers["x-oss-tagging"] = value
        }

        if let value = request.taggingDirective {
            input.headers["x-oss-tagging-directive"] = value
        }
        if let value = request.cacheControl {
            input.headers["Cache-Control"] = value
        }
        if let value = request.contentDisposition {
            input.headers["Content-Disposition"] = value
        }
        if let value = request.contentEncoding {
            input.headers["Content-Encoding"] = value
        }
        if let value = request.expires {
            input.headers["Expires"] = value
        }
        if let value = request.contentMd5 {
            input.headers["Content-MD5"] = value
        }
        if let value = request.contentType {
            input.headers["Content-Type"] = value
        }
        if let value = request.trafficLimit {
            input.headers["x-oss-traffic-limit"] = String(value)
        }

        if let value = request.metadata {
            for (k, v) in value {
                input.headers["x-oss-meta-\(k)"] = v
            }
        }
    }

    static func deserializeCopyObject(
        _ result: inout CopyObjectResult,
        _ output: inout OperationOutput
    ) throws {
        let body: [String: String] = try Serde.deserializeXml(output.body, "CopyObjectResult")

        result.etag = body["ETag"]
        if let lastModified = body["LastModified"] {
            result.lastModified = lastModified
        }
    }
}

// MARK: - GetObject

extension Serde {
    static func serializeGetObject(
        _ request: inout GetObjectRequest,
        _ input: inout OperationInput
    ) throws {
        if let value = request.range {
            input.headers["Range"] = value
        }
        if let value = request.rangeBehavior {
            input.headers["x-oss-range-behavior"] = value
        }
        if let value = request.ifModifiedSince {
            input.headers["If-Modified-Since"] = value
        }

        if let value = request.ifUnmodifiedSince {
            input.headers["If-Unmodified-Since"] = value
        }

        if let value = request.ifMatch {
            input.headers["If-Match"] = value
        }

        if let value = request.ifNoneMatch {
            input.headers["If-None-Match"] = value
        }

        if let value = request.acceptEncoding {
            input.headers["Accept-Encoding"] = value
        }

        if let value = request.responseContentType {
            input.parameters["response-content-type"] = value
        }

        if let value = request.responseContentLanguage {
            input.parameters["response-content-language"] = value
        }

        if let value = request.responseExpires {
            input.parameters["response-expires"] = value
        }

        if let value = request.responseCacheControl {
            input.parameters["response-cache-control"] = value
        }

        if let value = request.responseContentDisposition {
            input.parameters["response-content-disposition"] = value
        }

        if let value = request.responseContentEncoding {
            input.parameters["response-content-encoding"] = value
        }

        if let value = request.versionId {
            input.parameters["versionId"] = value
        }
        if let value = request.trafficLimit {
            input.headers["x-oss-traffic-limit"] = String(value)
        }
        if let value = request.process {
            input.headers["x-oss-process"] = String(value)
        }
    }

    static func deserializeGetObject(
        _ result: inout GetObjectResult,
        _ output: inout OperationOutput
    ) throws {
        result.body = output.body
    }
}

// MARK: - AppendObject

extension Serde {
    static func serializeAppendObject(
        _ request: inout AppendObjectRequest,
        _ input: inout OperationInput
    ) throws {
        if let value = request.serverSideEncryption {
            input.headers["x-oss-server-side-encryption"] = value
        }

        if let value = request.objectAcl {
            input.headers["x-oss-object-acl"] = value
        }

        if let value = request.storageClass {
            input.headers["x-oss-storage-class"] = value
        }

        if let value = request.metadata {
            for (k, v) in value {
                input.headers["x-oss-meta-\(k)"] = v
            }
        }

        if let value = request.cacheControl {
            input.headers["Cache-Control"] = value
        }

        if let value = request.contentDisposition {
            input.headers["Content-Disposition"] = value
        }

        if let value = request.contentEncoding {
            input.headers["Content-Encoding"] = value
        }

        if let value = request.contentMd5 {
            input.headers["Content-MD5"] = value
        }
        if let value = request.contentType {
            input.headers["Content-Type"] = value
        }
        if let value = request.expires {
            input.headers["Expires"] = value
        }

        if let value = request.position {
            input.parameters["position"] = String(value)
        }
        if let value = request.trafficLimit {
            input.headers["x-oss-traffic-limit"] = String(value)
        }
        input.body = request.body
    }

    static func deserializeAppendObject(
        _: inout AppendObjectResult,
        _: inout OperationOutput
    ) throws {}
}

// MARK: - DeleteObject

extension Serde {
    static func serializeDeleteObject(
        _ request: inout DeleteObjectRequest,
        _ input: inout OperationInput
    ) throws {
        if let value = request.versionId {
            input.parameters["versionId"] = value
        }
    }

    static func deserializeDeleteObject(
        _: inout DeleteObjectResult,
        _: inout OperationOutput
    ) throws {}
}

// MARK: - HeadObject

extension Serde {
    static func serializeHeadObject(
        _ request: inout HeadObjectRequest,
        _ input: inout OperationInput
    ) throws {
        if let value = request.ifModifiedSince {
            input.headers["If-Modified-Since"] = value
        }

        if let value = request.ifUnmodifiedSince {
            input.headers["If-Unmodified-Since"] = value
        }

        if let value = request.ifMatch {
            input.headers["If-Match"] = value
        }

        if let value = request.ifNoneMatch {
            input.headers["If-None-Match"] = value
        }

        if let value = request.versionId {
            input.parameters["versionId"] = value
        }
    }

    static func deserializeHeadObject(
        _: inout HeadObjectResult,
        _: inout OperationOutput
    ) throws {}
}

// MARK: - GetObjectMeta

extension Serde {
    static func serializeGetObjectMeta(
        _ request: inout GetObjectMetaRequest,
        _ input: inout OperationInput
    ) throws {
        if let value = request.versionId {
            input.parameters["versionId"] = value
        }
    }

    static func deserializeGetObjectMeta(
        _: inout GetObjectMetaResult,
        _: inout OperationOutput
    ) throws {}
}

// MARK: - DeleteMultipleObjects

extension Serde {
    static func serializeDeleteMultipleObjects(
        _ request: inout DeleteMultipleObjectsRequest,
        _ input: inout OperationInput
    ) throws {
        if let value = request.encodingType {
            input.headers["Encoding-Type"] = value
        }

        var xmlBody = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
        xmlBody.append("<Delete>")
        if let quiet = request.delete?.quiet {
            xmlBody.append("<Quiet>\(quiet)</Quiet>")
        }
        if let objects = request.delete?.objects {
            for object in objects {
                if let key = object.key {
                    xmlBody.append("<Object><Key>\(key.escape())</Key>")
                    if let versionId = object.versionId {
                        xmlBody.append("<VersionId>\(versionId)</VersionId>")
                    }
                    xmlBody.append("</Object>")
                }
            }
        }
        xmlBody.append("</Delete>")
        if let body = xmlBody.data(using: .utf8) {
            input.body = .data(body)
        }
    }

    static func deserializeDeleteMultipleObjects(
        _ result: inout DeleteMultipleObjectsResult,
        _ output: inout OperationOutput
    ) throws {
        let deleteResult: [String: Any] = try Serde.deserializeXml(output.body, "DeleteResult")

        result.encodingType = deleteResult["EncodingType"] as? String
        if let deleted = deleteResult["Deleted"] as? [[String: Any]] {
            var deletedObjects: [DeletedInfo] = []
            for object in deleted {
                guard let key = object["Key"] as? String else {
                    continue
                }
                var deletedObject = DeletedInfo(key: key,
                                                versionId: object["VersionId"] as? String,
                                                deleteMarker: (object["DeleteMarker"] as? String)?.toBool(),
                                                deleteMarkerVersionId: object["DeleteMarkerVersionId"] as? String)
                if result.encodingType == "url" {
                    deletedObject.key = deletedObject.key?.removingPercentEncoding
                }

                deletedObjects.append(deletedObject)
            }
            result.deletedObjects = deletedObjects
        }
    }
}

// MARK: - RestoreObject

extension Serde {
    static func serializeRestoreObject(
        _ request: inout RestoreObjectRequest,
        _ input: inout OperationInput
    ) throws {
        if let value = request.versionId {
            input.parameters["versionId"] = value
        }

        var xmlBody = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
        xmlBody.append("<RestoreRequest>")
        if let days = request.restoreRequest?.days {
            xmlBody.append("<Days>\(days)</Days>")
        }
        if let tier = request.restoreRequest?.jobParameters?.tier {
            xmlBody.append("<JobParameters><Tier>\(tier)</Tier></JobParameters>")
        }
        xmlBody.append("</RestoreRequest>")
        if let body = xmlBody.data(using: .utf8) {
            input.body = .data(body)
        }
    }

    static func deserializeRestoreObject(
        _: inout RestoreObjectResult,
        _: inout OperationOutput
    ) throws {}
}

// MARK: - CleanRestoredObject

extension Serde {
    static func serializeCleanRestoredObject(
        _: inout CleanRestoredObjectRequest,
        _: inout OperationInput
    ) throws {}

    static func deserializeCleanRestoredObject(
        _: inout CleanRestoredObjectResult,
        _: inout OperationOutput
    ) throws {}
}
