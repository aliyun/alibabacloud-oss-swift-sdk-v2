import AlibabaCloudOSS
import Foundation
import XMLCoder


// MARK: - PutBucketReferer
extension Serde {
    static func serializePutBucketReferer (
        _ request: inout PutBucketRefererRequest,
        _ input: inout OperationInput
    ) throws {
        
        let data: Data = try XMLEncoder().encode(request.refererConfiguration, withRootKey: "RefererConfiguration")
        input.body = .data(data)
        
    }

    static func deserializePutBucketReferer (
        _ result: inout PutBucketRefererResult,
        _ output: inout OperationOutput
    ) throws {
        
    }
}


// MARK: - GetBucketReferer
extension Serde {
    static func serializeGetBucketReferer (
        _ request: inout GetBucketRefererRequest,
        _ input: inout OperationInput
    ) throws {
        
    }

    static func deserializeGetBucketReferer (
        _ result: inout GetBucketRefererResult,
        _ output: inout OperationOutput
    ) throws {
        
        guard let data = try output.body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }
        let refererConfiguration = try XMLDecoder().decode(RefererConfiguration.self, from: data)
        result.refererConfiguration = refererConfiguration
         
    }
}


