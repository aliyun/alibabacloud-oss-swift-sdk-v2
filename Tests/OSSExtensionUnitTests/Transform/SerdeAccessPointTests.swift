import AlibabaCloudOSS
@testable import AlibabaCloudOSSExtension
import XCTest

class SerdeAccessPointTests: XCTestCase {
    func testSerializeListAccessPoints() throws {
        var input = OperationInput()

        var request = ListAccessPointsRequest()
        try Serde.serializeInput(&request, &input, [Serde.serializeListAccessPoints])
        XCTAssertNil(input.parameters["max-keys"] as Any?)
        XCTAssertNil(input.parameters["continuation-token"] as Any?)

        request = ListAccessPointsRequest(
            maxKeys: 100,
            continuationToken: "continuationToken"
        )
        try Serde.serializeInput(&request, &input, [Serde.serializeListAccessPoints])
        XCTAssertEqual(input.parameters["max-keys"], "100")
        XCTAssertEqual(input.parameters["continuation-token"], "continuationToken")
    }

    func testDeserializeListAccessPoints() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = ListAccessPointsResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeListAccessPoints]))

        // normal
        let xml =
            """
            <ListAccessPointsResult>\
            <IsTruncated>true</IsTruncated>\
            <NextContinuationToken>abc</NextContinuationToken>\
            <AccountId>111933544165****</AccountId>\
            <AccessPoints>\
            <AccessPoint>\
            <Bucket>oss-example</Bucket>\
            <AccessPointName>ap-01</AccessPointName>\
            <Alias>ap-01-ossalias</Alias>\
            <NetworkOrigin>vpc</NetworkOrigin>\
            <VpcConfiguration>\
            <VpcId>vpc-t4nlw426y44rd3iq4****</VpcId>\
            </VpcConfiguration>\
            <Status>enable</Status>\
            </AccessPoint>\
            </AccessPoints>\
            </ListAccessPointsResult>
            """
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = ListAccessPointsResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeListAccessPoints]))
        XCTAssertEqual(result.accessPoints?.accessPoints?.count, 1)
        XCTAssertEqual(result.accessPoints?.accessPoints?.first?.accessPointName, "ap-01")
        XCTAssertEqual(result.accessPoints?.accessPoints?.first?.alias, "ap-01-ossalias")
        XCTAssertEqual(result.accessPoints?.accessPoints?.first?.bucket, "oss-example")
        XCTAssertEqual(result.accessPoints?.accessPoints?.first?.networkOrigin, "vpc")
        XCTAssertEqual(result.accessPoints?.accessPoints?.first?.status, "enable")
        XCTAssertEqual(result.accessPoints?.accessPoints?.first?.vpcConfiguration?.vpcId, "vpc-t4nlw426y44rd3iq4****")
        XCTAssertEqual(result.accountId, "111933544165****")
        XCTAssertEqual(result.isTruncated, true)
        XCTAssertEqual(result.nextContinuationToken, "abc")
    }
    
    func testSerializeGetAccessPoint() throws {
        var input = OperationInput()

        var request = GetAccessPointRequest()
        try Serde.serializeInput(&request, &input, [Serde.serializeGetAccessPoint])
        XCTAssertNil(input.headers["x-oss-access-point-name"] as Any?)

        request = GetAccessPointRequest(
            accessPointName: "accessPointName"
        )
        try Serde.serializeInput(&request, &input, [Serde.serializeGetAccessPoint])
        XCTAssertEqual(input.headers["x-oss-access-point-name"], "accessPointName")
    }
    
    func testDeserializeGetAccessPoint() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = GetAccessPointResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetAccessPoint]))

        // normal
        let xml =
            """
            <GetAccessPointResult>\
            <AccessPointName>ap-01</AccessPointName>\
            <Bucket>oss-example</Bucket>\
            <AccountId>111933544165xxxx</AccountId>\
            <NetworkOrigin>vpc</NetworkOrigin>\
            <VpcConfiguration>\
            <VpcId>vpc-t4nlw426y44rd3iq4xxxx</VpcId>\
            </VpcConfiguration>\
            <AccessPointArn>arn:acs:oss:cn-hangzhou:111933544165xxxx:accesspoint/ap-01</AccessPointArn>\
            <CreationDate>1626769503</CreationDate>\
            <Alias>ap-01-ossalias</Alias>\
            <Status>enable</Status>\
            <Endpoints>\
            <PublicEndpoint>ap-01.oss-cn-hangzhou.oss-accesspoint.aliyuncs.com</PublicEndpoint>\
            <InternalEndpoint>ap-01.oss-cn-hangzhou-internal.oss-accesspoint.aliyuncs.com</InternalEndpoint>\
            </Endpoints>\
            <PublicAccessBlockConfiguration>\
            <BlockPublicAccess>true</BlockPublicAccess>\
            </PublicAccessBlockConfiguration>\
            </GetAccessPointResult>
            """
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = GetAccessPointResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetAccessPoint]))
        XCTAssertEqual(result.accessPointArn, "arn:acs:oss:cn-hangzhou:111933544165xxxx:accesspoint/ap-01")
        XCTAssertEqual(result.accessPointName, "ap-01")
        XCTAssertEqual(result.accountId, "111933544165xxxx")
        XCTAssertEqual(result.alias, "ap-01-ossalias")
        XCTAssertEqual(result.bucket, "oss-example")
        XCTAssertEqual(result.creationDate, "1626769503")
        XCTAssertEqual(result.networkOrigin, "vpc")
        XCTAssertEqual(result.endpoints?.internalEndpoint, "ap-01.oss-cn-hangzhou-internal.oss-accesspoint.aliyuncs.com")
        XCTAssertEqual(result.endpoints?.publicEndpoint, "ap-01.oss-cn-hangzhou.oss-accesspoint.aliyuncs.com")
        XCTAssertEqual(result.publicAccessBlockConfiguration?.blockPublicAccess, true)
        XCTAssertEqual(result.vpcConfiguration?.vpcId, "vpc-t4nlw426y44rd3iq4xxxx")
    }
    
    func testSerializeGetAccessPointPolicy() throws {
        var input = OperationInput()

        var request = GetAccessPointPolicyRequest()
        try Serde.serializeInput(&request, &input, [Serde.serializeGetAccessPointPolicy])
        XCTAssertNil(input.headers["x-oss-access-point-name"] as Any?)

        request = GetAccessPointPolicyRequest(
            accessPointName: "accessPointName"
        )
        try Serde.serializeInput(&request, &input, [Serde.serializeGetAccessPointPolicy])
        XCTAssertEqual(input.headers["x-oss-access-point-name"], "accessPointName")
    }
    
    func testDeserializeGetAccessPointPolicy() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:],
                                     body: .data("hello oss".data(using: .utf8)!))
        var result = GetAccessPointPolicyResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetAccessPointPolicy]))
        XCTAssertEqual(try output.body?.readData(), "hello oss".data(using: .utf8))
    }
    
    func testSerializeDeleteAccessPointPolicy() throws {
        var input = OperationInput()

        var request = DeleteAccessPointPolicyRequest()
        try Serde.serializeInput(&request, &input, [Serde.serializeDeleteAccessPointPolicy])
        XCTAssertNil(input.headers["x-oss-access-point-name"] as Any?)

        request = DeleteAccessPointPolicyRequest(
            accessPointName: "accessPointName"
        )
        try Serde.serializeInput(&request, &input, [Serde.serializeDeleteAccessPointPolicy])
        XCTAssertEqual(input.headers["x-oss-access-point-name"], "accessPointName")
    }
    
    func testSerializePutAccessPointPolicy() throws {
        var input = OperationInput()

        var request = PutAccessPointPolicyRequest()
        try Serde.serializeInput(&request, &input, [Serde.serializePutAccessPointPolicy])
        XCTAssertNil(input.headers["x-oss-access-point-name"] as Any?)

        request = PutAccessPointPolicyRequest(
            accessPointName: "accessPointName",
            body: .data("hello oss".data(using: .utf8)!)
        )
        try Serde.serializeInput(&request, &input, [Serde.serializePutAccessPointPolicy])
        XCTAssertEqual(input.headers["x-oss-access-point-name"], "accessPointName")
        XCTAssertEqual(try input.body?.readData(), "hello oss".data(using: .utf8))
    }
    
    func testSerializeDeleteAccessPoint() throws {
        var input = OperationInput()

        var request = DeleteAccessPointRequest()
        try Serde.serializeInput(&request, &input, [Serde.serializeDeleteAccessPoint])
        XCTAssertNil(input.headers["x-oss-access-point-name"] as Any?)

        request = DeleteAccessPointRequest(
            accessPointName: "accessPointName"
        )
        try Serde.serializeInput(&request, &input, [Serde.serializeDeleteAccessPoint])
        XCTAssertEqual(input.headers["x-oss-access-point-name"], "accessPointName")
    }
    
    func testSerializeCreateAccessPoint() throws {
        var input = OperationInput()

        var xml = "<CreateAccessPointConfiguration />"
        var request = CreateAccessPointRequest(createAccessPointConfiguration: CreateAccessPointConfiguration())
        try Serde.serializeInput(&request, &input, [Serde.serializeCreateAccessPoint])
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))

        xml =
            """
            <CreateAccessPointConfiguration>\
            <AccessPointName>ap-01</AccessPointName>\
            <NetworkOrigin>vpc</NetworkOrigin>\
            <VpcConfiguration>\
            <VpcId>vpc-t4nlw426y44rd3iq4xxxx</VpcId>\
            </VpcConfiguration>\
            </CreateAccessPointConfiguration>
            """
        request = CreateAccessPointRequest(
            createAccessPointConfiguration: CreateAccessPointConfiguration(
                accessPointName: "ap-01",
                networkOrigin: "vpc",
                vpcConfiguration: AccessPointVpcConfiguration(vpcId: "vpc-t4nlw426y44rd3iq4xxxx")
            )
        )
        try Serde.serializeInput(&request, &input, [Serde.serializeCreateAccessPoint])
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
    }
    
    func testDeserializeCreateAccessPoint() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = CreateAccessPointResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeCreateAccessPoint]))

        // normal
        let xml =
            """
            <CreateAccessPointResult>\
            <AccessPointArn>acs:oss:cn-hangzhou:128364106451xxxx:accesspoint/ap-01</AccessPointArn>\
            <Alias>ap-01-45ee7945007a2f0bcb595f63e2215cxxxx-ossalias</Alias>\
            </CreateAccessPointResult>
            """
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = CreateAccessPointResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeCreateAccessPoint]))
        XCTAssertEqual(result.accessPointArn, "acs:oss:cn-hangzhou:128364106451xxxx:accesspoint/ap-01")
        XCTAssertEqual(result.alias, "ap-01-45ee7945007a2f0bcb595f63e2215cxxxx-ossalias")
    }
}

