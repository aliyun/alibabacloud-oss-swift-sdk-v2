import Foundation

// MARK: - PutObjectTagging

extension Serde {
    static func serializePutObjectTagging(
        _ request: inout PutObjectTaggingRequest,
        _ input: inout OperationInput
    ) throws {
        if let value = request.versionId {
            input.parameters["versionId"] = value
        }

        var xmlBody = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
        xmlBody.append("<Tagging>")
        xmlBody.append("<TagSet>")
        if let tagSet = request.tagging?.tagSet?.tags {
            for tag in tagSet {
                if let key = tag.key,
                   let value = tag.value
                {
                    xmlBody.append("<Tag>")
                    xmlBody.append("<Key>\(key.escape())</Key>")
                    xmlBody.append("<Value>\(value.escape())</Value>")
                    xmlBody.append("</Tag>")
                }
            }
        }
        xmlBody.append("</TagSet>")
        xmlBody.append("</Tagging>")
        input.body = .data(xmlBody.data(using: .utf8)!)
    }

    static func deserializePutObjectTagging(
        _: inout PutObjectTaggingResult,
        _: inout OperationOutput
    ) throws {}
}

// MARK: - GetObjectTagging

extension Serde {
    static func serializeGetObjectTagging(
        _ request: inout GetObjectTaggingRequest,
        _ input: inout OperationInput
    ) throws {
        if let value = request.versionId {
            input.parameters["versionId"] = value
        }
    }

    static func deserializeGetObjectTagging(
        _ result: inout GetObjectTaggingResult,
        _ output: inout OperationOutput
    ) throws {
        let body: [String: Any] = try Serde.deserializeXml(output.body, "Tagging")

        var tags: [Tag] = []
        if let tagSet = body["TagSet"] as? [String: Any] {
            var objects: [[String: String]] = []
            if let _contents = tagSet["Tag"] as? [[String: String]] {
                objects.append(contentsOf: _contents)
            } else if let content = tagSet["Tag"] as? [String: String] {
                objects.append(content)
            }

            for object in objects {
                let tag = Tag(key: object["Key"], value: object["Value"])
                tags.append(tag)
            }
        }
        result.tagging = Tagging(tagSet: TagSet(tags: tags))
    }
}

// MARK: - DeleteObjectTagging

extension Serde {
    static func serializeDeleteObjectTagging(
        _ request: inout DeleteObjectTaggingRequest,
        _ input: inout OperationInput
    ) throws {
        if let value = request.versionId {
            input.parameters["versionId"] = value
        }
    }

    static func deserializeDeleteObjectTagging(
        _: inout DeleteObjectTaggingResult,
        _: inout OperationOutput
    ) throws {}
}
