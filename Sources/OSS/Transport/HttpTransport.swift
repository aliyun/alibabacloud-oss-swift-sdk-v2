import Foundation

public protocol HttpTransport {
    func send(request: RequestMessage, options: HttpRequestOptions) async throws -> ResponseMessage
}
