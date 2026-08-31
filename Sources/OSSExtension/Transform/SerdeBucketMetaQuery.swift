import AlibabaCloudOSS
import Foundation
import XMLCoder


// MARK: - GetMetaQueryStatus
extension Serde {
    static func serializeGetMetaQueryStatus (
        _ request: inout GetMetaQueryStatusRequest,
        _ input: inout OperationInput
    ) throws {
        
    }

    static func deserializeGetMetaQueryStatus (
        _ result: inout GetMetaQueryStatusResult,
        _ output: inout OperationOutput
    ) throws {
        
        guard let data = try output.body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }
        let metaQueryStatus = try XMLDecoder().decode(MetaQueryStatus.self, from: data)
        result.metaQueryStatus = metaQueryStatus
         
    }
}


// MARK: - CloseMetaQuery
extension Serde {
    static func serializeCloseMetaQuery (
        _ request: inout CloseMetaQueryRequest,
        _ input: inout OperationInput
    ) throws {
        
    }

    static func deserializeCloseMetaQuery (
        _ result: inout CloseMetaQueryResult,
        _ output: inout OperationOutput
    ) throws {
        
    }
}


// MARK: - DoMetaQuery
extension Serde {
    static func serializeDoMetaQuery (
        _ request: inout DoMetaQueryRequest,
        _ input: inout OperationInput
    ) throws {
        
        if let value = request.mode {
            input.parameters["mode"] = value
        }
        
        let data: Data = try XMLEncoder().encode(request.metaQuery, withRootKey: "MetaQuery")
        input.body = .data(data)
        
    }

    static func deserializeDoMetaQuery (
        _ result: inout DoMetaQueryResult,
        _ output: inout OperationOutput
    ) throws {
        
        guard let data = try output.body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }
        let metaQuery = try XMLDecoder().decode(MetaQueryResp.self, from: data)
        result.metaQuery = metaQuery
         
    }
}


// MARK: - OpenMetaQuery
extension Serde {
    static func serializeOpenMetaQuery (
        _ request: inout OpenMetaQueryRequest,
        _ input: inout OperationInput
    ) throws {
        
        if let value = request.mode {
            input.parameters["mode"] = value
        }
        
    }

    static func deserializeOpenMetaQuery (
        _ result: inout OpenMetaQueryResult,
        _ output: inout OperationOutput
    ) throws {
        
    }
}


