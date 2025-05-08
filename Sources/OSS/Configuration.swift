import Foundation

public class Configuration {
    /// The domain names that other services can use to access OSS.
    public var endpoint: String?

    /// The credentials provider to use when signing requests.
    public var credentialsProvider: CredentialsProvider?

    /// The region in which the bucket is located.
    public var region: String?

    /// Max retry count, default value is 3
    public var retryMaxAttempts: Int?

    /// Maximum connections per host
    public var maxConnectionsPerHost: Int?

    /// Flag of enabling background file transmit service., default value is `false`
    public var enableBackgroundTransmitService: Bool?

    /// Sets the session Id for background file transmission
    public var backgroundSesseionIdentifier: String?

    /// Sets request timeout, default value is 15s
    public var timeoutIntervalForRequest: TimeInterval?

    /// Sets single object's max time, default value is 24h
    public var timeoutIntervalForResource: TimeInterval?

    /// Sets the user specific identifier appended to the User-Agent header.
    public var userAgent: String?

    /// Retry policy
    public var retryer: Retryer?

    /// Check data integrity of uploads via the crc64 by default.
    /// This feature takes effect for PutObject, AppendObject, UploadPart, Uploader.UploadFrom and Uploader.UploadFile
    public var enableUploadCRC64Validation: Bool?

    /// Check data integrity of download via the crc64 by default.
    /// This feature only takes effect for Downloader.DownloadFile, GetObjectToFile
    public var enableDownloadCRC64Validation: Bool?

    /// Disable Https protocol on request. Defaut value is false
    public var httpProtocal: HttpProtocal?

    /// Skip certificate check. Defaut value is false
    public var enableTLSVerify: Bool?

    /// Enable redirection. Defaut value is false
    public var enableFollowRedirect: Bool?

    /// Use the path style request mode, where the bucket name is placed in the path. Defaut value is false
    public var usePathStyle: Bool?

    /// Request mode using cname. Defaut value is false
    public var useCname: Bool?

    /// Authentication with OSS Signature Version, Defaults is "v4"
    public var signerVersion: SignerVersion?

    /// Dual-stack endpoints are provided in some regions.
    /// This allows an IPv4 client and an IPv6 client to access a bucket by using the same endpoint.
    ///  Set this to `true` to use a dual-stack endpoint for the requests.
    public var useDualStackEndpoint: Bool?

    /// You can use an internal endpoint to communicate between Alibaba Cloud services located  within the same
    /// region over the internal network. You are not charged for the traffic generated over the internal network.
    /// Set this to `true` to use a accelerate endpoint for the requests.
    public var useInternalEndpoint: Bool?

    /// OSS provides the transfer acceleration feature to accelerate date transfers of data
    /// uploads and downloads across countries and regions.
    /// Set this to `true` to use a accelerate endpoint for the requests.
    public var useAccelerateEndpoint: Bool?
    
    /// Additional signable headers.
    public var additionalHeaders: [String]?
    
    /// Proxy host.
    public var proxyHost: String?

    /// oss log agent
    public var logger: LogAgent?

    public static func `default`() -> Configuration {
        return Configuration()
    }
}

public extension Configuration {
    /// Set the domain names that other services can use to access OSS.
    /// - Parameter endpoint: The domain names that other services can use to access OSS.
    /// - Returns: self
    @discardableResult
    func withEndpoint(_ endpoint: String) -> Self {
        self.endpoint = endpoint
        return self
    }

    /// Set the credentials provider to use when signing requests.
    /// - Parameter credentialsProvider: The credentials provider to use when signing requests.
    /// - Returns: self
    @discardableResult
    func withCredentialsProvider(_ credentialsProvider: CredentialsProvider) -> Self {
        self.credentialsProvider = credentialsProvider
        return self
    }

    /// Set the region in which the bucket is located.
    /// - Parameter region: The region in which the bucket is located.
    /// - Returns: self
    @discardableResult
    func withRegion(_ region: String) -> Self {
        self.region = region
        return self
    }

    /// Set specifies the maximum number attempts an API client will call
    /// - Parameter maxRetryCount: Specifies the maximum number attempts an API client will call
    /// - Returns: self
    @discardableResult
    func withRetryMaxAttempts(_ retryMaxAttempts: Int) -> Self {
        self.retryMaxAttempts = retryMaxAttempts
        return self
    }

    /// Set maximum connections per host
    /// - Parameter maxConnectionsPerHost: maxConnectionsPerHost
    /// - Returns: self
    @discardableResult
    func withMaxConnectionsPerHost(_ maxConnectionsPerHost: Int) -> Self {
        self.maxConnectionsPerHost = maxConnectionsPerHost
        return self
    }

    /// Set whether to enable the background file transmit service
    /// - Parameter enableBackgroundTransmitService: enableBackgroundTransmitService
    /// - Returns: self
    @discardableResult
    func withBackgroundTransmitService(_ enableBackgroundTransmitService: Bool) -> Self {
        self.enableBackgroundTransmitService = enableBackgroundTransmitService
        return self
    }

    /// Set up backend session identifier
    /// - Parameter backgroundSesseionIdentifier: backgroundSesseionIdentifier
    /// - Returns: self
    @discardableResult
    func withBackgroundSesseionIdentifier(_ backgroundSesseionIdentifier: String) -> Self {
        self.backgroundSesseionIdentifier = backgroundSesseionIdentifier
        return self
    }

    /// Set request timeout period
    /// - Parameter timeoutIntervalForRequest: timeoutIntervalForRequest
    /// - Returns: self
    @discardableResult
    func withTimeoutIntervalForRequest(_ timeoutIntervalForRequest: TimeInterval) -> Self {
        self.timeoutIntervalForRequest = timeoutIntervalForRequest
        return self
    }
    
    /// Sets single object's max time.
    /// - Parameter timeoutIntervalForResource: timeoutIntervalForRequest
    /// - Returns: self
    @discardableResult
    func withTimeoutIntervalForResource(_ timeoutIntervalForResource: TimeInterval) -> Self {
        self.timeoutIntervalForResource = timeoutIntervalForResource
        return self
    }

    /// Set the optional user specific identifier appended to the User-Agent header.
    /// - Parameter userAgent: The optional user specific identifier appended to the User-Agent header.
    /// - Returns: self
    @discardableResult
    func withUserAgent(_ userAgent: String) -> Self {
        self.userAgent = userAgent
        return self
    }

    /// Set guides how HTTP requests should be retried in case of recoverable failures.
    /// - Parameter retryer: Guides how HTTP requests should be retried in case of recoverable failures.
    /// - Returns: self
    @discardableResult
    func withRetryer(_ retryer: Retryer) -> Self {
        self.retryer = retryer
        return self
    }

    /// Check data integrity of uploads via the crc64 by default.
    /// - Parameter enableUploadCRC64Validation: enableUploadCRC64Validation
    /// - Returns: self
    @discardableResult
    func withUploadCRC64Validation(_ enableUploadCRC64Validation: Bool) -> Self {
        self.enableUploadCRC64Validation = enableUploadCRC64Validation
        return self
    }

    /// Check data integrity of download via the crc64 by default.
    /// - Parameter enableDownloadCRC64Validation: enableDownloadCRC64Validation
    /// - Returns: self
    @discardableResult
    func withDownloadCRC64Validation(_ enableDownloadCRC64Validation: Bool) -> Self {
        self.enableDownloadCRC64Validation = enableDownloadCRC64Validation
        return self
    }

    /// Set up HTTP protocol
    /// - Parameter httpProtocal: http or https
    /// - Returns: self
    @discardableResult
    func withHttpProtocal(_ httpProtocal: HttpProtocal) -> Self {
        self.httpProtocal = httpProtocal
        return self
    }

    /// Skip certificate check.
    /// - Parameter enableTLSVerify: enableTLSVerify
    /// - Returns: self
    @discardableResult
    func withTLSVerify(_ enableTLSVerify: Bool) -> Self {
        self.enableTLSVerify = enableTLSVerify
        return self
    }

    /// Set enable http redirect or not. Default is disable
    /// - Parameter enableFollowRedirect: Enable http redirect or not. Default is disable
    /// - Returns: self
    @discardableResult
    func withFollowRedirect(_ enableFollowRedirect: Bool) -> Self {
        self.enableFollowRedirect = enableFollowRedirect
        return self
    }

    /// Set allows you to enable the client to use path-style addressing,
    /// - Parameter usePathStyle: usePathStyle
    /// - Returns: self
    @discardableResult
    func withUsePathStyle(_ usePathStyle: Bool) -> Self {
        self.usePathStyle = usePathStyle
        return self
    }

    /// Set if the endpoint is s CName, set this flag to true
    /// - Parameter useCname: useCname
    /// - Returns: self
    @discardableResult
    func withUseCname(_ useCname: Bool) -> Self {
        self.useCname = useCname
        return self
    }

    /// Set dual-stack endpoints are provided in some regions.
    /// - Parameter useDualStackEndpoint: Dual-stack endpoints are provided in some regions.
    /// - Returns: self
    @discardableResult
    func withUseDualStackEndpoint(_ useDualStackEndpoint: Bool) -> Self {
        self.useDualStackEndpoint = useDualStackEndpoint
        return self
    }

    /// You can use an internal endpoint to communicate between Alibaba Cloud services located
    /// - Parameter useInternalEndpoint: useInternalEndpoint
    /// - Returns: self
    @discardableResult
    func withUseInternalEndpoint(_ useInternalEndpoint: Bool) -> Self {
        self.useInternalEndpoint = useInternalEndpoint
        return self
    }

    /// Set OSS provides the transfer acceleration feature to accelerate date transfers
    /// - Parameter useAccelerateEndpoint: OSS provides the transfer acceleration feature to accelerate date transfers
    /// - Returns: self
    @discardableResult
    func withUseAccelerateEndpoint(_ useAccelerateEndpoint: Bool) -> Self {
        self.useAccelerateEndpoint = useAccelerateEndpoint
        return self
    }

    /// Set the signature version when signing requests. Valid values v4, v1
    /// - Parameter signerVersion: SignerVersion
    /// - Returns: self
    @discardableResult
    func withSignerVersion(_ signerVersion: SignerVersion) -> Self {
        self.signerVersion = signerVersion
        return self
    }

    /// Set additional signable headers.
    /// - Parameter additionalHeaders: Additional signable headers
    /// - Returns: self
    @discardableResult
    func withAdditionalHeaders(_ additionalHeaders: [String]) -> Self {
        self.additionalHeaders = additionalHeaders
        return self
    }
    
    /// Set proxy host.
    /// - Parameter proxyHost: Proxy host
    /// - Returns: self
    @discardableResult
    func withProxyHost(_ proxyHost: String) -> Self {
        self.proxyHost = proxyHost
        return self
    }
    
    /// Set up logger
    /// - Parameter logger: logger
    /// - Returns: self
    @discardableResult
    func withLogger(_ logger: LogAgent) -> Self {
        self.logger = logger
        return self
    }
}
