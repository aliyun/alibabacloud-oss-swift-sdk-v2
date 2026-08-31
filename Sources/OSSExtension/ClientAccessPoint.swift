import AlibabaCloudOSS
import Foundation

extension Client {

    /// Queries the information about user-level or bucket-level access points.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func listAccessPoints(
        _ request: ListAccessPointsRequest,
        _ options: OperationOptions? = nil
    ) async throws -> ListAccessPointsResult {

        var input = OperationInput(
            operationName: "ListAccessPoints",
            method: "GET",
            parameters: [ 
                "accessPoint": "", 
            ]
        ) 

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeListAccessPoints, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = ListAccessPointsResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeListAccessPoints])

        return result
    }
    
    /// Queries the information about an access point.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func getAccessPoint(
        _ request: GetAccessPointRequest,
        _ options: OperationOptions? = nil
    ) async throws -> GetAccessPointResult {

        var input = OperationInput(
            operationName: "GetAccessPoint",
            method: "GET",
            parameters: [ 
                "accessPoint": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeGetAccessPoint, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = GetAccessPointResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetAccessPoint])

        return result
    }
    
    /// Queries the configurations of an access point policy.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func getAccessPointPolicy(
        _ request: GetAccessPointPolicyRequest,
        _ options: OperationOptions? = nil
    ) async throws -> GetAccessPointPolicyResult {

        var input = OperationInput(
            operationName: "GetAccessPointPolicy",
            method: "GET",
            parameters: [ 
                "accessPointPolicy": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeGetAccessPointPolicy, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = GetAccessPointPolicyResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetAccessPointPolicy])

        return result
    }
    
    /// Deletes an access point policy.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func deleteAccessPointPolicy(
        _ request: DeleteAccessPointPolicyRequest,
        _ options: OperationOptions? = nil
    ) async throws -> DeleteAccessPointPolicyResult {

        var input = OperationInput(
            operationName: "DeleteAccessPointPolicy",
            method: "DELETE",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "accessPointPolicy": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeDeleteAccessPointPolicy, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = DeleteAccessPointPolicyResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeDeleteAccessPointPolicy])

        return result
    }
    
    /// Configures an access point policy.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func putAccessPointPolicy(
        _ request: PutAccessPointPolicyRequest,
        _ options: OperationOptions? = nil
    ) async throws -> PutAccessPointPolicyResult {

        var input = OperationInput(
            operationName: "PutAccessPointPolicy",
            method: "PUT",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "accessPointPolicy": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializePutAccessPointPolicy, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = PutAccessPointPolicyResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializePutAccessPointPolicy])

        return result
    }
    
    /// Deletes an access point.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func deleteAccessPoint(
        _ request: DeleteAccessPointRequest,
        _ options: OperationOptions? = nil
    ) async throws -> DeleteAccessPointResult {

        var input = OperationInput(
            operationName: "DeleteAccessPoint",
            method: "DELETE",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "accessPoint": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeDeleteAccessPoint, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = DeleteAccessPointResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeDeleteAccessPoint])

        return result
    }
    
    /// Creates an access point.
    /// - Parameters:
    ///   - request: The request parameter to send
    ///   - request: Optional, operation options
    /// - Returns: The result instance.
    public func createAccessPoint(
        _ request: CreateAccessPointRequest,
        _ options: OperationOptions? = nil
    ) async throws -> CreateAccessPointResult {

        var input = OperationInput(
            operationName: "CreateAccessPoint",
            method: "PUT",
            headers: [
                "Content-Type": "application/xml"
            ],
            parameters: [ 
                "accessPoint": "", 
            ]
        ) 
        input.bucket = try request.bucket.ensureRequired(field: "request.bucket")
        try request.createAccessPointConfiguration.ensureRequired(field: "request.createAccessPointConfiguration")

        var req = request
        try Serde.serializeInput(&req, &input, [Serde.serializeCreateAccessPoint, Serde.addContentMd5])
        var output = try await invokeOperation(input, options)

        var result = CreateAccessPointResult()
        try Serde.deserializeOutput(&result, &output, [Serde.deserializeCreateAccessPoint])

        return result
    }
    
}
