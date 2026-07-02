import AlibabaCloudOSS
import Foundation



/// The authentication information for the origin server in mirror-based back-to-origin.
public struct MirrorAuth: Sendable {

    /// The authentication type.
    public var authType: Swift.String?

    /// The sign region for signature.
    public var region: Swift.String?

    /// The access key id for signature.
    public var accessKeyId: Swift.String?

    /// The access key secret for signature.
    public var accessKeySecret: Swift.String?

    public init( 
        authType: Swift.String? = nil,
        region: Swift.String? = nil,
        accessKeyId: Swift.String? = nil,
        accessKeySecret: Swift.String? = nil,
    ) { 
        self.authType = authType
        self.region = region
        self.accessKeyId = accessKeyId
        self.accessKeySecret = accessKeySecret
    }
}

extension MirrorAuth: Codable {
    enum CodingKeys: String, CodingKey { 
        case authType = "AuthType"
    
        case region = "Region"
    
        case accessKeyId = "AccessKeyId"
    
        case accessKeySecret = "AccessKeySecret"
    
    }
}


/// The headers that are sent to the origin. The specified headers are configured in the data returned by the origin regardless of whether the headers are contained in the request. This parameter takes effect only when the value of RedirectType is Mirror. You can specify up to 10 headers.
public struct Set: Sendable {

    /// The key of the header. The key can be up to 1,024 bytes in length and can contain only letters, digits, and hyphens (-). This parameter takes effect only when the value of RedirectType is Mirror.  This parameter must be specified if Set is specified.
    public var key: Swift.String?

    /// The value of the header. The value can be up to 1,024 bytes in length and cannot contain `\r\n`. This parameter takes effect only when the value of RedirectType is Mirror.  This parameter must be specified if Set is specified.
    public var value: Swift.String?

    public init( 
        key: Swift.String? = nil,
        value: Swift.String? = nil,
    ) { 
        self.key = key
        self.value = value
    }
}

extension Set: Codable {
    enum CodingKeys: String, CodingKey { 
        case key = "Key"
    
        case value = "Value"
    
    }
}


/// The configuration list for multiple origins.
public struct MirrorMultiAlternate: Sendable {

    /// The distinct number of a specific origin.
    public var mirrorMultiAlternateNumber: Swift.Int?

    /// The URL for a specific origin.
    public var mirrorMultiAlternateURL: Swift.String?

    /// The VPC ID for a specific origin.
    public var mirrorMultiAlternateVpcId: Swift.String?

    /// The region for a specific origin.
    public var mirrorMultiAlternateDstRegion: Swift.String?

    public init( 
        mirrorMultiAlternateNumber: Swift.Int? = nil,
        mirrorMultiAlternateURL: Swift.String? = nil,
        mirrorMultiAlternateVpcId: Swift.String? = nil,
        mirrorMultiAlternateDstRegion: Swift.String? = nil,
    ) { 
        self.mirrorMultiAlternateNumber = mirrorMultiAlternateNumber
        self.mirrorMultiAlternateURL = mirrorMultiAlternateURL
        self.mirrorMultiAlternateVpcId = mirrorMultiAlternateVpcId
        self.mirrorMultiAlternateDstRegion = mirrorMultiAlternateDstRegion
    }
}

extension MirrorMultiAlternate: Codable {
    enum CodingKeys: String, CodingKey { 
        case mirrorMultiAlternateNumber = "MirrorMultiAlternateNumber"
    
        case mirrorMultiAlternateURL = "MirrorMultiAlternateURL"
    
        case mirrorMultiAlternateVpcId = "MirrorMultiAlternateVpcId"
    
        case mirrorMultiAlternateDstRegion = "MirrorMultiAlternateDstRegion"
    
    }
}


/// The container to store the configuration for multiple origins in mirror-based back-to-origin.
public struct MirrorMultiAlternates: Sendable {

    /// The configuration list for multiple origins.
    public var mirrorMultiAlternates: [MirrorMultiAlternate]?

    public init( 
        mirrorMultiAlternates: [MirrorMultiAlternate]? = nil,
    ) { 
        self.mirrorMultiAlternates = mirrorMultiAlternates
    }
}

extension MirrorMultiAlternates: Codable {
    enum CodingKeys: String, CodingKey { 
        case mirrorMultiAlternates = "MirrorMultiAlternate"
    
    }
}


/// The matching condition. If all of the specified conditions are met, the rule is run. A rule is considered matched only when the rule meets the conditions that are specified by all nodes in Condition.  This parameter must be specified if RoutingRule is specified.
public struct RoutingRuleCondition: Sendable {

    /// The prefix of object names. Only objects whose names contain the specified prefix match the rule.
    public var keyPrefixEquals: Swift.String?

    /// Only Objects that match this suffix can match this rule.
    public var keySuffixEquals: Swift.String?

    /// The HTTP status code. The rule is matched only when the specified object is accessed and the specified HTTP status code is returned. If the redirection rule is the mirroring-based back-to-origin rule, the value of this parameter is 404.
    public var httpErrorCodeReturnedEquals: Swift.Int?

    /// The rule will only be matched when the request contains the specified Header with the specified value. Up to 10 of these can be specified in the container.
    public var includeHeaders: [IncludeHeader]?

    public init( 
        keyPrefixEquals: Swift.String? = nil,
        keySuffixEquals: Swift.String? = nil,
        httpErrorCodeReturnedEquals: Swift.Int? = nil,
        includeHeaders: [IncludeHeader]? = nil,
    ) { 
        self.keyPrefixEquals = keyPrefixEquals
        self.keySuffixEquals = keySuffixEquals
        self.httpErrorCodeReturnedEquals = httpErrorCodeReturnedEquals
        self.includeHeaders = includeHeaders
    }
}

extension RoutingRuleCondition: Codable {
    enum CodingKeys: String, CodingKey { 
        case keyPrefixEquals = "KeyPrefixEquals"
    
        case keySuffixEquals = "KeySuffixEquals"
    
        case httpErrorCodeReturnedEquals = "HttpErrorCodeReturnedEquals"
    
        case includeHeaders = "IncludeHeader"
    
    }
}


/// The rule list for setting tags.
public struct Taggings: Sendable {

    /// The tag key.
    public var key: Swift.String?

    /// The rule for setting tag value for a specific tag key.
    public var value: Swift.String?

    public init( 
        key: Swift.String? = nil,
        value: Swift.String? = nil,
    ) { 
        self.key = key
        self.value = value
    }
}

extension Taggings: Codable {
    enum CodingKeys: String, CodingKey { 
        case key = "Key"
    
        case value = "Value"
    
    }
}


/// The rule list for setting response headers in mirror-based back-to-origin.
public struct ReturnHeader: Sendable {

    /// The response header.
    public var key: Swift.String?

    /// The rule for setting response header value for a specific header.
    public var value: Swift.String?

    public init( 
        key: Swift.String? = nil,
        value: Swift.String? = nil,
    ) { 
        self.key = key
        self.value = value
    }
}

extension ReturnHeader: Codable {
    enum CodingKeys: String, CodingKey { 
        case key = "Key"
    
        case value = "Value"
    
    }
}


/// Container to store the rules for setting response headers in mirror-based back-to-origin.
public struct MirrorReturnHeaders: Sendable {

    /// The rule list for setting response headers in mirror-based back-to-origin.
    public var returnHeaders: [ReturnHeader]?

    public init( 
        returnHeaders: [ReturnHeader]? = nil,
    ) { 
        self.returnHeaders = returnHeaders
    }
}

extension MirrorReturnHeaders: Codable {
    enum CodingKeys: String, CodingKey { 
        case returnHeaders = "ReturnHeader"
    
    }
}


/// The container for the redirection rule or mirroring-based back-to-origin rule. You can specify up to 20 rules.
public struct RoutingRule: Sendable {

    /// The sequence number that is used to match and run the redirection rules. OSS matches redirection rules based on this parameter. If a match succeeds, only the rule is run and the subsequent rules are not run.  This parameter must be specified if RoutingRule is specified.
    public var ruleNumber: Swift.Int?

    /// The matching condition. If all of the specified conditions are met, the rule is run. A rule is considered matched only when the rule meets the conditions that are specified by all nodes in Condition.  This parameter must be specified if RoutingRule is specified.
    public var condition: RoutingRuleCondition?

    /// The operation to perform after the rule is matched.  This parameter must be specified if RoutingRule is specified.
    public var redirect: RoutingRuleRedirect?

    /// The Lua script config of this rule.
    public var luaConfig: RoutingRuleLuaConfig?

    public init( 
        ruleNumber: Swift.Int? = nil,
        condition: RoutingRuleCondition? = nil,
        redirect: RoutingRuleRedirect? = nil,
        luaConfig: RoutingRuleLuaConfig? = nil,
    ) { 
        self.ruleNumber = ruleNumber
        self.condition = condition
        self.redirect = redirect
        self.luaConfig = luaConfig
    }
}

extension RoutingRule: Codable {
    enum CodingKeys: String, CodingKey { 
        case ruleNumber = "RuleNumber"
    
        case condition = "Condition"
    
        case redirect = "Redirect"
    
        case luaConfig = "LuaConfig"
    
    }
}


/// The container that stores the redirection rules.  You must specify at least one of the following containers: IndexDocument, ErrorDocument, and RoutingRules.
public struct RoutingRules: Sendable {

    /// The specified redirection rule or mirroring-based back-to-origin rule. You can specify up to 20 rules.
    public var routingRules: [RoutingRule]?

    public init( 
        routingRules: [RoutingRule]? = nil,
    ) { 
        self.routingRules = routingRules
    }
}

extension RoutingRules: Codable {
    enum CodingKeys: String, CodingKey { 
        case routingRules = "RoutingRule"
    
    }
}


/// The container that stores the default homepage.
public struct IndexDocument: Sendable {

    /// The default homepage.
    public var suffix: Swift.String?

    /// Specifies whether to redirect the access to the default homepage of the subdirectory when the subdirectory is accessed. Valid values:
    /// *   **true**: The access is redirected to the default homepage of the subdirectory.
    /// *   **false** (default): The access is redirected to the default homepage of the root directory.
    /// For example, the default homepage is set to index.html, and `bucket.oss-cn-hangzhou.aliyuncs.com/subdir/` is the site that you want to access. If **SupportSubDir** is set to false, the access is redirected to `bucket.oss-cn-hangzhou.aliyuncs.com/index.html`. If **SupportSubDir** is set to true, the access is redirected to `bucket.oss-cn-hangzhou.aliyuncs.com/subdir/index.html`.
    public var supportSubDir: Swift.Bool?

    /// The operation to perform when the default homepage is set, the name of the accessed object does not end with a forward slash (/), and the object does not exist. This parameter takes effect only when **SupportSubDir** is set to true. It takes effect after RoutingRule but before ErrorFile. For example, the default homepage is set to index.html, `bucket.oss-cn-hangzhou.aliyuncs.com/abc` is the site that you want to access, and the abc object does not exist. In this case, different operations are performed based on the value of **Type**.*   **0** (default): OSS checks whether the object named abc/index.html, which is in the `Object + Forward slash (/) + Homepage` format, exists. If the object exists, OSS returns HTTP status code 302 and the Location header value that contains URL-encoded `/abc/`. The URL-encoded /abc/ is in the `Forward slash (/) + Object + Forward slash (/)` format. If the object does not exist, OSS returns HTTP status code 404 and continues to check ErrorFile.
    /// *   **1**: OSS returns HTTP status code 404 and the NoSuchKey error code and continues to check ErrorFile.
    /// *   **2**: OSS checks whether abc/index.html exists. If abc/index.html exists, the content of the object is returned. If abc/index.html does not exist, OSS returns HTTP status code 404 and continues to check ErrorFile.
    public var type: Swift.Int?

    public init( 
        suffix: Swift.String? = nil,
        supportSubDir: Swift.Bool? = nil,
        type: Swift.Int? = nil,
    ) { 
        self.suffix = suffix
        self.supportSubDir = supportSubDir
        self.type = type
    }
}

extension IndexDocument: Codable {
    enum CodingKeys: String, CodingKey { 
        case suffix = "Suffix"
    
        case supportSubDir = "SupportSubDir"
    
        case type = "Type"
    
    }
}


/// The container that stores the default 404 page.
public struct ErrorDocument: Sendable {

    /// The error page.
    public var key: Swift.String?

    /// The HTTP status code returned with the error page.
    public var httpStatus: Swift.Int?

    public init( 
        key: Swift.String? = nil,
        httpStatus: Swift.Int? = nil,
    ) { 
        self.key = key
        self.httpStatus = httpStatus
    }
}

extension ErrorDocument: Codable {
    enum CodingKeys: String, CodingKey { 
        case key = "Key"
    
        case httpStatus = "HttpStatus"
    
    }
}


/// The root node for website configuration.
public struct WebsiteConfiguration: Sendable {

    /// The container that stores the default homepage.  You must specify at least one of the following containers: IndexDocument, ErrorDocument, and RoutingRules.
    public var indexDocument: IndexDocument?

    /// The container that stores the default 404 page.  You must specify at least one of the following containers: IndexDocument, ErrorDocument, and RoutingRules.
    public var errorDocument: ErrorDocument?

    /// The container that stores the redirection rules.  You must specify at least one of the following containers: IndexDocument, ErrorDocument, and RoutingRules.
    public var routingRules: RoutingRules?

    public init( 
        indexDocument: IndexDocument? = nil,
        errorDocument: ErrorDocument? = nil,
        routingRules: RoutingRules? = nil,
    ) { 
        self.indexDocument = indexDocument
        self.errorDocument = errorDocument
        self.routingRules = routingRules
    }
}

extension WebsiteConfiguration: Codable {
    enum CodingKeys: String, CodingKey { 
        case indexDocument = "IndexDocument"
    
        case errorDocument = "ErrorDocument"
    
        case routingRules = "RoutingRules"
    
    }
}


/// The rule will only be matched when the request contains the specified Header with the specified value. Up to 10 of these can be specified in the container.
public struct IncludeHeader: Sendable {

    /// The rule will only be matched when the request contains this Header and its value is equal to the specified value.
    public var key: Swift.String?

    /// The rule will only be matched when the request contains this Header and its value is equal to the specified value.
    public var equals: Swift.String?

    /// The rule will only be matched when the request contains this Header and its value starts with the specified value.
    public var startsWith: Swift.String?

    /// The rule will only be matched when the request contains this Header and its value ends with the specified value.
    public var endsWith: Swift.String?

    public init( 
        key: Swift.String? = nil,
        equals: Swift.String? = nil,
        startsWith: Swift.String? = nil,
        endsWith: Swift.String? = nil,
    ) { 
        self.key = key
        self.equals = equals
        self.startsWith = startsWith
        self.endsWith = endsWith
    }
}

extension IncludeHeader: Codable {
    enum CodingKeys: String, CodingKey { 
        case key = "Key"
    
        case equals = "Equals"
    
        case startsWith = "StartsWith"
    
        case endsWith = "EndsWith"
    
    }
}


/// The headers contained in the response that is returned when you use mirroring-based back-to-origin. This parameter takes effect only when the value of RedirectType is Mirror.
public struct MirrorHeaders: Sendable {

    /// Specifies whether to pass through all request headers other than the following headers to the origin. This parameter takes effect only when the value of RedirectType is Mirror.
    /// *   Headers such as content-length, authorization2, authorization, range, and date
    /// *   Headers that start with oss-, x-oss-, and x-drs-Default value: false.Valid values:
    /// *   true
    /// *   false
    public var passAll: Swift.Bool?

    /// The headers to pass through to the origin. This parameter takes effect only when the value of RedirectType is Mirror. Each specified header can be up to 1,024 bytes in length and can contain only letters, digits, and hyphens (-). You can specify up to 10 headers.
    public var pass: [Swift.String]?

    /// The headers that are not allowed to pass through to the origin. This parameter takes effect only when the value of RedirectType is Mirror. Each header can be up to 1,024 bytes in length and can contain only letters, digits, and hyphens (-). You can specify up to 10 headers. This parameter is used together with PassAll.
    public var removes: [Swift.String]?

    /// The headers that are sent to the origin. The specified headers are configured in the data returned by the origin regardless of whether the headers are contained in the request. This parameter takes effect only when the value of RedirectType is Mirror. You can specify up to 10 headers.
    public var sets: [Set]?

    public init( 
        passAll: Swift.Bool? = nil,
        pass: [Swift.String]? = nil,
        removes: [Swift.String]? = nil,
        sets: [Set]? = nil,
    ) { 
        self.passAll = passAll
        self.pass = pass
        self.removes = removes
        self.sets = sets
    }
}

extension MirrorHeaders: Codable {
    enum CodingKeys: String, CodingKey { 
        case passAll = "PassAll"
    
        case pass = "Pass"
    
        case removes = "Remove"
    
        case sets = "Set"
    
    }
}


/// Lua script config for the routing rule.
public struct RoutingRuleLuaConfig: Sendable {

    /// The name of the Lua script.
    public var script: Swift.String?

    public init( 
        script: Swift.String? = nil,
    ) { 
        self.script = script
    }
}

extension RoutingRuleLuaConfig: Codable {
    enum CodingKeys: String, CodingKey { 
        case script = "Script"
    
    }
}


/// The rules for setting tags when saving files during mirror-based back-to-origin.
public struct MirrorTaggings: Sendable {

    /// The rule list for setting tags.
    public var taggings: [Taggings]?

    public init( 
        taggings: [Taggings]? = nil,
    ) { 
        self.taggings = taggings
    }
}

extension MirrorTaggings: Codable {
    enum CodingKeys: String, CodingKey { 
        case taggings = "Taggings"
    
    }
}


/// The operation to perform after the rule is matched.  This parameter must be specified if RoutingRule is specified.
public struct RoutingRuleRedirect: Sendable {

    /// 是否透传SNI
    public var mirrorSNI: Swift.Bool?

    /// Specifies whether to redirect the access to the address specified by Location if the origin returns an HTTP 3xx status code. This parameter takes effect only when the value of RedirectType is Mirror.
    /// For example, when a mirroring-based back-to-origin request is initiated, the origin returns 302 and Location is specified.
    /// *   If you set MirrorFollowRedirect to true, OSS continues requesting the resource at the address specified by Location. The access can be redirected up to 10 times. If the access is redirected more than 10 times, the mirroring-based back-to-origin request fails.
    /// *   If you set MirrorFollowRedirect to false, OSS returns 302 and passes through Location.Default value: true.
    public var mirrorFollowRedirect: Swift.Bool?

    /// Mirror-based back-to-origin with express tunnel.
    public var mirrorIsExpressTunnel: Swift.Bool?

    /// The VPC ID for mirror-based back-to-origin express tunnel.
    public var mirrorDstVpcId: Swift.String?

    /// The tunnel ID for mirror-based back-to-origin.
    public var mirrorTunnelId: Swift.String?

    /// The rules for setting tags when saving files during mirror-based back-to-origin.
    public var mirrorTaggings: MirrorTaggings?

    /// Container to store the rules for setting response headers in mirror-based back-to-origin.
    public var mirrorReturnHeaders: MirrorReturnHeaders?

    /// Specifies whether to include parameters of the original request in the redirection request when the system runs the redirection rule or mirroring-based back-to-origin rule. For example, if the **PassQueryString** parameter is set to true, the `?a=b&c=d` parameter string is included in a request sent to OSS, and the redirection mode is 302, this parameter is added to the Location header. For example, if the request is `Location:example.com?a=b&c=d` and the redirection type is mirroring-based back-to-origin, the ?a=b\&c=d parameter string is also included in the back-to-origin request. Valid values: true and false (default).
    public var passQueryString: Swift.Bool?

    /// The string that is used to replace the prefix of the object name during redirection. If the prefix of an object name is empty, the string precedes the object name.  You can specify only one of the ReplaceKeyWith and ReplaceKeyPrefixWith parameters in a rule. For example, if you access an object named abc/test.txt, KeyPrefixEquals is set to abc/, ReplaceKeyPrefixWith is set to def/, the value of the Location header is `http://example.com/def/test.txt`.
    public var replaceKeyPrefixWith: Swift.String?

    /// Not save data in web-based back-to-origin.
    public var mirrorProxyPass: Swift.Bool?

    /// Whether to use role for mirror-based back-to-origin.
    public var mirrorUsingRole: Swift.Bool?

    /// Specify which status codes returned by the origin server should be passed through to the client along with the body. The value should be HTTP status codes such as 4xx, 5xx, etc., separated by commas (,), for example, 400,404. This setting takes effect only when RedirectType is set to Mirror. When OSS requests content from the origin server, if the origin server returns one of the status codes specified in this parameter, OSS will pass through the status code and body returned by the origin server to the client. If the 404 status code is specified in this parameter, the configured ErrorDocument will be ineffective.
    public var transparentMirrorResponseCodes: Swift.String?

    /// Specifies whether to check the MD5 hash of the body of the response returned by the origin. This parameter takes effect only when the value of RedirectType is Mirror. When **MirrorCheckMd5** is set to true and the response returned by the origin includes the Content-Md5 header, OSS checks whether the MD5 hash of the obtained data matches the header value. If the MD5 hash of the obtained data does not match the header value, the obtained data is not stored in OSS. Default value: false.
    public var mirrorCheckMd5: Swift.Bool?

    /// The string that is used to replace the requested object name when the request is redirected. This parameter can be set to the ${key} variable, which indicates the object name in the request. For example, if ReplaceKeyWith is set to `prefix/${key}.suffix` and the object to access is test, the value of the Location header is `http://example.com/prefix/test.suffix`.
    public var replaceKeyWith: Swift.String?

    /// The slave URL for mirror-based back-to-origin.
    public var mirrorURLSlave: Swift.String?

    /// Whether to allow take video snapshot in mirror-based back-to-origin.
    public var mirrorAllowVideoSnapshot: Swift.Bool?

    /// This parameter plays the same role as PassQueryString and has a higher priority than PassQueryString. This parameter takes effect only when the value of RedirectType is Mirror. Default value: false.
    /// Valid values:
    /// *   true
    /// *   false
    public var mirrorPassQueryString: Swift.Bool?

    /// If this parameter is set to true, the prefix of the object names is replaced with the value specified by ReplaceKeyPrefixWith. If this parameter is not specified or empty, the prefix of object names is truncated.  When the ReplaceKeyWith parameter is not empty, the EnableReplacePrefix parameter cannot be set to true.Default value: false.
    public var enableReplacePrefix: Swift.Bool?

    /// The HTTP redirect code in the response. This parameter takes effect only when RedirectType is set to External or AliCDN. Valid values: 301, 302, and 307.
    public var httpRedirectCode: Swift.Int?

    /// The role name used for mirror-based back-to-origin.
    public var mirrorRole: Swift.String?

    /// The HTTP status codes that trigger the asynchronous pull mode in mirror-based back-to-origin.
    public var mirrorAsyncStatus: Swift.Int?

    /// The authentication information for the origin server in mirror-based back-to-origin.
    public var mirrorAuth: MirrorAuth?

    /// The protocol used for redirection. This parameter takes effect only when RedirectType is set to External or AliCDN. For example, if you access an object named test, Protocol is set to https, and Hostname is set to `example.com`, the value of the Location header is `https://example.com/test`. Valid values: **http** and **https**.
    public var `protocol`: Swift.String?

    /// The slave VPC ID for mirror-based back-to-origin express tunnel.
    public var mirrorDstSlaveVpcId: Swift.String?

    /// Whether to store the user defined metadata in mirror-based back-to-origin.
    public var mirrorSaveOssMeta: Swift.Bool?

    /// The headers contained in the response that is returned when you use mirroring-based back-to-origin. This parameter takes effect only when the value of RedirectType is Mirror.
    public var mirrorHeaders: MirrorHeaders?

    /// The domain name used for redirection. The domain name must comply with the domain naming rules. For example, if you access an object named test, Protocol is set to https, and Hostname is set to `example.com`, the value of the Location header is `https://example.com/test`.
    public var hostName: Swift.String?

    /// The VPC region for mirror-based back-to-origin express tunnel.
    public var mirrorDstRegion: Swift.String?

    /// Whether to allow take HeadObject in mirror-based back-to-origin.
    public var mirrorAllowHeadObject: Swift.Bool?

    /// The redirection type. Valid values:
    /// *   **Mirror**: mirroring-based back-to-origin.
    /// *   **External**: external redirection. OSS returns an HTTP 3xx status code and returns an address for you to redirect to.
    /// *   **AliCDN**: redirection based on Alibaba Cloud CDN. Compared with external redirection, OSS adds an additional header to the request. After Alibaba Cloud CDN identifies the header, Alibaba Cloud CDN redirects the access to the specified address and returns the obtained data instead of the HTTP 3xx status code that redirects the access to another address.  This parameter must be specified if Redirect is specified.
    public var redirectType: Swift.String?

    /// Whether to pass slashes to origin.
    public var mirrorPassOriginalSlashes: Swift.Bool?

    /// Whether to allow get image information in mirror-based back-to-origin.
    public var mirrorAllowGetImageInfo: Swift.Bool?

    /// The container to store the configuration for multiple origins in mirror-based back-to-origin.
    public var mirrorMultiAlternates: MirrorMultiAlternates?

    /// The origin URL for mirroring-based back-to-origin. This parameter takes effect only when the value of RedirectType is Mirror. The origin URL must start with \*\*http://** or **https://\*\* and end with a forward slash (/). OSS adds an object name to the end of the URL to generate a back-to-origin URL. For example, the name of the object to access is myobject. If MirrorURL is set to `http://example.com/`, the back-to-origin URL is `http://example.com/myobject`. If MirrorURL is set to `http://example.com/dir1/`, the back-to-origin URL is `http://example.com/dir1/myobject`.  This parameter must be specified if RedirectType is set to Mirror.
    /// Valid values:
    /// *   true
    /// *   false
    public var mirrorURL: Swift.String?

    /// Use LastModifiedTime of the file from origin.
    public var mirrorUserLastModified: Swift.Bool?

    /// Used for determining the state of primary-secondary switching. The logic for primary-secondary switching is based on the error code returned by the origin server. If MirrorSwitchAllErrors is set to true, all status codes except the following are considered failures: 200, 206, 301, 302, 303, 307, 404. If it is set to false, only status codes in the 5xx range or timeouts are considered failures.
    public var mirrorSwitchAllErrors: Swift.Bool?

    /// The probe URL for mirror-based back-to-origin.
    public var mirrorURLProbe: Swift.String?

    public init( 
        redirectType: Swift.String? = nil,
        mirrorSNI: Swift.Bool? = nil,
        mirrorFollowRedirect: Swift.Bool? = nil,
        mirrorIsExpressTunnel: Swift.Bool? = nil,
        mirrorDstVpcId: Swift.String? = nil,
        mirrorTunnelId: Swift.String? = nil,
        mirrorTaggings: MirrorTaggings? = nil,
        mirrorReturnHeaders: MirrorReturnHeaders? = nil,
        passQueryString: Swift.Bool? = nil,
        replaceKeyPrefixWith: Swift.String? = nil,
        mirrorProxyPass: Swift.Bool? = nil,
        mirrorUsingRole: Swift.Bool? = nil,
        transparentMirrorResponseCodes: Swift.String? = nil,
        mirrorCheckMd5: Swift.Bool? = nil,
        replaceKeyWith: Swift.String? = nil,
        mirrorURLSlave: Swift.String? = nil,
        mirrorAllowVideoSnapshot: Swift.Bool? = nil,
        mirrorPassQueryString: Swift.Bool? = nil,
        enableReplacePrefix: Swift.Bool? = nil,
        httpRedirectCode: Swift.Int? = nil,
        mirrorRole: Swift.String? = nil,
        mirrorAsyncStatus: Swift.Int? = nil,
        mirrorAuth: MirrorAuth? = nil,
        protocol: Swift.String? = nil,
        mirrorDstSlaveVpcId: Swift.String? = nil,
        mirrorSaveOssMeta: Swift.Bool? = nil,
        mirrorHeaders: MirrorHeaders? = nil,
        hostName: Swift.String? = nil,
        mirrorDstRegion: Swift.String? = nil,
        mirrorAllowHeadObject: Swift.Bool? = nil,
        mirrorPassOriginalSlashes: Swift.Bool? = nil,
        mirrorAllowGetImageInfo: Swift.Bool? = nil,
        mirrorMultiAlternates: MirrorMultiAlternates? = nil,
        mirrorURL: Swift.String? = nil,
        mirrorUserLastModified: Swift.Bool? = nil,
        mirrorSwitchAllErrors: Swift.Bool? = nil,
        mirrorURLProbe: Swift.String? = nil,
    ) { 
        self.mirrorSNI = mirrorSNI
        self.mirrorFollowRedirect = mirrorFollowRedirect
        self.mirrorIsExpressTunnel = mirrorIsExpressTunnel
        self.mirrorDstVpcId = mirrorDstVpcId
        self.mirrorTunnelId = mirrorTunnelId
        self.mirrorTaggings = mirrorTaggings
        self.mirrorReturnHeaders = mirrorReturnHeaders
        self.passQueryString = passQueryString
        self.replaceKeyPrefixWith = replaceKeyPrefixWith
        self.mirrorProxyPass = mirrorProxyPass
        self.mirrorUsingRole = mirrorUsingRole
        self.transparentMirrorResponseCodes = transparentMirrorResponseCodes
        self.mirrorCheckMd5 = mirrorCheckMd5
        self.replaceKeyWith = replaceKeyWith
        self.mirrorURLSlave = mirrorURLSlave
        self.mirrorAllowVideoSnapshot = mirrorAllowVideoSnapshot
        self.mirrorPassQueryString = mirrorPassQueryString
        self.enableReplacePrefix = enableReplacePrefix
        self.httpRedirectCode = httpRedirectCode
        self.mirrorRole = mirrorRole
        self.mirrorAsyncStatus = mirrorAsyncStatus
        self.mirrorAuth = mirrorAuth
        self.protocol = `protocol`
        self.mirrorDstSlaveVpcId = mirrorDstSlaveVpcId
        self.mirrorSaveOssMeta = mirrorSaveOssMeta
        self.mirrorHeaders = mirrorHeaders
        self.hostName = hostName
        self.mirrorDstRegion = mirrorDstRegion
        self.mirrorAllowHeadObject = mirrorAllowHeadObject
        self.redirectType = redirectType
        self.mirrorPassOriginalSlashes = mirrorPassOriginalSlashes
        self.mirrorAllowGetImageInfo = mirrorAllowGetImageInfo
        self.mirrorMultiAlternates = mirrorMultiAlternates
        self.mirrorURL = mirrorURL
        self.mirrorUserLastModified = mirrorUserLastModified
        self.mirrorSwitchAllErrors = mirrorSwitchAllErrors
        self.mirrorURLProbe = mirrorURLProbe
    }
}

extension RoutingRuleRedirect: Codable {
    enum CodingKeys: String, CodingKey { 
        case redirectType = "RedirectType"

        case mirrorSNI = "MirrorSNI"
    
        case mirrorFollowRedirect = "MirrorFollowRedirect"
    
        case mirrorIsExpressTunnel = "MirrorIsExpressTunnel"
    
        case mirrorDstVpcId = "MirrorDstVpcId"
    
        case mirrorTunnelId = "MirrorTunnelId"
    
        case mirrorTaggings = "MirrorTaggings"
    
        case mirrorReturnHeaders = "MirrorReturnHeaders"
    
        case passQueryString = "PassQueryString"
    
        case replaceKeyPrefixWith = "ReplaceKeyPrefixWith"
    
        case mirrorProxyPass = "MirrorProxyPass"
    
        case mirrorUsingRole = "MirrorUsingRole"
    
        case transparentMirrorResponseCodes = "TransparentMirrorResponseCodes"
    
        case mirrorCheckMd5 = "MirrorCheckMd5"
    
        case replaceKeyWith = "ReplaceKeyWith"
    
        case mirrorURLSlave = "MirrorURLSlave"
    
        case mirrorAllowVideoSnapshot = "MirrorAllowVideoSnapshot"
    
        case mirrorPassQueryString = "MirrorPassQueryString"
    
        case enableReplacePrefix = "EnableReplacePrefix"
    
        case httpRedirectCode = "HttpRedirectCode"
    
        case mirrorRole = "MirrorRole"
    
        case mirrorAsyncStatus = "MirrorAsyncStatus"
    
        case mirrorAuth = "MirrorAuth"
    
        case `protocol` = "Protocol"
    
        case mirrorDstSlaveVpcId = "MirrorDstSlaveVpcId"
    
        case mirrorSaveOssMeta = "MirrorSaveOssMeta"
    
        case mirrorHeaders = "MirrorHeaders"
    
        case hostName = "HostName"
    
        case mirrorDstRegion = "MirrorDstRegion"
    
        case mirrorAllowHeadObject = "MirrorAllowHeadObject"
        
        case mirrorPassOriginalSlashes = "MirrorPassOriginalSlashes"
    
        case mirrorAllowGetImageInfo = "MirrorAllowGetImageInfo"
    
        case mirrorMultiAlternates = "MirrorMultiAlternates"
    
        case mirrorURL = "MirrorURL"
    
        case mirrorUserLastModified = "MirrorUserLastModified"
    
        case mirrorSwitchAllErrors = "MirrorSwitchAllErrors"
    
        case mirrorURLProbe = "MirrorURLProbe"
    
    }
}




/// The request for the GetBucketWebsite operation.
public struct GetBucketWebsiteRequest : RequestModel {
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

/// The result for the GetBucketWebsite operation.
public struct GetBucketWebsiteResult : ResultModel {
    public var commonProp: ResultModelProp = .init()
 
    /// The containers of the website configuration.
    public var websiteConfiguration: WebsiteConfiguration?
     
}

/// The request for the PutBucketWebsite operation.
public struct PutBucketWebsiteRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// The request body schema.
    public var websiteConfiguration: WebsiteConfiguration?
    

    public init( 
        bucket: Swift.String? = nil,
        websiteConfiguration: WebsiteConfiguration? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.websiteConfiguration = websiteConfiguration
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the PutBucketWebsite operation.
public struct PutBucketWebsiteResult : ResultModel {
    public var commonProp: ResultModelProp = .init()

}

/// The request for the DeleteBucketWebsite operation.
public struct DeleteBucketWebsiteRequest : RequestModel {
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

/// The result for the DeleteBucketWebsite operation.
public struct DeleteBucketWebsiteResult : ResultModel {
    public var commonProp: ResultModelProp = .init()

}

