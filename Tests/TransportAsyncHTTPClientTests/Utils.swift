
import AlibabaCloudOSS
import Crypto
import Foundation
import XCTest

struct IntegrationTestError: Error {
    var message: String
    init(_ message: String) {
        self.message = message
    }
}

open class Utils {
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
                let data = fileHandle.readData(ofLength: chunkSize)
                if data.count == 0 {
                    done = true
                }
                md5.update(data: data)
            }

            return Data(md5.finalize())
        } catch {
            throw IntegrationTestError("Cannot open file: \(error.localizedDescription)")
        }
    }
}

actor ValueActor<T: Sendable> {
    private var value: T

    init(value: T) {
        self.value = value
    }

    func setValue(value: T) {
        self.value = value
    }

    func getValue() -> T {
        return value
    }
}

extension Data {
    func toBase64String() -> String {
        return base64EncodedString(options: .lineLength64Characters)
    }
}

extension Data {
    func calculateMd5() -> Data {
        Data(Insecure.MD5.hash(data: self))
    }
}
