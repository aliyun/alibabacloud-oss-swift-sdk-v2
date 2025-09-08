import AlibabaCloudOSS
import Foundation



/// Indicates the container for the payer.
public struct RequestPaymentConfiguration: Sendable {

    /// Indicates who pays the download and request fees.
    public var payer: Swift.String?

    public init( 
        payer: Swift.String? = nil
    ) { 
        self.payer = payer
    }
}

extension RequestPaymentConfiguration: Codable {
    enum CodingKeys: String, CodingKey { 
        case payer = "Payer"
    
    }
}




/// The request for the PutBucketRequestPayment operation.
public struct PutBucketRequestPaymentRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// The request body schema.
    public var requestPaymentConfiguration: RequestPaymentConfiguration?
    

    public init( 
        bucket: Swift.String? = nil,
        requestPaymentConfiguration: RequestPaymentConfiguration? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.requestPaymentConfiguration = requestPaymentConfiguration
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the PutBucketRequestPayment operation.
public struct PutBucketRequestPaymentResult : ResultModel {
    public var commonProp: ResultModelProp = .init()

}

/// The request for the GetBucketRequestPayment operation.
public struct GetBucketRequestPaymentRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    

    public init( 
        bucket: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the GetBucketRequestPayment operation.
public struct GetBucketRequestPaymentResult : ResultModel {
    public var commonProp: ResultModelProp = .init()
 
    /// Indicates the container for the payer.
    public var requestPaymentConfiguration: RequestPaymentConfiguration?
     
}

