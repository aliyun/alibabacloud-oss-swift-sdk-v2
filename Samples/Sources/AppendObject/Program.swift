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

    @Option(help: "The name of the object.")
    var key: String
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
            let key = opts.key

            // Using the SDK's default configuration
            // loading credentials values from the environment variables
            let credentialsProvider = EnvironmentCredentialsProvider()

            let config = Configuration.default()
                .withRegion(region)
                .withCredentialsProvider(credentialsProvider)
                .withUploadCRC64Validation(false)

            if let endpoint = endpoint {
                config.withEndpoint(endpoint)
            }

            let client = Client(config)

            let content1 = "Hello"
            let content2 = ", OSS!"

            var result = try await client.appendObject(
                AppendObjectRequest(
                    bucket: bucket,
                    key: key,
                    position: 0,
                    body: .data(content1.data(using: .utf8)!)
                )
            )
            print("result:\n\(result)")
            
            result = try await client.appendObject(
                AppendObjectRequest(
                    bucket: bucket,
                    key: key,
                    position: result.nextAppendPosition,
                    body: .data(content2.data(using: .utf8)!)
                )
            )
            print("result:\n\(result)")

        } catch {
            Program.exit(withError: error)
        }
    }
}
