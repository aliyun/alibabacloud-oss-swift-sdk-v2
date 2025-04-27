import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

struct InnerOptions {
    let userAgent: String
    let logger: LogAgent?
    let urlsession: URLSession
    let sessionOwner: Bool
}

struct PresignInnerResult {
    var method: String?
    var url: String?
    var expiration: Date?
    var signedHeaders: [String: String]?
}

class ClientImpl {
    var executeStack: ExecuteStack
    let options: ClientOptions
    let innerOptions: InnerOptions

    public init(
        _ config: Configuration,
        _ actions: [ClientOptionsAction] = []
    ) {
        // apply config & options
        let opts = Self.resolveConfig(config)

        for action in actions {
            action(opts)
        }

        let userAgent = Self.resolveUserAgent(config)
        let (urlsession, sessionOwner) = Self.resolveURLSession(config)

        let innerOpts = InnerOptions(
            userAgent: userAgent,
            logger: config.logger,
            urlsession: urlsession,
            sessionOwner: sessionOwner
        )

        // build execute stack
        let stack = opts.executeMW != nil ?
            ExecuteStack(handler: opts.executeMW!) :
            ExecuteStack(session: innerOpts.urlsession, logger: innerOpts.logger)

        stack.push(
            create: { (next: ExecuteMiddleware) in
                let retryHandler = opts.featureFlags.contains(.correctClockSkew) ? FixTimeRetryHandler() : nil
                return RetryerMiddleware(
                    nextHandler: next,
                    retryer: opts.retryer,
                    logger: innerOpts.logger,
                    retryHandler: retryHandler
                )
            }, name: "Retryer"
        )

        stack.push(
            create: { (next: ExecuteMiddleware) in
                SignerMiddleware(
                    nextHandler: next,
                    signer: opts.signer,
                    provider: opts.credentialsProvider,
                    logger: innerOpts.logger
                )
            }, name: "Singer"
        )

        stack.push(
            create: { (next: ExecuteMiddleware) in
                ResponseCheckerMiddleware(nextHandler: next, logger: innerOpts.logger)
            }, name: "Checker"
        )

        options = opts
        innerOptions = innerOpts
        executeStack = stack
    }

    func hasFeatureFlag(_ flag: FeatureFlag) -> Bool {
        return options.featureFlags.contains(flag)
    }

    deinit {
        if self.innerOptions.sessionOwner {
            self.innerOptions.urlsession.finishTasksAndInvalidate()
        }
    }

    static func resolveConfig(_ config: Configuration) -> ClientOptions {
        let product = Defaults.product
        let region = config.region ?? ""
        let endpoint = resolveEndpoint(config)
        let retryer = resolveRetryer(config)
        let signer = resolveSigner(config)
        let addressStyle = resolveAddressStyle(config, endpoint)
        let featureFlags = resolveFeatureFlags(config)
        let opts = ClientOptions(
            product: product,
            region: region,
            endpoint: endpoint,
            retryMaxAttempts: config.retryMaxAttempts,
            retryer: retryer,
            signer: signer,
            credentialsProvider: config.credentialsProvider,
            addressStyle: addressStyle,
            authMethod: nil,
            featureFlags: featureFlags
        )

        return opts
    }

    static func resolveEndpoint(_ config: Configuration) -> URL? {
        var endpoint: String
        if let _endpoint = config.endpoint,
           !_endpoint.isEmpty
        {
            endpoint = _endpoint
        } else {
            guard let region = config.region else {
                return nil
            }
            let endpointType: EndpointType
            if config.useDualStackEndpoint ?? false {
                endpointType = .dualstack
            } else if config.useInternalEndpoint ?? false {
                endpointType = .internal
            } else if config.useAccelerateEndpoint ?? false {
                endpointType = .accelerate
            } else {
                endpointType = .defautt
            }
            endpoint = OSSUtils.regionToEndpoint(region: region, type: endpointType)
        }

        if !endpoint.contains("://") {
            endpoint = config.httpProtocal.rawValue + "://" + endpoint
        }
        return URL(string: endpoint)
    }

    static func resolveRetryer(_ config: Configuration) -> Retryer {
        guard let retryer = config.retryer else {
            return StandardRetryer(maxAttempt: config.retryMaxAttempts)
        }
        return retryer
    }

    static func resolveSigner(_ config: Configuration) -> Signer {
        switch config.signerVersion {
        case .v1:
            SignerV1()
        default:
            SignerV4()
        }
    }

    static func resolveURLSession(_ config: Configuration) -> (URLSession, Bool) {
        let owner = true

        let delegate = OSSURLSessionDelegate(enableTLSVerify: config.enableTLSVerify ?? false,
                                             enableFollowRedirect: config.enableFollowRedirect ?? false)
        let delegateQueue = OperationQueue()
        var sessionConfig: URLSessionConfiguration
        sessionConfig = .default
        #if !(os(Linux) || os(Windows))
            if config.enableBackgroundTransmitService {
                let identifier = config.backgroundSesseionIdentifier ?? Defaults.backgroundSesseionIdentifier
                sessionConfig = .background(withIdentifier: identifier)
            }
        #endif
        sessionConfig.timeoutIntervalForRequest = config.timeoutIntervalForRequest
        sessionConfig.timeoutIntervalForResource = config.timeoutIntervalForResource
        sessionConfig.requestCachePolicy = .reloadIgnoringLocalCacheData
        if let maximumConnectionsPerHost = config.maxConnectionsPerHost {
            sessionConfig.httpMaximumConnectionsPerHost = maximumConnectionsPerHost
            delegateQueue.maxConcurrentOperationCount = maximumConnectionsPerHost
        }
        return (URLSession(configuration: sessionConfig,
                           delegate: delegate,
                           delegateQueue: delegateQueue), owner)
    }

    static func resolveAddressStyle(_ config: Configuration, _ endpoint: URL?) -> AddressStyleType {
        var style: AddressStyleType
        if config.useCname ?? false {
            style = .cname
        } else if config.usePathStyle ?? false {
            style = .path
        } else {
            style = .virtualHosted
        }

        if let endpoint = endpoint, let host = endpoint.host {
            style = host.isIPAddress() ? .path : style
        }
        return style
    }

    static func resolveUserAgent(_ config: Configuration) -> String {
        var ua = UserAgent.getDefault()
        if let userAgent = config.userAgent {
            ua = "\(ua) /\(userAgent)"
        }
        return ua
    }

    static func resolveFeatureFlags(_ config: Configuration) -> FeatureFlag {
        var featureFlags = Defaults.featureFlags
        if let enableUploadCRC64Validation = config.enableUploadCRC64Validation {
            if enableUploadCRC64Validation {
                featureFlags.insert(.enableCRC64CheckUpload)
            } else {
                featureFlags.remove(.enableCRC64CheckUpload)
            }
        }
        if let enableDownloadCRC64Validation = config.enableDownloadCRC64Validation {
            if enableDownloadCRC64Validation {
                featureFlags.insert(.enableCRC64CheckDownload)
            } else {
                featureFlags.remove(.enableCRC64CheckDownload)
            }
        }
        return featureFlags
    }

    static func verifyOperation(input: inout OperationInput) throws {
        if let bucketName = input.bucket, try !bucketName.isValidBucketName() {
            throw ClientError.bucketInvalidError(bucketName)
        }
        if let key = input.key, try !key.isValidObjectKey() {
            throw ClientError.objectInvalidError(key)
        }
    }

    public func execute(
        with input: inout OperationInput,
        args opOpts: OperationOptions? = nil
    ) async throws -> OperationOutput {
        // verify input
        try Self.verifyOperation(input: &input)

        // build execute context
        let (request, context) = try buildRequestContext(with: &input, opts: opOpts)

        // execute and wait result
        do {
            let result = try await executeStack.execute(request, context)
            return OperationOutput(
                input: input,
                statusCode: result.statusCode,
                headers: result.headers,
                body: result.content
            )
        } catch {
            // wrap to operation error
            throw error
        }
    }

    public func presignInner(
        with input: inout OperationInput,
        args opOpts: OperationOptions? = nil
    ) async throws -> PresignInnerResult {
        // verify input
        try Self.verifyOperation(input: &input)

        // build execute context
        let (request, context) = try buildRequestContext(with: &input, opts: opOpts)

        var result = PresignInnerResult(
            method: request.method,
            url: request.requestUri.absoluteString
        )

        guard let provider = options.credentialsProvider else {
            return result
        }

        if provider is AnonymousCredentialsProvider {
            return result
        }

        let credentials = try await provider.getCredentials()

        if credentials.isEmpty() {
            throw ClientError.credentialsEmptyError()
        }

        context.signingContext?.credentials = credentials
        context.signingContext?.authHeader = false

        let req = try await options.signer.sign(request: request, signingContext: &(context.signingContext!))

        // update signable headers & check max expiration time
        // signed headers
        // content-type, content-md5, x-oss- and additionalHeaders in sign v4
        let expiration = context.signingContext!.expirationTime!
        var expect: [String] = ["content-type", "content-md5"]
        if options.signer is SignerV4 {
            context.signingContext?.additionalHeaderNames?.forEach { expect.append($0.lowercased()) }
            let expires = Int(expiration.timeIntervalSince1970 - Date().timeIntervalSince1970)
            if expires > 7 * 24 * 3600 {
                throw ClientError.presignExpirationError(expiration: expiration)
            }
        }

        var signedHeaders: [String: String] = [:]
        for (k, v) in req.headers {
            let lowkey = k.lowercased()
            if expect.contains(lowkey) {
                signedHeaders[lowkey] = v
            }
        }

        result.url = req.requestUri.absoluteString
        result.expiration = expiration
        result.signedHeaders = signedHeaders

        return result
    }

    func buildRequestContext(
        with input: inout OperationInput,
        opts: OperationOptions?
    ) throws -> (RequestMessage, ExecuteContext) {
        // default api options
        let retryMaxAttempts = opts?.retryMaxAttempts
        let readWriteTimeout = opts?.readWriteTimeout

        var responseHandlers: [ResponseHandler] = [ServerResponseHandler()]
        // response delegate
        if let handlers = input.metadata.values(key: AttributeKeys.responseHandler) {
            handlers.forEach { value in responseHandlers.append(value) }
        }

        // signing context
        var signingContext = SigningContext(
            bucket: input.bucket,
            key: input.key,
            region: options.region,
            product: options.product
        )

        // signing time from user
        if let expirationTime = input.metadata.get(key: AttributeKeys.expirationTime) {
            signingContext.expirationTime = expirationTime
        }

        // request
        // request::host & path & query
        guard let endpoint = options.endpoint else {
            throw ClientError.endpointInvalidError()
        }
        let baseUrl = input.buildHostPath(
            host: endpoint.hostPort(),
            addressStyle: options.addressStyle
        )
        var url = "\(endpoint.scheme!)://\(baseUrl)"
        let query = input.queryString()
        if !query.isEmpty {
            url = "\(url)?\(query)"
        }
        guard let uri = URL(string: url) else {
            throw ClientError.requestError(detail: "Build url fail. url: \(url)")
        }

        // request::headers
        var headers: [String: String] = [:]
        input.headers.forEach { key, value in headers[key.lowercased()] = value }
        headers["user-agent"] = innerOptions.userAgent

        // request::body
        let request = RequestMessage(
            method: input.method,
            requestUri: uri,
            headers: headers,
            content: input.body
        )

        let context = ExecuteContext(
            retryMaxAttempts: retryMaxAttempts,
            readWriteTimeout: readWriteTimeout,
            signingContext: signingContext,
            progressDelegate: input.metadata.get(key: AttributeKeys.progressDelegate),
            responseHandlers: responseHandlers,
            saveToURL: opts?.saveToURL
        )

        return (request, context)
    }
}

extension OperationInput {
    func buildPath(pathStyle: AddressStyleType) -> String? {
        var path: String?
        if let bucketName = bucket {
            if pathStyle == .path {
                path = "/".appending(bucketName)
            }
        }

        if let objectKey = key?.urlEncodeWithoutSeparator() {
            path = (path ?? "").appending("/").appending(objectKey)
        }

        return path
    }

    func buildHost(endpoint: String, pathStyle: AddressStyleType) throws -> String {
        guard let temComs = URLComponents(string: endpoint),
              var host = temComs.host
        else {
            throw ClientError.requestError(detail: "Endpoint format error.")
        }

        if let bucketName = bucket {
            if pathStyle != .cname {
                host = bucketName.appending(".").appending(host)
            }
        }

        return host
    }

    func queryItems() -> [URLQueryItem]? {
        var queryItems: [URLQueryItem]?
        if parameters.count > 0 {
            queryItems = parameters.compactMap {
                if let name = $0.urlEncode() {
                    let value = $1?.urlEncode()
                    return URLQueryItem(name: name, value: value)
                } else {
                    return nil
                }
            }
        }

        return queryItems
    }

    func queryString() -> String {
        if parameters.count == 0 {
            return ""
        }

        return parameters.map { key, value in
            if let name = key.urlEncode() {
                let value = value?.urlEncode()
                return "\(name)=\(value ?? "")"
            } else {
                return ""
            }
        }.joined(separator: "&")
    }

    func buildHostPath(host: String, addressStyle: AddressStyleType) -> String {
        var paths: [String] = []
        var baseUrl = host
        if let bucket = bucket {
            switch addressStyle {
            case .path:
                paths.append(bucket)
                if key == nil {
                    paths.append("")
                }
            case .cname:
                break
            default: // virtual host
                baseUrl = "\(bucket).\(host)"
            }
        }

        if let encodeKey = key?.urlEncodePath() {
            paths.append(encodeKey)
        }

        return "\(baseUrl)/\(paths.joined(separator: "/"))"
    }
}

extension URL {
    func hostPort() -> String {
        guard var str = host else {
            return ""
        }
        if let port = port {
            str += ":\(port)"
        }
        return str
    }
}
