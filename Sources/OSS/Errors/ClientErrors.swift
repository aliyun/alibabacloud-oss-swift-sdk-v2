import Foundation

public struct ClientError: SdkErrorType {
    /// The error code
    public let code: String

    /// The detail error
    public let message: String

    /// Gets the Error instance that caused the current exception.
    public var innerError: Error? { return _innerError }

    let _innerError: Error?

    public init(
        code: String,
        message: String,
        innerError: Error? = nil
    ) {
        self.code = code
        self.message = message
        _innerError = innerError
    }

    public var description: String {
        if let innerError = _innerError {
            return "\(message)\nCaused by:\n\(innerError)"
        } else {
            return "\(message)"
        }
    }
}

/// Credentials error.
public extension ClientError {
    static func credentialsEmptyError(
        innerError: Error? = nil
    ) -> ClientError {
        return ClientError(
            code: "CredentialsError",
            message: "Credentials is null or empty.",
            innerError: innerError
        )
    }

    static func credentialsFetchError(
        innerError: Error? = nil
    ) -> ClientError {
        return ClientError(
            code: "CredentialsFetchError",
            message: "Fetch Credentials raised a error.",
            innerError: innerError
        )
    }
}

/// Parameter error.
public extension ClientError {
    static func paramInvalidError(
        field: String
    ) -> ClientError {
        return ClientError(
            code: "ParameterError",
            message: "Invalid field, \(field)."
        )
    }

    static func paramNullError(
        field: String
    ) -> ClientError {
        return ClientError(
            code: "ParameterError",
            message: "Null field, \(field)."
        )
    }

    static func paramNullOrEmptyError(
        field: String
    ) -> ClientError {
        return ClientError(
            code: "ParameterError",
            message: "Null or empty field, \(field)."
        )
    }

    static func paramRequiredError(
        field: String
    ) -> ClientError {
        return ClientError(
            code: "ParameterError",
            message: "Missing required field, \(field)."
        )
    }
}

/// Validation error.
public extension ClientError {
    static func bucketInvalidError(
        _ value: String
    ) -> ClientError {
        return ClientError(
            code: "ValidationError",
            message: "Bucket name is invalid, got \(value)."
        )
    }

    static func objectInvalidError(
        _ value: String
    ) -> ClientError {
        return ClientError(
            code: "ValidationError",
            message: "Object name is invalid, got \(value)."
        )
    }

    static func endpointInvalidError() -> ClientError {
        return ClientError(
            code: "ValidationError",
            message: "Endpoint is invalid."
        )
    }

    static func accountIdInvalidError(
        _ value: String
    ) -> ClientError {
        return ClientError(
            code: "ValidationError",
            message: "invalid account id: \(value), must be pure digits."
        )
    }
}

/// crc check error.
public extension ClientError {
    static func inconsistentError(
        clientCrc: UInt64,
        serverCrc: UInt64
    ) -> ClientError {
        return ClientError(
            code: "InconsistentError",
            message: "crc is inconsistent, client \(clientCrc), server \(serverCrc)."
        )
    }
}

/// presign error.
public extension ClientError {
    static func presignExpirationError(
        expiration: Date
    ) -> ClientError {
        return ClientError(
            code: "PresignError",
            message: "Expires should be not greater than 604800(seven days), got \(expiration)."
        )
    }
}

/// Serialization & Deserialization error.
public extension ClientError {
    static func serializationError(
        innerError _: Error? = nil
    ) -> ClientError {
        return ClientError(
            code: "SerdeError",
            message: "Serialization raised a error."
        )
    }

    static func deserializationError(
        innerError _: Error? = nil
    ) -> ClientError {
        return ClientError(
            code: "SerdeError",
            message: "Deserialization raised a error."
        )
    }

    static func parseResponseBodyError(
        info: String? = nil,
        snapshot: Data? = nil,
        innerError: Error? = nil
    ) -> ClientError {
        let bodyStr = String(data: snapshot ?? Data(), encoding: .utf8) ?? ""
        let info = info ?? "Parse response body fail."
        return ClientError(
            code: "SerdeError",
            message: "\(info) part response body:\n\(bodyStr.prefix(256))",
            innerError: innerError
        )
    }
}

/// Operation Error
public extension ClientError {
    static func operationError(
        name: String,
        innerError: Error
    ) -> ClientError {
        return ClientError(
            code: "OperationError",
            message: "Operation \(name) raised a error.",
            innerError: innerError
        )
    }
}

/// Remote signature Error
public extension ClientError {
    static func signatureResultRequiredError(
        field: String
    ) -> ClientError {
        return ClientError(
            code: "RemoteSignatureError",
            message: "The signature result don't contain \(field) field."
        )
    }

    static func signatureCallError(
        innerError _: Error
    ) -> ClientError {
        return ClientError(
            code: "RemoteSignatureError",
            message: "Call delegate.signature field."
        )
    }
}

/// Request & Response Error
public extension ClientError {
    /// An error occurred while attempt to make a request to the service.
    static func requestError(
        detail: String,
        innerError: Error? = nil
    ) -> ClientError {
        return ClientError(
            code: "RequestError",
            message: "Request error: \(detail)",
            innerError: innerError
        )
    }

    /// The request was sent, but the client failed to understand the response.
    /// The connection may have timed out. These errors can be retried for idempotent or safe operations
    static func responseError(
        detail: String,
        innerError: Error? = nil
    ) -> ClientError {
        return ClientError(
            code: "ResponseError",
            message: "Response error: \(detail)",
            innerError: innerError
        )
    }
}
