import Foundation
import AlibabaCloudOSS
import AsyncHTTPClient
import NIOHTTP1
import NIOCore
import NIOSSL

public class AsyncHTTPClientTransport: HttpTransport {
    
    private let _httpClient: HTTPClient
    private let logger: LogAgent?

    public init(
        _ httpClient: HTTPClient,
        _ logger: LogAgent? = nil
    ) {
        _httpClient = httpClient
        self.logger = logger
    }
    
    deinit {
        do {
            try _httpClient.syncShutdown()
        } catch {
            logger?.error(error.localizedDescription)
        }
    }
    
    public func send(request: RequestMessage, options: HttpRequestOptions) async throws -> ResponseMessage {
        logger?.debug(request.description)
        var httpRequest = HTTPClientRequest(url: request.requestUri.absoluteString)
        httpRequest.method = HTTPMethod(rawValue: request.method)
        httpRequest.headers = HTTPHeaders(request.headers.map { ($0.key, $0.value) })
        
        if let body = request.content,
           let byteStream = try ByteStreamAsyncSequence(byteStream: body) {
            
            let totalBytesExpected: Int64
            let length: HTTPClientRequest.Body.Length
            if let bodyLength = try body.getBodyLength() {
                totalBytesExpected = Int64(bodyLength)
                length = .known(Int64(bodyLength))
            } else {
                totalBytesExpected = -1
                length = .unknown
            }
            
            if let progressDelegate = options.progressDelegate,
               progressDelegate.upload {
                let progressByteStream = ProgressAsyncSequence(
                    asyncSequence: byteStream,
                    progressDelegate: progressDelegate.delegate,
                    totalBytesExpected: totalBytesExpected
                )
                httpRequest.body = .stream(progressByteStream, length: length)
            } else {
                httpRequest.body = .stream(byteStream, length: length)
            }
            
        }

        let response = try await _httpClient.execute(httpRequest, timeout: .seconds(30))
        
        // convert to HttpResponse
        var headers: [String:String] = [:]
        response.headers.forEach { (key, value) in
            headers[key] = value
        }
        
        let destination: Destination
        if options.saveToURL ?? false,
           200..<300 ~= response.status.code {
            // Refer to URLSession and create a temporary file
            let fileName = NSTemporaryDirectory() + NSUUID().uuidString + ".tmp"
            _ = FileManager.default.createFile(atPath: fileName, contents: nil)
            let fileURL =  URL(fileURLWithPath: fileName)
            
            destination = try .file(fileURL)
        } else {
            destination = .data(Data())
        }
        
        if let progressDelegate = options.progressDelegate,
           !progressDelegate.upload {
            let totalBytesExpected = headers[caseInsensitive: "Content-Length"]?.toInt64() ?? -1
            
            try await ProgressAsyncSequence(
                asyncSequence: response.body,
                progressDelegate: progressDelegate.delegate,
                totalBytesExpected: totalBytesExpected
            ).read(to: destination) { destination, readedData in
                try destination.write(readedData)
            }
        } else {
            try await response.body.read(to: destination) { destination, readedData in
                try destination.write(readedData)
            }
        }
        
        let body = destination.toByteStream()
        return ResponseMessage(
            statusCode: Int(response.status.code),
            headers: headers,
            content: body
        )
    }
}

fileprivate class Destination {
    
    fileprivate class Content {
        internal private(set) var data: Data
        init(_ data: Data) {
            self.data = data
        }
        
        func append(_ data: Data) {
            self.data.append(data)
        }
    }
    
    enum DestinationType {
        case file(URL, FileHandle)
        case data(Content)
    }
    
    fileprivate let destinationType: DestinationType
    
    init(destinationType: DestinationType) {
        self.destinationType = destinationType
    }
    
    deinit {
        switch destinationType {
        case .file(_, let fileHandle):
            fileHandle.closeFile()
        default:
            break
        }
    }
    
    static func file(_ url: URL) throws -> Destination {
        let fileHandle = try FileHandle(forWritingTo: url)
        let type = DestinationType.file(url, fileHandle)
        return Destination(destinationType: type)
    }
    
    static func data(_ data: Data) -> Destination {
        let type = DestinationType.data(Content(data))
        return Destination(destinationType: type)
    }
    
    func write(_ data: Data) throws {
        switch destinationType {
        case .file(_, let fileHandle):
            if #available(iOS 13.4, *) {
                try fileHandle.write(contentsOf: data)
            } else {
                fileHandle.write(data)
            }
        case .data(let content):
            content.append(data)
        }
    }
}

extension Destination {
    func toByteStream() -> ByteStream {
        switch destinationType {
        case .file(let url, _):
            return .file(url)
        case .data(let content):
            return .data(content.data)
        }
    }
}

extension AsyncSequence where Element == ByteBuffer {
        
    fileprivate func read(to destination: Destination, callback: @escaping @Sendable (Destination, Data) async throws -> Void) async throws {
        var iterator = self.makeAsyncIterator()
        while var bytes = try await iterator.next() {
            let bufferSize = 8 * 1024 < bytes.readableBytes ? 8 * 1024 : bytes.readableBytes
            print("readableBytes: \(bytes.readableBytes)")
            while let data = bytes.readData(length: bufferSize) {
                try await callback(destination, data)
            }
        }
    }
}

extension String {
    func toInt64() -> Int64? {
        Int64(self)
    }
}

extension Dictionary where Key == String {
    subscript(caseInsensitive key: Key) -> Value? {
        if let value = self[key] {
            return value
        }
        let kk = key.lowercased()
        for (k, v) in self {
            if k.lowercased() == kk {
                return v
            }
        }
        return nil
    }
}
