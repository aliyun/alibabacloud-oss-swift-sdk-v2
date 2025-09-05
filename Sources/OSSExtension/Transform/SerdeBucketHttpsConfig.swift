import AlibabaCloudOSS
import Foundation
import XMLCoder


// MARK: - GetBucketHttpsConfig
extension Serde {
    static func serializeGetBucketHttpsConfig (
        _ request: inout GetBucketHttpsConfigRequest,
        _ input: inout OperationInput
    ) throws {
        
    }

    static func deserializeGetBucketHttpsConfig (
        _ result: inout GetBucketHttpsConfigResult,
        _ output: inout OperationOutput
    ) throws {
        
        guard let data = try output.body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }
        let httpsConfiguration = try XMLDecoder().decode(HttpsConfiguration.self, from: data)
        result.httpsConfiguration = httpsConfiguration
         
    }
}


// MARK: - PutBucketHttpsConfig
extension Serde {
    static func serializePutBucketHttpsConfig (
        _ request: inout PutBucketHttpsConfigRequest,
        _ input: inout OperationInput
    ) throws {
        
        let data: Data = try XMLEncoder().encode(request.httpsConfiguration, withRootKey: "HttpsConfiguration")
        input.body = .data(data)
        
    }

    static func deserializePutBucketHttpsConfig (
        _ result: inout PutBucketHttpsConfigResult,
        _ output: inout OperationOutput
    ) throws {
        
    }
}


