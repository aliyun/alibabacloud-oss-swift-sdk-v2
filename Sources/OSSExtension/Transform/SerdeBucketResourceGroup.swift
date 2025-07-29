import AlibabaCloudOSS
import Foundation
import XMLCoder


// MARK: - GetBucketResourceGroup
extension Serde {
    static func serializeGetBucketResourceGroup (
        _ request: inout GetBucketResourceGroupRequest,
        _ input: inout OperationInput
    ) throws {
        
    }

    static func deserializeGetBucketResourceGroup (
        _ result: inout GetBucketResourceGroupResult,
        _ output: inout OperationOutput
    ) throws {
        
        guard let data = try output.body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }
        let bucketResourceGroupConfiguration = try XMLDecoder().decode(BucketResourceGroupConfiguration.self, from: data)
        result.bucketResourceGroupConfiguration = bucketResourceGroupConfiguration
         
    }
}


// MARK: - PutBucketResourceGroup
extension Serde {
    static func serializePutBucketResourceGroup (
        _ request: inout PutBucketResourceGroupRequest,
        _ input: inout OperationInput
    ) throws {
        
        let data: Data = try XMLEncoder().encode(request.bucketResourceGroupConfiguration, withRootKey: "BucketResourceGroupConfiguration")
        input.body = .data(data)
        
    }

    static func deserializePutBucketResourceGroup (
        _ result: inout PutBucketResourceGroupResult,
        _ output: inout OperationOutput
    ) throws {
        
    }
}


