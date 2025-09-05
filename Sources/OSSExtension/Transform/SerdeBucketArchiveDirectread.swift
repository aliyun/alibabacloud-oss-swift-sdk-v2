import AlibabaCloudOSS
import Foundation
import XMLCoder


// MARK: - GetBucketArchiveDirectRead
extension Serde {
    static func serializeGetBucketArchiveDirectRead (
        _ request: inout GetBucketArchiveDirectReadRequest,
        _ input: inout OperationInput
    ) throws {
        
    }

    static func deserializeGetBucketArchiveDirectRead (
        _ result: inout GetBucketArchiveDirectReadResult,
        _ output: inout OperationOutput
    ) throws {
        
        guard let data = try output.body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }
        let archiveDirectReadConfiguration = try XMLDecoder().decode(ArchiveDirectReadConfiguration.self, from: data)
        result.archiveDirectReadConfiguration = archiveDirectReadConfiguration
         
    }
}


// MARK: - PutBucketArchiveDirectRead
extension Serde {
    static func serializePutBucketArchiveDirectRead (
        _ request: inout PutBucketArchiveDirectReadRequest,
        _ input: inout OperationInput
    ) throws {
        
        let data: Data = try XMLEncoder().encode(request.archiveDirectReadConfiguration, withRootKey: "ArchiveDirectReadConfiguration")
        input.body = .data(data)
        
    }

    static func deserializePutBucketArchiveDirectRead (
        _ result: inout PutBucketArchiveDirectReadResult,
        _ output: inout OperationOutput
    ) throws {
        
    }
}


