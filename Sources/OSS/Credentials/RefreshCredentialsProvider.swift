
import Foundation

public final class RefreshCredentialsProvider: CredentialsProvider {
    // default refresh time is 300 Second
    let defaultInterval = TimeInterval(300)
    let expiringCredential: ExpiringValue<Credentials>
    public let provider: CredentialsProvider

    public init(refreshInterval: TimeInterval? = nil, closure: @escaping GetCredentialsClosure) {
        provider = ClosureCredentialsProvider(closure: closure)
        expiringCredential = ExpiringValue<Credentials>(threshold: refreshInterval ?? defaultInterval)
    }

    public init(provider: CredentialsProvider, refreshInterval: TimeInterval? = nil) {
        self.provider = provider
        expiringCredential = ExpiringValue<Credentials>(threshold: refreshInterval ?? defaultInterval)
    }

    public func getCredentials() async throws -> Credentials {
        try await expiringCredential.getValue {
            try await Self.getCredentialAndExpiration(provider: self.provider)
        }
    }

    static func getCredentialAndExpiration(provider: CredentialsProvider) async throws -> (Credentials, Date) {
        try Task.checkCancellation()
        let cred = try await provider.getCredentials()
        return (cred, cred.expiration ?? Date.distantFuture)
    }
}
