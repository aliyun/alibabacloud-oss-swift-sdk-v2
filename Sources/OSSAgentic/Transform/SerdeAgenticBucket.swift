import AlibabaCloudOSS
import Foundation

/// The Content-MD5 of an empty body, sent on bodyless agentic requests.
private let emptyContentMd5 = "1B2M2Y8AsgTpgAmY7PhCfg=="

private func parseServerSideEncryptionRule(_ node: [String: Any]) -> ServerSideEncryptionRule {
    // SSE fields are nested under ApplyServerSideEncryptionByDefault per spec;
    // fall back to the rule element itself for a flat shape.
    let base = (node["ApplyServerSideEncryptionByDefault"] as? [String: Any]) ?? node
    return ServerSideEncryptionRule(
        kMSDataEncryption: base["KMSDataEncryption"] as? String,
        sSEAlgorithm: base["SSEAlgorithm"] as? String,
        kMSMasterKeyID: base["KMSMasterKeyID"] as? String
    )
}

private func parseAgenticBucketInfo(_ node: [String: Any]) -> AgenticBucketInfo {
    var info = AgenticBucketInfo()
    info.name = node["Name"] as? String
    info.owner = node["Owner"] as? String
    info.region = node["Region"] as? String
    info.storageClass = node["StorageClass"] as? String
    info.dataRedundancyType = node["DataRedundancyType"] as? String
    info.status = node["Status"] as? String
    info.bucketResourceType = node["BucketResourceType"] as? String
    info.createTime = node["CreateTime"] as? String
    info.acl = node["ACL"] as? String
    info.publicAccessBlock = node["PublicAccessBlock"] as? String
    if let sse = node["ServerSideEncryptionRule"] as? [String: Any] {
        info.serverSideEncryptionRule = parseServerSideEncryptionRule(sse)
    }
    info.versioning = node["Versioning"] as? String
    info.bucketPolicy = node["BucketPolicy"] as? String
    return info
}

// MARK: - CreateAgenticBucket

func serializeCreateAgenticBucket(
    _ request: inout CreateAgenticBucketRequest,
    _ input: inout OperationInput
) throws {
    if let config = request.createAgenticBucketConfiguration {
        var xmlBody = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
        xmlBody.append("<CreateAgenticBucketConfiguration>")
        if let storageClass = config.storageClass {
            xmlBody.append("<StorageClass>\(storageClass)</StorageClass>")
        }
        if let dataRedundancyType = config.dataRedundancyType {
            xmlBody.append("<DataRedundancyType>\(dataRedundancyType)</DataRedundancyType>")
        }
        xmlBody.append("</CreateAgenticBucketConfiguration>")
        input.body = .data(xmlBody.data(using: .utf8)!)
    } else {
        input.headers["Content-MD5"] = emptyContentMd5
    }
}

func deserializeCreateAgenticBucket(
    _: inout CreateAgenticBucketResult,
    _: inout OperationOutput
) throws {}

// MARK: - DeleteAgenticBucket

func serializeDeleteAgenticBucket(
    _: inout DeleteAgenticBucketRequest,
    _ input: inout OperationInput
) throws {
    input.headers["Content-MD5"] = emptyContentMd5
}

func deserializeDeleteAgenticBucket(
    _: inout DeleteAgenticBucketResult,
    _: inout OperationOutput
) throws {}

// MARK: - GetAgenticBucket

func serializeGetAgenticBucket(
    _: inout GetAgenticBucketRequest,
    _ input: inout OperationInput
) throws {
    input.headers["Content-MD5"] = emptyContentMd5
}

func deserializeGetAgenticBucket(
    _ result: inout GetAgenticBucketResult,
    _ output: inout OperationOutput
) throws {
    let body: [String: Any] = try Serde.deserializeXml(output.body, "AgenticBucketInfo")
    result.agenticBucketInfo = parseAgenticBucketInfo(body)
}

// MARK: - ListAgenticBuckets

func serializeListAgenticBuckets(
    _ request: inout ListAgenticBucketsRequest,
    _ input: inout OperationInput
) throws {
    if let value = request.continuationToken {
        input.parameters["continuation-token"] = value
    }
    if let value = request.maxKeys {
        input.parameters["max-keys"] = String(value)
    }
    input.headers["Content-MD5"] = emptyContentMd5
}

func deserializeListAgenticBuckets(
    _ result: inout ListAgenticBucketsResult,
    _ output: inout OperationOutput
) throws {
    let body: [String: Any] = try Serde.deserializeXml(output.body, "ListAgenticBucketsResult")

    result.region = body["Region"] as? String
    result.owner = body["Owner"] as? String
    result.continuationToken = body["ContinuationToken"] as? String
    result.nextContinuationToken = body["NextContinuationToken"] as? String
    result.isTruncated = (body["IsTruncated"] as? String)?.toBool()

    if let wrapper = body["AgenticBuckets"] as? [String: Any],
       let items = wrapper["AgenticBucket"]
    {
        var buckets: [AgenticBucketSummary] = []
        var responseItems: [[String: Any]] = []
        if let array = items as? [[String: Any]] {
            responseItems.append(contentsOf: array)
        } else if let single = items as? [String: Any] {
            responseItems.append(single)
        }
        for item in responseItems {
            var summary = AgenticBucketSummary()
            summary.name = item["Name"] as? String
            summary.storageClass = item["StorageClass"] as? String
            summary.dataRedundancyType = item["DataRedundancyType"] as? String
            summary.createTime = item["CreateTime"] as? String
            buckets.append(summary)
        }
        result.agenticBuckets = buckets
    }
}

// MARK: - PutAgenticBucketStatus

func serializePutAgenticBucketStatus(
    _ request: inout PutAgenticBucketStatusRequest,
    _ input: inout OperationInput
) throws {
    if let status = request.status {
        var xmlBody = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
        xmlBody.append("<AgenticBucketStatus>")
        xmlBody.append("<Status>\(status)</Status>")
        xmlBody.append("</AgenticBucketStatus>")
        input.body = .data(xmlBody.data(using: .utf8)!)
    } else {
        input.headers["Content-MD5"] = emptyContentMd5
    }
}

func deserializePutAgenticBucketStatus(
    _: inout PutAgenticBucketStatusResult,
    _: inout OperationOutput
) throws {}

// MARK: - ListBucketSpaces

func serializeListBucketSpaces(
    _ request: inout ListBucketSpacesRequest,
    _ input: inout OperationInput
) throws {
    if let value = request.prefix {
        input.parameters["prefix"] = value
    }
    if let value = request.continuationToken {
        input.parameters["continuation-token"] = value
    }
    if let value = request.startAfter {
        input.parameters["start-after"] = value
    }
    if let value = request.maxKeys {
        input.parameters["max-keys"] = String(value)
    }
    input.headers["Content-MD5"] = emptyContentMd5
}

func deserializeListBucketSpaces(
    _ result: inout ListBucketSpacesResult,
    _ output: inout OperationOutput
) throws {
    let body: [String: Any] = try Serde.deserializeXml(output.body, "ListBucketSpacesResult")

    if let ownerData = body["Owner"] as? [String: String] {
        var owner = Owner()
        owner.displayName = ownerData["DisplayName"]
        owner.id = ownerData["ID"]
        result.owner = owner
    }
    result.prefix = body["Prefix"] as? String
    result.maxKeys = (body["MaxKeys"] as? String)?.toInt()
    result.continuationToken = body["ContinuationToken"] as? String
    result.nextContinuationToken = body["NextContinuationToken"] as? String
    result.startAfter = body["StartAfter"] as? String
    result.isTruncated = (body["IsTruncated"] as? String)?.toBool()

    if let wrapper = body["BucketSpaces"] as? [String: Any],
       let items = wrapper["BucketSpace"]
    {
        var spaces: [BucketSpaceSummary] = []
        var responseItems: [[String: Any]] = []
        if let array = items as? [[String: Any]] {
            responseItems.append(contentsOf: array)
        } else if let single = items as? [String: Any] {
            responseItems.append(single)
        }
        for item in responseItems {
            var summary = BucketSpaceSummary()
            summary.name = item["Name"] as? String
            summary.location = item["Location"] as? String
            summary.creationDate = item["CreationDate"] as? String
            summary.storageClass = item["StorageClass"] as? String
            spaces.append(summary)
        }
        result.bucketSpaces = spaces
    }
}
