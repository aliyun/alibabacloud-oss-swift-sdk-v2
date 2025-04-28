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
    
    @Option(help: "The name of the source bucket.")
    var sourceBucket: String

    @Option(help: "The name of the source object.")
    var sourceKey: String
    
    @Option(help: "The ID that identifies the object to which the part that you want to upload belongs.")
    var uploadId: String
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
            let sourceBucket = opts.sourceBucket
            let sourceKey = opts.sourceKey
            let uploadId = opts.uploadId

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

            let result = try await client.uploadPartCopy(
                UploadPartCopyRequest(
                    bucket: bucket,
                    key: key,
                    sourceBucket: sourceBucket,
                    sourceKey: sourceKey,
                    uploadId: uploadId
                )
            )
            print("result:\n\(result)")

        } catch {
            Program.exit(withError: error)
        }
    }
}
