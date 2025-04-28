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

    @Option(help: "The name of the objects.")
    var objects: String
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
            let objects = opts.objects

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
            
            var deleteObjects: [DeleteObject] = []
            for object in objects.components(separatedBy: ",") {
                deleteObjects.append(DeleteObject(key: object))
            }

            let result = try await client.deleteMultipleObjects(
                DeleteMultipleObjectsRequest(
                    bucket: bucket,
                    objects: deleteObjects
                )
            )
            print("result:\n\(result)")

        } catch {
            Program.exit(withError: error)
        }
    }
}
