import XCTest
import AlibabaCloudOSS

final class DownloaderTests: BaseTestCase {
    
    override func setUp() async throws {
        try await super.setUp()
        
        client = getDefaultClient()
        bucketName = randomBucketName()
        
        let requst = PutBucketRequest(bucket: bucketName)
        try await assertNoThrow(await client?.putBucket(requst))
        
        let downloadDir = "\(tempDir)\(pathSeparator)oss"
        if !FileManager.default.fileExists(atPath: downloadDir) {
            try FileManager.default.createDirectory(atPath: downloadDir, withIntermediateDirectories: true)
        }
    }
    
    override func tearDown() async throws {
        try await cleanBucket(client: client!, bucket: bucketName)
        try await super.tearDown()
    }
    
    func testDownload() async throws {
        let key = randomObjectName()
        let file = createTestFile("test-file", 20 * 1024 * 1024)
        let downloadFilePath = "\(tempDir)\(pathSeparator)oss\(pathSeparator)downloader-destination-file"

        await assertNoThrow(try await client?.putObject(PutObjectRequest(
            bucket: bucketName,
            key: key,
            body: .file(URL(fileURLWithPath: file!))
        )))
        
        let downloader = Downloader(client!)
        await assertNoThrow(try await downloader.downloadFile(GetObjectRequest(
            bucket: bucketName,
            key: key
        ), URL(fileURLWithPath: downloadFilePath)))
        
        try XCTAssertEqual(
            Data(contentsOf: URL(fileURLWithPath: file!)).calculateMd5().base64EncodedString(),
            Data(contentsOf: URL(fileURLWithPath: downloadFilePath)).calculateMd5().base64EncodedString()
        )
        
        removeTestFile(file!)
        removeTestFile(downloadFilePath)
    }
    
    func testDownloadWithProgressListener() async throws {
        let key = randomObjectName()
        let file = createTestFile("test-file", 20 * 1024 * 1024)
        let downloadFilePath = "\(tempDir)\(pathSeparator)oss\(pathSeparator)downloader-destination-file"
        nonisolated(unsafe) var totalBytesReceive: Int64 = 0
        
        await assertNoThrow(try await client?.putObject(PutObjectRequest(
            bucket: bucketName,
            key: key,
            body: .file(URL(fileURLWithPath: file!))
        )))
        
        let downloader = Downloader(client!) {
            $0.partSize = 1024 * 1024
        }
        await assertNoThrow(try await downloader.downloadFile(GetObjectRequest(
            bucket: bucketName,
            key: key,
            progress: ProgressClosure(closure: { bytesIncrement, totalBytesTransferred, totalBytesExpected in
                totalBytesReceive += bytesIncrement
                XCTAssertEqual(totalBytesTransferred, totalBytesReceive)
                XCTAssertEqual(20 * 1024 * 1024, totalBytesExpected)
            })
        ), URL(fileURLWithPath: downloadFilePath)))
        XCTAssertEqual(20 * 1024 * 1024, totalBytesReceive)
        
        removeTestFile(file!)
        removeTestFile(downloadFilePath)
    }
    
    func testDownloadWithRange() async throws {
        let key = randomObjectName()
        let file = createTestFile("test-file", 20 * 1024 * 1024)
        let downloadFilePath = "\(tempDir)\(pathSeparator)oss\(pathSeparator)downloader-destination-file"
        
        await assertNoThrow(try await client?.putObject(PutObjectRequest(
            bucket: bucketName,
            key: key,
            body: .file(URL(fileURLWithPath: file!))
        )))
        
        let downloader = Downloader(client!) {
            $0.partSize = 1024 * 1024
        }
        await assertNoThrow(try await downloader.downloadFile(GetObjectRequest(
            bucket: bucketName,
            key: key,
            range: Range(start: 123, end: 6 * 1024 + 123).asString()
        ), URL(fileURLWithPath: downloadFilePath)))
        
        try XCTAssertEqual(
            Data(contentsOf: URL(fileURLWithPath: file!)).subdata(in: 123..<(6 * 1024 + 123)).calculateMd5().base64EncodedString(),
            Data(contentsOf: URL(fileURLWithPath: downloadFilePath)).calculateMd5().base64EncodedString()
        )
        
        removeTestFile(file!)
        removeTestFile(downloadFilePath)
    }
    
    func testDownloadWithEnableCheckpoint() async throws {
        let key = randomObjectName()
        let file = createTestFile("test-file", 20 * 1024 * 1024)
        let downloadFilePath = "\(tempDir)\(pathSeparator)oss\(pathSeparator)downloader-destination-file"

        await assertNoThrow(try await client?.putObject(PutObjectRequest(
            bucket: bucketName,
            key: key,
            body: .file(URL(fileURLWithPath: file!))
        )))
        
        let downloader = Downloader(client!) {
            $0.partSize = 1024 * 1024
            $0.enableCheckpoint = true
        }
        try await Task {
            nonisolated(unsafe) let task = withUnsafeCurrentTask { $0 }
            await assertThrowsAsyncError(try await downloader.downloadFile(GetObjectRequest(
                bucket: bucketName,
                key: key,
                progress: ProgressClosure(closure: { bytesIncrement, totalBytesTransferred, totalBytesExpected in
                    if totalBytesTransferred > totalBytesExpected / 2 {
                        task?.cancel()
                    }
                })
            ), URL(fileURLWithPath: downloadFilePath)))
        }.value
        
        await assertNoThrow(try await downloader.downloadFile(GetObjectRequest(
            bucket: bucketName,
            key: key,
            progress: ProgressClosure(closure: { bytesIncrement, totalBytesTransferred, totalBytesExpected in
                XCTAssertTrue(totalBytesTransferred >= totalBytesExpected / 2)
            })
        ), URL(fileURLWithPath: downloadFilePath)))
        
        try XCTAssertEqual(
            Data(contentsOf: URL(fileURLWithPath: file!)).calculateMd5().base64EncodedString(),
            Data(contentsOf: URL(fileURLWithPath: downloadFilePath)).calculateMd5().base64EncodedString()
        )
        
        removeTestFile(file!)
        removeTestFile(downloadFilePath)
    }
    
    func testDownloadWithCheckpointDir() async throws {
        let key = randomObjectName()
        let file = createTestFile("test-file", 20 * 1024 * 1024)
        let downloadFilePath = "\(tempDir)\(pathSeparator)oss\(pathSeparator)downloader-destination-file"
        let baseDir = "\(tempDir)\(pathSeparator)oss\(pathSeparator)downloader"

        await assertNoThrow(try await client?.putObject(PutObjectRequest(
            bucket: bucketName,
            key: key,
            body: .file(URL(fileURLWithPath: file!))
        )))
        
        let downloader = Downloader(client!) {
            $0.partSize = 1024 * 1024
            $0.enableCheckpoint = true
            $0.checkpointDir = baseDir
        }
        try await Task {
            nonisolated(unsafe) let task = withUnsafeCurrentTask { $0 }
            await assertThrowsAsyncError(try await downloader.downloadFile(GetObjectRequest(
                bucket: bucketName,
                key: key,
                progress: ProgressClosure(closure: { bytesIncrement, totalBytesTransferred, totalBytesExpected in
                    if totalBytesTransferred > totalBytesExpected / 2 {
                        task?.cancel()
                    }
                })
            ), URL(fileURLWithPath: downloadFilePath)))
        }.value
        
        var isDirectory: ObjCBool = false
        XCTAssertTrue(FileManager.default.fileExists(atPath: baseDir, isDirectory: &isDirectory))
        XCTAssertTrue(isDirectory.boolValue)
        XCTAssertEqual(1, FileManager.default.enumerator(atPath: baseDir)?.allObjects.count)
        
        await assertNoThrow(try await downloader.downloadFile(GetObjectRequest(
            bucket: bucketName,
            key: key,
            progress: ProgressClosure(closure: { bytesIncrement, totalBytesTransferred, totalBytesExpected in
                XCTAssertTrue(totalBytesTransferred >= totalBytesExpected / 2)
            })
        ), URL(fileURLWithPath: downloadFilePath)))
        
        try XCTAssertEqual(
            Data(contentsOf: URL(fileURLWithPath: file!)).calculateMd5().base64EncodedString(),
            Data(contentsOf: URL(fileURLWithPath: downloadFilePath)).calculateMd5().base64EncodedString()
        )
        
        XCTAssertEqual(0, FileManager.default.enumerator(atPath: baseDir)?.allObjects.count)
        removeTestFile(file!)
        removeTestFile(downloadFilePath)
    }
    
    func testDownloadWithAbort() async throws {
        let key = randomObjectName()
        let file = createTestFile("test-file", 20 * 1024 * 1024)
        let downloadFilePath = "\(tempDir)\(pathSeparator)oss\(pathSeparator)downloader-destination-file"
        let baseDir = "\(tempDir)\(pathSeparator)oss\(pathSeparator)downloader"
        
        await assertNoThrow(try await client?.putObject(PutObjectRequest(
            bucket: bucketName,
            key: key,
            body: .file(URL(fileURLWithPath: file!))
        )))
        
        let downloader = Downloader(client!) {
            $0.partSize = 1024 * 1024
            $0.enableCheckpoint = true
            $0.checkpointDir = baseDir
            $0.useTempFile = false
        }
        try await Task {
            nonisolated(unsafe) let task = withUnsafeCurrentTask { $0 }
            await assertThrowsAsyncError(try await downloader.downloadFile(GetObjectRequest(
                bucket: bucketName,
                key: key,
                progress: ProgressClosure(closure: { bytesIncrement, totalBytesTransferred, totalBytesExpected in
                    if totalBytesTransferred > totalBytesExpected / 2 {
                        task?.cancel()
                    }
                })
            ), URL(fileURLWithPath: downloadFilePath)))
        }.value
        
        await assertNoThrow(try await downloader.abortDownload(GetObjectRequest(
            bucket: bucketName,
            key: key
        ), URL(fileURLWithPath: downloadFilePath)))
        
        XCTAssertEqual(0, FileManager.default.enumerator(atPath: baseDir)?.allObjects.count)
        XCTAssertTrue(!FileManager.default.fileExists(atPath: downloadFilePath))
        removeTestFile(file!)
    }
    
    func testDownloadWithException() async throws {
        let key = randomObjectName()
        let downloadFilePath = "\(tempDir)\(pathSeparator)oss\(pathSeparator)downloader-destination-file"
        
        let downloader = Downloader(client!)
        await assertThrowsAsyncError(try await downloader.downloadFile(GetObjectRequest(), URL(fileURLWithPath: downloadFilePath))) {
            let error = $0 as? ClientError
            XCTAssertEqual(error?.message, "Missing required field, request.bucket.")
        }
        
        await assertThrowsAsyncError(try await downloader.downloadFile(GetObjectRequest(
            bucket: bucketName
        ), URL(fileURLWithPath: downloadFilePath))) {
            let error = $0 as? ClientError
            XCTAssertEqual(error?.message, "Missing required field, request.key.")
        }
        
        let invalidDownloader = Downloader(getInvalidAkClient())
        await assertThrowsAsyncError(try await invalidDownloader.downloadFile(GetObjectRequest(
            bucket: bucketName,
            key: key
        ), URL(fileURLWithPath: downloadFilePath))) {
            let error = $0 as? ServerError
            XCTAssertEqual(error?.statusCode, 403)
        }
    }
    
    func testAbortDownloadWithException() async throws {
        let key = randomObjectName()
        let downloadFilePath = "\(tempDir)\(pathSeparator)oss\(pathSeparator)downloader-destination-file"
        
        let downloader = Downloader(client!)
        await assertThrowsAsyncError(try await downloader.abortDownload(GetObjectRequest(), URL(fileURLWithPath: downloadFilePath))) {
            let error = $0 as? ClientError
            XCTAssertEqual(error?.message, "Missing required field, request.bucket.")
        }
        
        await assertThrowsAsyncError(try await downloader.abortDownload(GetObjectRequest(
            bucket: bucketName
        ), URL(fileURLWithPath: downloadFilePath))) {
            let error = $0 as? ClientError
            XCTAssertEqual(error?.message, "Missing required field, request.key.")
        }
        
        let invalidDownloader = Downloader(getInvalidAkClient())
        await assertThrowsAsyncError(try await invalidDownloader.abortDownload(GetObjectRequest(
            bucket: bucketName,
            key: key
        ), URL(fileURLWithPath: downloadFilePath))) {
            let error = $0 as? ServerError
            XCTAssertEqual(error?.statusCode, 403)
        }
    }
}
