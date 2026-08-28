import AlibabaCloudOSS
import AlibabaCloudOSSAgentic
import ArgumentParser
import Foundation

struct Program: ParsableCommand {
    @Option(help: "The region in which the buckets are located.")
    var region: String

    @Option(help: "The domain names that other services can use to access OSS.")
    var endpoint: String?

    @Option(help: "The Alibaba Cloud account ID (UID).")
    var accountId: String
}

@main
struct Main {
    static func main() async {
        let args = Array(CommandLine.arguments.dropFirst())

        do {
            let opts = try Program.parse(args)

            let region = opts.region
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

            // Create the Paginator for the ListAgenticBuckets operation.
            let paginator = client.listAgenticBucketsPaginator(ListAgenticBucketsRequest())

            // Iterate through the AgenticBucket pages
            for try await page in paginator {
                for bucket in page.agenticBuckets ?? [] {
                    print("AgenticBucket: \(bucket.name ?? "") \(bucket.storageClass ?? "") \(bucket.dataRedundancyType ?? "")")
                }
            }

        } catch {
            Program.exit(withError: error)
        }
    }
}
