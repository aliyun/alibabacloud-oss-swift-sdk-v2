import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

class URLSessionTransport: HttpTransport {
    
    private let _session: URLSession
    private let logger: LogAgent?

    init(
        _ options: HttpTransportOptions,
        _ logger: LogAgent? = nil
    ) {
        _session = Self.createURLSession(options)
        self.logger = logger
    }
    
    deinit {
        _session.finishTasksAndInvalidate()
    }
    
    static func createURLSession(_ options: HttpTransportOptions) -> URLSession {
        let delegate = OSSURLSessionDelegate(enableTLSVerify: options.enableTLSVerify ?? true,
                                             enableFollowRedirect: options.enableFollowRedirect ?? false)
        let delegateQueue = OperationQueue()
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = options.timeoutIntervalForRequest ?? Defaults.timeoutIntervalForRequest
        sessionConfig.timeoutIntervalForResource = options.timeoutIntervalForResource ?? Defaults.timeoutIntervalForResource
        sessionConfig.requestCachePolicy = .reloadIgnoringLocalCacheData
        if var proxyHost = options.proxyHost {
            if !proxyHost.contains("://") {
                proxyHost = "scheme://" + proxyHost
            }
            let url = URL(string: proxyHost)
            var connectionProxyDictionary: [String: Any] = [:]
            if url?.scheme == "scheme" ||
                url?.scheme == "http" {
                connectionProxyDictionary["HTTPEnable"] = true
                connectionProxyDictionary["HTTPProxy"] = url?.host
                connectionProxyDictionary["HTTPPort"] = url?.port
            }
            if url?.scheme == "scheme" ||
                url?.scheme == "https" {
                connectionProxyDictionary["HTTPSEnable"] = true
                connectionProxyDictionary["HTTPSProxy"] = url?.host
                connectionProxyDictionary["HTTPSPort"] = url?.port
            }
            sessionConfig.connectionProxyDictionary = connectionProxyDictionary
        }
        if let maximumConnectionsPerHost = options.maxConnectionsPerHost {
            sessionConfig.httpMaximumConnectionsPerHost = maximumConnectionsPerHost
            delegateQueue.maxConcurrentOperationCount = maximumConnectionsPerHost
        }
        return URLSession(
            configuration: sessionConfig,
            delegate: delegate,
            delegateQueue: delegateQueue
        )
    }
    
    func send(request: RequestMessage, options: HttpRequestOptions) async throws -> ResponseMessage {
        logger?.debug(request.description)
        var urlRequest = URLRequest(url: request.requestUri)
        urlRequest.httpMethod = request.method
        for (key, value) in request.headers {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }

        // task delegate
        let delegate: URLSessionTaskDelegate?
        if let progresInfo = options.progressDelegate {
            delegate = progresInfo.upload ?
                UploadProgressDelegate(progress: progresInfo.delegate) :
                DownloadProgressDelegate(progress: progresInfo.delegate)
        } else {
            delegate = nil
        }

        let body: ByteStream
        let urlResponse: URLResponse
        let respData: Data

        do {
            switch request.content {
            case let .file(url):
                if #available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *) {
                    (respData, urlResponse) = try await _session.upload(
                        for: urlRequest,
                        fromFile: url,
                        delegate: delegate
                    )
                } else {
                    (respData, urlResponse) = try await _session.upload(for: urlRequest, fromFile: url)
                }
                body = .data(respData)
            default:
                switch request.content {
                case let .data(content):
                    urlRequest.httpBody = content
                case let .stream(inputStream):
                    urlRequest.httpBodyStream = inputStream
                default:
                    // no content
                    break
                }

                let respUrl: URL
                if #available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *),
                   let saveToUrl = options.saveToURL, saveToUrl == true
                {
                    /// because of the bug of URLSession, we can't get the progress of downloading
                    /// set delegate to nil always
                    (respUrl, urlResponse) = try await _session.download(for: urlRequest, delegate: nil)

                    // save reponse body into memroy when status code is not 2xx
                    if let resp = (urlResponse as? HTTPURLResponse), resp.statusCode >= 300 {
                        body = .data(FileManager.default.contents(atPath: respUrl.path)!)
                        try FileManager.default.removeItem(at: respUrl)
                    } else {
                        body = .file(respUrl)
                    }
                    
                } else {
                    if #available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *) {
                        (respData, urlResponse) = try await _session.data(for: urlRequest, delegate: delegate)
                    } else {
                        (respData, urlResponse) = try await _session.data(for: urlRequest)
                    }
                    body = .data(respData)
                }
            }
        } catch {
            logger?.error("\(error)")
            throw ClientError.responseError(
                detail: "send request failed",
                innerError: error
            )
        }

        guard let urlResponse = (urlResponse as? HTTPURLResponse) else {
            throw ClientError.responseError(detail: "Failed to convert URLResponse to HttpResponse")
        }

        // convert URLResponse to HttpResponse
        var headers: [String: String] = [:]
        for (key, value) in urlResponse.allHeaderFields {
            headers[key as! String] = value as? String
        }
        let response = ResponseMessage(
            statusCode: urlResponse.statusCode,
            headers: headers,
            content: body,
            request: request
        )
        logger?.debug(response.description)
        return response
    }
}

private class UploadProgressDelegate: NSObject, URLSessionTaskDelegate, @unchecked Sendable {
    private var progress: ProgressDelegate

    init(progress: ProgressDelegate) {
        self.progress = progress
    }

    func urlSession(_: URLSession, task _: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        progress.onProgress(bytesSent, totalBytesSent, totalBytesExpectedToSend)
    }
}

private class DownloadProgressDelegate: NSObject, URLSessionDataDelegate, @unchecked Sendable {
    private var progress: ProgressDelegate
    public var bytesWritten: Int64
    public var totalBytesWritten: Int64
    public var totalBytesExpectedToWrite: Int64

    init(progress: ProgressDelegate) {
        self.progress = progress
        bytesWritten = 0
        totalBytesWritten = 0
        totalBytesExpectedToWrite = -1
    }

    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @Sendable @escaping (URLSession.ResponseDisposition) -> Void) {
        totalBytesExpectedToWrite = response.expectedContentLength
        #if canImport(FoundationNetworking)
            if let sessionDelegate = session.delegate as? URLSessionDataDelegate {
                sessionDelegate.urlSession(session, dataTask: dataTask, didReceive: response, completionHandler: completionHandler)
            } else {
                completionHandler(.allow)
            }
        #endif
    }

    public func urlSession(_: URLSession, dataTask _: URLSessionDataTask, didReceive data: Data) {
        bytesWritten = Int64(data.count)
        totalBytesWritten += bytesWritten
        progress.onProgress(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite)
    }
}
