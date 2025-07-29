import AlibabaCloudOSS
import Foundation
import XMLCoder


// MARK: - PutBucketEncryption
extension Serde {
    static func serializePutBucketEncryption (
        _ request: inout PutBucketEncryptionRequest,
        _ input: inout OperationInput
    ) throws {
        
        let data: Data = try XMLEncoder().encode(request.serverSideEncryptionRule, withRootKey: "ServerSideEncryptionRule")
        input.body = .data(data)
        
    }

    static func deserializePutBucketEncryption (
        _ result: inout PutBucketEncryptionResult,
        _ output: inout OperationOutput
    ) throws {
        
    }
}


// MARK: - GetBucketEncryption
extension Serde {
    static func serializeGetBucketEncryption (
        _ request: inout GetBucketEncryptionRequest,
        _ input: inout OperationInput
    ) throws {
        
    }

    static func deserializeGetBucketEncryption (
        _ result: inout GetBucketEncryptionResult,
        _ output: inout OperationOutput
    ) throws {
        
        guard let data = try output.body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }
        let serverSideEncryptionRule = try XMLDecoder().decode(ServerSideEncryptionRule.self, from: data)
        result.serverSideEncryptionRule = serverSideEncryptionRule
         
    }
}


// MARK: - DeleteBucketEncryption
extension Serde {
    static func serializeDeleteBucketEncryption (
        _ request: inout DeleteBucketEncryptionRequest,
        _ input: inout OperationInput
    ) throws {
        
    }

    static func deserializeDeleteBucketEncryption (
        _ result: inout DeleteBucketEncryptionResult,
        _ output: inout OperationOutput
    ) throws {
        
    }
}


