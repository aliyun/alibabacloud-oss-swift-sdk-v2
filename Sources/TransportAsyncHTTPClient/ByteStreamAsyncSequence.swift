import Foundation
import NIOCore
import AlibabaCloudOSS

struct ByteStreamAsyncSequence: @unchecked Sendable, AsyncSequence {
    public typealias Element = ByteBuffer
    typealias AsyncIteratorNextCallback = () async throws -> Element?
    
    var makeAsyncIteratorCallback: () -> AsyncIteratorNextCallback
    
    init?(
        byteStream: ByteStream
    ) throws {
        switch byteStream {
        case .none:
            return nil
        case .data(let data):
            makeAsyncIteratorCallback = {
                var iterator = DataAsyncIterator(data: data)
                return {
                    try await iterator.next()
                }
            }
        case .file(let url):
            makeAsyncIteratorCallback = {
                let iterator = FileAsyncIterator(fileURL: url)
                return {
                    try await iterator.next()
                }
            }
        case .stream(let inputStream):
            makeAsyncIteratorCallback = {
                let iterator = StreamAsyncIterator(stream: inputStream)
                return {
                    try await iterator.next()
                }
            }
        }
    }
    
    public func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(nextCallback: makeAsyncIteratorCallback())
    }
    
    struct AsyncIterator: AsyncIteratorProtocol {
        @usableFromInline let nextCallback: AsyncIteratorNextCallback
        
        @inlinable init(nextCallback: @escaping AsyncIteratorNextCallback) {
            self.nextCallback = nextCallback
        }
        
        @inlinable mutating func next() async throws -> Element? {
            try await self.nextCallback()
        }
    }
    
    struct DataAsyncIterator: AsyncIteratorProtocol {
        
        let data: Data
        var offset: UInt64
        
        init(data: Data) {
            self.data = data
            offset = 0
        }
        
        mutating func next() async throws -> Element? {
            guard offset < data.count else {
                return nil
            }
            let bufferSize = offset + 4096 < data.count ? 4096 : UInt64(data.count) - offset
            let data = self.data.subdata(in: Int(offset)..<Int(offset) + Int(bufferSize))
            offset += UInt64(data.count)
            
            return ByteBuffer(data: data)
        }
    }
    
    class StreamAsyncIterator: AsyncIteratorProtocol {
        
        let stream: InputStream
        
        init(stream: InputStream) {
            self.stream = stream
            stream.open()
        }
        
        deinit {
            stream.close()
        }
        
        func next() async throws -> Element? {
            let bufferSize = 4096
            var data = Data()
            repeat {
                let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
                let readLength = stream.read(buffer, maxLength: bufferSize)
                if readLength == -1,
                   let error = stream.streamError {
                    throw error
                }
                if readLength == 0 {
                    break
                }
                let readData = Data(buffer: UnsafeBufferPointer(start: buffer, count: readLength))
                data.append(readData)
            } while true
            
            return ByteBuffer(data: data)
        }
    }
    
    class FileAsyncIterator: AsyncIteratorProtocol {
        
        let fileHandle: FileHandle?
        let error: Error?
        
        init(fileURL: URL) {
            do {
                fileHandle = try FileHandle(forReadingFrom: fileURL)
                error = nil
            } catch {
                fileHandle = nil
                self.error = error
            }
        }
        
        deinit {
            fileHandle?.closeFile()
        }
        
        func next() async throws -> Element? {
            if let error = error {
                throw error
            }
            
            let bufferSize = 4096
            guard let data = if #available(iOS 13.4, *) {
                try fileHandle?.read(upToCount: bufferSize)
            } else {
                fileHandle?.readData(ofLength: bufferSize)
            } else {
                return nil
            }
            
            return ByteBuffer(data: data)
        }
    }
}

