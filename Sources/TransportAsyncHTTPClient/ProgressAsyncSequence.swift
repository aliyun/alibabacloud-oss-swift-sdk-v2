import Foundation
import NIOCore
import AlibabaCloudOSS

struct ProgressAsyncSequence<T: AsyncSequence & Sendable>: Sendable, AsyncSequence where T.Element == ByteBuffer {
    typealias Element = T.Element
    let asyncSequence: T
    var progressDelegate: ProgressDelegate
    let totalBytesExpected: Int64
    
    init(
        asyncSequence: T,
        progressDelegate: ProgressDelegate,
        totalBytesExpected: Int64
    ) {
        self.asyncSequence = asyncSequence
        self.progressDelegate = progressDelegate
        self.totalBytesExpected = totalBytesExpected
    }
    
    struct AsyncIterator: AsyncIteratorProtocol {
        
        var iterator: T.AsyncIterator
        var progress: Progress
        
        init(
            iterator: T.AsyncIterator,
            progress: Progress
        ) where T.AsyncIterator.Element == ByteBuffer {
            self.iterator = iterator
            self.progress = progress
        }
        
        @inlinable mutating func next() async throws -> Element? {
            guard let element = try await iterator.next() else {
                return nil
            }
            progress.send(Int64(element.readableBytes))
            return element
        }
    }
    
    func makeAsyncIterator() -> AsyncIterator {
        let progress = Progress(progressDelegate, totalBytesExpected: totalBytesExpected)
        return AsyncIterator(
            iterator: asyncSequence.makeAsyncIterator(),
            progress: progress
        )
    }
    
    struct Progress {
        
        private var delegate: ProgressDelegate
        private let totalBytesExpected: Int64
        private var totalBytesTransferred: Int64

        init(
            _ delegate: ProgressDelegate,
            totalBytesExpected: Int64
        ) {
            self.delegate = delegate
            self.totalBytesExpected = totalBytesExpected
            self.totalBytesTransferred = 0
        }

        mutating func send(_ bytes: Int64) {
            totalBytesTransferred += bytes
            delegate.onProgress(bytes, totalBytesTransferred, totalBytesExpected)
        }
    }

}
