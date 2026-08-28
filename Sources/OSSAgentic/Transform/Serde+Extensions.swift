import AlibabaCloudOSS
import Crypto
import Foundation

extension DateFormatter {
    /// GMT format (for example, Tue, 29 Apr 2014 18:30:38 GMT)
    static let rfc5322DateTime = DateFormatter(
        fixedFormat: "EE, dd MMM yyyy HH:mm:ss zzz"
    )

    /// iso8601 with fractional seconds, (for example, 2025-03-28T18:20:30.000Z)
    static let iso8601DateTimeSeconds = DateFormatter(
        fixedFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    )

    /// iso8601 without fractional seconds, (for example, 2025-03-28T18:20:30Z)
    static let iso8601DateTime = DateFormatter(
        fixedFormat: "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    )

    private convenience init(fixedFormat dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
        locale = Locale(identifier: "en_US_POSIX")
        timeZone = TimeZone(secondsFromGMT: 0)!
    }
}

extension Date {
    /// Creates a date from a string using the given formatters.
    init?(from string: String, formatters: [DateFormatter]) {
        for formatter in formatters {
            if let date = formatter.date(from: string) {
                self = date
                return
            }
        }
        return nil
    }
}

extension Bool {
    func toString() -> String {
        self ? "true" : "false"
    }
}

extension String {
    func toInt() -> Int? {
        Int(self)
    }

    func toUInt64() -> UInt64? {
        UInt64(self)
    }

    func toBool() -> Bool {
        Bool(self) ?? false
    }

    func toDate() -> Date? {
        return Date(
            from: self,
            formatters: [
                DateFormatter.rfc5322DateTime,
                DateFormatter.iso8601DateTimeSeconds,
                DateFormatter.iso8601DateTime,
            ]
        )
    }
}

extension Data {
    func calculateMd5() -> Data {
        Data(Insecure.MD5.hash(data: self))
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

extension Dictionary where Key == String {
    func toUserMetadata() -> [String: Value]? {
        var result = [String: Value]()
        for (k, v) in self {
            let kk = k.lowercased()
            if kk.hasPrefix("x-oss-meta-") {
                result[String(kk[kk.index(kk.startIndex, offsetBy: 11) ..< kk.endIndex])] = v
            }
        }
        return result.count > 0 ? result : nil
    }
}

extension Optional {
    @discardableResult
    func ensureRequired(field: String) throws -> Wrapped {
        if let value = self {
            return value
        }
        throw ClientError.paramRequiredError(field: field)
    }
}
