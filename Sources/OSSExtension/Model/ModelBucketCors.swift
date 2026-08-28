import AlibabaCloudOSS
import Foundation

/// The container that stores the CORS rules.Up to 10 CORS rules can be configured for a bucket. The XML message body in a request can be up to 16 KB in size.
public struct CORSRule: Sendable {
    /// The origins from which cross-origin requests are allowed.
    public var allowedOrigins: [Swift.String]?

    /// The methods that you can use in cross-origin requests.
    public var allowedMethods: [Swift.String]?

    /// Specifies whether the headers specified by Access-Control-Request-Headers in the OPTIONS preflight request are allowed. Each header specified by Access-Control-Request-Headers must match the value of an AllowedHeader element.  You can use only one asterisk (\*) as the wildcard character.
    public var allowedHeaders: [Swift.String]?

    /// The response headers for allowed access requests from applications, such as an XMLHttpRequest object in JavaScript.  The asterisk (\*) wildcard character is not supported.
    public var exposeHeaders: [Swift.String]?

    /// The period of time within which the browser can cache the response to an OPTIONS preflight request for the specified resource. Unit: seconds.You can specify only one MaxAgeSeconds element in a CORS rule.
    public var maxAgeSeconds: Swift.Int?

    public init(
        allowedOrigins: [Swift.String]? = nil,
        allowedMethods: [Swift.String]? = nil,
        allowedHeaders: [Swift.String]? = nil,
        exposeHeaders: [Swift.String]? = nil,
        maxAgeSeconds: Swift.Int? = nil
    ) {
        self.allowedOrigins = allowedOrigins
        self.allowedMethods = allowedMethods
        self.allowedHeaders = allowedHeaders
        self.exposeHeaders = exposeHeaders
        self.maxAgeSeconds = maxAgeSeconds
    }
}

extension CORSRule: Codable {
    enum CodingKeys: String, CodingKey {
        case allowedOrigins = "AllowedOrigin"
        case allowedMethods = "AllowedMethod"
        case allowedHeaders = "AllowedHeader"
        case exposeHeaders = "ExposeHeader"
        case maxAgeSeconds = "MaxAgeSeconds"
    }
}

/// The container that stores CORS configuration.
public struct CORSConfiguration: Sendable {
    /// The container that stores CORS rules. Up to 10 rules can be configured for a bucket.
    public var corsRules: [CORSRule]?

    /// Indicates whether the Vary: Origin header was returned. Default value: false.- true: The Vary: Origin header is returned regardless whether the request is a cross-origin request or whether the cross-origin request succeeds.- false: The Vary: Origin header is not returned.
    public var responseVary: Swift.Bool?

    public init(
        corsRules: [CORSRule]? = nil,
        responseVary: Swift.Bool? = nil
    ) {
        self.corsRules = corsRules
        self.responseVary = responseVary
    }
}

extension CORSConfiguration: Codable {
    enum CodingKeys: String, CodingKey {
        case corsRules = "CORSRule"
        case responseVary = "ResponseVary"
    }
}

/// The request for the PutBucketCors operation.
public struct PutBucketCorsRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String?

    /// The request body schema.
    public var corsConfiguration: CORSConfiguration?

    public init(
        bucket: Swift.String? = nil,
        corsConfiguration: CORSConfiguration? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.bucket = bucket
        self.corsConfiguration = corsConfiguration
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the PutBucketCors operation.
public struct PutBucketCorsResult: ResultModel {
    public var commonProp: ResultModelProp = .init()
}

/// The request for the GetBucketCors operation.
public struct GetBucketCorsRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String?

    public init(
        bucket: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.bucket = bucket
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the GetBucketCors operation.
public struct GetBucketCorsResult: ResultModel {
    public var commonProp: ResultModelProp = .init()

    /// The container that stores CORS configuration.
    public var corsConfiguration: CORSConfiguration?
}

/// The request for the DeleteBucketCors operation.
public struct DeleteBucketCorsRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String?

    public init(
        bucket: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.bucket = bucket
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the DeleteBucketCors operation.
public struct DeleteBucketCorsResult: ResultModel {
    public var commonProp: ResultModelProp = .init()
}

/// The request for the OptionObject operation.
public struct OptionObjectRequest: RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String?

    /// The full path of the object.
    public var key: Swift.String?

    /// The origin of the request. It is used to identify a cross-origin request. You can specify only one Origin header in a cross-origin request. By default, this header is left empty.
    public var origin: Swift.String?

    /// The method to be used in the actual cross-origin request. You can specify only one Access-Control-Request-Method header in a cross-origin request. By default, this header is left empty.
    public var accessControlRequestMethod: Swift.String?

    /// The custom headers to be sent in the actual cross-origin request. You can configure multiple custom headers in a cross-origin request. Custom headers are separated by commas (,). By default, this header is left empty.
    public var accessControlRequestHeaders: Swift.String?

    public init(
        bucket: Swift.String? = nil,
        key: Swift.String? = nil,
        origin: Swift.String? = nil,
        accessControlRequestMethod: Swift.String? = nil,
        accessControlRequestHeaders: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) {
        self.bucket = bucket
        self.key = key
        self.origin = origin
        self.accessControlRequestMethod = accessControlRequestMethod
        self.accessControlRequestHeaders = accessControlRequestHeaders
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the OptionObject operation.
public struct OptionObjectResult: ResultModel {
    public var commonProp: ResultModelProp = .init()

    /// The origin that is included in the request. If the request is denied, the response does not contain the header.
    public var accessControlAllowOrigin: Swift.String? { return commonProp.headers?[caseInsensitive: "Access-Control-Allow-Origin"] }

    /// The HTTP method of the request. If the request is denied, the response does not contain the header.
    public var accessControlAllowMethods: Swift.String? { return commonProp.headers?[caseInsensitive: "Access-Control-Allow-Methods"] }

    /// The list of headers included in the request. If the request includes headers that are not allowed, the response does not contain the headers and the request is denied.
    public var accessControlAllowHeaders: Swift.String? { return commonProp.headers?[caseInsensitive: "Access-Control-Allow-Headers"] }

    /// The list of headers that can be accessed by JavaScript applications on a client.
    public var accessControlExposeHeaders: Swift.String? { return commonProp.headers?[caseInsensitive: "Access-Control-Expose-Headers"] }

    /// The maximum duration for the browser to cache preflight results. Unit: seconds.
    public var accessControlMaxAge: Swift.Int? { return commonProp.headers?[caseInsensitive: "Access-Control-Max-Age"]?.toInt() }
}
