import AlibabaCloudOSS
import Foundation
import XMLCoder


// MARK: - ListBucketDataRedundancyTransition
extension Serde {
    static func serializeListBucketDataRedundancyTransition (
        _ request: inout ListBucketDataRedundancyTransitionRequest,
        _ input: inout OperationInput
    ) throws {
        
    }

    static func deserializeListBucketDataRedundancyTransition (
        _ result: inout ListBucketDataRedundancyTransitionResult,
        _ output: inout OperationOutput
    ) throws {
        
        guard let data = try output.body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }
        let listBucketDataRedundancyTransition = try XMLDecoder().decode(ListBucketDataRedundancyTransition.self, from: data)
        result.listBucketDataRedundancyTransition = listBucketDataRedundancyTransition
         
    }
}


// MARK: - GetBucketDataRedundancyTransition
extension Serde {
    static func serializeGetBucketDataRedundancyTransition (
        _ request: inout GetBucketDataRedundancyTransitionRequest,
        _ input: inout OperationInput
    ) throws {
        
        if let value = request.redundancyTransitionTaskid {
            input.parameters["x-oss-redundancy-transition-taskid"] = value
        }
        
    }

    static func deserializeGetBucketDataRedundancyTransition (
        _ result: inout GetBucketDataRedundancyTransitionResult,
        _ output: inout OperationOutput
    ) throws {
        
        guard let data = try output.body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }
        let bucketDataRedundancyTransition = try XMLDecoder().decode(BucketDataRedundancyTransition.self, from: data)
        result.bucketDataRedundancyTransition = bucketDataRedundancyTransition
         
    }
}


// MARK: - CreateBucketDataRedundancyTransition
extension Serde {
    static func serializeCreateBucketDataRedundancyTransition (
        _ request: inout CreateBucketDataRedundancyTransitionRequest,
        _ input: inout OperationInput
    ) throws {
        
        if let value = request.targetRedundancyType {
            input.parameters["x-oss-target-redundancy-type"] = value
        }
        
    }

    static func deserializeCreateBucketDataRedundancyTransition (
        _ result: inout CreateBucketDataRedundancyTransitionResult,
        _ output: inout OperationOutput
    ) throws {
        
        guard let data = try output.body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }
        let bucketDataRedundancyTransition = try XMLDecoder().decode(BucketDataRedundancyTransition.self, from: data)
        result.bucketDataRedundancyTransition = bucketDataRedundancyTransition
         
    }
}


// MARK: - DeleteBucketDataRedundancyTransition
extension Serde {
    static func serializeDeleteBucketDataRedundancyTransition (
        _ request: inout DeleteBucketDataRedundancyTransitionRequest,
        _ input: inout OperationInput
    ) throws {
        
        if let value = request.redundancyTransitionTaskid {
            input.parameters["x-oss-redundancy-transition-taskid"] = value
        }
        
    }

    static func deserializeDeleteBucketDataRedundancyTransition (
        _ result: inout DeleteBucketDataRedundancyTransitionResult,
        _ output: inout OperationOutput
    ) throws {
        
    }
}

// MARK: - ListUserDataRedundancyTransition
extension Serde {
    static func serializeListUserDataRedundancyTransition (
        _ request: inout ListUserDataRedundancyTransitionRequest,
        _ input: inout OperationInput
    ) throws {
        if let value = request.continuationToken {
            input.parameters["continuation-token"] = value
        }
        if let value = request.maxKeys {
            input.parameters["max-keys"] = String(value)
        }
    }

    static func deserializeListUserDataRedundancyTransition (
        _ result: inout ListUserDataRedundancyTransitionResult,
        _ output: inout OperationOutput
    ) throws {
        
        guard let data = try output.body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }
        let listBucketDataRedundancyTransition = try XMLDecoder().decode(ListBucketDataRedundancyTransition.self, from: data)
        result.listBucketDataRedundancyTransition = listBucketDataRedundancyTransition
         
    }
}
