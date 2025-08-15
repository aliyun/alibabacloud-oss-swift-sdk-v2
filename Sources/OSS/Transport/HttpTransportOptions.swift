import Foundation

public struct HttpTransportOptions {
    public var timeoutIntervalForRequest: TimeInterval?
    public var timeoutIntervalForResource: TimeInterval?
    public var enableTLSVerify: Bool?
    public var enableFollowRedirect: Bool?
    public var proxyHost: String?
    public var maxConnectionsPerHost: Int?
}
