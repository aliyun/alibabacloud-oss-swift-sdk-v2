import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

final class OSSURLSessionDelegate: NSObject {
    private let enableTLSVerify: Bool
    private let enableFollowRedirect: Bool

    init(enableTLSVerify: Bool, enableFollowRedirect: Bool) {
        self.enableTLSVerify = enableTLSVerify
        self.enableFollowRedirect = enableFollowRedirect
    }
}

extension OSSURLSessionDelegate: URLSessionTaskDelegate {
    func urlSession(_: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        var disposition = URLSession.AuthChallengeDisposition.performDefaultHandling
        var credential: URLCredential?

        let host = challenge.protectionSpace.host

        switch challenge.protectionSpace.authenticationMethod {
        #if canImport(Security)
            case NSURLAuthenticationMethodServerTrust:
                if let serverTrust = challenge.protectionSpace.serverTrust {
                    if !enableTLSVerify ||
                        evaluate(serverTrust: serverTrust, domain: host)
                    {
                        disposition = URLSession.AuthChallengeDisposition.useCredential
                        credential = URLCredential(trust: serverTrust)
                    }
                }
        #endif
        default:
            disposition = URLSession.AuthChallengeDisposition.performDefaultHandling
        }
        completionHandler(disposition, credential)
    }

    func urlSession(_: URLSession, task _: URLSessionTask, willPerformHTTPRedirection _: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        if enableFollowRedirect {
            completionHandler(request)
        } else {
            completionHandler(nil)
        }
    }

    #if canImport(Security)
        private func evaluate(serverTrust: SecTrust, domain: String?) -> Bool {
            var policies = [Any]()
            if let domain = domain {
                policies.append(SecPolicyCreateSSL(true, domain as CFString))
            } else {
                policies.append(SecPolicyCreateBasicX509())
            }

            SecTrustSetPolicies(serverTrust, policies as CFTypeRef)

            return SecTrustEvaluateWithError(serverTrust, nil)
        }
    #endif
}
