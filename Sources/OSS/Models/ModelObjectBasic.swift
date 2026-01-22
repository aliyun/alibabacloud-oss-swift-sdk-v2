import Foundation

/// The container that stores the restoration priority coniguration. This configuration takes effect only when the request is sent to restore Cold Archive objects. If you do not specify the JobParameters parameter, the default restoration priority Standard is used.
public struct JobParameters: Sendable {
    /// The restoration priority. Valid values:*   Expedited: The object is restored within 1 hour.*   Standard: The object is restored within 2 to 5 hours.*   Bulk: The object is restored within 5 to 12 hours.
    public var tier: Swift.String?

    public init(
        tier: Swift.String? = nil
    ) {
        self.tier = tier
    }
}

/// The container that stores information about the RestoreObject request.
public struct RestoreRequest: Sendable {
    /// The duration in which the object can remain in the restored state. Unit: days. Valid values: 1 to 7.
    public var days: Swift.Int?

    /// The container that stores the restoration priority coniguration. This configuration takes effect only when the request is sent to restore Cold Archive objects. If you do not specify the JobParameters parameter, the default restoration priority Standard is used.
    public var jobParameters: JobParameters?

    public init(
        days: Swift.Int? = nil,
        jobParameters: JobParameters? = nil
    ) {
        self.days = days
        self.jobParameters = jobParameters
    }
}

public struct DeleteObject: Sendable {
    /// The name of the object that you want to delete.
    public var key: Swift.String?

    /// The version ID of the object that you want to delete.
    public var versionId: Swift.String?

    public init(key: String? = nil, versionId: String? = nil) {
        self.key = key
        self.versionId = versionId
    }
}

public struct DeletedInfo: Sendable {
    /// The name of the deleted object.
    public var key: Swift.String?

    /// The version ID of the object that you deleted.
    public var versionId: Swift.String?

    /// Indicates whether the deleted version is a delete marker.
    public var deleteMarker: Swift.Bool?

    /// The version ID of the delete marker.
    public var deleteMarkerVersionId: Swift.String?
}

/// The request for the PutObject operation.
public struct PutObjectRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String?

    /// The full path of the object.
    public var key: Swift.String?

    /// Specifies whether the object that is uploaded by calling the PutObject operation overwrites the existing object that has the same name.  When versioning is enabled or suspended for the bucket to which you want to upload the object, the **x-oss-forbid-overwrite** header does not take effect. In this case, the object that is uploaded by calling the PutObject operation overwrites the existing object that has the same name.
    ///   - If you do not specify the **x-oss-forbid-overwrite** header or set the **x-oss-forbid-overwrite** header to **false**, the object that is uploaded by calling the PutObject operation overwrites the existing object that has the same name.
    ///   - If the value of **x-oss-forbid-overwrite** is set to **true**, existing objects cannot be overwritten by objects that have the same names. If you specify the **x-oss-forbid-overwrite** request header, the queries per second (QPS) performance of OSS is degraded. If you want to use the **x-oss-forbid-overwrite** request header to perform a large number of operations (QPS greater than 1,000), contact technical support. Default value: **false**.
    public var forbidOverwrite: Swift.Bool?

    /// The method that is used to encrypt the object on the OSS server when the object is created. Valid values: **AES256**, **KMS**, and **SM4****.If you specify the header, the header is returned in the response. OSS uses the method that is specified by this header to encrypt the uploaded object. When you download the encrypted object, the **x-oss-server-side-encryption** header is included in the response and the header value is set to the algorithm that is used to encrypt the object.
    public var serverSideEncryption: Swift.String?

    /// The encryption method on the server side when an object is created. Valid values: **AES256**, **KMS**, and **SM4**.
    /// If you specify the header, the header is returned in the response. OSS uses the method that is specified by this header to encrypt the uploaded object. When you download the encrypted object, the **x-oss-server-side-encryption** header is included in the response and the header value is set to the algorithm that is used to encrypt the object.
    public var serverSideDataEncryption: Swift.String?

    /// The ID of the customer master key (CMK) managed by Key Management Service (KMS). This header is valid only when the **x-oss-server-side-encryption** header is set to KMS.
    public var serverSideEncryptionKeyId: Swift.String?

    /// The access control list (ACL) of the object. Default value: default. Valid values:- default: The ACL of the object is the same as that of the bucket in which the object is stored.
    ///  - private: The ACL of the object is private. Only the owner of the object and authorized users can read and write this object.
    ///  - public-read: The ACL of the object is public-read. Only the owner of the object and authorized users can read and write this object. Other users can only read the object. Exercise caution when you set the object ACL to this value.
    ///  - public-read-write: The ACL of the object is public-read-write. All users can read and write this object. Exercise caution when you set the object ACL to this value.
    /// For more information about the ACL, see **[ACL](~~100676~~)**.
    /// Sees ObjectACLType for supported values.
    public var objectAcl: Swift.String?

    /// The storage class of the bucket. Default value: Standard.  Valid values:- Standard- IA- Archive- ColdArchive
    /// Sees StorageClassType for supported values.
    public var storageClass: Swift.String?

    /// The tag of the object. You can configure multiple tags for the object. Example: TagA=A&TagB=B.
    /// The key and value of a tag must be URL-encoded. If a tag does not contain an equal sign (=), the value of the tag is considered an empty string.
    public var tagging: Swift.String?

    /// The caching behavior of the web page when the object is downloaded.
    public var cacheControl: Swift.String?

    /// The name of the object when the object is downloaded.
    public var contentDisposition: Swift.String?

    /// The content encoding format of the object when the object is downloaded.
    public var contentEncoding: Swift.String?

    /// The expiration time of the request.
    public var expires: Swift.String?

    /// The MD5 hash of the object that you want to upload.
    public var contentMd5: Swift.String?

    /// A standard MIME type describing the format of the contents.
    public var contentType: Swift.String?

    /// A callback parameter is a Base64-encoded string that contains multiple fields in the JSON format.
    public var callback: Swift.String?

    /// Configure custom parameters by using the callback-var parameter.
    public var callbackVar: Swift.String?

    /// Specify the speed limit value. The speed limit value ranges from  245760 to 838860800, with a unit of bit/s.
    public var trafficLimit: Swift.Int?

    /// <no value>
    public var metadata: [Swift.String: Swift.String]?

    /// The body of the request.
    public var body: ByteStream?

    /// progress
    public var progress: ProgressDelegate?

    public init(bucket: String? = nil,
                key: String? = nil,
                forbidOverwrite: Bool? = nil,
                serverSideEncryption: String? = nil,
                serverSideDataEncryption: String? = nil,
                serverSideEncryptionKeyId: String? = nil,
                objectAcl: String? = nil,
                storageClass: String? = nil,
                tagging: String? = nil,
                cacheControl: String? = nil,
                contentDisposition: String? = nil,
                contentEncoding: String? = nil,
                expires: String? = nil,
                contentMd5: String? = nil,
                contentType: String? = nil,
                callback: String? = nil,
                callbackVar: String? = nil,
                trafficLimit: Int? = nil,
                metadata: [String: String]? = nil,
                body: ByteStream? = nil,
                progress: ProgressDelegate? = nil,
                commonProp: RequestModelProp? = nil)
    {
        self.bucket = bucket
        self.key = key
        self.forbidOverwrite = forbidOverwrite
        self.serverSideEncryption = serverSideEncryption
        self.serverSideDataEncryption = serverSideDataEncryption
        self.serverSideEncryptionKeyId = serverSideEncryptionKeyId
        self.objectAcl = objectAcl
        self.storageClass = storageClass
        self.tagging = tagging
        self.cacheControl = cacheControl
        self.contentDisposition = contentDisposition
        self.contentEncoding = contentEncoding
        self.expires = expires
        self.contentMd5 = contentMd5
        self.contentType = contentType
        self.callback = callback
        self.callbackVar = callbackVar
        self.trafficLimit = trafficLimit
        self.metadata = metadata
        self.body = body
        self.progress = progress
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the PutObject operation.
public struct PutObjectResult: ResultModel {
    public var commonProp: ResultModelProp = .init()

    /// The 64-bit CRC value of the object. This value is calculated based on the ECMA-182 standard.
    public var hashCrc64ecma: Swift.UInt64? { return commonProp.headers?[caseInsensitive: "x-oss-hash-crc64ecma"]?.toUInt64() }

    /// Version of the object.
    public var versionId: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-version-id"] }

    /// Entity tag for the uploaded object.
    public var etag: Swift.String? { commonProp.headers?[caseInsensitive: "ETag"] }

    /// Content-Md5 for the uploaded object.
    public var contentMd5: Swift.String? { return commonProp.headers?[caseInsensitive: "Content-MD5"] }

    /// Callback result in json format.
    /// It is valid only when the callback is set.
    public var callbackResult: Data?
}

/// The request for the CopyObject operation.
public struct CopyObjectRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String?

    /// The full path of the object.
    public var key: Swift.String?

    /// The name of the source bucket.
    public var sourceBucket: Swift.String?

    /// The name of the source object.
    public var sourceKey: Swift.String?

    /// Specifies whether the CopyObject operation overwrites objects with the same name. The **x-oss-forbid-overwrite** request header does not take effect when versioning is enabled or suspended for the destination bucket. In this case, the CopyObject operation overwrites the existing object that has the same name as the destination object.*   If you do not specify the **x-oss-forbid-overwrite** header or set the header to **false**, an existing object that has the same name as the object that you want to copy is overwritten.*****   If you set the **x-oss-forbid-overwrite** header to **true**, an existing object that has the same name as the object that you want to copy is not overwritten.If you specify the **x-oss-forbid-overwrite** header, the queries per second (QPS) performance of OSS may be degraded. If you want to specify the **x-oss-forbid-overwrite** header in a large number of requests (QPS greater than 1,000), contact technical support. Default value: false.
    public var forbidOverwrite: Swift.Bool?

    /// The object copy condition. If the ETag value of the source object is the same as the ETag value that you specify in the request, OSS copies the object and returns 200 OK. By default, this header is left empty.
    public var copySourceIfMatch: Swift.String?

    /// The object copy condition. If the ETag value of the source object is different from the ETag value that you specify in the request, OSS copies the object and returns 200 OK. By default, this header is left empty.
    public var copySourceIfNoneMatch: Swift.String?

    /// The object copy condition. If the time that you specify in the request is the same as or later than the modification time of the object, OSS copies the object and returns 200 OK. By default, this header is left empty.
    public var copySourceIfUnmodifiedSince: Swift.String?

    /// If the source object is modified after the time that you specify in the request, OSS copies the object. By default, this header is left empty.
    public var copySourceIfModifiedSince: Swift.String?

    /// The method that is used to configure the metadata of the destination object. Default value: COPY.*   **COPY**: The metadata of the source object is copied to the destination object. The **x-oss-server-side-encryption** attribute of the source object is not copied to the destination object. The **x-oss-server-side-encryption** header in the CopyObject request specifies the method that is used to encrypt the destination object.*   **REPLACE**: The metadata that you specify in the request is used as the metadata of the destination object.  If the path of the source object is the same as the path of the destination object and versioning is disabled for the bucket in which the source and destination objects are stored, the metadata that you specify in the CopyObject request is used as the metadata of the destination object regardless of the value of the x-oss-metadata-directive header.
    public var metadataDirective: Swift.String?

    /// The entropy coding-based encryption algorithm that OSS uses to encrypt an object when you create the object. The valid values of the header are **AES256** and **KMS**. You must activate Key Management Service (KMS) in the OSS console before you can use the KMS encryption algorithm. Otherwise, the KmsServiceNotEnabled error is returned.*   If you do not specify the **x-oss-server-side-encryption** header in the CopyObject request, the destination object is not encrypted on the server regardless of whether the source object is encrypted on the server.*   If you specify the **x-oss-server-side-encryption** header in the CopyObject request, the destination object is encrypted on the server after the CopyObject operation is performed regardless of whether the source object is encrypted on the server. In addition, the response to a CopyObject request contains the **x-oss-server-side-encryption** header whose value is the encryption algorithm of the destination object. When the destination object is downloaded, the **x-oss-server-side-encryption** header is included in the response. The value of this header is the encryption algorithm of the destination object.
    public var serverSideEncryption: Swift.String?

    /// The server side data encryption algorithm. Invalid value: SM4
    public var serverSideDataEncryption: Swift.String?

    /// The ID of the customer master key (CMK) that is managed by KMS. This parameter is available only if you set **x-oss-server-side-encryption** to KMS.
    public var serverSideEncryptionKeyId: Swift.String?

    /// The access control list (ACL) of the destination object when the object is created. Default value: default.Valid values:*   default: The ACL of the object is the same as the ACL of the bucket in which the object is stored.*   private: The ACL of the object is private. Only the owner of the object and authorized users have read and write permissions on the object. Other users do not have permissions on the object.*   public-read: The ACL of the object is public-read. Only the owner of the object and authorized users have read and write permissions on the object. Other users have only read permissions on the object. Exercise caution when you set the ACL of the bucket to this value.*   public-read-write: The ACL of the object is public-read-write. All users have read and write permissions on the object. Exercise caution when you set the ACL of the bucket to this value.For more information about ACLs, see [Object ACL](~~100676~~).
    /// Sees ObjectACLType for supported values.
    public var objectAcl: Swift.String?

    /// The storage class of the object that you want to upload. Default value: Standard. If you specify a storage class when you upload the object, the storage class applies regardless of the storage class of the bucket to which you upload the object. For example, if you set **x-oss-storage-class** to Standard when you upload an object to an IA bucket, the storage class of the uploaded object is Standard.Valid values:*   Standard*   IA*   Archive*   ColdArchiveFor more information about storage classes, see [Overview](~~51374~~).
    /// Sees StorageClassType for supported values.
    public var storageClass: Swift.String?

    /// The tag of the destination object. You can add multiple tags to the destination object. Example: TagA=A\&TagB=B.  The tag key and tag value must be URL-encoded. If a key-value pair does not contain an equal sign (=), the tag value is considered an empty string.
    public var tagging: Swift.String?

    /// The method that is used to add tags to the destination object. Default value: Copy.
    /// Valid values:
    ///    **Copy**: The tags of the source object are copied to the destination object.
    ///    **Replace**: The tags that you specify in the request are added to the destination object.
    public var taggingDirective: Swift.String?

    /// The caching behavior of the web page when the object is downloaded.
    public var cacheControl: Swift.String?

    /// The name of the object when the object is downloaded.
    public var contentDisposition: Swift.String?

    /// The content encoding format of the object when the object is downloaded.
    public var contentEncoding: Swift.String?

    /// The expiration time of the request.
    public var expires: Swift.String?

    /// The MD5 hash of the object that you want to upload.
    public var contentMd5: Swift.String?

    /// A standard MIME type describing the format of the contents.
    public var contentType: Swift.String?

    /// Specify the speed limit value. The speed limit value ranges from  245760 to 838860800, with a unit of bit/s.
    public var trafficLimit: Swift.Int?

    /// <no value>
    public var metadata: [Swift.String: Swift.String]?

    public init(
        bucket: Swift.String? = nil,
        key: Swift.String? = nil,
        sourceBucket: Swift.String? = nil,
        sourceKey: Swift.String? = nil,
        forbidOverwrite: Swift.Bool? = nil,
        copySourceIfMatch: Swift.String? = nil,
        copySourceIfNoneMatch: Swift.String? = nil,
        copySourceIfUnmodifiedSince: Swift.String? = nil,
        copySourceIfModifiedSince: Swift.String? = nil,
        metadataDirective: Swift.String? = nil,
        serverSideEncryption: Swift.String? = nil,
        serverSideDataEncryption: Swift.String? = nil,
        serverSideEncryptionKeyId: Swift.String? = nil,
        objectAcl: Swift.String? = nil,
        storageClass: Swift.String? = nil,
        tagging: Swift.String? = nil,
        taggingDirective: Swift.String? = nil,
        cacheControl: String? = nil,
        contentDisposition: String? = nil,
        contentEncoding: String? = nil,
        expires: String? = nil,
        contentMd5: String? = nil,
        contentType: String? = nil,
        trafficLimit: Int? = nil,
        metadata: [Swift.String: Swift.String]? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.bucket = bucket
        self.key = key
        self.sourceBucket = sourceBucket
        self.sourceKey = sourceKey
        self.forbidOverwrite = forbidOverwrite
        self.copySourceIfMatch = copySourceIfMatch
        self.copySourceIfNoneMatch = copySourceIfNoneMatch
        self.copySourceIfUnmodifiedSince = copySourceIfUnmodifiedSince
        self.copySourceIfModifiedSince = copySourceIfModifiedSince
        self.metadataDirective = metadataDirective
        self.serverSideEncryption = serverSideEncryption
        self.serverSideDataEncryption = serverSideDataEncryption
        self.serverSideEncryptionKeyId = serverSideEncryptionKeyId
        self.objectAcl = objectAcl
        self.storageClass = storageClass
        self.tagging = tagging
        self.taggingDirective = taggingDirective
        self.cacheControl = cacheControl
        self.contentDisposition = contentDisposition
        self.contentEncoding = contentEncoding
        self.expires = expires
        self.contentMd5 = contentMd5
        self.contentType = contentType
        self.trafficLimit = trafficLimit
        self.metadata = metadata
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the CopyObject operation.
public struct CopyObjectResult: ResultModel {
    public var commonProp: ResultModelProp = .init()

    /// The version ID of the source object.
    public var copySourceVersionId: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-copy-source-version-id"] }

    /// Version of the object.
    public var versionId: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-version-id"] }

    /// The 64-bit CRC value of the object. This value is calculated based on the ECMA-182 standard.
    public var hashCrc64: Swift.UInt64? { return commonProp.headers?[caseInsensitive: "x-oss-hash-crc64ecma"]?.toUInt64() }

    /// The encryption method on the server side when an object is created. Valid values: AES256 and KMS
    public var ServerSideEncryption: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-server-side-encryption"] }

    /// The encryption algorithm of the object. AES256 or SM4.
    public var ServerSideDataEncryption: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-server-side-data-encryption"] }

    /// The ID of the customer master key (CMK) that is managed by Key Management Service (KMS).
    public var ServerSideEncryptionKeyId: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-server-side-encryption-key-id"] }

    /// The ETag value of the destination object.
    public var etag: Swift.String?

    /// The time when the destination object was last modified.
    public var lastModified: Swift.String?
}

/// The request for the GetObject operation.
public struct GetObjectRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String?

    /// The full path of the object.
    public var key: Swift.String?

    /// The range of data of the object to be returned.
    /// - If the value of Range is valid, OSS returns the response that includes the total size of the object and the range of data returned. For example, Content-Range: bytes 0~9/44 indicates that the total size of the object is 44 bytes, and the range of data returned is the first 10 bytes.
    /// - However, if the value of Range is invalid, the entire object is returned, and the response returned by OSS excludes Content-Range. Default value: null
    public var range: Swift.String?

    /// Specify standard behaviors to download data by range.
    /// If the value is "standard", the download behavior is modified when the specified range is not within the valid range.
    /// For an object whose size is 1,000 bytes:
    /// 1) If you set Range: bytes to 500-2000, the value at the end of the range is invalid. In this case, OSS returns HTTP status code 206 and the data that is within the range of byte 500 to byte 999.
    /// 2) If you set Range: bytes to 1000-2000, the value at the start of the range is invalid. In this case, OSS returns HTTP status code 416 and the InvalidRange error code.
    public var rangeBehavior: Swift.String?

    /// If the time specified in this header is earlier than the object modified time or is invalid, OSS returns the object and 200 OK. If the time specified in this header is later than or the same as the object modified time, OSS returns 304 Not Modified. The time must be in GMT. Example: `Fri, 13 Nov 2015 14:47:53 GMT`.Default value: null
    public var ifModifiedSince: Swift.String?

    /// If the time specified in this header is the same as or later than the object modified time, OSS returns the object and 200 OK. If the time specified in this header is earlier than the object modified time, OSS returns 412 Precondition Failed.                               The time must be in GMT. Example: `Fri, 13 Nov 2015 14:47:53 GMT`.You can specify both the **If-Modified-Since** and **If-Unmodified-Since** headers in a request. Default value: null
    public var ifUnmodifiedSince: Swift.String?

    /// If the ETag specified in the request matches the ETag value of the object, OSS transmits the object and returns 200 OK. If the ETag specified in the request does not match the ETag value of the object, OSS returns 412 Precondition Failed. The ETag value of an object is used to check whether the content of the object has changed. You can check data integrity by using the ETag value. Default value: null
    public var ifMatch: Swift.String?

    /// If the ETag specified in the request does not match the ETag value of the object, OSS transmits the object and returns 200 OK. If the ETag specified in the request matches the ETag value of the object, OSS returns 304 Not Modified. You can specify both the **If-Match** and **If-None-Match** headers in a request. Default value: null
    public var ifNoneMatch: Swift.String?

    /// The encoding type at the client side. If you want an object to be returned in the GZIP format, you must include the Accept-Encoding:gzip header in your request. OSS determines whether to return the object compressed in the GZip format based on the Content-Type header and whether the size of the object is larger than or equal to 1 KB.                                   If an object is compressed in the GZip format, the response OSS returns does not include the ETag value of the object.    - OSS supports the following Content-Type values to compress the object in the GZip format: text/cache-manifest, text/xml, text/plain, text/css, application/javascript, application/x-javascript, application/rss+xml, application/json, and text/json. Default value: null
    public var acceptEncoding: Swift.String?

    /// The content-type header in the response that OSS returns.
    public var responseContentType: Swift.String?

    /// The content-language header in the response that OSS returns.
    public var responseContentLanguage: Swift.String?

    /// The expires header in the response that OSS returns.
    public var responseExpires: Swift.String?

    /// The cache-control header in the response that OSS returns.
    public var responseCacheControl: Swift.String?

    /// The content-disposition header in the response that OSS returns.
    public var responseContentDisposition: Swift.String?

    /// The content-encoding header in the response that OSS returns.
    public var responseContentEncoding: Swift.String?

    /// The version ID of the object that you want to query.
    public var versionId: Swift.String?

    /// Specify the speed limit value. The speed limit value ranges from  245760 to 838860800, with a unit of bit/s.
    public var trafficLimit: Swift.Int?

    /// Image processing parameters.
    public var process: Swift.String?

    /// progress
    public var progress: ProgressDelegate?

    public init(bucket: String? = nil,
                key: String? = nil,
                range: String? = nil,
                rangeBehavior: String? = nil,
                ifModifiedSince: String? = nil,
                ifUnmodifiedSince: String? = nil,
                ifMatch: String? = nil,
                ifNoneMatch: String? = nil,
                acceptEncoding: String? = nil,
                responseContentType: String? = nil,
                responseContentLanguage: String? = nil,
                responseExpires: String? = nil,
                responseCacheControl: String? = nil,
                responseContentDisposition: String? = nil,
                responseContentEncoding: String? = nil,
                versionId: String? = nil,
                trafficLimit: Int? = nil,
                process: String? = nil,
                progress: ProgressDelegate? = nil,
                commonProp: RequestModelProp? = nil)
    {
        self.bucket = bucket
        self.key = key
        self.range = range
        self.rangeBehavior = rangeBehavior
        self.ifModifiedSince = ifModifiedSince
        self.ifUnmodifiedSince = ifUnmodifiedSince
        self.ifMatch = ifMatch
        self.ifNoneMatch = ifNoneMatch
        self.acceptEncoding = acceptEncoding
        self.responseContentType = responseContentType
        self.responseContentLanguage = responseContentLanguage
        self.responseExpires = responseExpires
        self.responseCacheControl = responseCacheControl
        self.responseContentDisposition = responseContentDisposition
        self.responseContentEncoding = responseContentEncoding
        self.versionId = versionId
        self.trafficLimit = trafficLimit
        self.process = process
        self.progress = progress
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the GetObject operation.
public struct GetObjectResult: ResultModel {
    public var commonProp: ResultModelProp = .init()

    /// the Md5 hash for the uploaded object.
    public var contentMd5: Swift.String? { return commonProp.headers?[caseInsensitive: "Content-MD5"] }

    /// A map of metadata to store with the object.
    /// It is a lowcased key dictionary
    public var metadata: [Swift.String: Swift.String]? { return commonProp.headers?.toUserMetadata() }

    /// The type of the object.
    public var objectType: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-object-type"] }

    /// The 64-bit CRC value of the object.
    /// This value is calculated based on the ECMA-182 standard.
    public var hashCrc64ecma: Swift.UInt64? { return commonProp.headers?[caseInsensitive: "x-oss-hash-crc64ecma"]?.toUInt64() }

    /// The lifecycle information about the object.
    /// If lifecycle rules are configured for the object, this header is included in the response.
    /// This header contains the following parameters: expiry-date that indicates the expiration time of the object, and rule-id that indicates the ID of the matched lifecycle rule.
    public var expiration: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-expiration"] }

    /// <no value>
    public var requestCharged: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-request-charged"] }

    /// A standard MIME type describing the format of the object data.
    public var contentType: Swift.String? { return commonProp.headers?[caseInsensitive: "Content-Type"] }

    /// The ID of the customer master key (CMK) that is managed by Key Management Service (KMS).
    public var serverSideEncryptionKeyId: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-server-side-encryption-key-id"] }

    /// The position for the next append operation.
    /// If the type of the object is Appendable, this header is included in the response.
    public var nextAppendPosition: Swift.Int? { return commonProp.headers?[caseInsensitive: "x-oss-next-append-position"]?.toInt() }

    /// The status of the object when you restore an object.
    /// If the storage class of the bucket is Archive and a RestoreObject request is submitted.
    public var restore: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-restore"] }

    /// Size of the body in bytes.
    public var contentLength: Swift.Int? { return commonProp.headers?[caseInsensitive: "Content-Length"]?.toInt() }

    /// The portion of the object returned in the response.
    public var contentRange: Swift.Int? { return commonProp.headers?[caseInsensitive: "Content-Range"]?.toInt() }

    /// The entity tag (ETag).
    /// An ETag is created when an object is created to identify the content of the object.
    public var etag: Swift.String? { return commonProp.headers?[caseInsensitive: "ETag"] }

    /// The server side data encryption algorithm.
    public var serverSideEncryption: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-server-side-encryption"] }

    /// The storage class of the object.
    public var storageClass: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-storage-class"] }

    /// The result of an event notification that is triggered for the object.
    public var processStatus: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-process-status"] }

    /// The time when the returned objects were last modified.
    public var lastModified: Swift.String? { return commonProp.headers?[caseInsensitive: "Last-Modified"] }

    /// The number of tags added to the object.
    /// This header is included in the response only when you have read permissions on tags.
    public var taggingCount: Swift.Int? { return commonProp.headers?[caseInsensitive: "x-oss-tagging-count"]?.toInt() }

    /// Specifies whether the object retrieved was (true) or was not (false) a Delete  Marker.
    public var deleteMarker: Bool? { return commonProp.headers?[caseInsensitive: "x-oss-delete-marker"]?.toBool() }

    /// <no value>
    public var body: ByteStream?
}

/// The request for the AppendObject operation.
public struct AppendObjectRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String?

    /// The full path of the object.
    public var key: Swift.String?

    /// The method used to encrypt objects on the specified OSS server. Valid values:- AES256: Keys managed by OSS are used for encryption and decryption (SSE-OSS). - KMS: Keys managed by Key Management Service (KMS) are used for encryption and decryption. - SM4: The SM4 block cipher algorithm is used for encryption and decryption.
    public var serverSideEncryption: Swift.String?

    /// The access control list (ACL) of the object. Default value: default.  Valid values:- default: The ACL of the object is the same as that of the bucket in which the object is stored. - private: The ACL of the object is private. Only the owner of the object and authorized users can read and write this object. - public-read: The ACL of the object is public-read. Only the owner of the object and authorized users can read and write this object. Other users can only read the object. Exercise caution when you set the object ACL to this value. - public-read-write: The ACL of the object is public-read-write. All users can read and write this object. Exercise caution when you set the object ACL to this value. For more information about the ACL, see [ACL](~~100676~~).
    /// Sees ObjectACLType for supported values.
    public var objectAcl: Swift.String?

    /// The storage class of the object that you want to upload. Valid values:- Standard- IA- ArchiveIf you specify the object storage class when you upload an object, the storage class of the uploaded object is the specified value regardless of the storage class of the bucket to which the object is uploaded. If you set x-oss-storage-class to Standard when you upload an object to an IA bucket, the object is stored as a Standard object. For more information about storage classes, see the "Overview" topic in Developer Guide. notice The value that you specify takes effect only when you call the AppendObject operation on an object for the first time.
    /// Sees StorageClassType for supported values.
    public var storageClass: Swift.String?

    /// <no value>
    public var metadata: [Swift.String: Swift.String]?

    /// The web page caching behavior for the object. For more information, see **[RFC 2616](https://www.ietf.org/rfc/rfc2616.txt)**. Default value: null.
    public var cacheControl: Swift.String?

    /// The name of the object when the object is downloaded. For more information, see **[RFC 2616](https://www.ietf.org/rfc/rfc2616.txt)**. Default value: null.
    public var contentDisposition: Swift.String?

    /// The encoding format of the object content. For more information, see **[RFC 2616](https://www.ietf.org/rfc/rfc2616.txt)**. Default value: null.
    public var contentEncoding: Swift.String?

    /// The Content-MD5 header value is a string calculated by using the MD5 algorithm. The header is used to check whether the content of the received message is the same as that of the sent message. To obtain the value of the Content-MD5 header, calculate a 128-bit number based on the message content except for the header, and then encode the number in Base64. Default value: null.Limits: none.
    public var contentMd5: Swift.String?

    /// A standard MIME type describing the format of the contents.
    public var contentType: Swift.String?

    /// The expiration time. For more information, see **[RFC 2616](https://www.ietf.org/rfc/rfc2616.txt)**. Default value: null.
    public var expires: Swift.String?

    /// Specify the initial value of CRC64. If not set, the crc check is ignored.
    public var initHashCrc64: UInt64?

    /// The position from which the AppendObject operation starts.  Each time an AppendObject operation succeeds, the x-oss-next-append-position header is included in the response to specify the position from which the next AppendObject operation starts. The value of position in the first AppendObject operation performed on an object must be 0. The value of position in subsequent AppendObject operations performed on the object is the current length of the object. For example, if the value of position specified in the first AppendObject request is 0 and the value of content-length is 65536, the value of position in the second AppendObject request must be 65536. - If the value of position in the AppendObject request is 0 and the name of the object that you want to append is unique, you can set headers such as x-oss-server-side-encryption in an AppendObject request in the same way as you set in a PutObject request. If you add the x-oss-server-side-encryption header to an AppendObject request, the x-oss-server-side-encryption header is included in the response to the request. If you want to modify metadata, you can call the CopyObject operation. - If you call an AppendObject operation to append a 0 KB object whose position value is valid to an Appendable object, the status of the Appendable object is not changed.
    public var position: Swift.Int?

    /// Specify the speed limit value. The speed limit value ranges from  245760 to 838860800, with a unit of bit/s.
    public var trafficLimit: Swift.Int?

    /// The request body.
    public var body: ByteStream?

    /// progress
    public var progress: ProgressDelegate?

    public init(
        bucket: Swift.String? = nil,
        key: Swift.String? = nil,
        position: Swift.Int? = nil,
        body: ByteStream? = nil,
        initHashCrc64: UInt64? = nil,
        serverSideEncryption: Swift.String? = nil,
        objectAcl: Swift.String? = nil,
        storageClass: Swift.String? = nil,
        metadata: [Swift.String: Swift.String]? = nil,
        cacheControl: Swift.String? = nil,
        contentDisposition: Swift.String? = nil,
        contentEncoding: Swift.String? = nil,
        contentMd5: Swift.String? = nil,
        contentType: Swift.String? = nil,
        expires: Swift.String? = nil,
        progress: ProgressDelegate? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.bucket = bucket
        self.key = key
        self.initHashCrc64 = initHashCrc64
        self.serverSideEncryption = serverSideEncryption
        self.objectAcl = objectAcl
        self.storageClass = storageClass
        self.metadata = metadata
        self.cacheControl = cacheControl
        self.contentDisposition = contentDisposition
        self.contentEncoding = contentEncoding
        self.contentMd5 = contentMd5
        self.contentType = contentType
        self.expires = expires
        self.position = position
        self.body = body
        self.progress = progress
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the AppendObject operation.
public struct AppendObjectResult: ResultModel {
    public var commonProp: ResultModelProp = .init()

    /// The position that must be provided in the next request, which is the current length of the object.
    public var nextAppendPosition: Swift.Int? { return commonProp.headers?[caseInsensitive: "x-oss-next-append-position"]?.toInt() }

    /// Version of the object.
    public var versionId: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-version-id"] }

    /// The 64-bit CRC value of the object. This value is calculated based on the ECMA-182 standard.
    public var hashCrc64ecma: Swift.UInt64? { return commonProp.headers?[caseInsensitive: "x-oss-hash-crc64ecma"]?.toUInt64() }

    /// The encryption method on the server side when an object is created. Valid values: AES256 and KMS
    public var ServerSideEncryption: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-server-side-encryption"] }

    /// The encryption algorithm of the object. AES256 or SM4.
    public var ServerSideDataEncryption: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-server-side-data-encryption"] }

    /// The ID of the customer master key (CMK) that is managed by Key Management Service (KMS).
    public var ServerSideEncryptionKeyId: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-server-side-encryption-key-id"] }

    /// The ETag value of the destination object.
    public var etag: Swift.String?
}

/// The request for the DeleteObject operation.
public struct DeleteObjectRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The information about the bucket.
    public var bucket: Swift.String?

    /// The full path of the object.
    public var key: Swift.String?

    /// The version ID of the object.
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

/// The result for the DeleteObject operation.
public struct DeleteObjectResult: ResultModel {
    public var commonProp: ResultModelProp = .init()

    /// <no value>
    public var deleteMarker: Swift.Bool? { return commonProp.headers?[caseInsensitive: "x-oss-delete-marker"]?.toBool() }

    /// <no value>
    public var versionId: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-version-id"] }
}

/// The request for the HeadObject operation.
public struct HeadObjectRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String?

    /// The full path of the object.
    public var key: Swift.String?

    /// If the time that is specified in the request is earlier than the time when the object is modified, OSS returns 200 OK and the metadata of the object. Otherwise, OSS returns 304 not modified. Default value: null.
    public var ifModifiedSince: Swift.String?

    /// If the time that is specified in the request is later than or the same as the time when the object is modified, OSS returns 200 OK and the metadata of the object. Otherwise, OSS returns 412 precondition failed. Default value: null.
    public var ifUnmodifiedSince: Swift.String?

    /// If the ETag value that is specified in the request matches the ETag value of the object, OSS returns 200 OK and the metadata of the object. Otherwise, OSS returns 412 precondition failed. Default value: null.
    public var ifMatch: Swift.String?

    /// If the ETag value that is specified in the request does not match the ETag value of the object, OSS returns 200 OK and the metadata of the object. Otherwise, OSS returns 304 Not Modified. Default value: null.
    public var ifNoneMatch: Swift.String?

    /// The version ID of the object for which you want to query metadata.
    public var versionId: Swift.String?

    public init(
        bucket: Swift.String? = nil,
        key: Swift.String? = nil,
        ifModifiedSince: Swift.String? = nil,
        ifUnmodifiedSince: Swift.String? = nil,
        ifMatch: Swift.String? = nil,
        ifNoneMatch: Swift.String? = nil,
        versionId: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.bucket = bucket
        self.key = key
        self.ifModifiedSince = ifModifiedSince
        self.ifUnmodifiedSince = ifUnmodifiedSince
        self.ifMatch = ifMatch
        self.ifNoneMatch = ifNoneMatch
        self.versionId = versionId
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the HeadObject operation.
public struct HeadObjectResult: ResultModel {
    public var commonProp: ResultModelProp = .init()

    /// The lifecycle information about the object.
    /// If lifecycle rules are configured for the object, this header is included in the response.
    /// This header contains the following parameters: expiry-date that indicates the expiration time of the object, and rule-id that indicates the ID of the matched lifecycle rule.
    public var expiration: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-expiration"] }

    /// The status of the object when you restore an object.
    /// If the storage class of the bucket is Archive and a RestoreObject request is submitted.
    public var restore: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-restore"] }

    /// the Md5 hash for the uploaded object.
    public var contentMd5: Swift.String? { return commonProp.headers?[caseInsensitive: "Content-MD5"] }

    /// The entity tag (ETag).
    /// An ETag is created when an object is created to identify the content of the object.
    public var etag: Swift.String? { return commonProp.headers?[caseInsensitive: "ETag"] }

    /// The type of the object.
    public var objectType: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-object-type"] }

    /// The result of an event notification that is triggered for the object.
    public var processStatus: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-process-status"] }

    /// The requester. This header is included in the response if the pay-by-requester mode is enabled for the bucket and the requester is not the bucket owner. The value of this header is requester.
    public var requestCharged: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-request-charged"] }

    /// The time when the returned objects were last modified.
    public var lastModified: Swift.String? { return commonProp.headers?[caseInsensitive: "Last-Modified"] }

    /// A map of metadata to store with the object.
    /// It is a lowcased key dictionary
    public var metadata: [Swift.String: Swift.String]? { return commonProp.headers?.toUserMetadata() }

    /// The number of tags added to the object.
    /// This header is included in the response only when you have read permissions on tags.
    public var taggingCount: Swift.Int? { return commonProp.headers?[caseInsensitive: "x-oss-tagging-count"]?.toInt() }

    /// If the requested object is encrypted by
    /// using a server-side encryption algorithm based on entropy encoding, OSS automatically decrypts
    /// the object and returns the decrypted object after OSS receives the GetObject request.
    /// The x-oss-server-side-encryption header is included in the response to indicate the encryption algorithm used to encrypt the object on the server.
    public var serverSideEncryption: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-server-side-encryption"] }

    /// The server side data encryption algorithm.
    public var serverSideDataEncryption: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-server-side-data-encryption"] }

    /// The ID of the customer master key (CMK) that is managed by Key Management Service (KMS).
    public var serverSideEncryptionKeyId: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-server-side-encryption-key-id"] }

    /// The position for the next append operation.
    /// If the type of the object is Appendable, this header is included in the response.
    public var nextAppendPosition: Swift.Int? { return commonProp.headers?[caseInsensitive: "x-oss-next-append-position"]?.toInt() }

    /// The 64-bit CRC value of the object.
    /// This value is calculated based on the ECMA-182 standard.
    public var hashCrc64ecma: Swift.UInt64? { return commonProp.headers?[caseInsensitive: "x-oss-hash-crc64ecma"]?.toUInt64() }

    /// The time when the storage class of the returned objects is changed to Cold Archive or Deep Cold Archive based on lifecycle rules.
    public var transitionTime: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-transition-time"] }

    /// The storage class of the object.
    public var storageClass: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-storage-class"] }

    /// Size of the body in bytes.
    public var contentLength: Swift.Int? { return commonProp.headers?[caseInsensitive: "Content-Length"]?.toInt() }

    /// A standard MIME type describing the format of the object data.
    public var contentType: Swift.String? { return commonProp.headers?[caseInsensitive: "Content-Type"] }

    /// The caching behavior of the web page when the object is downloaded.
    public var cacheControl: Swift.String? { return commonProp.headers?[caseInsensitive: "Cache-Control"] }

    /// The method that is used to access the object.
    public var contentDisposition: Swift.String? { return commonProp.headers?[caseInsensitive: "Content-Disposition"] }

    /// The method that is used to encode the object.
    public var contentEncoding: Swift.String? { return commonProp.headers?[caseInsensitive: "Content-Encoding"] }

    /// The expiration time of the cache in UTC.
    public var expires: Swift.String? { return commonProp.headers?[caseInsensitive: "Expires"] }

    ///  Version of the object.
    public var versionId: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-version-id"] }
}

/// The request for the GetObjectMeta operation.
public struct GetObjectMetaRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String?

    /// The full path of the object.
    public var key: Swift.String?

    /// The versionID of the object.
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

/// The result for the GetObjectMeta operation.
public struct GetObjectMetaResult: ResultModel {
    public var commonProp: ResultModelProp = .init()

    /// <no value>
    public var versionId: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-version-id"] }

    /// <no value>
    public var etag: Swift.String? { return commonProp.headers?[caseInsensitive: "ETag"] }

    /// <no value>
    public var contentLength: Swift.Int? { return commonProp.headers?[caseInsensitive: "Content-Length"]?.toInt() }

    /// <no value>
    public var lastAccessTime: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-last-access-time"] }

    /// <no value>
    public var lastModified: Swift.String? { return commonProp.headers?[caseInsensitive: "Last-Modified"] }

    /// <no value>
    public var transitionTime: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-transition-time"] }
}

/// The request for the RestoreObject operation.
public struct RestoreObjectRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String?

    /// The full path of the object.
    public var key: Swift.String?

    /// The version number of the object that you want to restore.
    public var versionId: Swift.String?

    /// The request body schema.
    public var restoreRequest: RestoreRequest?

    public init(
        bucket: Swift.String? = nil,
        key: Swift.String? = nil,
        versionId: Swift.String? = nil,
        restoreRequest: RestoreRequest? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.bucket = bucket
        self.key = key
        self.versionId = versionId
        self.restoreRequest = restoreRequest
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the RestoreObject operation.
public struct RestoreObjectResult: ResultModel {
    public var commonProp: ResultModelProp = .init()

    /// <no value>
    public var versionId: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-version-id"] }

    /// <no value>
    public var objectRestorePriority: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-object-restore-priority"] }
}

/// The request for the DeleteMultipleObjects operation.
public struct DeleteMultipleObjectsRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket
    public var bucket: Swift.String?

    /// The encoding type of the object names in the response. Valid value: url
    /// Sees <see cref="Models.EncodingType"/> for supported values.
    public var encodingType: Swift.String?

    /// Specifies whether to enable the Quiet return mode.
    /// The DeleteMultipleObjects operation provides the following return modes: Valid value: true,false
    public var quiet: Swift.Bool?

    /// The container that stores information about you want to delete objects.
    public var objects: [DeleteObject]?

    public init(bucket: String? = nil,
                objects: [DeleteObject]? = nil,
                quiet: Bool? = nil,
                encodingType: String? = nil,
                commonProp: RequestModelProp? = nil)
    {
        self.bucket = bucket
        self.encodingType = encodingType
        self.quiet = quiet
        self.objects = objects
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The request for the DeleteMultipleObjects operation.
public struct DeleteMultipleObjectsResult: ResultModel {
    public var commonProp: ResultModelProp = .init()

    /// The container that stores information about you want to delete objects.
    public var deletedObjects: [DeletedInfo]?

    /// The encoding type of the object names in the response. Valid value: url
    /// Sees <see cref="Models.EncodingType"/> for supported values.
    public var encodingType: String?
}

/// The request for the CleanRestoredObject operation.
public struct CleanRestoredObjectRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket
    public var bucket: Swift.String?

    /// The name of the object.
    public var key: Swift.String?

    public init(
        bucket: Swift.String? = nil,
        key: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.bucket = bucket
        self.key = key
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the CleanRestoredObject operation.
public struct CleanRestoredObjectResult: ResultModel {
    public var commonProp: ResultModelProp = .init()
}

public struct SealAppendObjectRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket
    public var bucket: Swift.String?

    /// The name of the object.
    public var key: Swift.String?
    
    /// Specifies the expected length of the object when you call the SealAppendObject operation.
    /// OSS checks whether this length matches the actual length of the object. If the lengths do not match, the request fails and the PositionNotEqualToLength error is returned.
    public var position: Swift.Int?
    
    init(
        bucket: String? = nil,
        key: String? = nil,
        position: Int? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.bucket = bucket
        self.key = key
        self.position = position
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

public struct SealAppendObjectResult: ResultModel {
    public var commonProp: ResultModelProp = .init()
    
    /// The time in GMT format when the SealAppendObject operation was first performed on the object. This timestamp does not change even if the operation is performed again.
    public var sealedTime: String? { return commonProp.headers?[caseInsensitive: "x-oss-sealed-time"] }
}
