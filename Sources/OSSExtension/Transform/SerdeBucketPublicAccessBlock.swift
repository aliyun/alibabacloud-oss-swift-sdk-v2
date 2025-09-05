import AlibabaCloudOSS
import Foundation
import XMLCoder


// MARK: - GetBucketPublicAccessBlock
extension Serde {
    static func serializeGetBucketPublicAccessBlock (
        _ request: inout GetBucketPublicAccessBlockRequest,
        _ input: inout OperationInput
    ) throws {
        
    }

    static func deserializeGetBucketPublicAccessBlock (
        _ result: inout GetBucketPublicAccessBlockResult,
        _ output: inout OperationOutput
    ) throws {
        
        guard let data = try output.body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }
        let publicAccessBlockConfiguration = try XMLDecoder().decode(PublicAccessBlockConfiguration.self, from: data)
        result.publicAccessBlockConfiguration = publicAccessBlockConfiguration
         
    }
}


// MARK: - PutBucketPublicAccessBlock
extension Serde {
    static func serializePutBucketPublicAccessBlock (
        _ request: inout PutBucketPublicAccessBlockRequest,
        _ input: inout OperationInput
    ) throws {
        
        let data: Data = try XMLEncoder().encode(request.publicAccessBlockConfiguration, withRootKey: "PublicAccessBlockConfiguration")
        input.body = .data(data)
        
    }

    static func deserializePutBucketPublicAccessBlock (
        _ result: inout PutBucketPublicAccessBlockResult,
        _ output: inout OperationOutput
    ) throws {
        
    }
}


// MARK: - DeleteBucketPublicAccessBlock
extension Serde {
    static func serializeDeleteBucketPublicAccessBlock (
        _ request: inout DeleteBucketPublicAccessBlockRequest,
        _ input: inout OperationInput
    ) throws {
        
    }

    static func deserializeDeleteBucketPublicAccessBlock (
        _ result: inout DeleteBucketPublicAccessBlockResult,
        _ output: inout OperationOutput
    ) throws {
        
    }
}


