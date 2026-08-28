import Foundation

/// Derives physical BucketSpace names of the form `{prefix}-{accountId}-{region}-bs-apsr`.
public struct BucketSpaceHelper: Sendable {
    let accountId: String
    let region: String

    public init(accountId: String, region: String) {
        self.accountId = accountId
        self.region = region
    }

    public init(config: Configuration) {
        self.init(accountId: config.accountId ?? "", region: config.region ?? "")
    }

    /// Returns the physical BucketSpace name for the given user-defined prefix.
    public func toBucketName(_ prefix: String) -> String {
        return "\(prefix)-\(accountId)-\(region)-bs-apsr"
    }
}
