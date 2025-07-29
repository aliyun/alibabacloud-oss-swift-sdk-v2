import AlibabaCloudOSS
import Foundation
import XMLCoder


// MARK: - PutBucketAccessMonitor
extension Serde {
    static func serializePutBucketAccessMonitor (
        _ request: inout PutBucketAccessMonitorRequest,
        _ input: inout OperationInput
    ) throws {
        
        let data: Data = try XMLEncoder().encode(request.accessMonitorConfiguration, withRootKey: "AccessMonitorConfiguration")
        input.body = .data(data)
        
    }

    static func deserializePutBucketAccessMonitor (
        _ result: inout PutBucketAccessMonitorResult,
        _ output: inout OperationOutput
    ) throws {
        
    }
}


// MARK: - GetBucketAccessMonitor
extension Serde {
    static func serializeGetBucketAccessMonitor (
        _ request: inout GetBucketAccessMonitorRequest,
        _ input: inout OperationInput
    ) throws {
        
    }

    static func deserializeGetBucketAccessMonitor (
        _ result: inout GetBucketAccessMonitorResult,
        _ output: inout OperationOutput
    ) throws {
        
        guard let data = try output.body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }
        let accessMonitorConfiguration = try XMLDecoder().decode(AccessMonitorConfiguration.self, from: data)
        result.accessMonitorConfiguration = accessMonitorConfiguration
         
    }
}


