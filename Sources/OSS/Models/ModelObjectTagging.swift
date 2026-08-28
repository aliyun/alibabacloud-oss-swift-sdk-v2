import Foundation

/// The container used to store the tag that you want to configure.
public struct Tag: Sendable {
    /// The key of a tag. *   A tag key can be up to 64 bytes in length.*   A tag key cannot start with `http://`, `https://`, or `Aliyun`.*   A tag key must be UTF-8 encoded.*   A tag key cannot be left empty.
    public var key: Swift.String?

    /// The value of the tag that you want to add or modify. *   A tag value can be up to 128 bytes in length.*   A tag value must be UTF-8 encoded.*   The tag value can be left empty.
    public var value: Swift.String?

    public init(
        key: Swift.String? = nil,
        value: Swift.String? = nil
    ) {
        self.key = key
        self.value = value
    }
}

/// The container for tags.
public struct TagSet: Sendable {
    /// The tags.
    public var tags: [Tag]?

    public init(
        tags: [Tag]? = nil
    ) {
        self.tags = tags
    }
}

/// The container that stores the returned tag of the bucket.
public struct Tagging: Sendable {
    /// The tag set of the target object.
    public var tagSet: TagSet?

    public init(
        tagSet: TagSet? = nil
    ) {
        self.tagSet = tagSet
    }
}

extension Tagging: Codable {
    enum CodingKeys: String, CodingKey {
        case tagSet = "TagSet"
    }
}

extension TagSet: Codable {
    enum CodingKeys: String, CodingKey {
        case tags = "Tag"
    }
}

extension Tag: Codable {
    enum CodingKeys: String, CodingKey {
        case key = "Key"
        case value = "Value"
    }
}

/// The request for the PutObjectTagging operation.
public struct PutObjectTaggingRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String?

    /// The name of the object.
    public var key: Swift.String?

    /// The version id of the target object.
    public var versionId: Swift.String?

    /// The request body schema.
    public var tagging: Tagging?

    public init(
        bucket: Swift.String? = nil,
        key: Swift.String? = nil,
        versionId: Swift.String? = nil,
        tagging: Tagging? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.bucket = bucket
        self.key = key
        self.versionId = versionId
        self.tagging = tagging
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the PutObjectTagging operation.
public struct PutObjectTaggingResult: ResultModel {
    public var commonProp: ResultModelProp = .init()

    /// The version ID of the object.
    public var versionId: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-version-id"] }
}

/// The request for the GetObjectTagging operation.
public struct GetObjectTaggingRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String?

    /// The full path of the object.
    public var key: Swift.String?

    /// The versionID of the object that you want to query.
    public var versionId: Swift.String?

    public init(
        bucket: Swift.String? = nil,
        key: Swift.String? = nil,
        versionId: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.bucket = bucket
        self.key = key
        self.versionId = versionId
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the GetObjectTagging operation.
public struct GetObjectTaggingResult: ResultModel {
    public var commonProp: ResultModelProp = .init()

    /// The container that stores the returned tag of the bucket.
    public var tagging: Tagging?
}

/// The request for the DeleteObjectTagging operation.
public struct DeleteObjectTaggingRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String?

    /// The full path of the object.
    public var key: Swift.String?

    /// The version ID of the object that you want to delete.
    public var versionId: Swift.String?

    public init(
        bucket: Swift.String? = nil,
        key: Swift.String? = nil,
        versionId: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.bucket = bucket
        self.key = key
        self.versionId = versionId
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the DeleteObjectTagging operation.
public struct DeleteObjectTaggingResult: ResultModel {
    public var commonProp: ResultModelProp = .init()
}
