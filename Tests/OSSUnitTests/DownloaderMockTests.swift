import XCTest
@testable import AlibabaCloudOSS

class DownloaderMockTests: XCTestCase {
    
    func testMockDownloaderSingleRead() async throws {
        let file = Utils.createTestFile("test-file", 5 * 1024 * 1024 + 123)
        let path = "\(Utils.tempDir)\(Utils.pathSeparator)downloader"
        let data = try Data(contentsOf: URL(fileURLWithPath: file!))
        let crc = data.withUnsafeBytes {
            CRC64.default.crc64(crc: 0, buf: $0.baseAddress!, len: $0.count)
        }

        let credentialsProvider = StaticCredentialsProvider(accessKeyId: "ak", accessKeySecret: "sk")
        let config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withCredentialsProvider(credentialsProvider)
            .withDownloadCRC64Validation(false)
        
        let fileOperator = try FileOperator(file: URL(fileURLWithPath: file!))
        let mock = MockProcessRequest { requestMessage, context in
            if requestMessage.requestUri.absoluteString.contains("objectMeta") {
                XCTAssertEqual(requestMessage.method, "HEAD")
                return ResponseMessage(
                    statusCode: 200,
                    headers: ["Content-Length":"\(5 * 1024 * 1024 + 123)",
                              "Last-Modified":"Fri, 24 Feb 2012 06:07:48 GMT",
                              "ETag":"5B3C1A2E053D763E1B002CC607C5****",
                              "x-oss-hash-crc64ecma": String(crc)],
                )
            } else {
                XCTAssertEqual(requestMessage.method, "GET")
                let range = Range(rangeString: requestMessage.headers[caseInsensitive: "range"]!)
                
                let data = try await fileOperator.read(offset: UInt64(range!.start!), length: Int(range!.end! - range!.start!))
                return ResponseMessage(
                    statusCode: 200,
                    headers: [
                        "x-oss-hash-crc64ecma": String(crc),
                        "ETag":"5B3C1A2E053D763E1B002CC607C5****"
                    ],
                    content: .data(data!)
                )
            }
        }
        let client = Client(config) { $0.executeMW = mock }
        let downloader = Downloader(client) {
            $0.partSize = 256 * 1024
            $0.parallelNum = 1
        }
        
        if FileManager.default.fileExists(atPath: path) {
            try FileManager.default.removeItem(atPath: path)
        }
        
        await assertNoThrow(try await downloader.downloadFile(
            GetObjectRequest(
                bucket: "bucket",
                key: "key"
            ),
            URL(fileURLWithPath: path)
        ))
        
        XCTAssertEqual(try Utils.calculateMd5(fileURL: URL(fileURLWithPath: file!)),
                       try Utils.calculateMd5(fileURL: URL(fileURLWithPath: path)))
        
        Utils.removeTestFile(file!)
        Utils.removeTestFile(path)
    }
    
    func testMockDownloaderSingleReadWithRange() async throws {
        let file = Utils.createTestFile("test-file", 1 * 1024 * 1024 + 123)
        let path = "\(Utils.tempDir)\(Utils.pathSeparator)downloader"
        let data = try Data(contentsOf: URL(fileURLWithPath: file!))
        let crc = data.withUnsafeBytes {
            CRC64.default.crc64(crc: 0, buf: $0.baseAddress!, len: $0.count)
        }

        let credentialsProvider = StaticCredentialsProvider(accessKeyId: "ak", accessKeySecret: "sk")
        let config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withCredentialsProvider(credentialsProvider)
            .withDownloadCRC64Validation(false)
        
        let fileOperator = try FileOperator(file: URL(fileURLWithPath: file!))
        let mock = MockProcessRequest { requestMessage, context in
            if requestMessage.requestUri.absoluteString.contains("objectMeta") {
                XCTAssertEqual(requestMessage.method, "HEAD")
                return ResponseMessage(
                    statusCode: 200,
                    headers: ["Content-Length":"\(1 * 1024 * 1024 + 123)",
                              "Last-Modified":"Fri, 24 Feb 2012 06:07:48 GMT",
                              "ETag":"5B3C1A2E053D763E1B002CC607C5****",
                              "x-oss-hash-crc64ecma": String(crc)],
                )
            } else {
                XCTAssertEqual(requestMessage.method, "GET")
                let range = Range(rangeString: requestMessage.headers[caseInsensitive: "range"]!)
                
                let data = try await fileOperator.read(offset: UInt64(range!.start!), length: Int(range!.end! - range!.start!))
                return ResponseMessage(
                    statusCode: 200,
                    headers: [
                        "x-oss-hash-crc64ecma": String(crc),
                        "ETag":"5B3C1A2E053D763E1B002CC607C5****"
                    ],
                    content: .data(data!)
                )
            }
        }
        let client = Client(config) { $0.executeMW = mock }
        let downloader = Downloader(client) {
            $0.partSize = 256 * 1024
            $0.parallelNum = 1
        }
        
        if FileManager.default.fileExists(atPath: path) {
            try FileManager.default.removeItem(atPath: path)
        }
        
        await assertNoThrow(try await downloader.downloadFile(
            GetObjectRequest(
                bucket: "bucket",
                key: "key",
                range: Range(start: 5, end: 1 * 1024 * 1024 + 23).asString()
            ),
            URL(fileURLWithPath: path)
        ))
        
        XCTAssertEqual(try Data(contentsOf: URL(fileURLWithPath: file!)).subdata(in: 5..<1 * 1024 * 1024 + 23).calculateMd5(),
                       try Utils.calculateMd5(fileURL: URL(fileURLWithPath: path)))
        
        Utils.removeTestFile(file!)
        Utils.removeTestFile(path)
    }
    
    func testMockDownloaderParalleRead() async throws {
        let file = Utils.createTestFile("test-file", 5 * 1024 * 1024 + 123)
        let path = "\(Utils.tempDir)\(Utils.pathSeparator)downloader"
        let data = try Data(contentsOf: URL(fileURLWithPath: file!))
        let crc = data.withUnsafeBytes {
            CRC64.default.crc64(crc: 0, buf: $0.baseAddress!, len: $0.count)
        }

        let credentialsProvider = StaticCredentialsProvider(accessKeyId: "ak", accessKeySecret: "sk")
        let config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withCredentialsProvider(credentialsProvider)
            .withDownloadCRC64Validation(false)
        
        let fileOperator = try FileOperator(file: URL(fileURLWithPath: file!))
        let mock = MockProcessRequest { requestMessage, context in
            if requestMessage.requestUri.absoluteString.contains("objectMeta") {
                XCTAssertEqual(requestMessage.method, "HEAD")
                return ResponseMessage(
                    statusCode: 200,
                    headers: ["Content-Length":"\(5 * 1024 * 1024 + 123)",
                              "Last-Modified":"Fri, 24 Feb 2012 06:07:48 GMT",
                              "ETag":"5B3C1A2E053D763E1B002CC607C5****",
                              "x-oss-hash-crc64ecma": String(crc)],
                )
            } else {
                XCTAssertEqual(requestMessage.method, "GET")
                let range = Range(rangeString: requestMessage.headers[caseInsensitive: "range"]!)
                
                let data = try await fileOperator.read(offset: UInt64(range!.start!), length: Int(range!.end! - range!.start!))
                return ResponseMessage(
                    statusCode: 200,
                    headers: [
                        "x-oss-hash-crc64ecma": String(crc),
                        "ETag":"5B3C1A2E053D763E1B002CC607C5****"
                    ],
                    content: .data(data!)
                )
            }
        }
        let client = Client(config) { $0.executeMW = mock }
        let downloader = Downloader(client) {
            $0.partSize = 256 * 1024
            $0.parallelNum = 3
        }
        
        if FileManager.default.fileExists(atPath: path) {
            try FileManager.default.removeItem(atPath: path)
        }
        
        await assertNoThrow(try await downloader.downloadFile(
            GetObjectRequest(
                bucket: "bucket",
                key: "key"
            ),
            URL(fileURLWithPath: path)
        ))
        
        XCTAssertEqual(try Utils.calculateMd5(fileURL: URL(fileURLWithPath: file!)),
                       try Utils.calculateMd5(fileURL: URL(fileURLWithPath: path)))
        
        Utils.removeTestFile(file!)
        Utils.removeTestFile(path)
    }
    
    func testMockDownloaderParalleReadWithRange() async throws {
        let file = Utils.createTestFile("test-file", 3 * 1024 * 1024 + 123)
        let path = "\(Utils.tempDir)\(Utils.pathSeparator)downloader"
        let data = try Data(contentsOf: URL(fileURLWithPath: file!))
        let crc = data.withUnsafeBytes {
            CRC64.default.crc64(crc: 0, buf: $0.baseAddress!, len: $0.count)
        }

        let credentialsProvider = StaticCredentialsProvider(accessKeyId: "ak", accessKeySecret: "sk")
        let config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withCredentialsProvider(credentialsProvider)
            .withDownloadCRC64Validation(false)
        
        let fileOperator = try FileOperator(file: URL(fileURLWithPath: file!))
        let mock = MockProcessRequest { requestMessage, context in
            if requestMessage.requestUri.absoluteString.contains("objectMeta") {
                XCTAssertEqual(requestMessage.method, "HEAD")
                return ResponseMessage(
                    statusCode: 200,
                    headers: ["Content-Length":"\(3 * 1024 * 1024 + 123)",
                              "Last-Modified":"Fri, 24 Feb 2012 06:07:48 GMT",
                              "ETag":"5B3C1A2E053D763E1B002CC607C5****",
                              "x-oss-hash-crc64ecma": String(crc)],
                )
            } else {
                XCTAssertEqual(requestMessage.method, "GET")
                let range = Range(rangeString: requestMessage.headers[caseInsensitive: "range"]!)
                
                let data = try await fileOperator.read(offset: UInt64(range!.start!), length: Int(range!.end! - range!.start!))
                return ResponseMessage(
                    statusCode: 200,
                    headers: [
                        "x-oss-hash-crc64ecma": String(crc),
                        "ETag":"5B3C1A2E053D763E1B002CC607C5****"
                    ],
                    content: .data(data!)
                )
            }
        }
        let client = Client(config) { $0.executeMW = mock }
        let downloader = Downloader(client) {
            $0.partSize = 256 * 1024
            $0.parallelNum = 3
        }
        
        if FileManager.default.fileExists(atPath: path) {
            try FileManager.default.removeItem(atPath: path)
        }
        
        await assertNoThrow(try await downloader.downloadFile(
            GetObjectRequest(
                bucket: "bucket",
                key: "key",
                range: Range(start: 5, end: 3 * 1024 * 1024 + 23).asString()
            ),
            URL(fileURLWithPath: path)
        ))
        
        XCTAssertEqual(try Data(contentsOf: URL(fileURLWithPath: file!)).subdata(in: 5..<3 * 1024 * 1024 + 23).calculateMd5(),
                       try Utils.calculateMd5(fileURL: URL(fileURLWithPath: path)))
        
        Utils.removeTestFile(file!)
        Utils.removeTestFile(path)
    }
    
    func testDownloaderConstruct() {
        let client = Client(Configuration.default())
        var downloader = Downloader(client)
        XCTAssertEqual(downloader.options.parallelNum, Defaults.downloadParallel)
        XCTAssertEqual(downloader.options.partSize, Defaults.downloadPartSize)
        XCTAssertTrue(downloader.options.useTempFile)
        XCTAssertFalse(downloader.options.enableCheckpoint)
        XCTAssertNil(downloader.options.checkpointDir)
        
        downloader = Downloader(client) {
            $0.parallelNum = 1
            $0.partSize = 2
            $0.enableCheckpoint = true
            $0.useTempFile = false
            $0.checkpointDir = "/checkpointDir"
        }
        XCTAssertEqual(downloader.options.parallelNum, 1)
        XCTAssertEqual(downloader.options.partSize, 2)
        XCTAssertFalse(downloader.options.useTempFile)
        XCTAssertTrue(downloader.options.enableCheckpoint)
        XCTAssertEqual(downloader.options.checkpointDir, "/checkpointDir")
    }
    
    func testDownloaderDownloadFileArgument() async {
        let mock = MockProcessRequest { requestMessage, context in
            XCTAssertEqual(requestMessage.method, "HEAD")
            return ResponseMessage(
                statusCode: 200,
                headers: ["Content-Length":"\(3 * 1024 * 1024 + 123)",
                          "Last-Modified":"Fri, 24 Feb 2012 06:07:48 GMT",
                          "ETag":"5B3C1A2E053D763E1B002CC607C5****",
                          "x-oss-hash-crc64ecma": "1"],
            )
        }
        let config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withCredentialsProvider(EnvironmentCredentialsProvider())
        let client = Client(config) { $0.executeMW = mock }
        let downloader = Downloader(client)
        
        await assertThrowsAsyncError(try await downloader.downloadFile(
            GetObjectRequest(),
            URL(fileURLWithPath: "")
        )) {
            let error = $0 as? ClientError
            XCTAssertEqual(error?.code, "ParameterError")
            XCTAssertEqual(error?.message, "Missing required field, request.bucket.")
        }
        
        await assertThrowsAsyncError(try await downloader.downloadFile(
            GetObjectRequest(
                bucket: "bucket"
            ),
            URL(fileURLWithPath: "")
        )) {
            let error = $0 as? ClientError
            XCTAssertEqual(error?.code, "ParameterError")
            XCTAssertEqual(error?.message, "Missing required field, request.key.")
        }
    }
    
    func testMockDownloaderDownloadFileWithoutTempFile() async throws {
        let file = Utils.createTestFile("test-file", 5 * 1024 * 1024 + 123)
        let path = "\(Utils.tempDir)\(Utils.pathSeparator)downloader"
        let data = try Data(contentsOf: URL(fileURLWithPath: file!))
        let crc = data.withUnsafeBytes {
            CRC64.default.crc64(crc: 0, buf: $0.baseAddress!, len: $0.count)
        }

        let credentialsProvider = StaticCredentialsProvider(accessKeyId: "ak", accessKeySecret: "sk")
        let config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withCredentialsProvider(credentialsProvider)
            .withDownloadCRC64Validation(false)
        
        let fileOperator = try FileOperator(file: URL(fileURLWithPath: file!))
        let mock = MockProcessRequest { requestMessage, context in
            if requestMessage.requestUri.absoluteString.contains("objectMeta") {
                XCTAssertEqual(requestMessage.method, "HEAD")
                return ResponseMessage(
                    statusCode: 200,
                    headers: ["Content-Length":"\(5 * 1024 * 1024 + 123)",
                              "Last-Modified":"Fri, 24 Feb 2012 06:07:48 GMT",
                              "ETag":"5B3C1A2E053D763E1B002CC607C5****",
                              "x-oss-hash-crc64ecma": String(crc)],
                )
            } else {
                XCTAssertEqual(requestMessage.method, "GET")
                let range = Range(rangeString: requestMessage.headers[caseInsensitive: "range"]!)
                
                let data = try await fileOperator.read(offset: UInt64(range!.start!), length: Int(range!.end! - range!.start!))
                return ResponseMessage(
                    statusCode: 200,
                    headers: [
                        "x-oss-hash-crc64ecma": String(crc),
                        "ETag":"5B3C1A2E053D763E1B002CC607C5****"
                    ],
                    content: .data(data!)
                )
            }
        }
        let client = Client(config) { $0.executeMW = mock }
        let downloader = Downloader(client) {
            $0.partSize = 256 * 1024
            $0.parallelNum = 1
            $0.useTempFile = false
        }
        
        if FileManager.default.fileExists(atPath: path) {
            try FileManager.default.removeItem(atPath: path)
        }
        
        await assertNoThrow(try await downloader.downloadFile(
            GetObjectRequest(
                bucket: "bucket",
                key: "key"
            ),
            URL(fileURLWithPath: path)
        ))
        
        XCTAssertEqual(try Utils.calculateMd5(fileURL: URL(fileURLWithPath: file!)),
                       try Utils.calculateMd5(fileURL: URL(fileURLWithPath: path)))
        
        Utils.removeTestFile(file!)
        Utils.removeTestFile(path)
    }
    
    func testMockDownloaderDownloadFileInvalidPartSizeAndParallelNum() async throws {
        let file = Utils.createTestFile("test-file", 5 * 1024 * 1024 + 123)
        let path = "\(Utils.tempDir)\(Utils.pathSeparator)downloader"
        let data = try Data(contentsOf: URL(fileURLWithPath: file!))
        let crc = data.withUnsafeBytes {
            CRC64.default.crc64(crc: 0, buf: $0.baseAddress!, len: $0.count)
        }

        let credentialsProvider = StaticCredentialsProvider(accessKeyId: "ak", accessKeySecret: "sk")
        let config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withCredentialsProvider(credentialsProvider)
            .withDownloadCRC64Validation(false)
        
        let fileOperator = try FileOperator(file: URL(fileURLWithPath: file!))
        let mock = MockProcessRequest { requestMessage, context in
            if requestMessage.requestUri.absoluteString.contains("objectMeta") {
                XCTAssertEqual(requestMessage.method, "HEAD")
                return ResponseMessage(
                    statusCode: 200,
                    headers: ["Content-Length":"\(5 * 1024 * 1024 + 123)",
                              "Last-Modified":"Fri, 24 Feb 2012 06:07:48 GMT",
                              "ETag":"5B3C1A2E053D763E1B002CC607C5****",
                              "x-oss-hash-crc64ecma": String(crc)],
                )
            } else {
                XCTAssertEqual(requestMessage.method, "GET")
                let range = Range(rangeString: requestMessage.headers[caseInsensitive: "range"]!)
                
                let data = try await fileOperator.read(offset: UInt64(range!.start!), length: Int(range!.end! - range!.start!))
                return ResponseMessage(
                    statusCode: 200,
                    headers: [
                        "x-oss-hash-crc64ecma": String(crc),
                        "ETag":"5B3C1A2E053D763E1B002CC607C5****"
                    ],
                    content: .data(data!)
                )
            }
        }
        let client = Client(config) { $0.executeMW = mock }
        let downloader = Downloader(client) {
            $0.partSize = 0
            $0.parallelNum = 0
        }
        
        if FileManager.default.fileExists(atPath: path) {
            try FileManager.default.removeItem(atPath: path)
        }
        
        await assertNoThrow(try await downloader.downloadFile(
            GetObjectRequest(
                bucket: "bucket",
                key: "key"
            ),
            URL(fileURLWithPath: path)
        ))
        
        XCTAssertEqual(try Utils.calculateMd5(fileURL: URL(fileURLWithPath: file!)),
                       try Utils.calculateMd5(fileURL: URL(fileURLWithPath: path)))
        
        Utils.removeTestFile(file!)
        Utils.removeTestFile(path)
    }
    
    func testMockDownloaderDownloadFileFileSizeLessPartSize() async throws {
        let file = Utils.createTestFile("test-file", 1024 + 123)
        let path = "\(Utils.tempDir)\(Utils.pathSeparator)downloader"
        let data = try Data(contentsOf: URL(fileURLWithPath: file!))
        let crc = data.withUnsafeBytes {
            CRC64.default.crc64(crc: 0, buf: $0.baseAddress!, len: $0.count)
        }

        let credentialsProvider = StaticCredentialsProvider(accessKeyId: "ak", accessKeySecret: "sk")
        let config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withCredentialsProvider(credentialsProvider)
            .withDownloadCRC64Validation(false)
        
        let fileOperator = try FileOperator(file: URL(fileURLWithPath: file!))
        let mock = MockProcessRequest { requestMessage, context in
            if requestMessage.requestUri.absoluteString.contains("objectMeta") {
                XCTAssertEqual(requestMessage.method, "HEAD")
                return ResponseMessage(
                    statusCode: 200,
                    headers: ["Content-Length":"\(1024 + 123)",
                              "Last-Modified":"Fri, 24 Feb 2012 06:07:48 GMT",
                              "ETag":"5B3C1A2E053D763E1B002CC607C5****",
                              "x-oss-hash-crc64ecma": String(crc)],
                )
            } else {
                XCTAssertEqual(requestMessage.method, "GET")
                let range = Range(rangeString: requestMessage.headers[caseInsensitive: "range"]!)
                
                let data = try await fileOperator.read(offset: UInt64(range!.start!), length: Int(range!.end! - range!.start!))
                return ResponseMessage(
                    statusCode: 200,
                    headers: [
                        "x-oss-hash-crc64ecma": String(crc),
                        "ETag":"5B3C1A2E053D763E1B002CC607C5****"
                    ],
                    content: .data(data!)
                )
            }
        }
        let client = Client(config) { $0.executeMW = mock }
        let downloader = Downloader(client) {
            $0.partSize = 256 * 1024
            $0.parallelNum = 1
        }
        
        if FileManager.default.fileExists(atPath: path) {
            try FileManager.default.removeItem(atPath: path)
        }
        
        await assertNoThrow(try await downloader.downloadFile(
            GetObjectRequest(
                bucket: "bucket",
                key: "key"
            ),
            URL(fileURLWithPath: path)
        ))
        
        XCTAssertEqual(try Utils.calculateMd5(fileURL: URL(fileURLWithPath: file!)),
                       try Utils.calculateMd5(fileURL: URL(fileURLWithPath: path)))
        
        Utils.removeTestFile(file!)
        Utils.removeTestFile(path)
    }
    
    func testMockDownloaderDownloadFileFileChange() async throws {
        let file = Utils.createTestFile("test-file", 5 * 1024 * 1024 + 123)
        let path = "\(Utils.tempDir)\(Utils.pathSeparator)downloader"
        let data = try Data(contentsOf: URL(fileURLWithPath: file!))
        let crc = data.withUnsafeBytes {
            CRC64.default.crc64(crc: 0, buf: $0.baseAddress!, len: $0.count)
        }

        let credentialsProvider = StaticCredentialsProvider(accessKeyId: "ak", accessKeySecret: "sk")
        let config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withCredentialsProvider(credentialsProvider)
            .withDownloadCRC64Validation(false)
        
        let fileOperator = try FileOperator(file: URL(fileURLWithPath: file!))
        let mock = MockProcessRequest { requestMessage, context in
            if requestMessage.requestUri.absoluteString.contains("objectMeta") {
                XCTAssertEqual(requestMessage.method, "HEAD")
                return ResponseMessage(
                    statusCode: 200,
                    headers: ["Content-Length":"\(5 * 1024 * 1024 + 123)",
                              "Last-Modified":"Fri, 24 Feb 2012 06:07:48 GMT",
                              "ETag":"5B3C1A2E053D763E1B002CC607C5****",
                              "x-oss-hash-crc64ecma": String(crc)],
                )
            } else {
                XCTAssertEqual(requestMessage.method, "GET")
                let range = Range(rangeString: requestMessage.headers[caseInsensitive: "range"]!)
                
                let data = try await fileOperator.read(offset: UInt64(range!.start!), length: Int(range!.end! - range!.start!))
                let etag = if range!.start! > 1024 * 1024 {
                    "6B3C1A2E053D763E1B002CC607C5****"
                } else {
                    "5B3C1A2E053D763E1B002CC607C5****"
                }
                return ResponseMessage(
                    statusCode: 200,
                    headers: ["x-oss-hash-crc64ecma": String(crc),
                              "ETag": etag],
                    content: .data(data!)
                )
            }
        }
        let client = Client(config) { $0.executeMW = mock }
        let downloader = Downloader(client) {
            $0.partSize = 256 * 1024
            $0.parallelNum = 3
        }
        
        if FileManager.default.fileExists(atPath: path) {
            try FileManager.default.removeItem(atPath: path)
        }
        
        await assertThrowsAsyncError(try await downloader.downloadFile(
            GetObjectRequest(
                bucket: "bucket",
                key: "key"
            ),
            URL(fileURLWithPath: path)
        )) {
            let error = $0 as? ClientError
            XCTAssertEqual(error?.code, "DwonloadError")
            XCTAssertEqual(error?.message, "Source file is changed")
        }
        
        Utils.removeTestFile(file!)
        Utils.removeTestFile(path)
    }
    
    func testMockDownloaderDownloadFileEnableCheckpointNormal() async throws {
        let file = Utils.createTestFile("test-file", 5 * 1024 * 1024 + 123)
        let path = "\(Utils.tempDir)\(Utils.pathSeparator)downloader"
        let data = try Data(contentsOf: URL(fileURLWithPath: file!))
        let crc = data.withUnsafeBytes {
            CRC64.default.crc64(crc: 0, buf: $0.baseAddress!, len: $0.count)
        }

        let credentialsProvider = StaticCredentialsProvider(accessKeyId: "ak", accessKeySecret: "sk")
        let config = Configuration.default()
            .withRegion("cn-hangzhou")
            .withCredentialsProvider(credentialsProvider)
            .withDownloadCRC64Validation(false)
        
        let fileOperator = try FileOperator(file: URL(fileURLWithPath: file!))
        let mock = MockProcessRequest { requestMessage, context in
            if requestMessage.requestUri.absoluteString.contains("objectMeta") {
                XCTAssertEqual(requestMessage.method, "HEAD")
                return ResponseMessage(
                    statusCode: 200,
                    headers: ["Content-Length":"\(5 * 1024 * 1024 + 123)",
                              "Last-Modified":"Fri, 24 Feb 2012 06:07:48 GMT",
                              "ETag":"5B3C1A2E053D763E1B002CC607C5****",
                              "x-oss-hash-crc64ecma": String(crc)],
                )
            } else {
                XCTAssertEqual(requestMessage.method, "GET")
                let range = Range(rangeString: requestMessage.headers[caseInsensitive: "range"]!)
                
                let data = try await fileOperator.read(offset: UInt64(range!.start!), length: Int(range!.end! - range!.start!))
                return ResponseMessage(
                    statusCode: 200,
                    headers: [
                        "x-oss-hash-crc64ecma": String(crc),
                        "ETag":"5B3C1A2E053D763E1B002CC607C5****"
                    ],
                    content: .data(data!)
                )
            }
        }
        let client = Client(config) { $0.executeMW = mock }
        let downloader = Downloader(client) {
            $0.partSize = 256 * 1024
            $0.parallelNum = 3
            $0.enableCheckpoint = true
        }
        
        if FileManager.default.fileExists(atPath: path) {
            try FileManager.default.removeItem(atPath: path)
        }
        
        await assertNoThrow(try await downloader.downloadFile(
            GetObjectRequest(
                bucket: "bucket",
                key: "key"
            ),
            URL(fileURLWithPath: path)
        ))
        
        XCTAssertEqual(try Utils.calculateMd5(fileURL: URL(fileURLWithPath: file!)),
                       try Utils.calculateMd5(fileURL: URL(fileURLWithPath: path)))
        
        Utils.removeTestFile(file!)
        Utils.removeTestFile(path)
    }
}

private class MockProcessRequest: ExecuteMiddleware {
    var process: (RequestMessage, ExecuteContext) async throws -> ResponseMessage
    init(process: @escaping (RequestMessage, ExecuteContext) async throws -> ResponseMessage) {
        self.process = process
    }

    public func execute(request: RequestMessage, context: ExecuteContext) async throws -> ResponseMessage {
        try await process(request, context)
    }

    func reset(process: @escaping (RequestMessage, ExecuteContext) async throws -> ResponseMessage) {
        self.process = process
    }
}

actor FileOperator {
    private let fileHandle: FileHandle
    
    init(file: URL) throws {
        self.fileHandle = try FileHandle(forReadingFrom: file)
    }
    
    deinit {
        fileHandle.closeFile()
    }
    
    func read(offset: UInt64, length: Int) throws -> Data? {
        try fileHandle.seek(toOffset: offset)
        
        if #available(macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4, *) {
            return try fileHandle.read(upToCount: length + 1)
        } else {
            return fileHandle.readData(ofLength: length + 1)
        }
    }
}
