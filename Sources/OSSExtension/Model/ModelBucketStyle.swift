import AlibabaCloudOSS
import Foundation



/// The container that stores style infomration.
public struct StyleInfo: Sendable {

    /// The time when the style was last modified.
    public var lastModifyTime: Swift.String?

    /// The category of this style。
    /// Invalid value：image、document、video。
    public var category: Swift.String?

    /// The style name.
    public var name: Swift.String?

    /// The content of the style.
    public var content: Swift.String?

    /// The time when the style was created.
    public var createTime: Swift.String?

    public init( 
        name: Swift.String? = nil,
        lastModifyTime: Swift.String? = nil,
        category: Swift.String? = nil,
        content: Swift.String? = nil,
        createTime: Swift.String? = nil,
    ) { 
        self.lastModifyTime = lastModifyTime
        self.category = category
        self.name = name
        self.content = content
        self.createTime = createTime
    }
}

extension StyleInfo: Codable {
    enum CodingKeys: String, CodingKey { 
        case lastModifyTime = "LastModifyTime"
    
        case category = "Category"
    
        case name = "Name"
    
        case content = "Content"
    
        case createTime = "CreateTime"
    
    }
}


/// The container that was used to query the information about image styles.
public struct StyleList: Sendable {

    /// The list of styles.
    public var styles: [StyleInfo]?

    public init( 
        styles: [StyleInfo]? = nil,
    ) { 
        self.styles = styles
    }
}

extension StyleList: Codable {
    enum CodingKeys: String, CodingKey { 
        case styles = "Style"
    
    }
}

public struct StyleContent: Sendable {
    
    // The content of the style.
    public var content: String?
    
    public init(
        content: String? = nil
    ) {
        self.content = content
    }
}

extension StyleContent: Codable {
    enum CodingKeys: String, CodingKey {
        case content = "Content"
    }
}

/// The request for the PutStyle operation.
public struct PutStyleRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// The name of the image style.
    public var styleName: Swift.String?
    
    /// The category of the style.
    public var category: Swift.String?
    
    /// The container that stores the content information about the image style.
    public var style: StyleContent?
    

    public init( 
        bucket: Swift.String? = nil,
        styleName: Swift.String? = nil,
        category: Swift.String? = nil,
        style: StyleContent? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.styleName = styleName
        self.category = category
        self.style = style
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the PutStyle operation.
public struct PutStyleResult : ResultModel {
    public var commonProp: ResultModelProp = .init()

}

/// The request for the ListStyle operation.
public struct ListStyleRequest : RequestModel {
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

/// The result for the ListStyle operation.
public struct ListStyleResult : ResultModel {
    public var commonProp: ResultModelProp = .init()
 
    /// The container that was used to query the information about image styles.
    public var styleList: StyleList?
     
}

/// The request for the GetStyle operation.
public struct GetStyleRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// The name of the image style.
    public var styleName: Swift.String?
    

    public init( 
        bucket: Swift.String? = nil,
        styleName: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.styleName = styleName
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the GetStyle operation.
public struct GetStyleResult : ResultModel {
    public var commonProp: ResultModelProp = .init()
 
    /// The container in which the queried image styles are stored.
    public var style: StyleInfo?
     
}

/// The request for the DeleteStyle operation.
public struct DeleteStyleRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// The name of the image style.
    public var styleName: Swift.String?
    

    public init( 
        bucket: Swift.String? = nil,
        styleName: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.styleName = styleName
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the DeleteStyle operation.
public struct DeleteStyleResult : ResultModel {
    public var commonProp: ResultModelProp = .init()

}

