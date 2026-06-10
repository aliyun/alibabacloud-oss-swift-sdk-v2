import Foundation

public extension Client {
    /// You can call this operation to upload an object.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    func putObject(
        _ request: PutObjectRequest,
        _ options: OperationOptions? = nil
    ) async throws -> PutObjectResult {
        var input = OperationInput(
            operationName: "PutObject",
            method: "PUT"
        )
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        input.key = try request.key.ensureRequired(field: "request.key")

        if let progress = request.progress {
            input.metadata.set(
                key: AttributeKeys.progressDelegate,
                value: ProgressDelegateDesc(delegate: ProgressWithRetry(progress), upload: true)
            )
        }

        if clientImpl.hasFeatureFlag(FeatureFlag.enableCRC64CheckUpload) {
            input.metadata.append(
                key: AttributeKeys.responseHandler,
                value: ChekerUploadCrcResponseHandler()
            )
        }

        var req = request
        var customDeserializers: [SerdeSerializeDelegate] = [Serde.serializePutObject]
        if clientImpl.hasFeatureFlag(FeatureFlag.autoDetectMimeType) {
            customDeserializers.append(Serde.addContentType)
        }

        try Serde.serializeInput(&req, &input, customDeserializers)

        var output = try await clientImpl.execute(with: &input, args: options)

        var result = PutObjectResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializePutObject])

        return result
    }

    /// Copies objects within a bucket or between buckets in the same region.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    func copyObject(
        _ request: CopyObjectRequest,
        _ options: OperationOptions? = nil
    ) async throws -> CopyObjectResult {
        var input = OperationInput(
            operationName: "CopyObject",
            method: "PUT"
        )
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        input.key = try request.key.ensureRequired(field: "request.key")

        var req = request

        try Serde.serializeInput(&req, &input, [Serde.serializeCopyObject, Serde.addContentMd5])

        var output = try await clientImpl.execute(with: &input, args: options)

        var result = CopyObjectResult()

        try Serde.deserializeOutput(&result, &output, [Serde.deserializeCopyObject])

        return result
    }

    /// You can call this operation to query an object.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    func getObject(
        _ request: GetObjectRequest,
        _ options: OperationOptions? = nil
    ) async throws -> GetObjectResult {
        var input = OperationInput(
            operationName: "GetObject",
            method: "GET"
        )
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        input.key = try request.key.ensureRequired(field: "request.key")

        if let progress = request.progress {
            input.metadata.set(
                key: AttributeKeys.progressDelegate,
                value: ProgressDelegateDesc(delegate: ProgressWithRetry(progress), upload: false)
            )
        }
        if clientImpl.hasFeatureFlag(FeatureFlag.enableCRC64CheckUpload) {
            input.metadata.append(
                key: AttributeKeys.responseHandler,
                value: ChekerDownloadCrcResponseHandler()
            )
        }

        var req = request

        try Serde.serializeInput(&req, &input, [Serde.serializeGetObject])

        var output = try await clientImpl.execute(with: &input, args: options)

        var result = GetObjectResult()

        try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetObject])

        return result
    }

    /// You can call this operation to upload an object by appending the object to an existing object.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    func appendObject(
        _ request: AppendObjectRequest,
        _ options: OperationOptions? = nil
    ) async throws -> AppendObjectResult {
        var input = OperationInput(
            operationName: "AppendObject",
            method: "POST",
            parameters: [
                "append": "",
            ]
        )
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        input.key = try request.key.ensureRequired(field: "request.key")
        if let progress = request.progress {
            input.metadata.set(
                key: AttributeKeys.progressDelegate,
                value: ProgressDelegateDesc(delegate: ProgressWithRetry(progress), upload: true)
            )
        }
        if clientImpl.hasFeatureFlag(FeatureFlag.enableCRC64CheckUpload) {
            input.metadata.append(
                key: AttributeKeys.responseHandler,
                value: ChekerUploadCrcResponseHandler(crc: request.initHashCrc64)
            )
        }

        var req = request

        var customDeserializers: [SerdeSerializeDelegate] = [Serde.serializeAppendObject]
        if clientImpl.hasFeatureFlag(FeatureFlag.autoDetectMimeType) {
            customDeserializers.append(Serde.addContentType)
        } else {
            // urlsession add Content-Type:application/x-www-form-urlencoded default
            if req.contentType == nil {
                req.contentType = "application/octet-stream"
            }
        }

        try Serde.serializeInput(&req, &input, customDeserializers)

        var output = try await clientImpl.execute(with: &input, args: options)

        var result = AppendObjectResult()

        try Serde.deserializeOutput(&result, &output, [Serde.deserializeAppendObject])

        return result
    }

    /// You can call this operation to delete an object.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    func deleteObject(
        _ request: DeleteObjectRequest,
        _ options: OperationOptions? = nil
    ) async throws -> DeleteObjectResult {
        var input = OperationInput(
            operationName: "DeleteObject",
            method: "DELETE",
            headers: [
                "Content-Type": "application/xml",
            ]
        )
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        input.key = try request.key.ensureRequired(field: "request.key")

        var req = request

        try Serde.serializeInput(&req, &input, [Serde.serializeDeleteObject, Serde.addContentMd5])

        var output = try await clientImpl.execute(with: &input, args: options)

        var result = DeleteObjectResult()

        try Serde.deserializeOutput(&result, &output, [Serde.deserializeDeleteObject])

        return result
    }

    /// You can call this operation to query the metadata of an object.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    func headObject(
        _ request: HeadObjectRequest,
        _ options: OperationOptions? = nil
    ) async throws -> HeadObjectResult {
        var input = OperationInput(
            operationName: "HeadObject",
            method: "HEAD"
        )
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        input.key = try request.key.ensureRequired(field: "request.key")

        var req = request

        try Serde.serializeInput(&req, &input, [Serde.serializeHeadObject, Serde.addContentMd5])

        var output = try await clientImpl.execute(with: &input, args: options)

        var result = HeadObjectResult()

        try Serde.deserializeOutput(&result, &output, [Serde.deserializeHeadObject])

        return result
    }

    /// You can call this operation to query the metadata of an object, including ETag, Size, and LastModified. The content of the object is not returned.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    func getObjectMeta(
        _ request: GetObjectMetaRequest,
        _ options: OperationOptions? = nil
    ) async throws -> GetObjectMetaResult {
        var input = OperationInput(
            operationName: "GetObjectMeta",
            method: "HEAD",
            parameters: [
                "objectMeta": "",
            ]
        )
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        input.key = try request.key.ensureRequired(field: "request.key")

        var req = request

        try Serde.serializeInput(&req, &input, [Serde.serializeGetObjectMeta, Serde.addContentMd5])

        var output = try await clientImpl.execute(with: &input, args: options)

        var result = GetObjectMetaResult()

        try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetObjectMeta])

        return result
    }

    /// Deletes multiple objects from a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    func deleteMultipleObjects(
        _ request: DeleteMultipleObjectsRequest,
        _ options: OperationOptions? = nil
    ) async throws -> DeleteMultipleObjectsResult {
        var input = OperationInput(
            operationName: "DeleteMultipleObjects",
            method: "POST",
            headers: [
                "Content-Type": "application/xml",
            ],
            parameters: [
                "delete": "",
            ]
        )
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        try request.delete.ensureRequired(field: "request.delete")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeDeleteMultipleObjects, Serde.addContentMd5])

        var output = try await clientImpl.execute(with: &input, args: options)

        var result = DeleteMultipleObjectsResult()
        let deserialize: [SerdeDeserializeDelegate] = request.delete?.quiet ?? false ? [] : [Serde.deserializeDeleteMultipleObjects]
        try Serde.deserializeOutput(&result, &output, deserialize)

        return result
    }

    /// You can call this operation to restore objects of the Archive and Cold Archive storage classes.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    func restoreObject(
        _ request: RestoreObjectRequest,
        _ options: OperationOptions? = nil
    ) async throws -> RestoreObjectResult {
        var input = OperationInput(
            operationName: "RestoreObject",
            method: "POST",
            headers: [
                "Content-Type": "application/xml",
            ],
            parameters: [
                "restore": "",
            ]
        )
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        input.key = try request.key.ensureRequired(field: "request.key")

        var req = request

        try Serde.serializeInput(&req, &input, [Serde.serializeRestoreObject, Serde.addContentMd5])

        var output = try await clientImpl.execute(with: &input, args: options)

        var result = RestoreObjectResult()

        try Serde.deserializeOutput(&result, &output, [Serde.deserializeRestoreObject])

        return result
    }

    /// You can call this operation to clean an object restored from Archive or Cold Archive state. After that, the restored object returns to the frozen state.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    func cleanRestoredObject(
        _ request: CleanRestoredObjectRequest,
        _ options: OperationOptions? = nil
    ) async throws -> CleanRestoredObjectResult {
        var input = OperationInput(
            operationName: "CleanRestoredObject",
            method: "POST",
            headers: [
                "Content-Type": "application/xml",
            ],
            parameters: [
                "cleanRestoredObject": "",
            ]
        )
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        input.key = try request.key.ensureRequired(field: "request.key")

        var req = request

        try Serde.serializeInput(&req, &input, [Serde.serializeCleanRestoredObject, Serde.addContentMd5])

        var output = try await clientImpl.execute(with: &input, args: options)

        var result = CleanRestoredObjectResult()

        try Serde.deserializeOutput(&result, &output, [Serde.deserializeCleanRestoredObject])

        return result
    }

    func sealAppendObject(
        _ request: SealAppendObjectRequest,
        _ options: OperationOptions? = nil
    ) async throws -> SealAppendObjectResult {
        var input = OperationInput(
            operationName: "SealAppendObject",
            method: "POST",
            headers: [
                "Content-Type": "application/xml",
            ],
            parameters: [
                "seal": "",
            ]
        )
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        input.key = try request.key.ensureRequired(field: "request.key")
        _ = try request.position.ensureRequired(field: "request.position")

        var req = request

        try Serde.serializeInput(&req, &input, [Serde.serializeSealAppendObject])

        var output = try await clientImpl.execute(with: &input, args: options)

        var result = SealAppendObjectResult()

        try Serde.deserializeOutput(&result, &output, [Serde.deserializeSealAppendObject])

        return result
    }
}
