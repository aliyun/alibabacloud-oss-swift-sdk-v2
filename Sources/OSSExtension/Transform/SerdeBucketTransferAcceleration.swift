import Foundation
import AlibabaCloudOSS
import XMLCoder

// MARK: - PutBucketTransferAcceleration
extension Serde {
    static func serializePutBucketTransferAcceleration (
        _ request: inout PutBucketTransferAccelerationRequest,
        _ input: inout OperationInput
    ) throws -> Void {
        let data: Data = try XMLEncoder().encode(request.transferAccelerationConfiguration, withRootKey: "TransferAccelerationConfiguration")
        input.body = .data(data)
    }

    static func deserializePutBucketTransferAcceleration (
        _ result: inout PutBucketTransferAccelerationResult,
        _ output: inout OperationOutput
    ) throws -> Void {
        
    }
}


// MARK: - GetBucketTransferAcceleration
extension Serde {
    static func serializeGetBucketTransferAcceleration (
        _ request: inout GetBucketTransferAccelerationRequest,
        _ input: inout OperationInput
    ) throws -> Void {   
        
    }

    static func deserializeGetBucketTransferAcceleration (
        _ result: inout GetBucketTransferAccelerationResult,
        _ output: inout OperationOutput
    ) throws -> Void {
        guard let data = try output.body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }
        let transferAccelerationConfiguration = try XMLDecoder().decode(TransferAccelerationConfiguration.self, from: data)
        result.transferAccelerationConfiguration = transferAccelerationConfiguration
    }
}


