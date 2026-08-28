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

    @Option(help: "The user-defined prefix of the AgenticBucket name.")
    var bucket: String

    @Option(help: "The storage class of the AgenticBucket. Valid values: Standard, IA, Archive.")
    var storageClass: String?

    @Option(help: "The data redundancy type of the AgenticBucket. Valid values: LRS, ZRS.")
    var dataRedundancyType: String?
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

            let client = AgenticBucketClient(config)

            var configuration: CreateAgenticBucketConfiguration?
            if opts.storageClass != nil || opts.dataRedundancyType != nil {
                configuration = CreateAgenticBucketConfiguration(
                    storageClass: opts.storageClass,
                    dataRedundancyType: opts.dataRedundancyType
                )
            }

            let result = try await client.createAgenticBucket(
                CreateAgenticBucketRequest(
                    bucket: bucket,
                    createAgenticBucketConfiguration: configuration
                )
            )

            print("result:\n\(result)")

        } catch {
            Program.exit(withError: error)
        }
    }
}
