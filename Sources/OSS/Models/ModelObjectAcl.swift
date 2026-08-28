import Foundation

/// The request for the PutObjectAcl operation.
public struct PutObjectAclRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String?

    /// The name of the object.
    public var key: Swift.String?

    /// The access control list (ACL) of the object.
    /// Sees ObjectACLType for supported values.
    public var objectAcl: Swift.String?

    /// The version id of the object.
    public var versionId: Swift.String?

    public init(
        bucket: Swift.String? = nil,
        key: Swift.String? = nil,
        objectAcl: Swift.String? = nil,
        versionId: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.bucket = bucket
        self.key = key
        self.objectAcl = objectAcl
        self.versionId = versionId
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the PutObjectAcl operation.
public struct PutObjectAclResult: ResultModel {
    public var commonProp: ResultModelProp = .init()

    /// The version ID of the object.
    public var versionId: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-version-id"] }
}

/// The request for the GetObjectAcl operation.
public struct GetObjectAclRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String?

    /// The name of the object.
    public var key: Swift.String?

    /// The verison id of the target object.
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

/// The result for the GetObjectAcl operation.
public struct GetObjectAclResult: ResultModel {
    public var commonProp: ResultModelProp = .init()

    /// The container that stores the results of the GetObjectACL request.
    public var accessControlPolicy: AccessControlPolicy?
}
