import AlibabaCloudOSS
import Foundation



/// 
public struct Subtitles: Sendable {

    /// 
    public var subtitles: [MetaQueryRespSubtitle]?

    public init( 
        subtitles: [MetaQueryRespSubtitle]? = nil,
    ) {
        self.subtitles = subtitles
    }
}

extension Subtitles: Codable {
    enum CodingKeys: String, CodingKey { 
        case subtitles = "Subtitle"
    
    }
}


/// 
public struct MetaQueryAggregations: Sendable {

    /// 
    public var aggregations: [MetaQueryAggregationsResult]?

    public init( 
        aggregations: [MetaQueryAggregationsResult]? = nil,
    ) { 
        self.aggregations = aggregations
    }
}

extension MetaQueryAggregations: Codable {
    enum CodingKeys: String, CodingKey {
        case aggregations = "Aggregation"
    
    }
}


/// 
public struct MetaQueryRespVideoStream: Sendable {

    /// 
    public var duration: Swift.Float?

    /// 
    public var frameCount: Swift.Int?

    /// 
    public var pixelFormat: Swift.String?

    /// 
    public var colorSpace: Swift.String?

    /// 
    public var language: Swift.String?

    /// 
    public var bitrate: Swift.Int?

    /// 
    public var frameRate: Swift.String?

    /// 
    public var startTime: Swift.Float?

    /// 
    public var bitDepth: Swift.Int?

    /// 
    public var height: Swift.Int?

    /// 
    public var width: Swift.Int?

    /// 
    public var codecName: Swift.String?

    public init( 
        duration: Swift.Float? = nil,
        frameCount: Swift.Int? = nil,
        pixelFormat: Swift.String? = nil,
        colorSpace: Swift.String? = nil,
        language: Swift.String? = nil,
        bitrate: Swift.Int? = nil,
        frameRate: Swift.String? = nil,
        startTime: Swift.Float? = nil,
        bitDepth: Swift.Int? = nil,
        height: Swift.Int? = nil,
        width: Swift.Int? = nil,
        codecName: Swift.String? = nil,
    ) { 
        self.duration = duration
        self.frameCount = frameCount
        self.pixelFormat = pixelFormat
        self.colorSpace = colorSpace
        self.language = language
        self.bitrate = bitrate
        self.frameRate = frameRate
        self.startTime = startTime
        self.bitDepth = bitDepth
        self.height = height
        self.width = width
        self.codecName = codecName
    }
}

extension MetaQueryRespVideoStream: Codable {
    enum CodingKeys: String, CodingKey { 
        case duration = "Duration"
    
        case frameCount = "FrameCount"
    
        case pixelFormat = "PixelFormat"
    
        case colorSpace = "ColorSpace"
    
        case language = "Language"
    
        case bitrate = "Bitrate"
    
        case frameRate = "FrameRate"
    
        case startTime = "StartTime"
    
        case bitDepth = "BitDepth"
    
        case height = "Height"
    
        case width = "Width"
    
        case codecName = "CodecName"
    
    }
}


/// The container that stores user metadata.
public struct OSSUserMeta: Sendable {

    /// The user metadata items.
    public var userMetas: [MetaQueryUserMeta]?

    public init( 
        userMetas: [MetaQueryUserMeta]? = nil,
    ) { 
        self.userMetas = userMetas
    }
}

extension OSSUserMeta: Codable {
    enum CodingKeys: String, CodingKey { 
        case userMetas = "UserMeta"
    
    }
}


/// 
public struct Addresses: Sendable {

    /// 
    public var addresses: [MetaQueryRespAddress]?

    public init( 
        addresses: [MetaQueryRespAddress]? = nil,
    ) {
        self.addresses = addresses
    }
}

extension Addresses: Codable {
    enum CodingKeys: String, CodingKey { 
        case addresses = "Address"
    
    }
}


/// The list of object tags.
public struct OSSTagging: Sendable {

    /// The tags.
    public var taggings: [MetaQueryTagging]?

    public init( 
        taggings: [MetaQueryTagging]? = nil,
    ) { 
        self.taggings = taggings
    }
}

extension OSSTagging: Codable {
    enum CodingKeys: String, CodingKey { 
        case taggings = "Tagging"
    
    }
}


/// 
public struct Groups: Sendable {

    /// 
    public var groups: [Group]?

    public init( 
        groups: [Group]? = nil,
    ) { 
        self.groups = groups
    }
}

extension Groups: Codable {
    enum CodingKeys: String, CodingKey { 
        case groups = "Group"
    
    }
}


/// 
public struct MetaQueryRespAudioStream: Sendable {

    /// 
    public var codecName: Swift.String?

    /// 
    public var bitrate: Swift.Int?

    /// 
    public var sampleRate: Swift.Int?

    /// 
    public var startTime: Swift.Float?

    /// 
    public var duration: Swift.Float?

    /// 
    public var channels: Swift.Int?

    /// 
    public var language: Swift.String?

    public init( 
        codecName: Swift.String? = nil,
        bitrate: Swift.Int? = nil,
        sampleRate: Swift.Int? = nil,
        startTime: Swift.Float? = nil,
        duration: Swift.Float? = nil,
        channels: Swift.Int? = nil,
        language: Swift.String? = nil,
    ) { 
        self.codecName = codecName
        self.bitrate = bitrate
        self.sampleRate = sampleRate
        self.startTime = startTime
        self.duration = duration
        self.channels = channels
        self.language = language
    }
}

extension MetaQueryRespAudioStream: Codable {
    enum CodingKeys: String, CodingKey { 
        case codecName = "CodecName"
    
        case bitrate = "Bitrate"
    
        case sampleRate = "SampleRate"
    
        case startTime = "StartTime"
    
        case duration = "Duration"
    
        case channels = "Channels"
    
        case language = "Language"
    
    }
}


/// 
public struct MetaQueryRespSubtitle: Sendable {

    /// 
    public var codecName: Swift.String?

    /// 
    public var language: Swift.String?

    /// 
    public var startTime: Swift.Float?

    /// 
    public var duration: Swift.Float?

    public init( 
        codecName: Swift.String? = nil,
        language: Swift.String? = nil,
        startTime: Swift.Float? = nil,
        duration: Swift.Float? = nil,
    ) {
        self.codecName = codecName
        self.language = language
        self.startTime = startTime
        self.duration = duration
    }
}

extension MetaQueryRespSubtitle: Codable {
    enum CodingKeys: String, CodingKey { 
        case codecName = "CodecName"
    
        case language = "Language"
    
        case startTime = "StartTime"
    
        case duration = "Duration"
    
    }
}


/// A short description of struct
public struct MetaQueryFile: Sendable {

    /// 
    public var mediaType: Swift.String?

    /// 
    public var ossExpiration: Swift.String?

    /// 
    public var contentDisposition: Swift.String?

    /// 
    public var album: Swift.String?

    /// 
    public var videoStreams: VideoStreams?

    /// The object size.
    public var size: Swift.Int?

    /// The ETag of the object.
    public var eTag: Swift.String?

    /// The container that stores user metadata.
    public var ossUserMeta: OSSUserMeta?

    /// 
    public var serverSideEncryptionKeyId: Swift.String?

    /// 
    public var contentEncoding: Swift.String?

    /// The access control list (ACL) of the object.
    /// Valid values:
    /// *   default: the ACL of the bucket.
    /// *   private: private.
    /// *   public-read: public-read.
    /// *   public-read-write: public-read-write.
    public var objectACL: Swift.String?

    /// The number of the tags of the object.
    public var ossTaggingCount: Swift.Int?

    /// 
    public var latLong: Swift.String?

    /// 
    public var imageHeight: Swift.Int?

    /// 
    public var performer: Swift.String?

    /// 
    public var albumArtist: Swift.String?

    /// 
    public var audioStreams: AudioStreams?

    /// 
    public var subtitles: Subtitles?

    /// The full path of the object.
    public var filename: Swift.String?

    /// The server-side encryption of the object.
    public var serverSideEncryption: Swift.String?

    /// 
    public var serverSideDataEncryption: Swift.String?

    /// 
    public var videoHeight: Swift.Int?

    /// 
    public var artist: Swift.String?

    /// The server-side encryption algorithm used when the object was created.
    public var serverSideEncryptionCustomerAlgorithm: Swift.String?

    /// 
    public var uri: Swift.String?

    /// 
    public var produceTime: Swift.String?

    /// 
    public var cacheControl: Swift.String?

    /// 
    public var imageWidth: Swift.Int?

    /// 
    public var duration: Swift.Float?

    /// 
    public var addresses: Addresses?

    /// The type of the object.
    /// Valid values:
    /// *   Multipart: The object is uploaded by using multipart upload.
    /// *   Symlink: The object is a symbolic link that was created by calling the PutSymlink operation.
    /// *   Appendable: The object is uploaded by using AppendObject.
    /// *   Normal: The object is uploaded by using PutObject.
    public var ossObjectType: Swift.String?

    /// The CRC-64 value of the object.
    public var ossCRC64: Swift.String?

    /// The list of object tags.
    public var ossTagging: OSSTagging?

    /// 
    public var bitrate: Swift.Int?

    /// 
    public var composer: Swift.String?

    /// The time when the object was last modified.
    public var fileModifiedTime: Swift.String?

    /// The storage class of the object.
    /// Valid values:
    /// *   Archive: the Archive storage class.
    /// *   ColdArchive: the Cold Archive storage class.
    /// *   IA: the Infrequent Access (IA) storage class.
    /// *   Standard: The Standard storage class.
    public var ossStorageClass: Swift.String?

    /// 
    public var accessControlAllowOrigin: Swift.String?

    /// 
    public var accessControlRequestMethod: Swift.String?

    /// 
    public var videoWidth: Swift.Int?

    /// 
    public var contentType: Swift.String?

    /// 
    public var title: Swift.String?

    /// 
    public var contentLanguage: Swift.String?

    public init( 
        mediaType: Swift.String? = nil,
        ossExpiration: Swift.String? = nil,
        contentDisposition: Swift.String? = nil,
        album: Swift.String? = nil,
        videoStreams: VideoStreams? = nil,
        size: Swift.Int? = nil,
        eTag: Swift.String? = nil,
        ossUserMeta: OSSUserMeta? = nil,
        serverSideEncryptionKeyId: Swift.String? = nil,
        contentEncoding: Swift.String? = nil,
        objectACL: Swift.String? = nil,
        ossTaggingCount: Swift.Int? = nil,
        latLong: Swift.String? = nil,
        imageHeight: Swift.Int? = nil,
        performer: Swift.String? = nil,
        albumArtist: Swift.String? = nil,
        audioStreams: AudioStreams? = nil,
        subtitles: Subtitles? = nil,
        filename: Swift.String? = nil,
        serverSideEncryption: Swift.String? = nil,
        serverSideDataEncryption: Swift.String? = nil,
        videoHeight: Swift.Int? = nil,
        artist: Swift.String? = nil,
        serverSideEncryptionCustomerAlgorithm: Swift.String? = nil,
        uri: Swift.String? = nil,
        produceTime: Swift.String? = nil,
        cacheControl: Swift.String? = nil,
        imageWidth: Swift.Int? = nil,
        duration: Swift.Float? = nil,
        addresses: Addresses? = nil,
        ossObjectType: Swift.String? = nil,
        ossCRC64: Swift.String? = nil,
        ossTagging: OSSTagging? = nil,
        bitrate: Swift.Int? = nil,
        composer: Swift.String? = nil,
        fileModifiedTime: Swift.String? = nil,
        ossStorageClass: Swift.String? = nil,
        accessControlAllowOrigin: Swift.String? = nil,
        accessControlRequestMethod: Swift.String? = nil,
        videoWidth: Swift.Int? = nil,
        contentType: Swift.String? = nil,
        title: Swift.String? = nil,
        contentLanguage: Swift.String? = nil,
    ) { 
        self.mediaType = mediaType
        self.ossExpiration = ossExpiration
        self.contentDisposition = contentDisposition
        self.album = album
        self.videoStreams = videoStreams
        self.size = size
        self.eTag = eTag
        self.ossUserMeta = ossUserMeta
        self.serverSideEncryptionKeyId = serverSideEncryptionKeyId
        self.contentEncoding = contentEncoding
        self.objectACL = objectACL
        self.ossTaggingCount = ossTaggingCount
        self.latLong = latLong
        self.imageHeight = imageHeight
        self.performer = performer
        self.albumArtist = albumArtist
        self.audioStreams = audioStreams
        self.subtitles = subtitles
        self.filename = filename
        self.serverSideEncryption = serverSideEncryption
        self.serverSideDataEncryption = serverSideDataEncryption
        self.videoHeight = videoHeight
        self.artist = artist
        self.serverSideEncryptionCustomerAlgorithm = serverSideEncryptionCustomerAlgorithm
        self.uri = uri
        self.produceTime = produceTime
        self.cacheControl = cacheControl
        self.imageWidth = imageWidth
        self.duration = duration
        self.addresses = addresses
        self.ossObjectType = ossObjectType
        self.ossCRC64 = ossCRC64
        self.ossTagging = ossTagging
        self.bitrate = bitrate
        self.composer = composer
        self.fileModifiedTime = fileModifiedTime
        self.ossStorageClass = ossStorageClass
        self.accessControlAllowOrigin = accessControlAllowOrigin
        self.accessControlRequestMethod = accessControlRequestMethod
        self.videoWidth = videoWidth
        self.contentType = contentType
        self.title = title
        self.contentLanguage = contentLanguage
    }
}

extension MetaQueryFile: Codable {
    enum CodingKeys: String, CodingKey { 
        case mediaType = "MediaType"
    
        case ossExpiration = "OSSExpiration"
    
        case contentDisposition = "ContentDisposition"
    
        case album = "Album"
    
        case videoStreams = "VideoStreams"
    
        case size = "Size"
    
        case eTag = "ETag"
    
        case ossUserMeta = "OSSUserMeta"
    
        case serverSideEncryptionKeyId = "ServerSideEncryptionKeyId"
    
        case contentEncoding = "ContentEncoding"
    
        case objectACL = "ObjectACL"
    
        case ossTaggingCount = "OSSTaggingCount"
    
        case latLong = "LatLong"
    
        case imageHeight = "ImageHeight"
    
        case performer = "Performer"
    
        case albumArtist = "AlbumArtist"
    
        case audioStreams = "AudioStreams"
    
        case subtitles = "Subtitles"
    
        case filename = "Filename"
    
        case serverSideEncryption = "ServerSideEncryption"
    
        case serverSideDataEncryption = "ServerSideDataEncryption"
    
        case videoHeight = "VideoHeight"
    
        case artist = "Artist"
    
        case serverSideEncryptionCustomerAlgorithm = "ServerSideEncryptionCustomerAlgorithm"
    
        case uri = "URI"
    
        case produceTime = "ProduceTime"
    
        case cacheControl = "CacheControl"
    
        case imageWidth = "ImageWidth"
    
        case duration = "Duration"
    
        case addresses = "Addresses"
    
        case ossObjectType = "OSSObjectType"
    
        case ossCRC64 = "OSSCRC64"
    
        case ossTagging = "OSSTagging"
    
        case bitrate = "Bitrate"
    
        case composer = "Composer"
    
        case fileModifiedTime = "FileModifiedTime"
    
        case ossStorageClass = "OSSStorageClass"
    
        case accessControlAllowOrigin = "AccessControlAllowOrigin"
    
        case accessControlRequestMethod = "AccessControlRequestMethod"
    
        case videoWidth = "VideoWidth"
    
        case contentType = "ContentType"
    
        case title = "Title"
    
        case contentLanguage = "ContentLanguage"
    
    }
}


/// 
public struct MetaQueryAggregationsResult: Sendable {

    /// 
    public var value: Swift.Float?

    /// 
    public var groups: Groups?

    /// 
    public var field: Swift.String?

    /// 
    public var operation: Swift.String?

    public init( 
        value: Swift.Float? = nil,
        groups: Groups? = nil,
        field: Swift.String? = nil,
        operation: Swift.String? = nil,
    ) { 
        self.value = value
        self.groups = groups
        self.field = field
        self.operation = operation
    }
}

extension MetaQueryAggregationsResult: Codable {
    enum CodingKeys: String, CodingKey { 
        case value = "Value"
    
        case groups = "Groups"
    
        case field = "Field"
    
        case operation = "Operation"
    
    }
}


/// 
public struct MetaQueryRespAddress: Sendable {

    /// 
    public var addressLine: Swift.String?

    /// 
    public var city: Swift.String?

    /// 
    public var district: Swift.String?

    /// 
    public var language: Swift.String?

    /// 
    public var province: Swift.String?

    /// 
    public var township: Swift.String?

    public init( 
        addressLine: Swift.String? = nil,
        city: Swift.String? = nil,
        district: Swift.String? = nil,
        language: Swift.String? = nil,
        province: Swift.String? = nil,
        township: Swift.String? = nil,
    ) { 
        self.addressLine = addressLine
        self.city = city
        self.district = district
        self.language = language
        self.province = province
        self.township = township
    }
}

extension MetaQueryRespAddress: Codable {
    enum CodingKeys: String, CodingKey { 
        case addressLine = "AddressLine"
    
        case city = "City"
    
        case district = "District"
    
        case language = "Language"
    
        case province = "Province"
    
        case township = "Township"
    
    }
}


/// The container that stores the tag information.
public struct MetaQueryTagging: Sendable {

    /// The tag key.
    public var key: Swift.String?

    /// The tag value.
    public var value: Swift.String?

    public init( 
        key: Swift.String? = nil,
        value: Swift.String? = nil,
    ) { 
        self.key = key
        self.value = value
    }
}

extension MetaQueryTagging: Codable {
    enum CodingKeys: String, CodingKey { 
        case key = "Key"
    
        case value = "Value"
    
    }
}


/// The container that stores user metadata.
public struct MetaQueryUserMeta: Sendable {

    /// The key of the user metadata item.
    public var key: Swift.String?

    /// The value of the user metadata item.
    public var value: Swift.String?

    public init( 
        key: Swift.String? = nil,
        value: Swift.String? = nil,
    ) { 
        self.key = key
        self.value = value
    }
}

extension MetaQueryUserMeta: Codable {
    enum CodingKeys: String, CodingKey { 
        case key = "Key"
    
        case value = "Value"
    
    }
}


/// 
public struct AudioStreams: Sendable {

    /// 
    public var audioStreams: [MetaQueryRespAudioStream]?

    public init( 
        audioStreams: [MetaQueryRespAudioStream]? = nil,
    ) {
        self.audioStreams = audioStreams
    }
}

extension AudioStreams: Codable {
    enum CodingKeys: String, CodingKey { 
        case audioStreams = "AudioStream"
    
    }
}


/// 
public struct Files: Sendable {

    /// 
    public var files: [MetaQueryFile]?

    public init( 
        files: [MetaQueryFile]? = nil,
    ) { 
        self.files = files
    }
}

extension Files: Codable {
    enum CodingKeys: String, CodingKey { 
        case files = "File"
    
    }
}


/// 
public struct Group: Sendable {

    /// 
    public var value: Swift.String?

    /// 
    public var count: Swift.Int?

    public init( 
        value: Swift.String? = nil,
        count: Swift.Int? = nil,
    ) { 
        self.value = value
        self.count = count
    }
}

extension Group: Codable {
    enum CodingKeys: String, CodingKey { 
        case value = "Value"
    
        case count = "Count"
    
    }
}


/// 
public struct MetaQueryResp: Sendable {

    /// 
    public var nextToken: Swift.String?

    /// 
    public var files: Files?

    /// 
    public var aggregations: MetaQueryAggregations?

    public init( 
        nextToken: Swift.String? = nil,
        files: Files? = nil,
        aggregations: MetaQueryAggregations? = nil,
    ) {
        self.nextToken = nextToken
        self.files = files
        self.aggregations = aggregations
    }
}

extension MetaQueryResp: Codable {
    enum CodingKeys: String, CodingKey { 
        case nextToken = "NextToken"
    
        case files = "Files"
    
        case aggregations = "Aggregations"
    
    }
}


/// The container that stores the metadata information.
public struct MetaQueryStatus: Sendable {

    /// The status of the metadata index library.
    /// Valid values:
    /// - Ready: The metadata index library is being prepared after it is created.In this case, the metadata index library cannot be used to query data.
    /// - Stop: The metadata index library is paused.
    /// - Running: The metadata index library is running.
    /// - Retrying: The metadata index library failed to be created and is being created again.
    /// - Failed: The metadata index library failed to be created.
    /// - Deleted: The metadata index library is deleted.
    public var state: Swift.String?

    /// The scan type.
    /// Valid values:
    /// - FullScanning: Full scanning is in progress.
    /// - IncrementalScanning: Incremental scanning is in progress.
    public var phase: Swift.String?

    /// The time when the metadata index library was created. The value follows the RFC 3339 standard in the YYYY-MM-DDTHH:mm:ss+TIMEZONE format. YYYY-MM-DD indicates the year, month, and day. T indicates the beginning of the time element. HH:mm:ss indicates the hour, minute, and second. TIMEZONE indicates the time zone.
    public var createTime: Swift.String?

    /// The time when the metadata index library was updated. The value follows the RFC 3339 standard in the YYYY-MM-DDTHH:mm:ss+TIMEZONE format. YYYY-MM-DD indicates the year, month, and day. T indicates the beginning of the time element. HH:mm:ss indicates the hour, minute, and second. TIMEZONE indicates the time zone.
    public var updateTime: Swift.String?

    public init( 
        state: Swift.String? = nil,
        phase: Swift.String? = nil,
        createTime: Swift.String? = nil,
        updateTime: Swift.String? = nil,
    ) { 
        self.state = state
        self.phase = phase
        self.createTime = createTime
        self.updateTime = updateTime
    }
}

extension MetaQueryStatus: Codable {
    enum CodingKeys: String, CodingKey { 
        case state = "State"
    
        case phase = "Phase"
    
        case createTime = "CreateTime"
    
        case updateTime = "UpdateTime"
    
    }
}

public struct MediaTypes: Sendable {
    public var mediaTypes: [String]?
    
    public init(
        mediaTypes: [String]? = nil
    ) {
        self.mediaTypes = mediaTypes
    }
}

extension MediaTypes: Codable {
    enum CodingKeys: String, CodingKey {
        case mediaTypes = "MediaType"
    }
}

public struct MetaQuery: Sendable {
    /// The maximum number of objects to return. Valid values: 0 to 100. If this parameter is not set or is set to 0, up to 100 objects are returned.
    public var maxResults: Int?

    /// The query conditions. A query condition includes the following elements:
    /// *   Operation: the operator.
    /// Valid values: eq (equal to), gt (greater than), gte (greater than or equal to), lt (less than), lte (less than or equal to), match (fuzzy query), prefix (prefix query), and (AND), or (OR), and not (NOT).
    /// *   Field: the field name.
    /// *   Value: the field value.
    /// *   SubQueries: the subquery conditions.
    /// Options that are included in this element are the same as those of simple query. You need to set subquery conditions only when Operation is set to and, or, or not.
    public var query: String?

    /// The field based on which the results are sorted.
    public var sort: String?

    /// The sort order.
    public var order: String?

    /// The container that stores the information about aggregate operations.
    public var aggregations: MetaQueryAggregations?

    /// The pagination token used to obtain information in the next request. The object information is returned in alphabetical order starting from the value of NextToken.
    public var nextToken: String?

    /// The type of multimedia that you want to query. Valid values: image, video, audio, document
    public var mediaTypes: MediaTypes?

    /// The query conditions
    public var simpleQuery: String?
    
    public init(
        maxResults: Int? = nil,
        query: String? = nil,
        sort: String? = nil,
        order: String? = nil,
        aggregations: MetaQueryAggregations? = nil,
        nextToken: String? = nil,
        mediaTypes: MediaTypes? = nil,
        simpleQuery: String? = nil
    ) {
        self.maxResults = maxResults
        self.query = query
        self.sort = sort
        self.order = order
        self.aggregations = aggregations
        self.nextToken = nextToken
        self.mediaTypes = mediaTypes
        self.simpleQuery = simpleQuery
    }
}

extension MetaQuery: Codable {
    enum CodingKeys: String, CodingKey {
        case maxResults = "MaxResults"
        case query = "Query"
        case sort = "Sort"
        case order = "Order"
        case aggregations = "Aggregations"
        case nextToken = "NextToken"
        case mediaTypes = "MediaTypes"
        case simpleQuery = "SimpleQuery"
    }
}


/// 
public struct VideoStreams: Sendable {

    /// 
    public var videoStreams: [MetaQueryRespVideoStream]?

    public init( 
        videoStreams: [MetaQueryRespVideoStream]? = nil,
    ) {
        self.videoStreams = videoStreams
    }
}

extension VideoStreams: Codable {
    enum CodingKeys: String, CodingKey { 
        case videoStreams = "VideoStream"
    
    }
}




/// The request for the GetMetaQueryStatus operation.
public struct GetMetaQueryStatusRequest : RequestModel {
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

/// The result for the GetMetaQueryStatus operation.
public struct GetMetaQueryStatusResult : ResultModel {
    public var commonProp: ResultModelProp = .init()
 
    /// The container that stores the metadata information.
    public var metaQueryStatus: MetaQueryStatus?
     
}

/// The request for the CloseMetaQuery operation.
public struct CloseMetaQueryRequest : RequestModel {
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

/// The result for the CloseMetaQuery operation.
public struct CloseMetaQueryResult : ResultModel {
    public var commonProp: ResultModelProp = .init()

}

/// The request for the DoMetaQuery operation.
public struct DoMetaQueryRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// 
    public var mode: Swift.String?
    
    /// The request body schema.
    public var metaQuery: MetaQuery?
    

    public init( 
        bucket: Swift.String? = nil,
        mode: Swift.String? = nil,
        metaQuery: MetaQuery? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.mode = mode
        self.metaQuery = metaQuery
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the DoMetaQuery operation.
public struct DoMetaQueryResult : ResultModel {
    public var commonProp: ResultModelProp = .init()
 
    /// The container for the query result.
    public var metaQuery: MetaQueryResp?
     
}

/// The request for the OpenMetaQuery operation.
public struct OpenMetaQueryRequest : RequestModel {
    public var commonProp: RequestModelProp

    /// The name of the bucket.
    public var bucket: Swift.String? 
    
    /// 
    public var mode: Swift.String?
    

    public init( 
        bucket: Swift.String? = nil,
        mode: Swift.String? = nil,
        commonProp: RequestModelProp? = nil
    ) { 
        self.bucket = bucket
        self.mode = mode
        self.commonProp = commonProp ?? RequestModelProp()
    }
}

/// The result for the OpenMetaQuery operation.
public struct OpenMetaQueryResult : ResultModel {
    public var commonProp: ResultModelProp = .init()

}

