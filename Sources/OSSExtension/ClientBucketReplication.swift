import Foundation
import AlibabaCloudOSS

extension Client {

    /// Enables or disables the Replication Time Control (RTC) feature for existing cross-region replication (CRR) rules.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func putBucketRtc(
        _ request: PutBucketRtcRequest,
        _ options: OperationOptions? = nil
    ) async throws -> PutBucketRtcResult {

        var input = OperationInput(
            operationName: "PutBucketRtc",
            method: "PUT",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "rtc": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        try request.rtcConfiguration.ensureRequired(field: "request.rtcConfiguration")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializePutBucketRtc, Serde.addContentMd5])

        var output = try await invokeOperation(input, options)

        var result = PutBucketRtcResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializePutBucketRtc])

        return result
    }
    
    /// Configures data replication rules for a bucket. Object Storage Service (OSS) supports cross-region replication (CRR) and same-region replication (SRR).
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func putBucketReplication(
        _ request: PutBucketReplicationRequest,
        _ options: OperationOptions? = nil
    ) async throws -> PutBucketReplicationResult {

        var input = OperationInput(
            operationName: "PutBucketReplication",
            method: "POST",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "comp": "add", 
                "replication": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        try request.replicationConfiguration.ensureRequired(field: "request.replicationConfiguration")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializePutBucketReplication, Serde.addContentMd5])

        var output = try await invokeOperation(input, options)

        var result = PutBucketReplicationResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializePutBucketReplication])

        return result
    }
    
    /// Queries the data replication rules configured for a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func getBucketReplication(
        _ request: GetBucketReplicationRequest,
        _ options: OperationOptions? = nil
    ) async throws -> GetBucketReplicationResult {

        var input = OperationInput(
            operationName: "GetBucketReplication",
            method: "GET",
            parameters: [ 
                "replication": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeGetBucketReplication, Serde.addContentMd5])

        var output = try await invokeOperation(input, options)

        var result = GetBucketReplicationResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketReplication])

        return result
    }
    
    /// Queries the regions in which available destination buckets reside. You can determine the region of the destination bucket to which the data in the source bucket are replicated based on the returned response.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func getBucketReplicationLocation(
        _ request: GetBucketReplicationLocationRequest,
        _ options: OperationOptions? = nil
    ) async throws -> GetBucketReplicationLocationResult {

        var input = OperationInput(
            operationName: "GetBucketReplicationLocation",
            method: "GET",
            parameters: [ 
                "replicationLocation": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeGetBucketReplicationLocation, Serde.addContentMd5])

        var output = try await invokeOperation(input, options)

        var result = GetBucketReplicationLocationResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketReplicationLocation])

        return result
    }
    
    /// Queries the information about the data replication process of a bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func getBucketReplicationProgress(
        _ request: GetBucketReplicationProgressRequest,
        _ options: OperationOptions? = nil
    ) async throws -> GetBucketReplicationProgressResult {

        var input = OperationInput(
            operationName: "GetBucketReplicationProgress",
            method: "GET",
            parameters: [ 
                "replicationProgress": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        try request.ruleId.ensureRequired(field: "request.ruleId")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeGetBucketReplicationProgress, Serde.addContentMd5])

        var output = try await invokeOperation(input, options)

        var result = GetBucketReplicationProgressResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketReplicationProgress])

        return result
    }
    
    /// Disables data replication for a bucket and deletes the data replication rule configured for the bucket. After you call this operation, all operations performed on the source bucket are not synchronized to the destination bucket.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func deleteBucketReplication(
        _ request: DeleteBucketReplicationRequest,
        _ options: OperationOptions? = nil
    ) async throws -> DeleteBucketReplicationResult {

        var input = OperationInput(
            operationName: "DeleteBucketReplication",
            method: "POST",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "comp": "delete", 
                "replication": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        try request.replicationRules.ensureRequired(field: "request.replicationRules")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeDeleteBucketReplication, Serde.addContentMd5])

        var output = try await invokeOperation(input, options)

        var result = DeleteBucketReplicationResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeDeleteBucketReplication])

        return result
    }
    
}
