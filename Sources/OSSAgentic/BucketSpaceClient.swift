import AlibabaCloudOSS
import Foundation

/// A factory namespace for clients scoped to a BucketSpace.
public enum BucketSpaceClient {
    /// Creates a `Client` scoped to a BucketSpace. Every bucket passed to the returned
    /// client is rewritten to its physical form `{prefix}-{accountId}-{region}-bs-apsr`,
    /// so ordinary object operations transparently target the BucketSpace.
    public static func make(
        _ config: Configuration,
        _ actions: ClientOptionsAction...
    ) -> Client {
        return makeScopedClient(config, suffix: "-bs-apsr", actions)
    }
}

/// The literal segment that replaces `{accountId}-{region}` in the short host label.
private let aliasToken = "alias"

/// Builds a `Client` whose requests are rewritten to a physical `{bucket}-{accountId}-{region}{suffix}`
/// name and routed to the matching virtual-hosted host, without mutating the operation input.
///
/// Under ``AddressStyleType/virtualHostedAlias`` the host carries the short label
/// `{bucket}-alias{suffix}` instead, while signing keeps the physical name.
func makeScopedClient(
    _ config: Configuration,
    suffix: String,
    _ extraActions: [ClientOptionsAction]
) -> Client {
    let accountId = config.accountId ?? ""
    let region = config.region ?? ""

    // Resolves the physical bucket name from an operation input, without mutating it.
    let buildName: (OperationInput) throws -> String = { input in
        guard let bucket = input.bucket else { return "" }
        guard !accountId.isEmpty else { throw ClientError.paramRequiredError(field: "AccountId") }
        guard !region.isEmpty else { throw ClientError.paramRequiredError(field: "Region") }
        return "\(bucket)-\(accountId)-\(region)\(suffix)"
    }

    // Prefix the User-Agent for agentic requests without permanently mutating the
    // caller's configuration: the value is read synchronously during construction.
    let originalUserAgent = config.userAgent
    if let existing = originalUserAgent, !existing.isEmpty {
        config.userAgent = "agentic-client/\(existing)"
    } else {
        config.userAgent = "agentic-client"
    }
    defer { config.userAgent = originalUserAgent }

    // Apply the agentic routing on top of the extraActions result so it always wins.
    let agenticAction: ClientOptionsAction = { opts in
        opts.bucketNameResolver = buildName
        // Route to the physical host, reading the endpoint that extraActions may have
        // adjusted. Under path-style the physical name lives in the path instead of the host.
        if let endpoint = opts.endpoint, let scheme = endpoint.scheme {
            let authority = endpoint.hostPort()
            let addressStyle = opts.addressStyle
            opts.endpointProvider = { input in
                var paths: [String] = []
                var host = authority
                if let bucket = input.bucket {
                    switch addressStyle {
                    case .path:
                        paths.append(try buildName(input))
                        if input.key == nil {
                            paths.append("")
                        }
                    case .virtualHostedAlias:
                        let label = "\(bucket)-\(aliasToken)\(suffix)"
                        guard label.count <= 63 else {
                            throw ClientError(
                                code: "ValidationError",
                                message: "the host label \"\(label)\" exceeds the maximum length of 63 characters"
                            )
                        }
                        host = "\(label).\(authority)"
                    default: // virtual host
                        let name = try buildName(input)
                        guard name.count <= 63 else {
                            throw ClientError(
                                code: "ValidationError",
                                message: "the host label \"\(name)\" exceeds the maximum length of 63 characters"
                            )
                        }
                        host = "\(name).\(authority)"
                    }
                }
                if let encodeKey = input.key?.urlEncodePath() {
                    paths.append(encodeKey)
                }
                return "\(scheme)://\(host)/\(paths.joined(separator: "/"))"
            }
        }
    }

    let actions = extraActions + [agenticAction]
    return Client(config) { opts in
        for action in actions {
            action(opts)
        }
    }
}
