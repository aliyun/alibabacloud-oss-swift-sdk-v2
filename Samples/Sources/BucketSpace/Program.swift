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

    @Option(help: "The object key to write into the BucketSpace.")
    var key: String
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
            // physical name, so ordinary object operations target the BucketSpace.
            let client = BucketSpaceClient.make(config)

            let putResult = try await client.putObject(
                PutObjectRequest(
                    bucket: bucket,
                    key: opts.key,
                    body: .data("hello agentic".data(using: .utf8)!)
                )
            )
            print("put result:\n\(putResult)")

            let getResult = try await client.getObject(
                GetObjectRequest(
                    bucket: bucket,
                    key: opts.key
                )
            )
            print("get result:\n\(getResult)")

        } catch {
            Program.exit(withError: error)
        }
    }
}
