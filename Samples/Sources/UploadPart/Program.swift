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
            let uploadId = opts.uploadId
            let partSize = 256 * 1024

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

            let content = Data.random(length: 1024 * 1024)
            let count = (content.count / partSize) + (content.count % partSize > 0 ? 1 : 0)
            
            for i in 0..<count {
                await withTaskGroup {
                    $0.addTask {
                        do {
                            let data = content[(i * partSize)..<min((i + 1) * partSize, content.count)]
                            let result = try await client.uploadPart(
                                UploadPartRequest(
                                    bucket: bucket,
                                    key: key,
                                    partNumber: i + 1,
                                    uploadId: uploadId,
                                    body: .data(data)
                                )
                            )
                            print("result:\n\(result)")
                        } catch {
                            Program.exit(withError: error)
                        }
                    }
                }
            }

        } catch {
            Program.exit(withError: error)
        }
    }
}

extension Data {
    public static func random(length: Int) -> Data {
        let bytes = UnsafeMutablePointer<UInt8>.allocate(capacity: length)
        bytes.withMemoryRebound(to: UInt32.self, capacity: length) { ptr in
            arc4random_buf(ptr, length)
        }
        
        let data = Data(bytes: bytes, count: length)
        bytes.deallocate()
        return data
    }
}
