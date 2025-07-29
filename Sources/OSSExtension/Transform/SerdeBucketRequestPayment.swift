import AlibabaCloudOSS
import Foundation
import XMLCoder


// MARK: - PutBucketRequestPayment
extension Serde {
    static func serializePutBucketRequestPayment (
        _ request: inout PutBucketRequestPaymentRequest,
        _ input: inout OperationInput
    ) throws {
        
        let data: Data = try XMLEncoder().encode(request.requestPaymentConfiguration, withRootKey: "RequestPaymentConfiguration")
        input.body = .data(data)
        
    }

    static func deserializePutBucketRequestPayment (
        _ result: inout PutBucketRequestPaymentResult,
        _ output: inout OperationOutput
    ) throws {
        
    }
}


// MARK: - GetBucketRequestPayment
extension Serde {
    static func serializeGetBucketRequestPayment (
        _ request: inout GetBucketRequestPaymentRequest,
        _ input: inout OperationInput
    ) throws {
        
    }

    static func deserializeGetBucketRequestPayment (
        _ result: inout GetBucketRequestPaymentResult,
        _ output: inout OperationOutput
    ) throws {
        
        guard let data = try output.body?.readData() else {
            throw ClientError.parseResponseBodyError(info: "Can not get response body.")
        }
        let requestPaymentConfiguration = try XMLDecoder().decode(RequestPaymentConfiguration.self, from: data)
        result.requestPaymentConfiguration = requestPaymentConfiguration
         
    }
}


