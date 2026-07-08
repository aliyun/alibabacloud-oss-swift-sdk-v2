
import AlibabaCloudOSS
import Crypto
import Foundation
import XCTest

struct UnitTestError: Error {
    var message: String
    init(_ message: String) {
        self.message = message
    }
}

open class Utils {
    public static let tempDir = NSTemporaryDirectory() + "swift-sdk-test_" + NSUUID().uuidString
    #if os(Windows)
        public static let pathSeparator = "\\"
    #else
        public static let pathSeparator = "/"
    #endif

    public static func calculateMd5(fileURL url: URL) throws -> Data {
        let chunkSize = 8 * 1024
        do {
            let fileHandle = try FileHandle(forReadingFrom: url)
            defer {
                fileHandle.closeFile()
            }

            var md5 = Insecure.MD5()
            var done = false
            while !done {
#if canImport(Darwin)
                autoreleasepool {
                    let data = fileHandle.readData(ofLength: chunkSize)
                    if data.count == 0 {
                        done = true
                    }
                    md5.update(data: data)
                }
#else
                let data = fileHandle.readData(ofLength: chunkSize)
                if data.count == 0 {
                    done = true
                }
                md5.update(data: data)
#endif
            }

            return Data(md5.finalize())
        } catch {
            throw UnitTestError("Cannot open file: \(error.localizedDescription)")
        }
    }

    public static func createTestFile(_ fileName: String, _ contents: Data) -> String? {
        do {
            let path = "\(tempDir)\(pathSeparator)\(fileName)"
            try FileManager.default.createDirectory(atPath: tempDir, withIntermediateDirectories: true)
            if FileManager.default.fileExists(atPath: path) {
                removeTestFile(path)
            }
            if FileManager.default.createFile(atPath: path, contents: contents, attributes: nil) {
                return path
            } else {
                return nil
            }
        } catch {
            print("\(error)")
            return nil
        }
    }

    @nonobjc
    public static func createTestFile(_ fileName: String, _ size: Int) -> String? {
        do {
            let path = "\(tempDir)\(pathSeparator)\(fileName)"
            try FileManager.default.createDirectory(atPath: tempDir, withIntermediateDirectories: true)
            let contents = randomStr(size).data(using: .utf8)
            if FileManager.default.fileExists(atPath: path) {
                removeTestFile(path)
            }
            if FileManager.default.createFile(atPath: path, contents: contents, attributes: nil) {
                return path
            } else {
                return nil
            }
        } catch {
            print("\(error)")
            return nil
        }
    }

    public static func removeTestFile(_ location: String) {
        try? FileManager.default.removeItem(atPath: location)
    }

    static let random_str_char = "abcdefghijklmnopqrstuvwxyz"
    public static func randomStr(_ length: Int) -> String {
        var ranStr = ""
        for _ in 0 ..< length {
            let index = Int.random(in: 0 ..< random_str_char.count)
            ranStr.append(random_str_char[random_str_char.index(random_str_char.startIndex, offsetBy: index)])
        }
        return ranStr
    }
}

let FileDir: String = NSTemporaryDirectory()

enum FileName: String {
    case small
    case middle
    case big
    case picture

    func filePath() -> String {
        return FileDir.appending(rawValue)
    }

    func fileUrl() -> URL {
        return URL(fileURLWithPath: FileDir.appending(rawValue))
    }
}

actor ArrayActor<T> {
    public private(set) var elements: [T] = []

    func append(_ element: T) {
        elements.append(element)
    }
}

func assertThrowsAsyncError<T>(
    _ expression: @autoclosure () async throws -> T,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line,
    _ errorHandler: (_ error: Error) -> Void = { _ in }
) async {
    do {
        _ = try await expression()
        // expected error to be thrown, but it was not
        let customMessage = message()
        if customMessage.isEmpty {
            XCTFail("Asynchronous call did not throw an error.", file: file, line: line)
        } else {
            XCTFail(customMessage, file: file, line: line)
        }
    } catch {
        errorHandler(error)
    }
}

func assertNoThrow<T>(
    _ expression: @autoclosure () async throws -> T,
    file: StaticString = #filePath,
    line: UInt = #line,
    _ resultHandler: (_ result: T) -> Void = { _ in }
) async {
    do {
        let result = try await expression()
        resultHandler(result)
    } catch {
        XCTFail("Throw an error.", file: file, line: line)
    }
}

actor ValueActor {
    private var value = 0

    func setValue(value: Int) {
        self.value = value
    }

    func increment() {
        value += 1
    }

    func getV() -> Int {
        return value
    }
}

extension Data {
    func toBase64String() -> String {
        return base64EncodedString(options: .lineLength64Characters)
    }
}
