import AlibabaCloudOSS
import Foundation
import XMLCoder


// MARK: - PutBucketPolicy
extension Serde {
    static func serializePutBucketPolicy (
        _ request: inout PutBucketPolicyRequest,
        _ input: inout OperationInput
    ) throws {
        input.body = request.body
    }

    static func deserializePutBucketPolicy (
        _ result: inout PutBucketPolicyResult,
        _ output: inout OperationOutput
    ) throws {
        
    }
}


// MARK: - GetBucketPolicy
extension Serde {
    static func serializeGetBucketPolicy (
        _ request: inout GetBucketPolicyRequest,
        _ input: inout OperationInput
    ) throws {
        
    }

    static func deserializeGetBucketPolicy (
        _ result: inout GetBucketPolicyResult,
        _ output: inout OperationOutput
    ) throws {
        result.body = output.body
    }
}


// MARK: - DeleteBucketPolicy
extension Serde {
    static func serializeDeleteBucketPolicy (
        _ request: inout DeleteBucketPolicyRequest,
        _ input: inout OperationInput
    ) throws {
        
    }

    static func deserializeDeleteBucketPolicy (
        _ result: inout DeleteBucketPolicyResult,
        _ output: inout OperationOutput
    ) throws {
        
    }
}


// MARK: - GetBucketPolicyStatus
extension Serde {
    static func serializeGetBucketPolicyStatus (
        _ request: inout GetBucketPolicyStatusRequest,
        _ input: inout OperationInput
    ) throws {
        
    }

    static func deserializeGetBucketPolicyStatus (
        _ result: inout GetBucketPolicyStatusResult,
        _ output: inout OperationOutput
    ) throws {
        
        guard let data = try output.body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }
        let policyStatus = try XMLDecoder().decode(PolicyStatus.self, from: data)
        result.policyStatus = policyStatus
         
    }
}


