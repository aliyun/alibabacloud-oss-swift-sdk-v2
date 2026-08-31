import AlibabaCloudOSS
@testable import AlibabaCloudOSSExtension
import XCTest

class SerdeBucketStyleTests: XCTestCase {
    func testSerializePutStyle() throws {
        var input = OperationInput()

        var xml = "<Style />"
        var request = PutStyleRequest(style: StyleContent())
        try Serde.serializeInput(&request, &input, [Serde.serializePutStyle])
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
        
        xml =
            """
            <Style>\
            <Content>content</Content>\
            </Style>
            """
        request = PutStyleRequest(
            styleName: "styleName",
            category: "category",
            style: StyleContent(
                content: "content"
            )
        )
        try Serde.serializeInput(&request, &input, [Serde.serializePutStyle])
        XCTAssertEqual(input.parameters["styleName"], "styleName")
        XCTAssertEqual(input.parameters["category"], "category")
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
    }

    func testDeserializeListStyle() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = ListStyleResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeListStyle]))

        // normal
        let xml =
            """
            <StyleList>\
            <Style>\
            <Name>imagestyle</Name>\
            <Content>image/resize,p_50</Content>\
            <Category>image</Category>\
            <CreateTime>Wed, 20 May 2020 12:07:15 GMT</CreateTime>\
            <LastModifyTime>Wed, 21 May 2020 12:07:15 GMT</LastModifyTime>\
            </Style>\
            <Style>\
            <Name>imagestyle1</Name>\
            <Content>image/resize,w_200</Content>\
            <Category>image</Category>\
            <CreateTime>Wed, 20 May 2020 12:08:04 GMT</CreateTime>\
            <LastModifyTime>Wed, 21 May 2020 12:08:04 GMT</LastModifyTime>\
            </Style>\
            <Style>\
            <Name>imagestyle2</Name>\
            <Content>image/resize,w_300</Content>\
            <Category>image</Category>\
            <CreateTime>Fri, 12 Mar 2021 06:19:13 GMT</CreateTime>\
            <LastModifyTime>Fri, 13 Mar 2021 06:27:21 GMT</LastModifyTime>\
            </Style>\
            </StyleList>
            """
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = ListStyleResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeListStyle]))
        XCTAssertEqual(result.styleList?.styles?.count, 3)
        XCTAssertEqual(result.styleList?.styles?[0].name, "imagestyle")
        XCTAssertEqual(result.styleList?.styles?[0].category, "image")
        XCTAssertEqual(result.styleList?.styles?[0].content, "image/resize,p_50")
        XCTAssertEqual(result.styleList?.styles?[0].lastModifyTime, "Wed, 21 May 2020 12:07:15 GMT")
        XCTAssertEqual(result.styleList?.styles?[0].createTime, "Wed, 20 May 2020 12:07:15 GMT")
        XCTAssertEqual(result.styleList?.styles?[1].name, "imagestyle1")
        XCTAssertEqual(result.styleList?.styles?[1].category, "image")
        XCTAssertEqual(result.styleList?.styles?[1].content, "image/resize,w_200")
        XCTAssertEqual(result.styleList?.styles?[1].lastModifyTime, "Wed, 21 May 2020 12:08:04 GMT")
        XCTAssertEqual(result.styleList?.styles?[1].createTime, "Wed, 20 May 2020 12:08:04 GMT")
        XCTAssertEqual(result.styleList?.styles?[2].name, "imagestyle2")
        XCTAssertEqual(result.styleList?.styles?[2].category, "image")
        XCTAssertEqual(result.styleList?.styles?[2].content, "image/resize,w_300")
        XCTAssertEqual(result.styleList?.styles?[2].lastModifyTime, "Fri, 13 Mar 2021 06:27:21 GMT")
        XCTAssertEqual(result.styleList?.styles?[2].createTime, "Fri, 12 Mar 2021 06:19:13 GMT")
    }
    
    func testSerializeGetStyle() throws {
        var input = OperationInput()

        var request = GetStyleRequest()
        try Serde.serializeInput(&request, &input, [Serde.serializeGetStyle])
        XCTAssertNil(input.parameters["styleName"] as Any?)

        request = GetStyleRequest(styleName: "styleName")
        try Serde.serializeInput(&request, &input, [Serde.serializeGetStyle])
        XCTAssertEqual(input.parameters["styleName"], "styleName")
    }

    func testDeserializeGetStyle() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = GetStyleResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetStyle]))

        // normal
        let xml =
            """
            <Style>
            <Name>imagestyle</Name>
            <Content>image/resize,p_50</Content>
            <Category>image</Category>
            <CreateTime>Wed, 20 May 2020 12:07:15 GMT</CreateTime>
            <LastModifyTime>Wed, 21 May 2020 12:07:15 GMT</LastModifyTime>
            </Style>
            """
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = GetStyleResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetStyle]))
        XCTAssertEqual(result.style?.name, "imagestyle")
        XCTAssertEqual(result.style?.category, "image")
        XCTAssertEqual(result.style?.content, "image/resize,p_50")
        XCTAssertEqual(result.style?.lastModifyTime, "Wed, 21 May 2020 12:07:15 GMT")
        XCTAssertEqual(result.style?.createTime, "Wed, 20 May 2020 12:07:15 GMT")
    }
    
    func testSerializeDeleteStyle() throws {
        var input = OperationInput()

        var request = DeleteStyleRequest()
        try Serde.serializeInput(&request, &input, [Serde.serializeDeleteStyle])
        XCTAssertNil(input.parameters["styleName"] as Any?)

        request = DeleteStyleRequest(styleName: "styleName")
        try Serde.serializeInput(&request, &input, [Serde.serializeDeleteStyle])
        XCTAssertEqual(input.parameters["styleName"], "styleName")
    }
}
