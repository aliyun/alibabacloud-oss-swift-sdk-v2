import Foundation

/// The container that stores the information about multipart upload tasks.
public struct Upload: Sendable {
    /// The time when the multipart upload task was initiated.
    public var initiated: Foundation.Date?

    /// The name of the object for which a multipart upload task was initiated.  The results returned by OSS are listed in ascending alphabetical order of object names. Multiple multipart upload tasks that are initiated to upload the same object are listed in ascending order of upload IDs.
    public var key: Swift.String?

    /// The ID of the multipart upload task.
    public var uploadId: Swift.String?

    public init(
        initiated: Foundation.Date? = nil,
        key: Swift.String? = nil,
        uploadId: Swift.String? = nil
    ) {
        self.initiated = initiated
        self.key = key
        self.uploadId = uploadId
    }
}

/// The container that stores the uploaded parts.
public struct UploadPart: Sendable {
    /// The ETag that is generated when the object is created. ETags are used to identify the content of objects.If an object is created by calling the CompleteMultipartUpload operation, the ETag is not the MD5 hash of the object content but a unique value calculated based on a specific rule.  The ETag of an object can be used to check whether the object content changes. We recommend that you use the MD5 hash of an object rather than the ETag of the object to verify data integrity.
    public var etag: Swift.String?

    /// The number of parts.
    public var partNumber: Swift.Int?

    public init(
        etag: Swift.String? = nil,
        partNumber: Swift.Int? = nil
    ) {
        self.etag = etag
        self.partNumber = partNumber
    }
}

public struct Part: Sendable {
    /// The ETag value of the content of the uploaded part.
    public var etag: Swift.String?

    /// The number that identifies a part.
    public var partNumber: Swift.Int?

    /// The time when the part was uploaded.
    public var lastModified: Date?

    /// The size of the uploaded parts.
    public var size: Swift.Int?

    /// The 64-bit CRC value of the object.
    /// This value is calculated based on the ECMA-182 standar
    public var hashCrc64: Swift.String?

    public init(
        etag: Swift.String? = nil,
        partNumber: Swift.Int? = nil,
        lastModified: Date? = nil,
        size: Swift.Int? = nil,
        hashCrc64: Swift.String? = nil
    ) {
        self.etag = etag
        self.partNumber = partNumber
        self.lastModified = lastModified
        self.size = size
        self.hashCrc64 = hashCrc64
    }
}

/// The container that stores the content of the CompleteMultipartUpload request.
public struct CompleteMultipartUpload: Sendable {
    /// The container that stores the uploaded parts.
    public var parts: [UploadPart]?

    public init(
        parts: [UploadPart]? = nil
    ) {
        self.parts = parts
    }
}

/// The container that stores the copy result.
public struct CopyPartResult: Sendable {
    /// The last modified time of copy source.
    public var lastModified: Foundation.Date?

    /// The ETag of the copied part.
    public var etag: Swift.String?

    public init(
        lastModified: Foundation.Date? = nil,
        etag: Swift.String? = nil
    ) {
        self.lastModified = lastModified
        self.etag = etag
    }
}

/// The request for the InitiateMultipartUpload operation.
public struct InitiateMultipartUploadRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket to which the object is uploaded by the multipart upload task.
    public var bucket: Swift.String?

    /// The name of the object that is uploaded by the multipart upload task.
    public var key: Swift.String?

    /// Specifies whether the InitiateMultipartUpload operation overwrites the existing object that has the same name as the object that you want to upload. When versioning is enabled or suspended for the bucket to which you want to upload the object, the **x-oss-forbid-overwrite** header does not take effect. In this case, the InitiateMultipartUpload operation overwrites the existing object that has the same name as the object that you want to upload.   - If you do not specify the **x-oss-forbid-overwrite** header or set the **x-oss-forbid-overwrite** header to **false**, the object that is uploaded by calling the PutObject operation overwrites the existing object that has the same name.   - If the value of **x-oss-forbid-overwrite** is set to **true**, existing objects cannot be overwritten by objects that have the same names. If you specify the **x-oss-forbid-overwrite** request header, the queries per second (QPS) performance of OSS is degraded. If you want to use the **x-oss-forbid-overwrite** request header to perform a large number of operations (QPS greater than 1,000), contact technical support
    public var forbidOverwrite: Swift.Bool?

    /// The storage class of the bucket. Default value: Standard.  Valid values:- Standard- IA- Archive- ColdArchive
    /// Sees StorageClassType for supported values.
    public var storageClass: Swift.String?

    /// The tag of the object. You can configure multiple tags for the object. Example: TagA=A&amp;TagB=B. The key and value of a tag must be URL-encoded. If a tag does not contain an equal sign (=), the value of the tag is considered an empty string.
    public var tagging: Swift.String?

    /// The server-side encryption method that is used to encrypt each part of the object that you want to upload. Valid values: **AES256**, **KMS**, and **SM4**. You must activate Key Management Service (KMS) before you set this header to KMS. If you specify this header in the request, this header is included in the response. OSS uses the method specified by this header to encrypt each uploaded part. When you download the object, the x-oss-server-side-encryption header is included in the response and the header value is set to the algorithm that is used to encrypt the object.
    public var serverSideEncryption: Swift.String?

    /// The algorithm that is used to encrypt the object that you want to upload. If this header is not specified, the object is encrypted by using AES-256. This header is valid only when **x-oss-server-side-encryption** is set to KMS. Valid value: SM4.
    public var serverSideDataEncryption: Swift.String?

    /// The ID of the CMK that is managed by KMS. This header is valid only when **x-oss-server-side-encryption** is set to KMS.
    public var serverSideEncryptionKeyId: Swift.String?

    /// The caching behavior of the web page when the object is downloaded. For more information, see **[RFC 2616](https://www.ietf.org/rfc/rfc2616.txt)**. Default value: null.
    public var cacheControl: Swift.String?

    /// The name of the object when the object is downloaded. For more information, see **[RFC 2616](https://www.ietf.org/rfc/rfc2616.txt)**. Default value: null.
    public var contentDisposition: Swift.String?

    /// The content encoding format of the object when the object is downloaded. For more information, see **[RFC 2616](https://www.ietf.org/rfc/rfc2616.txt)**. Default value: null.
    public var contentEncoding: Swift.String?

    /// A standard MIME type describing the format of the contents.
    public var contentType: Swift.String?

    /// The expiration time of the request. Unit: milliseconds. For more information, see **[RFC 2616](https://www.ietf.org/rfc/rfc2616.txt)**. Default value: null.
    public var expires: Swift.String?

    /// The method used to encode the object name in the response. Only URL encoding is supported. The object name can contain characters encoded in UTF-8. However, the XML 1.0 standard cannot be used to parse specific control characters, such as characters whose ASCII values range from 0 to 10. You can configure the encoding-type parameter to encode object names that include characters that cannot be parsed by XML 1.0 in the response.brDefault value: null
    /// Sees EncodingType for supported values.
    public var encodingType: Swift.String?

    public init(
        bucket: Swift.String? = nil,
        key: Swift.String? = nil,
        forbidOverwrite: Swift.Bool? = nil,
        storageClass: Swift.String? = nil,
        tagging: Swift.String? = nil,
        serverSideEncryption: Swift.String? = nil,
        serverSideDataEncryption: Swift.String? = nil,
        serverSideEncryptionKeyId: Swift.String? = nil,
        cacheControl: Swift.String? = nil,
        contentDisposition: Swift.String? = nil,
        contentEncoding: Swift.String? = nil,
        contentType: Swift.String? = nil,
        expires: Swift.String? = nil,
        encodingType: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.bucket = bucket
        self.key = key
        self.forbidOverwrite = forbidOverwrite
        self.storageClass = storageClass
        self.tagging = tagging
        self.serverSideEncryption = serverSideEncryption
        self.serverSideDataEncryption = serverSideDataEncryption
        self.serverSideEncryptionKeyId = serverSideEncryptionKeyId
        self.cacheControl = cacheControl
        self.contentDisposition = contentDisposition
        self.contentEncoding = contentEncoding
        self.contentType = contentType
        self.expires = expires
        self.encodingType = encodingType
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the InitiateMultipartUpload operation.
public struct InitiateMultipartUploadResult: ResultModel {
    public var commonProp: ResultModelProp = .init()

    /// The encoding type of the object name in the response. If the encoding-type parameter is specified in the request, the object name in the response is encoded.
    public var encodingType: Swift.String?

    /// The name of the bucket to which the object is uploaded by the multipart upload task.
    public var bucket: Swift.String?

    /// The name of the object that is uploaded by the multipart upload task.
    public var key: Swift.String?

    /// The upload ID that uniquely identifies the multipart upload task. The upload ID is used to call UploadPart and CompleteMultipartUpload later.
    public var uploadId: Swift.String?
}

/// The request for the UploadPart operation.
public struct UploadPartRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String?

    /// The full path of the object.
    public var key: Swift.String?

    /// The number that identifies a part. Valid values: 1 to 10000.The size of a part ranges from 100 KB to 5 GB.  In multipart upload, each part except the last part must be larger than or equal to 100 KB in size. When you call the UploadPart operation, the size of each part is not verified because not all parts have been uploaded and OSS does not know which part is the last part. The size of each part is verified only when you call CompleteMultipartUpload.
    public var partNumber: Swift.Int?

    /// The ID that identifies the object to which the part that you want to upload belongs.
    public var uploadId: Swift.String?

    /// The request body.
    public var body: ByteStream?

    /// progress
    public var progress: ProgressDelegate?

    public init(
        bucket: Swift.String? = nil,
        key: Swift.String? = nil,
        partNumber: Swift.Int? = nil,
        uploadId: Swift.String? = nil,
        body: ByteStream? = nil,
        progress: ProgressDelegate? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.bucket = bucket
        self.key = key
        self.partNumber = partNumber
        self.uploadId = uploadId
        self.body = body
        self.progress = progress
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the UploadPart operation.
public struct UploadPartResult: ResultModel {
    public var commonProp: ResultModelProp = .init()

    public var etag: Swift.String? { commonProp.headers?[caseInsensitive: "ETag"] }
}

/// The request for the CompleteMultipartUpload operation.
public struct CompleteMultipartUploadRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String?

    /// The full path of the object.
    public var key: Swift.String?

    /// Specifieswhethertheobjectwith the sameobjectname is overwritten when you call the CompleteMultipartUpload operation.
    /// - If the value of x-oss-forbid-overwrite is not specified or set to false, the existing object can be overwritten by the object that has the same name.
    /// - If the value of x-oss-forbid-overwrite is set to true, the existing object cannot be overwritten by the object that has the same name.
    /// - The x-oss-forbid-overwrite request header is invalid if versioning is enabled or suspended for the bucket. In this case, the existing object can be overwritten by the object that has the same name when you call the CompleteMultipartUpload operation.
    /// - If you specify the x-oss-forbid-overwrite request header, the queries per second (QPS) performance of OSS may be degraded. If you want to configure the x-oss-forbid-overwrite header in a large number of requests (QPS  1,000), submit a ticket.
    public var forbidOverwrite: Swift.Bool?

    /// Specifies whether to list all parts that are uploaded by using the current upload ID.Valid value: yes.- If x-oss-complete-all is set to yes in the request, OSS lists all parts that are uploaded by using the current upload ID, sorts the parts by part number, and then performs the CompleteMultipartUpload operation. When OSS performs the CompleteMultipartUpload operation, OSS cannot detect the parts that are not uploaded or currently being uploaded. Before you call the CompleteMultipartUpload operation, make sure that all parts are uploaded.- If x-oss-complete-all is specified in the request, the request body cannot be specified. Otherwise, an error occurs.- If x-oss-complete-all is specified in the request, the format of the response remains unchanged.
    public var completeAll: Swift.String?

    /// The identifier of the multipart upload task.
    public var uploadId: Swift.String?

    /// The encodingtype of the object name in the response. Only URL encoding is supported.The object name can contain characters that are encoded in UTF-8. However, the XML 1.0 standard cannot be used to parse control characters, such as characters with an ASCII value from 0 to 10. You can configure this parameter to encode the object name in the response.
    /// Sees EncodingType for supported values.
    public var encodingType: Swift.String?

    /// The request body schema.
    public var completeMultipartUpload: CompleteMultipartUpload?

    public init(
        bucket: Swift.String? = nil,
        key: Swift.String? = nil,
        forbidOverwrite: Swift.Bool? = nil,
        completeAll: Swift.String? = nil,
        uploadId: Swift.String? = nil,
        encodingType: Swift.String? = nil,
        completeMultipartUpload: CompleteMultipartUpload? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.bucket = bucket
        self.key = key
        self.forbidOverwrite = forbidOverwrite
        self.completeAll = completeAll
        self.uploadId = uploadId
        self.encodingType = encodingType
        self.completeMultipartUpload = completeMultipartUpload
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the CompleteMultipartUpload operation.
public struct CompleteMultipartUploadResult: ResultModel {
    public var commonProp: ResultModelProp = .init()

    /// The version ID of the object.
    public var versionId: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-version-id"] }

    /// The name of the uploaded object.
    public var key: Swift.String?

    /// The ETag that is generated when an object is created. ETags are used to identify the content of objects.If an object is created by calling the CompleteMultipartUpload operation, the ETag value is not the MD5 hash of the object content but a unique value calculated based on a specific rule. The ETag of an object can be used to check whether the object content is modified. However, we recommend that you use the MD5 hash of an object rather than the ETag value of the object to verify data integrity.
    public var etag: Swift.String?

    /// The encoding type of the object name in the response. If this parameter is specified in the request, the object name is encoded in the response.
    public var encodingType: Swift.String?

    /// The URL that is used to access the uploaded object.
    public var location: Swift.String?

    /// The name of the bucket that contains the object you want to restore.
    public var bucket: Swift.String?

    public var callbackResult: Data?
}

/// The request for the UploadPartCopy operation.
public struct UploadPartCopyRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String?

    /// The full path of the object.
    public var key: Swift.String?

    /// The name of the source bucket.
    public var sourceBucket: Swift.String?

    /// The name of the source object.
    public var sourceKey: Swift.String?

    /// The range of bytes to copy data from the source object. For example, if you specify bytes to 0 to 9, the system transfers byte 0 to byte 9, a total of 10 bytes.brDefault value: null
    /// - If the x-oss-copy-source-range request header is not specified, the entire source object is copied.
    /// - If the x-oss-copy-source-range request header is specified, the response contains the length of the entire object and the range of bytes to be copied for this operation. For example, Content-Range: bytes 0~9/44 indicates that the length of the entire object is 44 bytes. The range of bytes to be copied is byte 0 to byte 9.
    /// - If the specified range does not conform to the range conventions, OSS copies the entire object and does not include Content-Range in the response.
    public var copySourceRange: Swift.String?

    /// The copy operation condition. If the ETag value of the source object is the same as the ETag value provided by the user, OSS copies data. Otherwise, OSS returns 412 Precondition Failed.brDefault value: null
    public var copySourceIfMatch: Swift.String?

    /// The object transfer condition. If the input ETag value does not match the ETag value of the object, the system transfers the object normally and returns 200 OK. Otherwise, OSS returns 304 Not Modified.brDefault value: null
    public var copySourceIfNoneMatch: Swift.String?

    /// The object transfer condition. If the specified time is the same as or later than the actual modified time of the object, OSS transfers the object normally and returns 200 OK. Otherwise, OSS returns 412 Precondition Failed.brDefault value: null
    public var copySourceIfUnmodifiedSince: Swift.String?

    /// The object transfer condition. If the specified time is earlier than the actual modified time of the object, the system transfers the object normally and returns 200 OK. Otherwise, OSS returns 304 Not Modified.brDefault value: nullbrTime format: ddd, dd MMM yyyy HH:mm:ss GMT. Example: Fri, 13 Nov 2015 14:47:53 GMT.
    public var copySourceIfModifiedSince: Swift.String?

    /// The number of parts.
    public var partNumber: Swift.Int?

    /// The ID that identifies the object to which the parts to upload belong.
    public var uploadId: Swift.String?

    public init(
        bucket: Swift.String? = nil,
        key: Swift.String? = nil,
        sourceBucket: Swift.String? = nil,
        sourceKey: Swift.String? = nil,
        copySourceRange: Swift.String? = nil,
        copySourceIfMatch: Swift.String? = nil,
        copySourceIfNoneMatch: Swift.String? = nil,
        copySourceIfUnmodifiedSince: Swift.String? = nil,
        copySourceIfModifiedSince: Swift.String? = nil,
        partNumber: Swift.Int? = nil,
        uploadId: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.bucket = bucket
        self.key = key
        self.sourceBucket = sourceBucket
        self.sourceKey = sourceKey
        self.copySourceRange = copySourceRange
        self.copySourceIfMatch = copySourceIfMatch
        self.copySourceIfNoneMatch = copySourceIfNoneMatch
        self.copySourceIfUnmodifiedSince = copySourceIfUnmodifiedSince
        self.copySourceIfModifiedSince = copySourceIfModifiedSince
        self.partNumber = partNumber
        self.uploadId = uploadId
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the UploadPartCopy operation.
public struct UploadPartCopyResult: ResultModel {
    public var commonProp: ResultModelProp = .init()

    /// The version ID of the source object.
    public var copySourceVersionId: Swift.String? { return commonProp.headers?[caseInsensitive: "x-oss-copy-source-version-id"] }

    /// The container that stores the copy result.
    public var copyPartResult: CopyPartResult?
}

/// The request for the AbortMultipartUpload operation.
public struct AbortMultipartUploadRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String?

    /// The full path of the object that you want to upload.
    public var key: Swift.String?

    /// The ID of the multipart upload task.
    public var uploadId: Swift.String?

    public init(
        bucket: Swift.String? = nil,
        key: Swift.String? = nil,
        uploadId: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.bucket = bucket
        self.key = key
        self.uploadId = uploadId
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the AbortMultipartUpload operation.
public struct AbortMultipartUploadResult: ResultModel {
    public var commonProp: ResultModelProp = .init()
}

/// The request for the ListMultipartUploads operation.
public struct ListMultipartUploadsRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String?

    /// The character used to group objects by name. Objects whose names contain the same string that ranges from the specified prefix to the delimiter that appears for the first time are grouped as a CommonPrefixes element.
    public var delimiter: Swift.String?

    /// The maximumnumber of multipart upload tasks that can be returned for the current request. Default value: 1000. Maximum value: 1000.
    public var maxUploads: Swift.Int?

    /// This parameter is used together with the upload-id-marker parameter to specify the position from which the next list begins.
    /// - If the upload-id-marker parameter is not set, Object Storage Service (OSS) returns all multipart upload tasks in which object names are alphabetically after the key-marker value.
    /// - If the upload-id-marker parameter is set, the response includes the following tasks:
    /// - Multipart upload tasks in which object names are alphabetically after the key-marker value in alphabetical order
    /// - Multipart upload tasks in which object names are the same as the key-marker parameter value but whose upload IDs are greater than the upload-id-marker parameter value
    public var keyMarker: Swift.String?

    /// The prefix that the returned object names must contain. If you specify a prefix in the request, the specified prefix is included in the response.You can use prefixes to group and manage objects in buckets in the same way you manage a folder in a file system.
    public var prefix: Swift.String?

    /// The upload ID of the multipart upload task after which the list begins. This parameter is used together with the key-marker parameter.
    /// - If the key-marker parameter is not set, OSS ignores the upload-id-marker parameter.
    /// - If the key-marker parameter is configured, the query result includes:
    /// - Multipart upload tasks in which object names are alphabetically after the key-marker value in alphabetical order
    /// - Multipart upload tasks in which object names are the same as the key-marker parameter value but whose upload IDs are greater than the upload-id-marker parameter value
    public var uploadIdMarker: Swift.String?

    /// The encoding type of the object name in the response. Values of Delimiter, KeyMarker, Prefix, NextKeyMarker, and Key can be encoded in UTF-8. However, the XML 1.0 standard cannot be used to parse control characters such as characters with an American Standard Code for Information Interchange (ASCII) value from 0 to 10. You can set the encoding-type parameter to encode values of Delimiter, KeyMarker, Prefix, NextKeyMarker, and Key in the response.Default value: null
    /// Sees EncodingType for supported values.
    public var encodingType: Swift.String?

    public init(
        bucket: Swift.String? = nil,
        delimiter: Swift.String? = nil,
        maxUploads: Swift.Int? = nil,
        keyMarker: Swift.String? = nil,
        prefix: Swift.String? = nil,
        uploadIdMarker: Swift.String? = nil,
        encodingType: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.bucket = bucket
        self.delimiter = delimiter
        self.maxUploads = maxUploads
        self.keyMarker = keyMarker
        self.prefix = prefix
        self.uploadIdMarker = uploadIdMarker
        self.encodingType = encodingType
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the ListMultipartUploads operation.
public struct ListMultipartUploadsResult: ResultModel {
    public var commonProp: ResultModelProp = .init()

    /// The method used to encode the object name in the response. If encoding-type is specified in the request, values of those elements including Delimiter, KeyMarker, Prefix, NextKeyMarker, and Key are encoded in the returned result.
    public var encodingType: Swift.String?

    /// The name of the object that corresponds to the multipart upload task after which the list begins.
    public var keyMarker: Swift.String?

    /// The upload ID of the multipart upload task after which the list begins.
    public var uploadIdMarker: Swift.String?

    /// Indicates whether the list of multipart upload tasks returned in the response is truncated. Default value: false. Valid values:
    /// - true: Only part of the results are returned this time.
    /// - false: All results are returned.
    public var isTruncated: Swift.Bool?

    /// The character used to group objects by name. If you specify the Delimiter parameter in the request, the response contains the CommonPrefixes element. Objects whose names contain the same string from the prefix to the next occurrence of the delimiter are grouped as a single result element in
    public var delimiter: Swift.String?

    /// The ID list of the multipart upload tasks.
    public var uploads: [Upload]?

    /// The name of the bucket.
    public var bucket: Swift.String?

    /// The object name marker in the response for the next request to return the remaining results.
    public var nextKeyMarker: Swift.String?

    /// The NextUploadMarker value that is used for the UploadMarker value in the next request if the response does not contain all required results.
    public var nextUploadIdMarker: Swift.String?

    /// The maximum number of multipart upload tasks returned by OSS.
    public var maxUploads: Swift.Int?

    /// The prefix that the returned object names must contain. If you specify a prefix in the request, the specified prefix is included in the response.
    public var prefix: Swift.String?

    /// If the delimiter parameter is specified in the request, the response contains the CommonPrefixes parameter. The objects whose names contain the same string from the prefix to the next occurrence of the delimiter are grouped as a single result element in the CommonPrefixes parameter.
    public var commonPrefixes: [CommonPrefix]?
}

/// The request for the ListParts operation.
public struct ListPartsRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String?

    /// The name of the object.
    public var key: Swift.String?

    /// The ID of the multipart upload task.By default, this parameter is left empty.
    public var uploadId: Swift.String?

    /// The maximum number of parts that can be returned by OSS.Default value: 1000.Maximum value: 1000.
    public var maxParts: Swift.Int?

    /// The position from which the list starts. All parts whose part numbers are greater than the value of this parameter are listed.By default, this parameter is left empty.
    public var partNumberMarker: Swift.Int?

    /// The maximum number of parts that can be returned by OSS. Default value: 1000.Maximum value: 1000.
    /// Sees EncodingType for supported values.
    public var encodingType: Swift.String?

    public init(
        bucket: Swift.String? = nil,
        key: Swift.String? = nil,
        uploadId: Swift.String? = nil,
        maxParts: Swift.Int? = nil,
        partNumberMarker: Swift.Int? = nil,
        encodingType: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.bucket = bucket
        self.key = key
        self.uploadId = uploadId
        self.maxParts = maxParts
        self.partNumberMarker = partNumberMarker
        self.encodingType = encodingType
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the ListParts operation.
public struct ListPartsResult: ResultModel {
    public var commonProp: ResultModelProp = .init()

    /// The maximum number of parts in the response.
    public var maxParts: Swift.Int?

    /// Indicates whether the list of parts returned in the response has been truncated. A value of true indicates that the response does not contain all required results. A value of false indicates that the response contains all required results.Valid values: true and false.
    public var isTruncated: Swift.Bool?

    /// The list of all parts.
    public var parts: [Part]?

    /// The name of the bucket.
    public var bucket: Swift.String?

    /// The name of the object.
    public var key: Swift.String?

    /// The ID of the upload task.
    public var uploadId: Swift.String?

    /// The position from which the list starts. All parts whose part numbers are greater than the value of this parameter are listed.
    public var partNumberMarker: Swift.Int?

    /// The NextPartNumberMarker value that is used for the PartNumberMarker value in a subsequent request when the response does not contain all required results.
    public var nextPartNumberMarker: Swift.Int?

    public var encodingType: Swift.String?
}
