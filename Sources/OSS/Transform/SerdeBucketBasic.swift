import Foundation

// MARK: - GetBucketStat

extension Serde {
    static func serializeGetBucketStat(
        _: inout GetBucketStatRequest,
        _: inout OperationInput
    ) throws {}

    static func deserializeGetBucketStat(
        _ result: inout GetBucketStatResult,
        _ output: inout OperationOutput
    ) throws {
        let body: [String: Any] = try Serde.deserializeXml(output.body, "BucketStat")

        var bucketStat = BucketStat()
        bucketStat.storage = (body["Storage"] as? String)?.toInt()
        bucketStat.deleteMarkerCount = (body["DeleteMarkerCount"] as? String)?.toInt()
        bucketStat.objectCount = (body["ObjectCount"] as? String)?.toInt()
        bucketStat.lastModifiedTime = (body["LastModifiedTime"] as? String)?.toInt()
        bucketStat.multipartUploadCount = (body["MultipartUploadCount"] as? String)?.toInt()
        bucketStat.multipartPartCount = (body["MultipartPartCount"] as? String)?.toInt()
        bucketStat.liveChannelCount = (body["LiveChannelCount"] as? String)?.toInt()
        bucketStat.standardStorage = (body["StandardStorage"] as? String)?.toInt()
        bucketStat.standardObjectCount = (body["StandardObjectCount"] as? String)?.toInt()
        bucketStat.infrequentAccessStorage = (body["InfrequentAccessStorage"] as? String)?.toInt()
        bucketStat.infrequentAccessObjectCount = (body["InfrequentAccessObjectCount"] as? String)?.toInt()
        bucketStat.infrequentAccessRealStorage = (body["InfrequentAccessRealStorage"] as? String)?.toInt()
        bucketStat.archiveStorage = (body["ArchiveStorage"] as? String)?.toInt()
        bucketStat.archiveObjectCount = (body["ArchiveObjectCount"] as? String)?.toInt()
        bucketStat.archiveRealStorage = (body["ArchiveRealStorage"] as? String)?.toInt()
        bucketStat.coldArchiveStorage = (body["ColdArchiveStorage"] as? String)?.toInt()
        bucketStat.coldArchiveObjectCount = (body["ColdArchiveObjectCount"] as? String)?.toInt()
        bucketStat.coldArchiveRealStorage = (body["ColdArchiveRealStorage"] as? String)?.toInt()
        bucketStat.deepColdArchiveRealStorage = (body["DeepColdArchiveRealStorage"] as? String)?.toInt()
        bucketStat.deepColdArchiveObjectCount = (body["DeepColdArchiveObjectCount"] as? String)?.toInt()
        bucketStat.deepColdArchiveStorage = (body["DeepColdArchiveStorage"] as? String)?.toInt()

        result.bucketStat = bucketStat
    }
}

// MARK: - PutBucket

extension Serde {
    static func serializePutBucket(
        _ request: inout PutBucketRequest,
        _ input: inout OperationInput
    ) throws {
        if let value = request.acl {
            input.headers["x-oss-acl"] = value
        }

        if let value = request.resourceGroupId {
            input.headers["x-oss-resource-group-id"] = value
        }

        if let value = request.bucketTagging {
            input.headers["x-oss-bucket-tagging"] = value
        }

        if let value = request.agenticBucket {
            input.headers["x-oss-agentic-bucket"] = value
        }

        // Omit the body when no configuration is provided: agentic bucket space
        // creation rejects a request that carries one.
        if let configuration = request.createBucketConfiguration {
            var xmlBody = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
            xmlBody.append("<CreateBucketConfiguration>")
            if let storageClass = configuration.storageClass {
                xmlBody.append("<StorageClass>\(storageClass)</StorageClass>")
            }
            if let dataRedundancyType = configuration.dataRedundancyType {
                xmlBody.append("<DataRedundancyType>\(dataRedundancyType)</DataRedundancyType>")
            }
            xmlBody.append("</CreateBucketConfiguration>")

            input.body = .data(xmlBody.data(using: .utf8)!)
        }
    }

    static func deserializePutBucket(
        _: inout PutBucketResult,
        _: inout OperationOutput
    ) throws {}
}

// MARK: - DeleteBucket

extension Serde {
    static func serializeDeleteBucket(
        _: inout DeleteBucketRequest,
        _: inout OperationInput
    ) throws {}

    static func deserializeDeleteBucket(
        _: inout DeleteBucketResult,
        _: inout OperationOutput
    ) throws {}
}

// MARK: - ListObjects

extension Serde {
    static func serializeListObjects(
        _ request: inout ListObjectsRequest,
        _ input: inout OperationInput
    ) throws {
        if let value = request.delimiter {
            input.parameters["delimiter"] = value
        }

        if let value = request.marker {
            input.parameters["marker"] = value
        }

        if let value = request.maxKeys {
            input.parameters["max-keys"] = String(value)
        }

        if let value = request.prefix {
            input.parameters["prefix"] = value
        }

        if let value = request.encodingType {
            input.parameters["encoding-type"] = value
        }
    }

    static func deserializeListObjects(
        _ result: inout ListObjectsResult,
        _ output: inout OperationOutput
    ) throws {
        let body: [String: Any] = try Serde.deserializeXml(output.body, "ListBucketResult")

        result.name = body["Name"] as? String
        if let isTruncatedString = body["IsTruncated"] as? String, let isTruncated = Bool(isTruncatedString) {
            result.isTruncated = isTruncated
        }
        result.marker = body["Marker"] as? String
        result.nextMarker = body["NextMarker"] as? String
        result.prefix = body["Prefix"] as? String
        result.delimiter = body["Delimiter"] as? String
        result.encodingType = body["EncodingType"] as? String
        result.maxKeys = (body["MaxKeys"] as? String)?.toInt()
        var commonPrefixes: [CommonPrefix]?
        if let commonPrefix = body["CommonPrefixes"] as? [String: String],
           let prefix = commonPrefix["Prefix"]
        {
            commonPrefixes = [CommonPrefix(prefix: prefix)]
        } else if let commonPrefix = body["CommonPrefixes"] as? [[String: String]] {
            commonPrefixes = []
            for prefix in commonPrefix {
                if let _prefix = prefix["Prefix"] {
                    commonPrefixes?.append(CommonPrefix(prefix: _prefix))
                }
            }
        }
        result.commonPrefixes = commonPrefixes

        var contentObjects: [ObjectSummary]?
        if let contents = body["Contents"] {
            contentObjects = []

            var objects: [[String: Any]] = []
            if let _contents = contents as? [[String: Any]] {
                objects.append(contentsOf: _contents)
            } else if let content = contents as? [String: Any] {
                objects.append(content)
            }
            for object in objects {
                var contentObject = ObjectSummary()
                contentObject.key = object["Key"] as? String
                contentObject.etag = object["ETag"] as? String
                contentObject.lastModified = (object["LastModified"] as? String)?.toDate()
                contentObject.transitionTime = (object["TransitionTime"] as? String)?.toDate()
                contentObject.size = (object["Size"] as? String)?.toInt()
                contentObject.storageClass = object["StorageClass"] as? String
                contentObject.restoreInfo = object["RestoreInfo"] as? String
                contentObject.type = object["Type"] as? String
                if let ownerData = object["Owner"] as? [String: String] {
                    var owner = Owner()
                    owner.displayName = ownerData["DisplayName"]
                    owner.id = ownerData["ID"]
                    contentObject.owner = owner
                }

                contentObjects?.append(contentObject)
            }
        }
        result.contents = contentObjects
        deserializeEncodingType(result: &result)
    }

    static func deserializeEncodingType(result: inout ListObjectsResult) {
        guard result.encodingType == "url" else {
            return
        }

        result.name = result.name?.removingPercentEncoding
        result.delimiter = result.delimiter?.removingPercentEncoding
        result.prefix = result.prefix?.removingPercentEncoding
        result.marker = result.marker?.removingPercentEncoding
        result.nextMarker = result.nextMarker?.removingPercentEncoding
        if let contents = result.contents {
            var decodeContents: [ObjectSummary] = []
            for content in contents {
                var decodeContent = content
                decodeContent.key = decodeContent.key?.removingPercentEncoding
                decodeContents.append(decodeContent)
            }
            result.contents = decodeContents
        }
        if let commonPrefixes = result.commonPrefixes {
            var decodeCommonPrefixes: [CommonPrefix] = []
            for commonPrefix in commonPrefixes {
                var decodeCommonPrefix = commonPrefix
                decodeCommonPrefix.prefix = decodeCommonPrefix.prefix?.removingPercentEncoding
                decodeCommonPrefixes.append(decodeCommonPrefix)
            }
            result.commonPrefixes = decodeCommonPrefixes
        }
    }
}

// MARK: - ListObjectsV2

extension Serde {
    static func serializeListObjectsV2(
        _ request: inout ListObjectsV2Request,
        _ input: inout OperationInput
    ) throws {
        if let value = request.delimiter {
            input.parameters["delimiter"] = value
        }

        if let value = request.maxKeys {
            input.parameters["max-keys"] = String(value)
        }

        if let value = request.prefix {
            input.parameters["prefix"] = value
        }

        if let value = request.encodingType {
            input.parameters["encoding-type"] = value
        }

        if let value = request.fetchOwner {
            input.parameters["fetch-owner"] = String(value)
        }

        if let value = request.startAfter {
            input.parameters["start-after"] = value
        }

        if let value = request.continuationToken {
            input.parameters["continuation-token"] = value
        }
    }

    static func deserializeListObjectsV2(
        _ result: inout ListObjectsV2Result,
        _ output: inout OperationOutput
    ) throws {
        let body: [String: Any] = try Serde.deserializeXml(output.body, "ListBucketResult")

        result.name = body["Name"] as? String
        if let isTruncatedString = body["IsTruncated"] as? String, let isTruncated = Bool(isTruncatedString) {
            result.isTruncated = isTruncated
        }
        if let keyCountString = body["KeyCount"] as? String,
           let keyCount = Int(keyCountString)
        {
            result.keyCount = keyCount
        }
        result.startAfter = body["StartAfter"] as? String
        result.prefix = body["Prefix"] as? String
        result.continuationToken = body["ContinuationToken"] as? String
        result.nextContinuationToken = body["NextContinuationToken"] as? String
        result.delimiter = body["Delimiter"] as? String
        result.encodingType = body["EncodingType"] as? String
        if let maxKeys = body["MaxKeys"] as? String {
            result.maxKeys = Int(maxKeys)
        }
        var commonPrefixes: [CommonPrefix]?
        if let commonPrefix = body["CommonPrefixes"] as? [String: String],
           let prefix = commonPrefix["Prefix"]
        {
            commonPrefixes = [CommonPrefix(prefix: prefix)]
        } else if let commonPrefix = body["CommonPrefixes"] as? [[String: String]] {
            commonPrefixes = []
            for prefix in commonPrefix {
                if let _prefix = prefix["Prefix"] {
                    commonPrefixes?.append(CommonPrefix(prefix: _prefix))
                }
            }
        }
        result.commonPrefixes = commonPrefixes

        var contentObjects: [ObjectSummary]?
        if let contents = body["Contents"] {
            contentObjects = []

            var objects: [[String: Any]] = []
            if let _contents = contents as? [[String: Any]] {
                objects.append(contentsOf: _contents)
            } else if let content = contents as? [String: Any] {
                objects.append(content)
            }
            for object in objects {
                var contentObject = ObjectSummary()
                contentObject.key = object["Key"] as? String
                contentObject.etag = object["ETag"] as? String
                contentObject.lastModified = (object["LastModified"] as? String)?.toDate()
                contentObject.transitionTime = (object["TransitionTime"] as? String)?.toDate()
                contentObject.size = (object["Size"] as? String)?.toInt()
                contentObject.storageClass = object["StorageClass"] as? String
                contentObject.restoreInfo = object["RestoreInfo"] as? String
                contentObject.type = object["Type"] as? String
                if let ownerData = object["Owner"] as? [String: String] {
                    var owner = Owner()
                    owner.displayName = ownerData["DisplayName"]
                    owner.id = ownerData["ID"]
                    contentObject.owner = owner
                }

                contentObjects?.append(contentObject)
            }
        }
        result.contents = contentObjects
        deserializeEncodingType(result: &result)
    }

    static func deserializeEncodingType(result: inout ListObjectsV2Result) {
        guard result.encodingType == "url" else {
            return
        }

        result.name = result.name?.removingPercentEncoding
        result.delimiter = result.delimiter?.removingPercentEncoding
        result.prefix = result.prefix?.removingPercentEncoding
        result.continuationToken = result.continuationToken?.removingPercentEncoding
        result.nextContinuationToken = result.nextContinuationToken?.removingPercentEncoding
        result.startAfter = result.startAfter?.removingPercentEncoding
        if let contents = result.contents {
            var decodeContents: [ObjectSummary] = []
            for content in contents {
                var decodeContent = content
                decodeContent.key = decodeContent.key?.removingPercentEncoding
                decodeContents.append(decodeContent)
            }
            result.contents = decodeContents
        }
        if let commonPrefixes = result.commonPrefixes {
            var decodeCommonPrefixes: [CommonPrefix] = []
            for commonPrefix in commonPrefixes {
                var decodeCommonPrefix = commonPrefix
                decodeCommonPrefix.prefix = decodeCommonPrefix.prefix?.removingPercentEncoding
                decodeCommonPrefixes.append(decodeCommonPrefix)
            }
            result.commonPrefixes = decodeCommonPrefixes
        }
    }
}

// MARK: - GetBucketInfo

extension Serde {
    static func serializeGetBucketInfo(
        _: inout GetBucketInfoRequest,
        _: inout OperationInput
    ) throws {}

    static func deserializeGetBucketInfo(
        _ result: inout GetBucketInfoResult,
        _ output: inout OperationOutput
    ) throws {
        let body: [String: Any] = try Serde.deserializeXml(output.body, "BucketInfo")
        let bucketContent = body["Bucket"] as? [String: Any]

        var bucket = Bucket()
        bucket.extranetEndpoint = bucketContent?["ExtranetEndpoint"] as? String
        bucket.intranetEndpoint = bucketContent?["IntranetEndpoint"] as? String
        bucket.location = bucketContent?["Location"] as? String
        bucket.resourceGroupId = bucketContent?["ResourceGroupId"] as? String
        bucket.versioning = bucketContent?["Versioning"] as? String
        bucket.crossRegionReplication = bucketContent?["CrossRegionReplication"] as? String
        bucket.transferAcceleration = bucketContent?["TransferAcceleration"] as? String
        bucket.accessMonitor = bucketContent?["AccessMonitor"] as? String
        bucket.storageClass = bucketContent?["StorageClass"] as? String
        bucket.dataRedundancyType = bucketContent?["DataRedundancyType"] as? String
        bucket.name = bucketContent?["Name"] as? String
        bucket.versioning = bucketContent?["Versioning"] as? String

        bucket.comment = bucketContent?["Comment"] as? String
        bucket.creationDate = (bucketContent?["CreationDate"] as? String)?.toDate()
        bucket.bucketResourceType = bucketContent?["BucketResourceType"] as? String
        bucket.agenticBucketName = bucketContent?["AgenticBucketName"] as? String
        bucket.blockPublicAccess = (bucketContent?["BlockPublicAccess"] as? String)?.toBool()
        if let accessControlList = bucketContent?["AccessControlList"] as? [String: String] {
            bucket.accessControlList = AccessControlList(grant: accessControlList["Grant"])
        }
        if let bucketPolicy = bucketContent?["BucketPolicy"] as? [String: String] {
            bucket.bucketPolicy = BucketPolicy(logBucket: bucketPolicy["LogBucket"],
                                               logPrefix: bucketPolicy["LogPrefix"])
        }
        if let serverSideEncryptionRule = bucketContent?["ServerSideEncryptionRule"] as? [String: String] {
            bucket.serverSideEncryptionRule = ServerSideEncryptionRule(kMSDataEncryption: serverSideEncryptionRule["KMSDataEncryption"],
                                                                       sSEAlgorithm: serverSideEncryptionRule["SSEAlgorithm"],
                                                                       kMSMasterKeyID: serverSideEncryptionRule["KMSMasterKeyID"])
        }
        if let ownerData = bucketContent?["Owner"] as? [String: String] {
            var owner = Owner()
            owner.displayName = ownerData["DisplayName"]
            owner.id = ownerData["ID"]
            bucket.owner = owner
        }
        result.bucketInfo = BucketInfo(bucket: bucket)
    }
}

// MARK: - GetBucketLocation

extension Serde {
    static func serializeGetBucketLocation(
        _: inout GetBucketLocationRequest,
        _: inout OperationInput
    ) throws {}

    static func deserializeGetBucketLocation(
        _ result: inout GetBucketLocationResult,
        _ output: inout OperationOutput
    ) throws {
        let body: String = try Serde.deserializeXml(output.body, "LocationConstraint")
        result.locationConstraint = body
    }
}
