import AlibabaCloudOSS
import Foundation
import XMLCoder


// MARK: - InitiateBucketWorm
extension Serde {
    static func serializeInitiateBucketWorm (
        _ request: inout InitiateBucketWormRequest,
        _ input: inout OperationInput
    ) throws -> Void {
        let data: Data = try XMLEncoder().encode(request.initiateWormConfiguration, withRootKey: "InitiateWormConfiguration")
        input.body = .data(data)
    }

    static func deserializeInitiateBucketWorm (
        _ result: inout InitiateBucketWormResult,
        _ output: inout OperationOutput
    ) throws -> Void {
         
    }
}


// MARK: - AbortBucketWorm
extension Serde {
    static func serializeAbortBucketWorm (
        _ request: inout AbortBucketWormRequest,
        _ input: inout OperationInput
    ) throws -> Void {
        
    }

    static func deserializeAbortBucketWorm (
        _ result: inout AbortBucketWormResult,
        _ output: inout OperationOutput
    ) throws -> Void {
        
    }
}


// MARK: - CompleteBucketWorm
extension Serde {
    static func serializeCompleteBucketWorm (
        _ request: inout CompleteBucketWormRequest,
        _ input: inout OperationInput
    ) throws -> Void {
        if let value = request.wormId {
            input.parameters["wormId"] = value
        }
        
    }

    static func deserializeCompleteBucketWorm (
        _ result: inout CompleteBucketWormResult,
        _ output: inout OperationOutput
    ) throws -> Void {
        
    }
}


// MARK: - ExtendBucketWorm
extension Serde {
    static func serializeExtendBucketWorm (
        _ request: inout ExtendBucketWormRequest,
        _ input: inout OperationInput
    ) throws -> Void {
        if let value = request.wormId {
            input.parameters["wormId"] = value
        }
        
        let data: Data = try XMLEncoder().encode(request.extendWormConfiguration, withRootKey: "ExtendWormConfiguration")
        input.body = .data(data)
    }

    static func deserializeExtendBucketWorm (
        _ result: inout ExtendBucketWormResult,
        _ output: inout OperationOutput
    ) throws -> Void {
        
    }
}


// MARK: - GetBucketWorm
extension Serde {
    static func serializeGetBucketWorm (
        _ request: inout GetBucketWormRequest,
        _ input: inout OperationInput
    ) throws -> Void {

    }

    static func deserializeGetBucketWorm (
        _ result: inout GetBucketWormResult,
        _ output: inout OperationOutput
    ) throws -> Void {
        
        guard let data = try output.body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }
        let wormConfiguration = try XMLDecoder().decode(WormConfiguration.self, from: data)
        result.wormConfiguration = wormConfiguration
    }
}


