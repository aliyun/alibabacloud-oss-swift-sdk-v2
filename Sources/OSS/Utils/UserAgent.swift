import Foundation
import class Foundation.ProcessInfo

/// platform info
private func getSystemName() -> String {
    #if os(Linux)
        return "linux"
    #elseif os(macOS)
        return "macOS"
    #elseif os(iOS)
        return "iOS"
    #elseif os(watchOS)
        return "watchOS"
    #elseif os(Windows)
        return "windows"
    #elseif os(tvOS)
        return "tvOS"
    #elseif os(visionOS)
        return "visionOS"
    #else
        return "unknown"
    #endif
}

enum UserAgent {}

extension UserAgent {
    static func getDefault() -> String {
        let sdkName = SdkInfo.name()
        let sdkVersion = SdkInfo.version()

        let systemName = getSystemName()
        let systemVersion = ProcessInfo.processInfo.operatingSystemVersion.description
        let localeIdentifier = Locale.current.identifier

        let info = "\(systemName)/\(systemVersion)/\(localeIdentifier)"

        return "\(sdkName)/\(sdkVersion) (\(info))"
    }
}

#if swift(>=6.0)
extension OperatingSystemVersion: @retroactive CustomStringConvertible {
    public var description: String {
        var osVersion = "\(majorVersion).\(minorVersion)"
        if patchVersion > 0 {
            osVersion += ".\(patchVersion)"
        }
        return osVersion
    }
}
#else
extension OperatingSystemVersion: CustomStringConvertible {
    public var description: String {
        var osVersion = "\(majorVersion).\(minorVersion)"
        if patchVersion > 0 {
            osVersion += ".\(patchVersion)"
        }
        return osVersion
    }
}
#endif
