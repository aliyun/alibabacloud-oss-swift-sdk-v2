import AlibabaCloudOSS
import AlibabaCloudOSSAgentic
import ArgumentParser
import Foundation

struct Program: ParsableCommand {
    @Option(help: "The region in which the bucket is located.")
    var region: String

    @Option(help: "The domain names that other services can use to access OSS.")
    var endpoint: String?

    @Option(help: "The Alibaba Cloud account ID (UID).")
    var accountId: String

    @Option(help: "The user-defined prefix of the BucketSpace name.")
    var bucket: String

    @Option(help: "The user-defined prefix of the AgenticBucket that owns the BucketSpace.")
    var agenticBucket: String
}

@main
struct Main {
    static func main() async {
        let args = Array(CommandLine.arguments.dropFirst())

        do {
            let opts = try Program.parse(args)

            let region = opts.region
            let bucket = opts.bucket
            let endpoint = opts.endpoint
            let accountId = opts.accountId

            // Using the SDK's default configuration
            // loading credentials values from the environment variables
            let credentialsProvider = EnvironmentCredentialsProvider()

            let config = Configuration.default()
                .withRegion(region)
                .withCredentialsProvider(credentialsProvider)
                .withAccountId(accountId)

            if let endpoint = endpoint {
                config.withEndpoint(endpoint)
            }

            // The scoped client transparently rewrites every bucket to its BucketSpace
            // physical name, so pass the prefix only.
            let client = BucketSpaceClient.make(config)

            // The BucketSpace must be created under an AgenticBucket, identified by its
            // full name {bucket}-{accountId}-{region}-ab-apsr.
            let result = try await client.putBucket(
                PutBucketRequest(
                    bucket: bucket,
                    agenticBucket: "\(opts.agenticBucket)-\(accountId)-\(region)-ab-apsr"
                )
            )
            print("put bucket space result:\n\(result)")

        } catch {
            Program.exit(withError: error)
        }
    }
}
