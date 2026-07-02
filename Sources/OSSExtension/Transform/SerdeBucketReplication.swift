import Foundation
import AlibabaCloudOSS
import XMLCoder

// MARK: - PutBucketRtc
extension Serde {
    static func serializePutBucketRtc (
        _ request: inout PutBucketRtcRequest,
        _ input: inout OperationInput
    ) throws -> Void {
        let data: Data = try XMLEncoder().encode(request.rtcConfiguration, withRootKey: "ReplicationRule")
        input.body = .data(data)
    }

    static func deserializePutBucketRtc (
        _ result: inout PutBucketRtcResult,
        _ output: inout OperationOutput
    ) throws -> Void {
        
    }
}


// MARK: - PutBucketReplication
extension Serde {
    static func serializePutBucketReplication (
        _ request: inout PutBucketReplicationRequest,
        _ input: inout OperationInput
    ) throws -> Void {
        let data: Data = try XMLEncoder().encode(request.replicationConfiguration, withRootKey: "ReplicationConfiguration")
        input.body = .data(data)
    }

    static func deserializePutBucketReplication (
        _ result: inout PutBucketReplicationResult,
        _ output: inout OperationOutput
    ) throws -> Void {
         
    }
}


// MARK: - GetBucketReplication
extension Serde {
    static func serializeGetBucketReplication (
        _ request: inout GetBucketReplicationRequest,
        _ input: inout OperationInput
    ) throws -> Void {
        
    }

    static func deserializeGetBucketReplication (
        _ result: inout GetBucketReplicationResult,
        _ output: inout OperationOutput
    ) throws -> Void {
        guard let data = try output.body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }
        let replicationConfiguration = try XMLDecoder().decode(ReplicationConfiguration.self, from: data)
        result.replicationConfiguration = replicationConfiguration
    }
}


// MARK: - GetBucketReplicationLocation
extension Serde {
    static func serializeGetBucketReplicationLocation (
        _ request: inout GetBucketReplicationLocationRequest,
        _ input: inout OperationInput
    ) throws -> Void {
        
    }

    static func deserializeGetBucketReplicationLocation (
        _ result: inout GetBucketReplicationLocationResult,
        _ output: inout OperationOutput
    ) throws -> Void {
        guard let data = try output.body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }
        let replicationLocation = try XMLDecoder().decode(ReplicationLocation.self, from: data)
        result.replicationLocation = replicationLocation
    }
}


// MARK: - GetBucketReplicationProgress
extension Serde {
    static func serializeGetBucketReplicationProgress (
        _ request: inout GetBucketReplicationProgressRequest,
        _ input: inout OperationInput
    ) throws -> Void {
        if let value = request.ruleId {
            input.parameters["rule-id"] = value
        }
    }

    static func deserializeGetBucketReplicationProgress (
        _ result: inout GetBucketReplicationProgressResult,
        _ output: inout OperationOutput
    ) throws -> Void {
        guard let data = try output.body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }
        let replicationProgress = try XMLDecoder().decode(ReplicationProgress.self, from: data)
        result.replicationProgress = replicationProgress
    }
}


// MARK: - DeleteBucketReplication
extension Serde {
    static func serializeDeleteBucketReplication (
        _ request: inout DeleteBucketReplicationRequest,
        _ input: inout OperationInput
    ) throws -> Void {
        let data: Data = try XMLEncoder().encode(request.replicationRules, withRootKey: "ReplicationRules")
        input.body = .data(data)
    }

    static func deserializeDeleteBucketReplication (
        _ result: inout DeleteBucketReplicationResult,
        _ output: inout OperationOutput
    ) throws -> Void {
        
    }
}


