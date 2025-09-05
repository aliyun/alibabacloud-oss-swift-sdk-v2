import AlibabaCloudOSS
import Foundation
import XMLCoder


// MARK: - GetPublicAccessBlock
extension Serde {
    static func serializeGetPublicAccessBlock (
        _ request: inout GetPublicAccessBlockRequest,
        _ input: inout OperationInput
    ) throws {
        
    }

    static func deserializeGetPublicAccessBlock (
        _ result: inout GetPublicAccessBlockResult,
        _ output: inout OperationOutput
    ) throws {
        
        guard let data = try output.body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }
        let publicAccessBlockConfiguration = try XMLDecoder().decode(PublicAccessBlockConfiguration.self, from: data)
        result.publicAccessBlockConfiguration = publicAccessBlockConfiguration
         
    }
}


// MARK: - PutPublicAccessBlock
extension Serde {
    static func serializePutPublicAccessBlock (
        _ request: inout PutPublicAccessBlockRequest,
        _ input: inout OperationInput
    ) throws {
        
        let data: Data = try XMLEncoder().encode(request.publicAccessBlockConfiguration, withRootKey: "PublicAccessBlockConfiguration")
        input.body = .data(data)
        
    }

    static func deserializePutPublicAccessBlock (
        _ result: inout PutPublicAccessBlockResult,
        _ output: inout OperationOutput
    ) throws {
        
    }
}


// MARK: - DeletePublicAccessBlock
extension Serde {
    static func serializeDeletePublicAccessBlock (
        _ request: inout DeletePublicAccessBlockRequest,
        _ input: inout OperationInput
    ) throws {
        
    }

    static func deserializeDeletePublicAccessBlock (
        _ result: inout DeletePublicAccessBlockResult,
        _ output: inout OperationOutput
    ) throws {
        
    }
}


