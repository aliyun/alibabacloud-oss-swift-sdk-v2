import Foundation

public class ClientOptions {
    public var product: Swift.String

    public var region: Swift.String

    public var endpoint: URL?

    public var retryMaxAttempts: Swift.Int

    public var retryer: Retryer

    public var signer: Signer

    public var credentialsProvider: CredentialsProvider?

    public var addressStyle: AddressStyleType

    public var authMethod: Swift.String?

    public var featureFlags: FeatureFlag

    public var additionalHeaders: [String] = []

    /// Resolves the bucket name used for signing from an operation input. When set, its
    /// return value replaces input.bucket in the signing context only; the input is not
    /// mutated. Defaults to nil (sign with input.bucket).
    public var bucketNameResolver: ((OperationInput) throws -> String)?

    /// Builds the full request URL (scheme://host/path) from an operation input. When set,
    /// it fully replaces the default host/path construction. Defaults to nil.
    public var endpointProvider: ((OperationInput) throws -> String)?

    /// The middleware to send request, use for test
    var executeMW: ExecuteMiddleware?

    init(
        product: Swift.String,
        region: Swift.String,
        endpoint: URL? = nil,
        retryMaxAttempts: Swift.Int,
        retryer: Retryer,
        signer: Signer,
        credentialsProvider: CredentialsProvider?,
        addressStyle: AddressStyleType,
        authMethod: Swift.String?,
        featureFlags: FeatureFlag
    ) {
        self.product = product
        self.region = region
        self.endpoint = endpoint
        self.retryMaxAttempts = retryMaxAttempts
        self.retryer = retryer
        self.signer = signer
        self.credentialsProvider = credentialsProvider
        self.addressStyle = addressStyle
        self.authMethod = authMethod
        self.featureFlags = featureFlags
    }
}

public typealias ClientOptionsAction = (ClientOptions) -> Void
