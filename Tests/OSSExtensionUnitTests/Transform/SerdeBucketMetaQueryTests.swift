import AlibabaCloudOSS
@testable import AlibabaCloudOSSExtension
import XCTest

class SerdeBucketMetaQueryTests: XCTestCase {
    
    func testDeserializeGetMetaQueryStatus() throws {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = GetMetaQueryStatusResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetMetaQueryStatus]))

        // normal
        let xml =
            """
            <MetaQueryStatus>\
            <State>Running</State>\
            <Phase>FullScanning</Phase>\
            <CreateTime>2024-09-11T10:49:17.289372919+08:00</CreateTime>\
            <UpdateTime>2024-09-11T10:49:17.289372919+08:00</UpdateTime>\
            <MetaQueryMode>basic</MetaQueryMode>\
            </MetaQueryStatus>
            """
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = GetMetaQueryStatusResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetMetaQueryStatus]))
        XCTAssertEqual(result.metaQueryStatus?.createTime, "2024-09-11T10:49:17.289372919+08:00")
        XCTAssertEqual(result.metaQueryStatus?.phase, "FullScanning")
        XCTAssertEqual(result.metaQueryStatus?.state, "Running")
        XCTAssertEqual(result.metaQueryStatus?.updateTime, "2024-09-11T10:49:17.289372919+08:00")
    }
    
    func testSerializeDoMetaQuery() throws {
        var input = OperationInput()

        var xml = "<MetaQuery />"
        var request = DoMetaQueryRequest(metaQuery: MetaQuery())
        try Serde.serializeInput(&request, &input, [Serde.serializeDoMetaQuery])
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
        
        // basic
        xml =
            """
            <MetaQuery>\
            <MaxResults>5</MaxResults>\
            <Query>{&quot;Field&quot;: &quot;Size&quot;,&quot;Value&quot;: &quot;1048576&quot;,&quot;Operation&quot;: &quot;gt&quot;}</Query>\
            <Sort>Size</Sort>\
            <Order>asc</Order>\
            <Aggregations>\
            <Aggregation>\
            <Field>Size</Field>\
            <Operation>sum</Operation>\
            </Aggregation>\
            <Aggregation>\
            <Value>1.0</Value>\
            <Groups>\
            <Group>\
            <Value>value</Value>\
            <Count>1</Count>\
            </Group>\
            </Groups>\
            <Field>Size</Field>\
            <Operation>max</Operation>\
            </Aggregation>\
            </Aggregations>\
            <NextToken>token</NextToken>\
            </MetaQuery>
            """
        request = DoMetaQueryRequest(
            metaQuery: MetaQuery(
                maxResults: 5,
                query: "{\"Field\": \"Size\",\"Value\": \"1048576\",\"Operation\": \"gt\"}",
                sort: "Size",
                order: "asc",
                aggregations: MetaQueryAggregations(
                    aggregations: [MetaQueryAggregationsResult(
                        field: "Size",
                        operation: "sum"
                    ), MetaQueryAggregationsResult(
                        value: 1,
                        groups: Groups(groups: [Group(value: "value", count: 1)]),
                        field: "Size",
                        operation: "max"
                    )]
                ),
                nextToken: "token",
            )
        )
        try Serde.serializeInput(&request, &input, [Serde.serializeDoMetaQuery])
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
        
        // semantic
        xml =
            """
            <MetaQuery>\
            <MaxResults>99</MaxResults>\
            <Query>俯瞰白雪覆盖的森林</Query>\
            <MediaTypes>\
            <MediaType>image</MediaType>\
            </MediaTypes>\
            <SimpleQuery>{&quot;Operation&quot;:&quot;gt&quot;, &quot;Field&quot;: &quot;Size&quot;, &quot;Value&quot;: &quot;30&quot;}</SimpleQuery>\
            </MetaQuery>
            """
        request = DoMetaQueryRequest(
            metaQuery: MetaQuery(
                maxResults: 99,
                query: "俯瞰白雪覆盖的森林",
                mediaTypes: MediaTypes(mediaTypes: ["image"]),
                simpleQuery: "{\"Operation\":\"gt\", \"Field\": \"Size\", \"Value\": \"30\"}"
            )
        )
        try Serde.serializeInput(&request, &input, [Serde.serializeDoMetaQuery])
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
    }

    func testDeserializeDoMetaQuery() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = DoMetaQueryResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeDoMetaQuery]))
        
        // basic
        var xml =
            """
            <MetaQuery>
            <NextToken>MTIzNDU2Nzg6aW1tdGVzdDpleGFtcGxlYnVja2V0OmRhdGFzZXQwMDE6b3NzOi8vZXhhbXBsZWJ1Y2tldC9zYW1wbGVvYmplY3QxLmpw****</NextToken>
            <Files>
            <File>
            <Filename>exampleobject.txt</Filename>
            <Size>120</Size>
            <FileModifiedTime>2025-05-19T16:14:38+08:00</FileModifiedTime>
            <OSSObjectType>Normal</OSSObjectType>
            <OSSStorageClass>Standard</OSSStorageClass>
            <ObjectACL>default</ObjectACL>
            <ETag>"fba9dede5f27731c9771645a3986****"</ETag>
            <OSSCRC64>4858A48BD1466884</OSSCRC64>
            <OSSTaggingCount>2</OSSTaggingCount>
            <OSSTagging>
            <Tagging>
            <Key>owner</Key>
            <Value>John</Value>
            </Tagging>
            <Tagging>
            <Key>type</Key>
            <Value>document</Value>
            </Tagging>
            </OSSTagging>
            <OSSUserMeta>
            <UserMeta>
            <Key>x-oss-meta-location</Key>
            <Value>hangzhou</Value>
            </UserMeta>
            </OSSUserMeta>
            </File>
            </Files>
            </MetaQuery>
            """
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = DoMetaQueryResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeDoMetaQuery]))
        XCTAssertEqual(result.metaQuery?.nextToken, "MTIzNDU2Nzg6aW1tdGVzdDpleGFtcGxlYnVja2V0OmRhdGFzZXQwMDE6b3NzOi8vZXhhbXBsZWJ1Y2tldC9zYW1wbGVvYmplY3QxLmpw****")
        XCTAssertEqual(result.metaQuery?.files?.files?.count, 1)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.filename, "exampleobject.txt")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.size, 120)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.fileModifiedTime, "2025-05-19T16:14:38+08:00")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.ossObjectType, "Normal")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.ossStorageClass, "Standard")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.objectACL, "default")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.eTag, "\"fba9dede5f27731c9771645a3986****\"")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.ossCRC64, "4858A48BD1466884")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.ossTaggingCount, 2)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.ossTagging?.taggings?.count, 2)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.ossTagging?.taggings?.first?.key, "owner")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.ossTagging?.taggings?.first?.value, "John")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.ossTagging?.taggings?.last?.key, "type")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.ossTagging?.taggings?.last?.value, "document")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.ossUserMeta?.userMetas?.count, 1)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.ossUserMeta?.userMetas?.first?.key, "x-oss-meta-location")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.ossUserMeta?.userMetas?.first?.value, "hangzhou")

        // semantic
        xml =
            """
            <MetaQuery>
            <Aggregations>
            <Aggregation>
            <Field>filed</Field>
            <Groups>
            <Group>
            <Count>1</Count>
            <Value>val</Value>
            </Group>
            </Groups>
            <Operation>opt</Operation>
            <Value>1.0</Value>
            </Aggregation>
            </Aggregations>
            <Files>
            <File>
            <URI>oss://examplebucket/test-object.jpg</URI>
            <Filename>sampleobject.jpg</Filename>
            <Size>1000</Size>
            <ObjectACL>default</ObjectACL>
            <FileModifiedTime>2025-05-19T16:15:33+08:00</FileModifiedTime>
            <ServerSideEncryption>AES256</ServerSideEncryption>
            <ServerSideEncryptionCustomerAlgorithm>SM4</ServerSideEncryptionCustomerAlgorithm>
            <ETag>\"1D9C280A7C4F67F7EF873E28449****\"</ETag>
            <OSSCRC64>559890638950338001</OSSCRC64>
            <ProduceTime>2021-06-29T14:50:15.011643661+08:00</ProduceTime>
            <ContentType>image/jpeg</ContentType>
            <MediaType>image</MediaType>
            <LatLong>30.134390,120.074997</LatLong>
            <Title>test</Title>
            <OSSExpiration>2024-12-01T12:00:00.000Z</OSSExpiration>
            <AccessControlAllowOrigin>https://aliyundoc.com</AccessControlAllowOrigin>
            <AccessControlRequestMethod>PUT</AccessControlRequestMethod>
            <ServerSideDataEncryption>SM4</ServerSideDataEncryption>
            <ServerSideEncryptionKeyId>9468da86-3509-4f8d-a61e-6eab1eac****</ServerSideEncryptionKeyId>
            <CacheControl>no-cache</CacheControl>
            <ContentDisposition>attachment; filename =test.jpg</ContentDisposition>
            <ContentEncoding>UTF-8</ContentEncoding>
            <ContentLanguage>zh-CN</ContentLanguage>
            <ImageHeight>500</ImageHeight>
            <ImageWidth>270</ImageWidth>
            <VideoWidth>1080</VideoWidth>
            <VideoHeight>1920</VideoHeight>
            <VideoStreams>
            <VideoStream>
            <CodecName>h264</CodecName>
            <Language>en</Language>
            <Bitrate>5407765</Bitrate>
            <FrameRate>25/1</FrameRate>
            <StartTime>0</StartTime>
            <Duration>22.88</Duration>
            <FrameCount>572</FrameCount>
            <BitDepth>8</BitDepth>
            <PixelFormat>yuv420p</PixelFormat>
            <ColorSpace>bt709</ColorSpace>
            <Height>720</Height>
            <Width>1280</Width>
            </VideoStream>
            <VideoStream>
            <CodecName>h264</CodecName>
            <Language>en</Language>
            <Bitrate>5407765</Bitrate>
            <FrameRate>25/1</FrameRate>
            <StartTime>0</StartTime>
            <Duration>22.88</Duration>
            <FrameCount>572</FrameCount>
            <BitDepth>8</BitDepth>
            <PixelFormat>yuv420p</PixelFormat>
            <ColorSpace>bt709</ColorSpace>
            <Height>720</Height>
            <Width>1280</Width>
            </VideoStream>
            </VideoStreams>
            <AudioStreams>
            <AudioStream>
            <CodecName>aac</CodecName>
            <Bitrate>1048576</Bitrate>
            <SampleRate>48000</SampleRate>
            <StartTime>0.0235</StartTime>
            <Duration>3.690667</Duration>
            <Channels>2</Channels>
            <Language>en</Language>
            </AudioStream>
            </AudioStreams>
            <Subtitles>
            <Subtitle>
            <CodecName>mov_text</CodecName>
            <Language>en</Language>
            <StartTime>0</StartTime>
            <Duration>71.378</Duration>
            </Subtitle>
            <Subtitle>
            <CodecName>mov_text</CodecName>
            <Language>en</Language>
            <StartTime>72</StartTime>
            <Duration>71.378</Duration>
            </Subtitle>
            </Subtitles>
            <Bitrate>5407765</Bitrate>
            <Artist>Jane</Artist>
            <AlbumArtist>Jenny</AlbumArtist>
            <Composer>Jane</Composer>
            <Performer>Jane</Performer>
            <Album>FirstAlbum</Album>
            <Duration>71.378</Duration>
            <Addresses>
            <Address>
            <AddressLine>中国浙江省杭州市余杭区文一西路969号</AddressLine>
            <City>杭州市</City>
            <Country>中国</Country>
            <District>余杭区</District>
            <Language>zh-Hans</Language>
            <Province>浙江省</Province>
            <Township>文一西路</Township>
            </Address>
            <Address>
            <AddressLine>中国浙江省杭州市余杭区文一西路970号</AddressLine>
            <City>杭州市</City>
            <Country>中国</Country>
            <District>余杭区</District>
            <Language>zh-Hans</Language>
            <Province>浙江省</Province>
            <Township>文一西路</Township>
            </Address>
            </Addresses>
            <OSSObjectType>Normal</OSSObjectType>
            <OSSStorageClass>Standard</OSSStorageClass>
            <OSSTaggingCount>2</OSSTaggingCount>
            <OSSTagging>
            <Tagging>
            <Key>key</Key>
            <Value>val</Value>
            </Tagging>
            <Tagging>
            <Key>key2</Key>
            <Value>val2</Value>
            </Tagging>
            </OSSTagging>
            <OSSUserMeta>
            <UserMeta>
            <Key>key</Key>
            <Value>val</Value>
            </UserMeta>
            </OSSUserMeta>
            </File>
            </Files>
            </MetaQuery>
            """
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = DoMetaQueryResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeDoMetaQuery]))
        XCTAssertEqual(result.metaQuery?.aggregations?.aggregations?.count, 1)
        XCTAssertEqual(result.metaQuery?.aggregations?.aggregations?.first?.field, "filed")
        XCTAssertEqual(result.metaQuery?.aggregations?.aggregations?.first?.groups?.groups?.count, 1)
        XCTAssertEqual(result.metaQuery?.aggregations?.aggregations?.first?.groups?.groups?.first?.count, 1)
        XCTAssertEqual(result.metaQuery?.aggregations?.aggregations?.first?.groups?.groups?.first?.value, "val")
        XCTAssertEqual(result.metaQuery?.aggregations?.aggregations?.first?.operation, "opt")
        XCTAssertEqual(result.metaQuery?.aggregations?.aggregations?.first?.value, 1)
        XCTAssertEqual(result.metaQuery?.files?.files?.count, 1)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.accessControlAllowOrigin, "https://aliyundoc.com")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.accessControlRequestMethod, "PUT")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.addresses?.addresses?.count, 2)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.addresses?.addresses?.first?.addressLine, "中国浙江省杭州市余杭区文一西路969号")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.addresses?.addresses?.first?.city, "杭州市")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.addresses?.addresses?.first?.district, "余杭区")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.addresses?.addresses?.first?.language, "zh-Hans")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.addresses?.addresses?.first?.province, "浙江省")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.addresses?.addresses?.first?.township, "文一西路")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.addresses?.addresses?.last?.addressLine, "中国浙江省杭州市余杭区文一西路970号")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.addresses?.addresses?.last?.city, "杭州市")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.addresses?.addresses?.last?.district, "余杭区")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.addresses?.addresses?.last?.language, "zh-Hans")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.addresses?.addresses?.last?.province, "浙江省")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.addresses?.addresses?.last?.township, "文一西路")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.album, "FirstAlbum")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.albumArtist, "Jenny")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.artist, "Jane")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.audioStreams?.audioStreams?.count, 1)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.audioStreams?.audioStreams?.first?.bitrate, 1048576)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.audioStreams?.audioStreams?.first?.channels, 2)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.audioStreams?.audioStreams?.first?.codecName, "aac")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.audioStreams?.audioStreams?.first?.duration, 3.690667)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.audioStreams?.audioStreams?.first?.language, "en")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.audioStreams?.audioStreams?.first?.sampleRate, 48000)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.audioStreams?.audioStreams?.first?.startTime, 0.0235)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.bitrate, 5407765)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.cacheControl, "no-cache")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.composer, "Jane")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.contentDisposition, "attachment; filename =test.jpg")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.contentEncoding, "UTF-8")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.contentLanguage, "zh-CN")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.contentType, "image/jpeg")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.duration, 71.378)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.eTag, "\"1D9C280A7C4F67F7EF873E28449****\"")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.fileModifiedTime, "2025-05-19T16:15:33+08:00")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.filename, "sampleobject.jpg")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.imageHeight, 500)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.imageWidth, 270)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.latLong, "30.134390,120.074997")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.mediaType, "image")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.objectACL, "default")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.performer, "Jane")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.produceTime, "2021-06-29T14:50:15.011643661+08:00")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.serverSideEncryption, "AES256")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.serverSideDataEncryption, "SM4")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.serverSideEncryptionCustomerAlgorithm, "SM4")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.serverSideEncryptionKeyId, "9468da86-3509-4f8d-a61e-6eab1eac****")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.size, 1000)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.subtitles?.subtitles?.count, 2)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.subtitles?.subtitles?.first?.codecName, "mov_text")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.subtitles?.subtitles?.first?.duration, 71.378)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.subtitles?.subtitles?.first?.language, "en")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.subtitles?.subtitles?.first?.startTime, 0)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.subtitles?.subtitles?.last?.codecName, "mov_text")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.subtitles?.subtitles?.last?.duration, 71.378)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.subtitles?.subtitles?.last?.language, "en")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.subtitles?.subtitles?.last?.startTime, 72)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.title, "test")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.videoHeight, 1920)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.videoStreams?.videoStreams?.count, 2)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.videoStreams?.videoStreams?.first?.bitDepth, 8)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.videoStreams?.videoStreams?.first?.bitrate, 5407765)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.videoStreams?.videoStreams?.first?.codecName, "h264")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.videoStreams?.videoStreams?.first?.colorSpace, "bt709")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.videoStreams?.videoStreams?.first?.duration, 22.88)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.videoStreams?.videoStreams?.first?.frameCount, 572)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.videoStreams?.videoStreams?.first?.frameRate, "25/1")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.videoStreams?.videoStreams?.first?.height, 720)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.videoStreams?.videoStreams?.first?.language, "en")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.videoStreams?.videoStreams?.first?.pixelFormat, "yuv420p")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.videoStreams?.videoStreams?.first?.startTime, 0)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.videoStreams?.videoStreams?.first?.width, 1280)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.videoStreams?.videoStreams?.last?.bitDepth, 8)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.videoStreams?.videoStreams?.last?.bitrate, 5407765)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.videoStreams?.videoStreams?.last?.codecName, "h264")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.videoStreams?.videoStreams?.last?.colorSpace, "bt709")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.videoStreams?.videoStreams?.last?.duration, 22.88)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.videoStreams?.videoStreams?.last?.frameCount, 572)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.videoStreams?.videoStreams?.last?.frameRate, "25/1")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.videoStreams?.videoStreams?.last?.height, 720)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.videoStreams?.videoStreams?.last?.language, "en")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.videoStreams?.videoStreams?.last?.pixelFormat, "yuv420p")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.videoStreams?.videoStreams?.last?.startTime, 0)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.videoStreams?.videoStreams?.last?.width, 1280)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.videoWidth, 1080)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.ossCRC64, "559890638950338001")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.ossExpiration, "2024-12-01T12:00:00.000Z")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.ossObjectType, "Normal")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.ossStorageClass, "Standard")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.ossTagging?.taggings?.count, 2)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.ossTagging?.taggings?.first?.key, "key")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.ossTagging?.taggings?.first?.value, "val")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.ossTagging?.taggings?.last?.key, "key2")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.ossTagging?.taggings?.last?.value, "val2")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.ossTaggingCount, 2)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.ossUserMeta?.userMetas?.count, 1)
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.ossUserMeta?.userMetas?.first?.key, "key")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.ossUserMeta?.userMetas?.first?.value, "val")
        XCTAssertEqual(result.metaQuery?.files?.files?.first?.uri, "oss://examplebucket/test-object.jpg")
    }
    
    func testSerializeOpenMetaQuery() throws {
        var input = OperationInput()
        
        var request = OpenMetaQueryRequest()
        try Serde.serializeInput(&request, &input, [Serde.serializeOpenMetaQuery])
        XCTAssertNil(input.parameters["mode"] as Any?)
        
        request = OpenMetaQueryRequest(mode: "basic")
        try Serde.serializeInput(&request, &input, [Serde.serializeOpenMetaQuery])
        XCTAssertEqual(input.parameters["mode"], "basic")
    }
}
