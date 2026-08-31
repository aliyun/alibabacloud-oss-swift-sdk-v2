import AlibabaCloudOSS
import Foundation
import XMLCoder


// MARK: - ListAccessPoints
extension Serde {
    static func serializeListAccessPoints (
        _ request: inout ListAccessPointsRequest,
        _ input: inout OperationInput
    ) throws {
        
        if let value = request.maxKeys {
            input.parameters["max-keys"] = String(value)
        }
        
        if let value = request.continuationToken {
            input.parameters["continuation-token"] = value
        }
        
    }

    static func deserializeListAccessPoints (
        _ result: inout ListAccessPointsResult,
        _ output: inout OperationOutput
    ) throws {
        
        guard let data = try output.body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }
        let listAccessPointsResult = try XMLDecoder().decode(ListAccessPointsResult.self, from: data)
        result.accessPoints = listAccessPointsResult.accessPoints
        result.accountId = listAccessPointsResult.accountId
        result.isTruncated = listAccessPointsResult.isTruncated
        result.maxKeys = listAccessPointsResult.maxKeys
        result.nextContinuationToken = listAccessPointsResult.nextContinuationToken
    }
}


// MARK: - GetAccessPoint
extension Serde {
    static func serializeGetAccessPoint (
        _ request: inout GetAccessPointRequest,
        _ input: inout OperationInput
    ) throws {
        
        if let value = request.accessPointName {
            input.headers["x-oss-access-point-name"] = value
        }
        
    }

    static func deserializeGetAccessPoint (
        _ result: inout GetAccessPointResult,
        _ output: inout OperationOutput
    ) throws {
        
        guard let data = try output.body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }
        let getAccessPointResult = try XMLDecoder().decode(GetAccessPointResult.self, from: data)
        result.accessPointArn = getAccessPointResult.accessPointArn
        result.accessPointName = getAccessPointResult.accessPointName
        result.accountId = getAccessPointResult.accountId
        result.alias = getAccessPointResult.alias
        result.bucket = getAccessPointResult.bucket
        result.creationDate = getAccessPointResult.creationDate
        result.networkOrigin = getAccessPointResult.networkOrigin
        result.status = getAccessPointResult.status
        result.endpoints = getAccessPointResult.endpoints
        result.publicAccessBlockConfiguration = getAccessPointResult.publicAccessBlockConfiguration
        result.vpcConfiguration = getAccessPointResult.vpcConfiguration
    }
}


// MARK: - GetAccessPointPolicy
extension Serde {
    static func serializeGetAccessPointPolicy (
        _ request: inout GetAccessPointPolicyRequest,
        _ input: inout OperationInput
    ) throws {
        
        if let value = request.accessPointName {
            input.headers["x-oss-access-point-name"] = value
        }
        
    }

    static func deserializeGetAccessPointPolicy (
        _ result: inout GetAccessPointPolicyResult,
        _ output: inout OperationOutput
    ) throws {
        result.body = output.body
    }
}


// MARK: - DeleteAccessPointPolicy
extension Serde {
    static func serializeDeleteAccessPointPolicy (
        _ request: inout DeleteAccessPointPolicyRequest,
        _ input: inout OperationInput
    ) throws {
        
        if let value = request.accessPointName {
            input.headers["x-oss-access-point-name"] = value
        }
        
    }

    static func deserializeDeleteAccessPointPolicy (
        _ result: inout DeleteAccessPointPolicyResult,
        _ output: inout OperationOutput
    ) throws {
        
    }
}


// MARK: - PutAccessPointPolicy
extension Serde {
    static func serializePutAccessPointPolicy (
        _ request: inout PutAccessPointPolicyRequest,
        _ input: inout OperationInput
    ) throws {
        
        if let value = request.accessPointName {
            input.headers["x-oss-access-point-name"] = value
        }
        
        input.body = request.body
        
    }

    static func deserializePutAccessPointPolicy (
        _ result: inout PutAccessPointPolicyResult,
        _ output: inout OperationOutput
    ) throws {
        
    }
}


// MARK: - DeleteAccessPoint
extension Serde {
    static func serializeDeleteAccessPoint (
        _ request: inout DeleteAccessPointRequest,
        _ input: inout OperationInput
    ) throws {
        
        if let value = request.accessPointName {
            input.headers["x-oss-access-point-name"] = value
        }
        
    }

    static func deserializeDeleteAccessPoint (
        _ result: inout DeleteAccessPointResult,
        _ output: inout OperationOutput
    ) throws {
        
    }
}


// MARK: - CreateAccessPoint
extension Serde {
    static func serializeCreateAccessPoint (
        _ request: inout CreateAccessPointRequest,
        _ input: inout OperationInput
    ) throws {
        
        let data: Data = try XMLEncoder().encode(request.createAccessPointConfiguration, withRootKey: "CreateAccessPointConfiguration")
        input.body = .data(data)
        
    }

    static func deserializeCreateAccessPoint (
        _ result: inout CreateAccessPointResult,
        _ output: inout OperationOutput
    ) throws {
        
        guard let data = try output.body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }
        let createAccessPointResult = try XMLDecoder().decode(CreateAccessPointResult.self, from: data)
        result.accessPointArn = createAccessPointResult.accessPointArn
        result.alias = createAccessPointResult.alias
    }
}


