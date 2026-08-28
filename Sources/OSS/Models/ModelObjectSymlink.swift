import Foundation

/// The request for the PutSymlink operation.
public struct PutSymlinkRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String?

    /// The full path of the object.
    public var key: Swift.String?

    /// The target object to which the symbolic link points. The naming conventions for target objects are the same as those for objects.
    /// - Similar to ObjectName, TargetObjectName must be URL-encoded.
    /// - The target object to which a symbolic link points cannot be a symbolic link.
    public var symlinkTarget: Swift.String?

    /// The access control list (ACL) of the object. Default value: default. Valid values:- default: The ACL of the object is the same as that of the bucket in which the object is stored.
    /// - private: The ACL of the object is private. Only the owner of the object and authorized users can read and write this object.
    /// - public-read: The ACL of the object is public-read. Only the owner of the object and authorized users can read and write this object. Other users can only read the object. Exercise caution when you set the object ACL to this value.
    /// - public-read-write: The ACL of the object is public-read-write. All users can read and write this object. Exercise caution when you set the object ACL to this value.
    /// For more information about the ACL, see **[ACL](~~100676~~)**.
    /// Sees ObjectACLType for supported values.
    public var objectAcl: Swift.String?

    /// The storage class of the bucket. Default value: Standard.  Valid values:- Standard- IA- Archive- ColdArchive
    /// Sees StorageClassType for supported values.
    public var storageClass: Swift.String?

    /// Specifies whether the PutSymlink operation overwrites the object that has the same name as that of the symbolic link you want to create.
    /// - If the value of **x-oss-forbid-overwrite** is not specified or set to **false**, existing objects can be overwritten by objects that have the same names.
    /// - If the value of **x-oss-forbid-overwrite** is set to **true**, existing objects cannot be overwritten by objects that have the same names.
    /// If you specify the **x-oss-forbid-overwrite** request header, the queries per second (QPS) performance of OSS is degraded. If you want to use the **x-oss-forbid-overwrite** request header to perform a large number of operations (QPS greater than 1,000), contact technical support.  The **x-oss-forbid-overwrite** request header is invalid when versioning is enabled or suspended for the destination bucket. In this case, the object with the same name can be overwritten.
    public var forbidOverwrite: Swift.Bool?

    public init(
        bucket: Swift.String? = nil,
        key: Swift.String? = nil,
        symlinkTarget: Swift.String? = nil,
        objectAcl: Swift.String? = nil,
        storageClass: Swift.String? = nil,
        forbidOverwrite: Swift.Bool? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.bucket = bucket
        self.key = key
        self.symlinkTarget = symlinkTarget
        self.objectAcl = objectAcl
        self.storageClass = storageClass
        self.forbidOverwrite = forbidOverwrite
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the PutSymlink operation.
public struct PutSymlinkResult: ResultModel {
    public var commonProp: ResultModelProp = .init()

    /// The version ID of the object.
    public var versionId: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-version-id"] }
}

/// The request for the GetSymlink operation.
public struct GetSymlinkRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String?

    /// The full path of the object.
    public var key: Swift.String?

    /// The version of the object to which the symbolic link points.
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

/// The result for the GetSymlink operation.
public struct GetSymlinkResult: ResultModel {
    public var commonProp: ResultModelProp = .init()

    /// The target object that the symbolic link points to.
    public var symlinkTarget: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-symlink-target"] }

    /// The version ID of the object.
    public var versionId: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-version-id"] }
}
