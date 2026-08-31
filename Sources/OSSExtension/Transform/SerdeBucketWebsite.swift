import AlibabaCloudOSS
import Foundation
import XMLCoder


// MARK: - GetBucketWebsite
extension Serde {
    static func serializeGetBucketWebsite (
        _ request: inout GetBucketWebsiteRequest,
        _ input: inout OperationInput
    ) throws {
        
    }

    static func deserializeGetBucketWebsite (
        _ result: inout GetBucketWebsiteResult,
        _ output: inout OperationOutput
    ) throws {
        
        guard let data = try output.body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }
        let websiteConfiguration = try XMLDecoder().decode(WebsiteConfiguration.self, from: data)
        result.websiteConfiguration = websiteConfiguration
         
    }
}


// MARK: - PutBucketWebsite
extension Serde {
    static func serializePutBucketWebsite (
        _ request: inout PutBucketWebsiteRequest,
        _ input: inout OperationInput
    ) throws {
        
        let data: Data = try XMLEncoder().encode(request.websiteConfiguration, withRootKey: "WebsiteConfiguration")
        input.body = .data(data)
        
    }

    static func deserializePutBucketWebsite (
        _ result: inout PutBucketWebsiteResult,
        _ output: inout OperationOutput
    ) throws {
        
    }
}


// MARK: - DeleteBucketWebsite
extension Serde {
    static func serializeDeleteBucketWebsite (
        _ request: inout DeleteBucketWebsiteRequest,
        _ input: inout OperationInput
    ) throws {
        
    }

    static func deserializeDeleteBucketWebsite (
        _ result: inout DeleteBucketWebsiteResult,
        _ output: inout OperationOutput
    ) throws {
        
    }
}


