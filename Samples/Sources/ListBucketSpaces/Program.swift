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

    @Option(help: "The prefix used to filter the returned BucketSpace names.")
    var prefix: String?
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

            // Create the Paginator for the ListBucketSpaces operation.
            let paginator = client.listBucketSpacesPaginator(
                ListBucketSpacesRequest(
                    bucket: bucket,
                    prefix: opts.prefix
                )
            )

            // Iterate through the BucketSpace pages
            for try await page in paginator {
                for space in page.bucketSpaces ?? [] {
                    print("BucketSpace: \(space.name ?? "") \(space.location ?? "") \(space.storageClass ?? "")")
                }
            }

        } catch {
            Program.exit(withError: error)
        }
    }
}
