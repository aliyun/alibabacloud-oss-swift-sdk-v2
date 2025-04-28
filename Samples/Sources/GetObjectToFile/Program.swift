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
    
    @Option(help: "Url of file.")
    var filePath: String
}
@main
struct Main {
    static func main() async {
        let args = Array(CommandLine.arguments.dropFirst())

        do {
            guard #available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *) else {
                throw ClientError(code: "error", message: "Current version don't support!")
            }
            let opts = try Program.parse(args)

            // Specify the region and other parameters.
            let region = opts.region
            let bucket = opts.bucket
            let endpoint = opts.endpoint
            let key = opts.key
            let filePath = opts.filePath

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

            let result = try await client.getObjectToFile(
                GetObjectRequest(
                    bucket: bucket,
                    key: key
                ),
                URL(fileURLWithPath: filePath)
            )
            print("result:\n\(result)")

        } catch {
            Program.exit(withError: error)
        }
    }
}
