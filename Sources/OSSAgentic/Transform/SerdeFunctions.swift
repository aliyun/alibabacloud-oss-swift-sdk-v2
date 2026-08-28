
import AlibabaCloudOSS
import Foundation

typealias SerdeSerializeDelegate<T: RequestModel> = (_ request: inout T, _ input: inout OperationInput) throws -> Void

typealias SerdeDeserializeDelegate<T: ResultModel> = (_ result: inout T, _ output: inout OperationOutput) throws -> Void

protocol SerdeSerializeXml {
    func asXml() throws -> Data
}

class Serde {
    static func serializeInput<T: RequestModel>(
        _ request: inout T,
        _ input: inout OperationInput,
        _ customSerializers: [SerdeSerializeDelegate<T>] = []
    ) throws -> Void {
        // Headers
        request.commonProp.headers?.forEach { key, value in
            input.headers[key] = value
        }

        // Parameters
        request.commonProp.parameters?.forEach { key, value in
            input.parameters[key] = value
        }

        // body
        if let xmlRequest = request as? SerdeSerializeXml {
            input.body = try .data(xmlRequest.asXml())
        }

        // custom serializer
        for serializer in customSerializers {
            try serializer(&request, &input)
        }
    }

    static func addContentMd5<T: RequestModel>(_: inout T, _ input: inout OperationInput) throws -> Void {
        guard input.headers[caseInsensitive: "Content-MD5"] == nil else {
            return
        }
        switch input.body {
        case let .data(data):
            input.headers["Content-MD5"] = data.calculateMd5().base64EncodedString(options: .lineLength64Characters)
        default:
            return
        }
    }

    static func addContentType<T: RequestModel>(_: inout T, _ input: inout OperationInput) throws -> Void {
        guard input.headers[caseInsensitive: "Content-Type"] == nil else {
            return
        }

        var value: String? = nil

        if let key = input.key,
           let contentType = MimeUtils.getMimeType(fileName: key)
        {
            value = contentType
        }
        if value == nil {
            switch input.body {
            case let .file(file):
                value = MimeUtils.getMimeType(fileURL: file)
            default:
                value = "application/octet-stream"
            }
        }
        input.headers["Content-Type"] = value ?? "application/octet-stream"
    }

    static func deserializeOutput<T: ResultModel>(
        _ result: inout T,
        _ output: inout OperationOutput,
        _ customDeserializers: [SerdeDeserializeDelegate<T>] = []
    ) throws -> Void {
        // common properties
        result.commonProp.statusCode = output.statusCode
        result.commonProp.headers = output.headers

        // custom serializer
        for deserializer in customDeserializers {
            try deserializer(&result, &output)
        }
    }

    static func deserializeXml<T>(
        _ body: ByteStream?,
        _ xmlRoot: String
    ) throws -> T {
        if xmlRoot == "" {
            throw ClientError.paramNullOrEmptyError(field: "xmlRoot")
        }

        // should not be nil, and ignore the error
        guard let data = try? body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }

        let (root, error) = Dictionary<String, Any>.withXMLDataError(data: data)
        if let error = error {
            throw ClientError.parseResponseBodyError(
                info: "Parse response body fail.",
                snapshot: data,
                innerError: error
            )
        }

        guard let element = root[xmlRoot] as? T else {
            throw ClientError.parseResponseBodyError(
                info: "Not found root tag <\(xmlRoot)>.",
                snapshot: data
            )
        }

        return element
    }
}
