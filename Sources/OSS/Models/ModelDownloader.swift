import Foundation

public struct DownloadResult: Sendable {
    let written: UInt64
}

public class DownloaderOptions: @unchecked Sendable {
    public var partSize: Int
    public var parallelNum: Int
    public var enableCheckpoint: Bool
    public var checkpointDir: String?
    public var verifyData: Bool?
    public var useTempFile: Bool
    
    public init(
        partSize: Int,
        parallelNum: Int,
        enableCheckpoint: Bool = false,
        checkpointDir: String? = nil,
        verifyData: Bool? = nil,
        useTempFile: Bool = true,
    ) {
        self.partSize = partSize
        self.parallelNum = parallelNum
        self.enableCheckpoint = enableCheckpoint
        self.checkpointDir = checkpointDir
        self.verifyData = verifyData
        self.useTempFile = useTempFile
    }
}

struct SourceInfo {
    let modTime: String
    let etag: String
    let sizeInBytes: UInt64
    let headers: [String: String]?
}

struct DownloadRange {
    var pos: UInt64
    var epos: UInt64
    var rstart: UInt64
}

struct DownloadedChunk: Sendable {
    let start: UInt64
    let size: UInt64
    let rstart: UInt64
    let crc64: UInt64?
}

actor FileOperator {
    private var file: URL
    private let fileHandle: FileHandle
    private let attribute: [FileAttributeKey: Any]
    
    init(file: URL) throws {
        self.file = file
        self.fileHandle = try FileHandle(forWritingTo: file)
        self.attribute = try FileManager.default.attributesOfItem(atPath: file.absoluteURL.path)
    }
    
    deinit {
        fileHandle.closeFile()
    }
    
    func write(data: Data, offset: UInt64) throws {
        try fileHandle.seek(toOffset: offset)
        
        if #available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *) {
            try fileHandle.write(contentsOf: data)
        } else {
            fileHandle.write(data)
        }
    }
    
    func remove() throws {
        try FileManager.default.removeItem(at: file)
    }
    
    func move(to newURL: URL) throws {
        try FileManager.default.moveItem(at: file, to: newURL)
    }
    
    func size() throws -> UInt64? {
        return attribute[FileAttributeKey.size] as? UInt64
    }
    
    func truncate(offset: UInt64) throws {
        try fileHandle.truncate(atOffset: offset)
    }
}

actor DownloadInfo {
    var chunks: [DownloadedChunk]
    var offset: UInt64
    var crcValue: UInt64
    
    init(
        chunks: [DownloadedChunk] = [],
        offset: UInt64 = 0,
        crcValue: UInt64 = 0
    ) {
        self.chunks = chunks
        self.offset = offset
        self.crcValue = crcValue
    }
    
    func processChunk(chunk: DownloadedChunk) {
        chunks.append(chunk)
        chunks.sort { $0.start < $1.start }
        repeat {
            guard let first = chunks.first else {
                break
            }
            if first.start == offset {
                if let crc64 = first.crc64 {
                    crcValue = CRC64.default.crc64Combine(crc1: crcValue, crc2: crc64, len2: UInt(first.size))
                }
                offset += first.size
                chunks.removeFirst()
            } else {
                break
            }
        } while true
    }
}
