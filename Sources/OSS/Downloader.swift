import Foundation

public typealias DownloaderOptionsAction = (DownloaderOptions) -> Void

public class Downloader: @unchecked Sendable {
    /// The oss client.
    let client: Client
    var options: DownloaderOptions
    
    public init(
        _ client: Client,
        _ actions: DownloaderOptionsAction...
    ) {
        self.client = client
        self.options = DownloaderOptions(
            partSize: Defaults.downloadPartSize,
            parallelNum: Defaults.downloadParallel
        )
        
        for action in actions {
            action(options)
        }
    }
    
    public func downloadFile(
        _ request: GetObjectRequest,
        _ file: URL
    ) async throws -> DownloadResult {
        try request.bucket.ensureRequired(field: "request.bucket")
        try request.key.ensureRequired(field: "request.key")
        
        let delegate = DownloadDelegate(
            client: client,
            options: options,
            request: request
        )
        return try await delegate.download(to: file.absoluteURL.path)
    }
    
    public func abortDownload(
        _ request: GetObjectRequest,
        _ file: URL
    ) async throws {
        try request.bucket.ensureRequired(field: "request.bucket")
        try request.key.ensureRequired(field: "request.key")
        
        let delegate = DownloadDelegate(
            client: client,
            options: options,
            request: request
        )
        
        try await delegate.abortDownload(file.absoluteURL.path)
    }
}

actor DownloadDelegate: Sendable {
    
    private let client: Client
    private var options: DownloaderOptions
    private let request: GetObjectRequest
    
    private var totalBytesTransferred: Int64 = 0
    
    private var tempFileDir: String {
        var fileDir: String
        if let catchDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
            fileDir = catchDir
        } else {
            fileDir = NSHomeDirectory()
        }
        fileDir = fileDir + "/OSS"
        return fileDir
    }
    
    init(client: Client, options: DownloaderOptions, request: GetObjectRequest) {
        self.client = client
        self.options = options
        self.request = request
        
        if self.options.parallelNum <= 0 {
            self.options.parallelNum = Defaults.downloadParallel
        }
        if self.options.partSize <= 0 {
            self.options.partSize = Defaults.downloadPartSize
        }
    }
    
    fileprivate func checkCheckpoint(
        sourceInfo: SourceInfo,
        filePath: String,
        baseDir: String?,
        partSize: Int,
        downloadRange: inout DownloadRange
    ) async throws -> DownloadCheckpoint? {
        guard options.enableCheckpoint else {
            return nil
        }
        
        let name = "\(request.bucket!)/\(request.key!)"
        let srcHash = "oss://\(name.escape())\n\(request.versionId ?? "")\n\(request.range ?? "")".data(using: .utf8)!.calculateMd5().hexString()
        let destHash = filePath.data(using: .utf8)!.calculateMd5().hexString()
        
        let cpFileDir: String = baseDir ?? tempFileDir
        if !FileManager.default.fileExists(atPath: cpFileDir) {
            try FileManager.default.createDirectory(atPath: cpFileDir, withIntermediateDirectories: true)
        }
        
        let cpFilePath = cpFileDir + "/\(srcHash)-\(destHash)\(Defaults.checkpointFileSuffixDownloader)"
                
        var checkpoint = DownloadCheckpoint(
            cpDirPath: cpFileDir,
            cpFilePath: cpFilePath,
            verifyData: options.verifyData ?? false,
            loaded: false,
            info: DownloadCheckpoint.Info(
                magic: Defaults.checkpointMagic,
                md5: nil,
                data: DownloadCheckpoint.Info.Data(
                    objectInfo: DownloadCheckpoint.Info.Data.ObjectInfo(name: "oss://\(name)", versionId: request.versionId, range: request.range),
                    objectMeta: DownloadCheckpoint.Info.Data.ObjectMeta(size: sourceInfo.sizeInBytes, lastModified: sourceInfo.modTime, etag: sourceInfo.etag),
                    downloadInfo: DownloadCheckpoint.Info.Data.DownloadInfo(offset: 0, crc: 0),
                    filePath: filePath,
                    partSize: partSize)
            )
        )
        try checkpoint.load()
        if checkpoint.loaded {
            if let offset = checkpoint.info.data.downloadInfo?.offset {
                downloadRange.pos = offset
            }
        } else {
            checkpoint.info.data.downloadInfo?.offset = downloadRange.pos
        }
        
        return checkpoint
    }
    
    fileprivate func checkSource() async throws -> SourceInfo {
        let result = try await client.getObjectMeta(
            GetObjectMetaRequest(
                bucket: request.bucket,
                key: request.key
            )
        )
        
        guard let size = result.contentLength,
              let lastModified = result.lastModified,
              let etag = result.etag else {
            throw ClientError.responseError(detail: "Cann't obtain header: \(result.headers ?? [:])")
        }
        
        return SourceInfo(modTime: lastModified,
                          etag: etag,
                          sizeInBytes: UInt64(size),
                          headers: result.headers)
    }
    
    fileprivate func checkDestination(filePath: String) throws -> FileOperator {
        if filePath == "" {
            throw ClientError.paramNullOrEmptyError(field: "filePath")
        }
        let tempFilePath = options.useTempFile ? filePath + Defaults.tempFileSuffix : filePath
                
        if !FileManager.default.fileExists(atPath: tempFilePath) {
            if (!FileManager.default.createFile(atPath: tempFilePath, contents: nil)) {
                throw ClientError.fileOperationError(filePath: tempFilePath, operation: "Create file failed.")
            }
        } else if !options.enableCheckpoint {
            throw ClientError.fileOperationError(filePath: tempFilePath, operation: "File is Existing.")
        }
        
        return try FileOperator(file: URL(fileURLWithPath: tempFilePath))
    }
    
    private func adjustRange(sizeInBytes: UInt64) throws -> DownloadRange {
        var pos: UInt64 = 0
        var rstart: UInt64 = 0
        var epos: UInt64 = sizeInBytes
        
        if let range = request.range,
           let httpRange = Range(rangeString: range) {
            guard let start = httpRange.start,
                  start <= sizeInBytes else {
                throw ClientError.paramInvalidError(field: "Invalid range, object size :\(sizeInBytes), range: \(range)")
            }
            pos = start
            rstart = pos
            if let end = httpRange.end,
               end - start > 0 {
                epos = min(end, sizeInBytes)
            }
        }
        
        return DownloadRange(pos: pos, epos: epos, rstart: rstart)
    }
    
    private func adjustWriter(fileOperator: FileOperator,
                              downloadRange: DownloadRange) async throws {
        let pos: UInt64 = downloadRange.pos
        let epos: UInt64 = downloadRange.epos
        let rstart: UInt64 = downloadRange.rstart
        
        let expectSize = epos - rstart
        if let size = try await fileOperator.size(),
           size > expectSize {
            try await fileOperator.truncate(offset: pos - rstart)
        }
    }
    
    fileprivate func download(to filePath: String) async throws -> DownloadResult {
        let checkCrc = client.clientImpl.options.featureFlags.contains(.enableCRC64CheckDownload) && request.range == nil
        let sourceInfo = try await checkSource()
                
        let fileOperator = try checkDestination(filePath: filePath)
        do {
            var downloadRange = try adjustRange(sizeInBytes: sourceInfo.sizeInBytes)
            let checkpoint = try await checkCheckpoint(
                sourceInfo: sourceInfo,
                filePath: filePath,
                baseDir: options.checkpointDir,
                partSize: options.partSize,
                downloadRange: &downloadRange
            )
            try await adjustWriter(fileOperator: fileOperator,
                                   downloadRange: downloadRange)
            
            let epos: UInt64 = downloadRange.epos
            let pos: UInt64 = downloadRange.pos
            let size = min(epos - pos, UInt64(options.partSize))
            let downloadInfo = DownloadInfo(
                offset: checkpoint?.info.data.downloadInfo?.offset ?? 0,
                crcValue: checkpoint?.info.data.downloadInfo?.crc ?? 0
            )
            let written = downloadRange.pos - downloadRange.rstart
            processProgress(transferred: Int64(written), totalSize: Int64(sourceInfo.sizeInBytes))

            try await withThrowingTaskGroup(of: Void.self) { group in
                var downloadCount = 0
                for offset in stride(from: pos, to: epos, by: UInt64.Stride(size)) {
                    
                    downloadCount += 1
                    if downloadCount > options.parallelNum { try await group.next() }
                    
                    let chunk = DownloadedChunk(start: offset,
                                                size: min(size, epos - offset),
                                                rstart: downloadRange.rstart,
                                                crc64: nil)
                    let _ = group.addTaskUnlessCancelled {
                        let dchunk = try await self.downloadChunk(
                            fileOperator: fileOperator,
                            chunk: chunk,
                            sourceInfo: sourceInfo
                        )
                        await downloadInfo.processChunk(chunk: dchunk)
                        await self.processProgress(transferred: Int64(dchunk.size), totalSize: Int64(sourceInfo.sizeInBytes))
                        
                        if var checkpoint = checkpoint {
                            checkpoint.info.data.downloadInfo?.offset = await downloadInfo.offset
                            checkpoint.info.data.downloadInfo?.crc = await downloadInfo.crcValue
                            try checkpoint.dump()
                        }
                    }
                }
            }
            if checkCrc,
               let serverCrcValue = sourceInfo.headers?["x-oss-hash-crc64ecma"]?.toUInt64(),
               await downloadInfo.crcValue != serverCrcValue {
                throw ClientError.inconsistentError(clientCrc: await downloadInfo.crcValue, serverCrc: serverCrcValue)
            }
            if options.useTempFile {
                try await fileOperator.move(to: URL(fileURLWithPath: filePath))
            }
            try checkpoint?.remove()
            
            return DownloadResult(written: await downloadInfo.offset)
        } catch {
            if !(options.enableCheckpoint) {
                try await fileOperator.remove()
            }
            throw error
        }
    }
    
    private func downloadChunk(
        fileOperator: FileOperator,
        chunk: DownloadedChunk,
        sourceInfo: SourceInfo
    ) async throws -> DownloadedChunk {
        let request = GetObjectRequest(
            bucket: request.bucket,
            key: request.key,
            range: Range(start: chunk.start, end: chunk.start + chunk.size - 1).asString(),
            rangeBehavior: "standard"
        )
        let result = try await client.getObject(request)
        if result.etag != sourceInfo.etag {
            throw ClientError(code: "DwonloadError", message: "Source file is changed")
        }
        guard let data = try result.body?.readData() else {
            throw ClientError.responseError(detail: "Cann't obtain body data.")
        }
        
        try await fileOperator.write(data: data, offset: chunk.start - chunk.rstart)
        let crc = result.body?.hashCrc64ecma(crc: 0)
        
        return DownloadedChunk(
            start: chunk.start,
            size: UInt64(data.count),
            rstart: chunk.rstart,
            crc64: crc
        )
    }
    
    private func processProgress(transferred: Int64, totalSize: Int64) {
        var progress = request.progress

        self.totalBytesTransferred += transferred
        progress?.onProgress(transferred, self.totalBytesTransferred, totalSize)
    }
    
    fileprivate func abortDownload(_ filePath: String) async throws {
        let sourceInfo = try await checkSource()
        let fileOperator = try checkDestination(filePath: filePath)
        var downloadRange = try adjustRange(sizeInBytes: sourceInfo.sizeInBytes)
        let checkpoint = try await checkCheckpoint(
            sourceInfo: sourceInfo,
            filePath: filePath,
            baseDir: options.checkpointDir,
            partSize: options.partSize,
            downloadRange: &downloadRange
        )
        
        try checkpoint?.remove()
        try await fileOperator.remove()
    }
}

struct DownloadCheckpoint {
    let cpDirPath: String
    let cpFilePath: String
    let verifyData: Bool
    var loaded: Bool
    var info: Info
    
    struct Info: Codable {
        let magic: String
        var md5: String?
        var data: Data
        
        struct Data: Codable {
            struct ObjectInfo: Codable, Equatable {
                let name: String
                let versionId: String?
                let range: String?
                
                static func == (lhs: Self, rhs: Self) -> Bool {
                    lhs.name == rhs.name &&
                    lhs.versionId == rhs.versionId &&
                    lhs.range == rhs.range
                }
            }
            struct ObjectMeta: Codable, Equatable {
                let size: UInt64
                let lastModified: String
                let etag: String
                
                static func == (lhs: Self, rhs: Self) -> Bool {
                    lhs.size == rhs.size &&
                    lhs.lastModified == rhs.lastModified &&
                    lhs.etag == rhs.etag
                }
            }
            
            struct DownloadInfo: Codable, Equatable {
                var offset: UInt64
                var crc: UInt64
                
                static func == (lhs: Self, rhs: Self) -> Bool {
                    lhs.offset == rhs.offset &&
                    lhs.crc == rhs.crc
                }
            }
            
            let objectInfo: ObjectInfo
            let objectMeta: ObjectMeta?
            var downloadInfo: DownloadInfo?
            
            let filePath: String
            let partSize: Int
        }
    }
    
    mutating func load() throws {
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: cpDirPath, isDirectory: &isDirectory),
              isDirectory.boolValue else {
            return
        }
        
        isDirectory = false
        guard FileManager.default.fileExists(atPath: cpFilePath, isDirectory: &isDirectory),
              !isDirectory.boolValue else {
            return
        }
        
        if try !valid() {
            try remove()
        }
        
        loaded = true
    }
    
    mutating func valid() throws -> Bool {
        let content = try Data(contentsOf: URL(fileURLWithPath: cpFilePath))
        
        let info = try JSONDecoder().decode(DownloadCheckpoint.Info.self, from: content)
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let data = try encoder.encode(info.data)
        let md5 = data.calculateMd5().hexString()
        guard info.magic == Defaults.checkpointMagic,
              md5 == info.md5 else {
            return false
        }
        
        guard info.data.objectInfo == self.info.data.objectInfo,
              info.data.objectMeta == self.info.data.objectMeta,
              info.data.filePath == self.info.data.filePath,
              info.data.partSize == self.info.data.partSize else {
            return false
        }
        
        guard let downloadInfo = info.data.downloadInfo else {
            return false
        }
        
        if downloadInfo.offset == 0 &&
            downloadInfo.crc != 0 {
            return false
        }
        
        var rOffset: UInt64 = 0
        if let range = self.info.data.objectInfo.range {
            if let r = Range(rangeString: range) {
                rOffset = r.start ?? 0
            } else {
                return false
            }
        }
        if downloadInfo.offset < rOffset {
            return false
        }
        
        let remains = (downloadInfo.offset - rOffset) % UInt64(info.data.partSize)
        if remains != 0 {
            return false
        }

        //valid data
        if self.verifyData && info.data.downloadInfo?.crc != 0 {
            let bufferSize = 4 * 1024;
            let fileHandle = FileHandle(forReadingAtPath: self.info.data.filePath)
            defer {
                fileHandle?.closeFile()
            }
            var offset: Int64 = 0
            let end = downloadInfo.offset - rOffset
            var crc: UInt64 = 0
            repeat {
                guard let data = fileHandle?.readData(ofLength: bufferSize) else {
                    break
                }
                crc = data.withUnsafeBytes {
                    CRC64.default.crc64(crc: crc, buf: $0.baseAddress!, len: $0.count)
                }
                offset += Int64(data.count)
            } while offset >= end
            
            if crc != downloadInfo.crc {
                return false
            }
        }

        // update
        self.info.data.downloadInfo = downloadInfo

        return true
    }
    
    func dump() throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let data = try encoder.encode(info.data)
        let md5 = data.calculateMd5().hexString()
        var info = self.info
        info.md5 = md5
        
        let content = try JSONEncoder().encode(info)
        try content.write(to: URL(fileURLWithPath: cpFilePath), options: .atomic)
    }
    
    func remove() throws {
        try FileManager.default.removeItem(atPath: cpFilePath)
    }
}
