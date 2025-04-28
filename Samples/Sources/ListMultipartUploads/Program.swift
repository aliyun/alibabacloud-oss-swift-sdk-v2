import AlibabaCloudOSS
import ArgumentParser
import Foundation

struct Program: ParsableCommand {
    @Option(help: "The region in which the bucket is located.")
    var region: String

    @Option(help: "The domain names that other services can use to access OSS.")
    var endpoint: String?

    @Option(help: "The name of the bucket.")
    var bucket: String
}
@main
struct Main {
    static func main() async {
        let args = Array(CommandLine.arguments.dropFirst())

        do {
            let opts = try Program.parse(args)

            // Specify the region and other parameters.
            let region = opts.region
            let bucket = opts.bucket
            let endpoint = opts.endpoint

            // Using the SDK's default configuration
            // loading credentials values from the environment variables
            let credentialsProvider = EnvironmentCredentialsProvider()

            let config = Configuration.default()
                .withRegion(region)
                .withCredentialsProvider(credentialsProvider)

            if let endpoint = endpoint {
                config.withEndpoint(endpoint)
            }

            let client = Client(config)

            // Create the Paginator for the ListBuckets operation.
            let paginator = client.listMultipartUploadsPaginator(
                ListMultipartUploadsRequest(
                    bucket: bucket
                )
            )

            // Iterate through the bucket pages
            for try await page in paginator {
                for upload in page.uploads ?? [] {
                    print("Upload key:\(upload.key ?? ""), upload id: \(upload.uploadId ?? ""), initiated: \(upload.initiated!)")
                }
            }
        } catch {
            Program.exit(withError: error)
        }
    }
}
