import AlibabaCloudOSS
import Foundation



/// The container that stores the information about an access point.
public struct CreateAccessPointConfiguration: Sendable {

    /// The name of the access point. The name of the access point must meet the following naming rules:
    /// *   The name must be unique in a region of your Alibaba Cloud account.
    /// *   The name cannot end with -ossalias.
    /// *   The name can contain only lowercase letters, digits, and hyphens (-). It cannot start or end with a hyphen (-).
    /// *   The name must be 3 to 19 characters in length.
    public var accessPointName: Swift.String?

    /// The network origin of the access point.
    public var networkOrigin: Swift.String?

    /// The container that stores the information about the VPC.
    public var vpcConfiguration: AccessPointVpcConfiguration?

    public init( 
        accessPointName: Swift.String? = nil,
        networkOrigin: Swift.String? = nil,
        vpcConfiguration: AccessPointVpcConfiguration? = nil,
    ) { 
        self.accessPointName = accessPointName
        self.networkOrigin = networkOrigin
        self.vpcConfiguration = vpcConfiguration
    }
}

extension CreateAccessPointConfiguration: Codable {
    enum CodingKeys: String, CodingKey { 
        case accessPointName = "AccessPointName"
    
        case networkOrigin = "NetworkOrigin"
    
        case vpcConfiguration = "VpcConfiguration"
    
    }
}


/// The container that stores the information about the VPC.
public struct AccessPointVpcConfiguration: Sendable {

    /// The ID of the VPC that is required only when the NetworkOrigin parameter is set to vpc.
    public var vpcId: Swift.String?

    public init( 
        vpcId: Swift.String? = nil,
    ) { 
        self.vpcId = vpcId
    }
}

extension AccessPointVpcConfiguration: Codable {
    enum CodingKeys: String, CodingKey { 
        case vpcId = "VpcId"
    
    }
}


/// The container that stores the information about all access points.
public struct AccessPoints: Sendable {

    /// The container that stores the information about all access point.
    public var accessPoints: [AccessPoint]?

    public init( 
        accessPoints: [AccessPoint]? = nil,
    ) { 
        self.accessPoints = accessPoints
    }
}

extension AccessPoints: Codable {
    enum CodingKeys: String, CodingKey { 
        case accessPoints = "AccessPoint"
    
    }
}

/// The container that stores the network origin information about the access point.
public struct Endpoints: Sendable {

    /// The public endpoint of the access point.
    public var publicEndpoint: Swift.String?

    /// 接入点的内网Endpoint。
    public var internalEndpoint: Swift.String?

    public init( 
        publicEndpoint: Swift.String? = nil,
        internalEndpoint: Swift.String? = nil,
    ) { 
        self.publicEndpoint = publicEndpoint
        self.internalEndpoint = internalEndpoint
    }
}

extension Endpoints: Codable {
    enum CodingKeys: String, CodingKey { 
        case publicEndpoint = "PublicEndpoint"
    
        case internalEndpoint = "InternalEndpoint"
    
    }
}


/// The result for the GetAccessPoint operation.
public struct GetAccessPointResult : ResultModel {
    public var commonProp: ResultModelProp = .init()

    /// The name of the bucket for which the access point is configured.
    public var bucket: Swift.String?

    /// 接入点创建时间。
    public var creationDate: Swift.String?

    /// The alias of the access point.
    public var alias: Swift.String?

    /// The status of the access point.
    public var status: Swift.String?

    /// The container that stores the network origin information about the access point.
    public var endpoints: Endpoints?

    /// The name of the access point.
    public var accessPointName: Swift.String?

    /// The ID of the Alibaba Cloud account for which the access point is configured.
    public var accountId: Swift.String?

    /// The network origin of the access point.
    /// Valid values: vpc and internet.
    /// vpc: You can only use the specified VPC ID to access the access point.
    /// internet: You can use public endpoints and internal endpoints to access the access point.
    public var networkOrigin: Swift.String?

    /// The container that stores the information about the VPC.
    public var vpcConfiguration: AccessPointVpcConfiguration?

    /// The ARN of the access point.
    public var accessPointArn: Swift.String?

    /// 保存接入点阻止公共访问的配置
    public var publicAccessBlockConfiguration: PublicAccessBlockConfiguration?

    public init( 
        bucket: Swift.String? = nil,
        creationDate: Swift.String? = nil,
        alias: Swift.String? = nil,
        status: Swift.String? = nil,
        endpoints: Endpoints? = nil,
        accessPointName: Swift.String? = nil,
        accountId: Swift.String? = nil,
        networkOrigin: Swift.String? = nil,
        vpcConfiguration: AccessPointVpcConfiguration? = nil,
        accessPointArn: Swift.String? = nil,
        publicAccessBlockConfiguration: PublicAccessBlockConfiguration? = nil,
    ) { 
        self.bucket = bucket
        self.creationDate = creationDate
        self.alias = alias
        self.status = status
        self.endpoints = endpoints
        self.accessPointName = accessPointName
        self.accountId = accountId
        self.networkOrigin = networkOrigin
        self.vpcConfiguration = vpcConfiguration
        self.accessPointArn = accessPointArn
        self.publicAccessBlockConfiguration = publicAccessBlockConfiguration
    }
}

extension GetAccessPointResult: Codable {
    enum CodingKeys: String, CodingKey { 
        case bucket = "Bucket"
    
        case creationDate = "CreationDate"
    
        case alias = "Alias"
    
        case status = "Status"
    
        case endpoints = "Endpoints"
    
        case accessPointName = "AccessPointName"
    
        case accountId = "AccountId"
    
        case networkOrigin = "NetworkOrigin"
    
        case vpcConfiguration = "VpcConfiguration"
    
        case accessPointArn = "AccessPointArn"
    
        case publicAccessBlockConfiguration = "PublicAccessBlockConfiguration"
    
    }
}


/// The container that stores the information about an access point.
public struct AccessPoint: Sendable {

    /// The container that stores the information about the VPC.
    public var vpcConfiguration: AccessPointVpcConfiguration?

    /// The status of the access point.
    public var status: Swift.String?

    /// The name of the bucket for which the access point is configured.
    public var bucket: Swift.String?

    /// The name of the access point.
    public var accessPointName: Swift.String?

    /// The alias of the access point.
    public var alias: Swift.String?

    /// The network origin of the access point.
    public var networkOrigin: Swift.String?

    public init( 
        vpcConfiguration: AccessPointVpcConfiguration? = nil,
        status: Swift.String? = nil,
        bucket: Swift.String? = nil,
        accessPointName: Swift.String? = nil,
        alias: Swift.String? = nil,
        networkOrigin: Swift.String? = nil,
    ) { 
        self.vpcConfiguration = vpcConfiguration
        self.status = status
        self.bucket = bucket
        self.accessPointName = accessPointName
        self.alias = alias
        self.networkOrigin = networkOrigin
    }
}

extension AccessPoint: Codable {
    enum CodingKeys: String, CodingKey { 
        case vpcConfiguration = "VpcConfiguration"
    
        case status = "Status"
    
        case bucket = "Bucket"
    
        case accessPointName = "AccessPointName"
    
        case alias = "Alias"
    
        case networkOrigin = "NetworkOrigin"
    
    }
}


/// The result for the CreateAccessPoint operation.
public struct CreateAccessPointResult : ResultModel {
    public var commonProp: ResultModelProp = .init()
 
    /// The Alibaba Cloud Resource Name (ARN) of the access point.
    public var accessPointArn: Swift.String?

    /// The alias of the access point.
    public var alias: Swift.String?

    public init( 
        accessPointArn: Swift.String? = nil,
        alias: Swift.String? = nil,
    ) { 
        self.accessPointArn = accessPointArn
        self.alias = alias
    }
}

extension CreateAccessPointResult: Codable {
    enum CodingKeys: String, CodingKey { 
        case accessPointArn = "AccessPointArn"
    
        case alias = "Alias"
    
    }
}




/// The request for the ListAccessPoints operation.
public struct ListAccessPointsRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The maximum number of access points that can be returned.
    /// Valid values:
    /// *   For user-level access points: (0,1000].
    /// *   For bucket-level access points: (0,100].
    public var maxKeys: Swift.Int?
    
    /// The token from which the listing operation starts. You must specify the value of NextContinuationToken that is obtained from the previous query as the value of continuation-token.
    public var continuationToken: Swift.String?
    

    public init( 
        maxKeys: Swift.Int? = nil,
        continuationToken: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.maxKeys = maxKeys
        self.continuationToken = continuationToken
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the ListAccessPoints operation.
public struct ListAccessPointsResult : ResultModel {
    public var commonProp: ResultModelProp = .init()
 
    /// Indicates whether the returned list is truncated.
    /// Valid values:
    /// * true: indicates that not all results are returned.
    /// * false: indicates that all results are returned.
    public var isTruncated: Swift.Bool?

    /// Indicates that this ListAccessPoints request does not return all results that can be listed. You can use NextContinuationToken to continue obtaining list results.
    public var nextContinuationToken: Swift.String?

    /// The ID of the Alibaba Cloud account to which the access point belongs.
    public var accountId: Swift.String?

    /// The container that stores the information about all access points.
    public var accessPoints: AccessPoints?

    /// The maximum number of results set for this enumeration operation.
    public var maxKeys: Swift.Int?

    public init(
        isTruncated: Swift.Bool? = nil,
        nextContinuationToken: Swift.String? = nil,
        accountId: Swift.String? = nil,
        accessPoints: AccessPoints? = nil,
        maxKeys: Swift.Int? = nil,
    ) {
        self.isTruncated = isTruncated
        self.nextContinuationToken = nextContinuationToken
        self.accountId = accountId
        self.accessPoints = accessPoints
        self.maxKeys = maxKeys
    }
}

extension ListAccessPointsResult: Codable {
    enum CodingKeys: String, CodingKey {
        case isTruncated = "IsTruncated"
    
        case nextContinuationToken = "NextContinuationToken"
    
        case accountId = "AccountId"
    
        case accessPoints = "AccessPoints"
    
        case maxKeys = "MaxKeys"
    
    }
}

/// The request for the GetAccessPoint operation.
public struct GetAccessPointRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// The name of the access point.
    public var accessPointName: Swift.String?
    

    public init( 
        bucket: Swift.String? = nil,
        accessPointName: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.accessPointName = accessPointName
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The request for the GetAccessPointPolicy operation.
public struct GetAccessPointPolicyRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// The name of the access point.
    public var accessPointName: Swift.String?
    

    public init( 
        bucket: Swift.String? = nil,
        accessPointName: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.accessPointName = accessPointName
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the GetAccessPointPolicy operation.
public struct GetAccessPointPolicyResult : ResultModel {
    public var commonProp: ResultModelProp = .init()
 
    /// <no value>
    public var body: ByteStream?
     
}

/// The request for the DeleteAccessPointPolicy operation.
public struct DeleteAccessPointPolicyRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// The name of the access point.
    public var accessPointName: Swift.String?
    

    public init( 
        bucket: Swift.String? = nil,
        accessPointName: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.accessPointName = accessPointName
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the DeleteAccessPointPolicy operation.
public struct DeleteAccessPointPolicyResult : ResultModel {
    public var commonProp: ResultModelProp = .init()

}

/// The request for the PutAccessPointPolicy operation.
public struct PutAccessPointPolicyRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// The name of the access point.
    public var accessPointName: Swift.String?
    
    /// The configurations of the access point policy.
    public var body: ByteStream?
    

    public init( 
        bucket: Swift.String? = nil,
        accessPointName: Swift.String? = nil,
        body: ByteStream? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.accessPointName = accessPointName
        self.body = body
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the PutAccessPointPolicy operation.
public struct PutAccessPointPolicyResult : ResultModel {
    public var commonProp: ResultModelProp = .init()

}

/// The request for the DeleteAccessPoint operation.
public struct DeleteAccessPointRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// The name of the access point.
    public var accessPointName: Swift.String?
    

    public init( 
        bucket: Swift.String? = nil,
        accessPointName: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.accessPointName = accessPointName
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the DeleteAccessPoint operation.
public struct DeleteAccessPointResult : ResultModel {
    public var commonProp: ResultModelProp = .init()

}

/// The request for the CreateAccessPoint operation.
public struct CreateAccessPointRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// The container of the request body.
    public var createAccessPointConfiguration: CreateAccessPointConfiguration?
    

    public init( 
        bucket: Swift.String? = nil,
        createAccessPointConfiguration: CreateAccessPointConfiguration? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.createAccessPointConfiguration = createAccessPointConfiguration
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

