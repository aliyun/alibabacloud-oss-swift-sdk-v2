import AlibabaCloudOSS
import Foundation
import XMLCoder


// MARK: - PutStyle
extension Serde {
    static func serializePutStyle (
        _ request: inout PutStyleRequest,
        _ input: inout OperationInput
    ) throws {
        
        if let value = request.styleName {
            input.parameters["styleName"] = value
        }
        
        if let value = request.category {
            input.parameters["category"] = value
        }
        
        let data: Data = try XMLEncoder().encode(request.style, withRootKey: "Style")
        input.body = .data(data)
        
    }

    static func deserializePutStyle (
        _ result: inout PutStyleResult,
        _ output: inout OperationOutput
    ) throws {
        
    }
}


// MARK: - ListStyle
extension Serde {
    static func serializeListStyle (
        _ request: inout ListStyleRequest,
        _ input: inout OperationInput
    ) throws {
        
    }

    static func deserializeListStyle (
        _ result: inout ListStyleResult,
        _ output: inout OperationOutput
    ) throws {
        
        guard let data = try output.body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }
        let styleList = try XMLDecoder().decode(StyleList.self, from: data)
        result.styleList = styleList
         
    }
}


// MARK: - GetStyle
extension Serde {
    static func serializeGetStyle (
        _ request: inout GetStyleRequest,
        _ input: inout OperationInput
    ) throws {
        
        if let value = request.styleName {
            input.parameters["styleName"] = value
        }
        
    }

    static func deserializeGetStyle (
        _ result: inout GetStyleResult,
        _ output: inout OperationOutput
    ) throws {
        
        guard let data = try output.body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }
        let style = try XMLDecoder().decode(StyleInfo.self, from: data)
        result.style = style
         
    }
}


// MARK: - DeleteStyle
extension Serde {
    static func serializeDeleteStyle (
        _ request: inout DeleteStyleRequest,
        _ input: inout OperationInput
    ) throws {
        
        if let value = request.styleName {
            input.parameters["styleName"] = value
        }
        
    }

    static func deserializeDeleteStyle (
        _ result: inout DeleteStyleResult,
        _ output: inout OperationOutput
    ) throws {
        
    }
}


