import AlibabaCloudOSS
import Foundation
import XMLCoder

// MARK: - PutBucketLifecycle
extension Serde {
    static func serializePutBucketLifecycle (
        _ request: inout PutBucketLifecycleRequest,
        _ input: inout OperationInput
    ) throws -> Void {
        if let value = request.allowSameActionOverlap {
            input.headers["x-oss-allow-same-action-overlap"] = value
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let encoder = XMLEncoder()
        encoder.dateEncodingStrategy = .formatted(formatter)
        let data: Data = try encoder.encode(request.lifecycleConfiguration, withRootKey: "LifecycleConfiguration")
        input.body = .data(data)
    }

    static func deserializePutBucketLifecycle (
        _ result: inout PutBucketLifecycleResult,
        _ output: inout OperationOutput
    ) throws -> Void {
        
    }
}


// MARK: - GetBucketLifecycle
extension Serde {
    static func serializeGetBucketLifecycle (
        _ request: inout GetBucketLifecycleRequest,
        _ input: inout OperationInput
    ) throws -> Void {

    }

    static func deserializeGetBucketLifecycle (
        _ result: inout GetBucketLifecycleResult,
        _ output: inout OperationOutput
    ) throws -> Void {
        guard let data = try output.body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let decoder = XMLDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        let lifecycleConfiguration = try decoder.decode(LifecycleConfiguration.self, from: data)
        result.lifecycleConfiguration = lifecycleConfiguration
    }
}


// MARK: - DeleteBucketLifecycle
extension Serde {
    static func serializeDeleteBucketLifecycle (
        _ request: inout DeleteBucketLifecycleRequest,
        _ input: inout OperationInput
    ) throws -> Void {

    }

    static func deserializeDeleteBucketLifecycle (
        _ result: inout DeleteBucketLifecycleResult,
        _ output: inout OperationOutput
    ) throws -> Void {
        
    }
}


