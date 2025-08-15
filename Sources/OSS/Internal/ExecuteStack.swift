import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

typealias CreateMiddleware = (ExecuteMiddleware) throws -> ExecuteMiddleware

class ExecuteStack {
    private let _handler: ExecuteMiddleware
    private let _lock = NSLock()
    private var _stack: [(CreateMiddleware, String)]
    private var _cached: ExecuteMiddleware?

    init(httpTransport: HttpTransport, logger: LogAgent? = nil) {
        _handler = TransportExecuteMiddleware(httpTransport, logger)
        _stack = []
        _cached = nil
    }

    init(handler: ExecuteMiddleware) {
        _handler = handler
        _stack = []
        _cached = nil
    }

    public func push(create: @escaping CreateMiddleware, name: String) {
        _stack.append((create, name))
        _cached = nil
    }

    public func resolve() throws -> ExecuteMiddleware {
        if let cached = _cached {
            return cached
        }
        _lock.lock()
        defer {
            self._lock.unlock()
        }
        if let cached = _cached {
            return cached
        }

        var prev = _handler
        for (create, _) in _stack.reversed() {
            prev = try create(prev)
        }
        _cached = prev
        return prev
    }

    public func execute(_ request: RequestMessage, _ context: ExecuteContext) async throws -> ResponseMessage {
        let handler = try resolve()
        return try await handler.execute(request: request, context: context)
    }
}
