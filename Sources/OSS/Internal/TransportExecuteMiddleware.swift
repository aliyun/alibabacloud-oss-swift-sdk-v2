import Foundation

class TransportExecuteMiddleware: ExecuteMiddleware {
    private let httpTransport: HttpTransport
    private let logger: LogAgent?

    init(_ httpTransport: HttpTransport,
         _ logger: LogAgent? = nil)
    {
        self.httpTransport = httpTransport
        self.logger = logger
    }

    public func execute(request: RequestMessage, context: ExecuteContext) async throws -> ResponseMessage {
        let options = HttpRequestOptions(
            progressDelegate: context.progressDelegate,
            saveToURL: context.saveToURL
        )
        return try await httpTransport.send(request: request, options: options)
    }
}
