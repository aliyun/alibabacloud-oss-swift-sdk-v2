import Foundation

public extension Client {
    /// You can call this operation to query an object.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - file: URL of file
    /// - Returns: The result instance.
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    func getObjectToFile(
        _ request: GetObjectRequest,
        _ file: URL,
        _ options: OperationOptions? = nil
    ) async throws -> GetObjectResult {
        var options = options ?? OperationOptions()
        options.saveToURL = true

        var result = try await getObject(request, options)

        // Remove any existing file
        if FileManager.default.fileExists(atPath: file.path) {
            try FileManager.default.removeItem(at: file)
        }

        switch result.body {
        case let .file(tempURL):
            try FileManager.default.moveItem(
                at: tempURL,
                to: file
            )
            result.body = .file(file)
        default:
            throw ClientError.paramInvalidError(field: "result.body")
        }
        return result
    }

    /// Checks if the bucket exists
    /// - Parameter bucket: The request parameter to send.
    /// - Returns: True if the object exists, else False.
    func isBucketExist(_ bucket: Swift.String) async throws -> Bool {
        do {
            let request = GetBucketAclRequest(bucket: bucket)
            let _ = try await getBucketAcl(request)
            return true
        } catch {
            if let serverError = error as? ServerError,
               serverError.code == "NoSuchBucket"
            {
                return false
            }
            throw error
        }
    }

    /// Checks if the object exists
    /// - Parameters:
    ///   - bucket: he request parameter to send.
    ///   - key: The request parameter to send.
    /// - Returns: True if the object exists, else False.
    func isObjectExist(
        _ bucket: Swift.String,
        _ key: Swift.String,
        _ versionId: Swift.String? = nil
    ) async throws -> Bool {
        do {
            let request = GetObjectMetaRequest(bucket: bucket,
                                               key: key,
                                               versionId: versionId)
            let _ = try await getObjectMeta(request)
            return true
        } catch {
            if let serverError = error as? ServerError {
                if serverError.code == "NoSuchKey" {
                    return false
                }
                if serverError.statusCode == 404,
                   serverError.code == "BadErrorResponse"
                {
                    return false
                }
            }
            throw error
        }
    }
}

extension Optional {
    @discardableResult
    func ensureRequired(field: String) throws -> Wrapped {
        if let value = self {
            return value
        }
        throw ClientError.paramRequiredError(field: field)
    }
}
