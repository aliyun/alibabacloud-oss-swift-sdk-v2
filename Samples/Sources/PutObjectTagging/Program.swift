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
    
    @Option(help: "The request body schema.")
    var tagging: String
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
            let tagging = opts.tagging

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
            
            var tags: [Tag] = []
            for tag in tagging.components(separatedBy: ",") {
                let keyValue = tag.components(separatedBy: "=")
                if keyValue.count == 2,
                   let key = keyValue.first,
                   let value = keyValue.last {
                    tags.append(Tag(key: key,
                                    value: value))
                }
            }

            let result = try await client.putObjectTagging(
                PutObjectTaggingRequest(
                    bucket: bucket,
                    key: key,
                    tagging: Tagging(tagSet: TagSet(tags: tags))
                )
            )
            print("result:\n\(result)")

        } catch {
            Program.exit(withError: error)
        }
    }
}
