import AlibabaCloudOSS
@testable import AlibabaCloudOSSExtension
import XCTest

class SerdeBucketLoggingTests: XCTestCase {
    func testSerializePutBucketLogging() throws {
        var input = OperationInput()

        var xml = "<BucketLoggingStatus />"
        var request = PutBucketLoggingRequest(bucketLoggingStatus: BucketLoggingStatus())
        try Serde.serializeInput(&request, &input, [Serde.serializePutBucketLogging])
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
        
        xml =
            """
            <BucketLoggingStatus>\
            <LoggingEnabled>\
            <TargetBucket>targetBucket</TargetBucket>\
            <TargetPrefix>targetPrefix</TargetPrefix>\
            </LoggingEnabled>\
            </BucketLoggingStatus>
            """
        request = PutBucketLoggingRequest(
            bucketLoggingStatus: BucketLoggingStatus(
                loggingEnabled: LoggingEnabled(targetBucket: "targetBucket", targetPrefix: "targetPrefix")
            )
        )
        try Serde.serializeInput(&request, &input, [Serde.serializePutBucketLogging])
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
    }

    func testDeserializeGetBucketLogging() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = GetBucketLoggingResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketLogging]))

        // normal
        let xml =
            """
            <BucketLoggingStatus>\
            <LoggingEnabled>\
            <TargetBucket>targetBucket</TargetBucket>\
            <TargetPrefix>targetPrefix</TargetPrefix>\
            </LoggingEnabled>\
            </BucketLoggingStatus>
            """
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = GetBucketLoggingResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketLogging]))
        XCTAssertEqual(result.bucketLoggingStatus?.loggingEnabled?.targetBucket, "targetBucket")
        XCTAssertEqual(result.bucketLoggingStatus?.loggingEnabled?.targetPrefix, "targetPrefix")
    }
    
    func testSerializePutUserDefinedLogFieldsConfig() throws {
        var input = OperationInput()

        var xml = "<UserDefinedLogFieldsConfiguration />"
        var request = PutUserDefinedLogFieldsConfigRequest(userDefinedLogFieldsConfiguration: UserDefinedLogFieldsConfiguration())
        try Serde.serializeInput(&request, &input, [Serde.serializePutUserDefinedLogFieldsConfig])
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
        
        xml =
            """
            <UserDefinedLogFieldsConfiguration>\
            <HeaderSet>\
            <header>header1</header>\
            <header>header2</header>\
            <header>header3</header>\
            </HeaderSet>\
            <ParamSet>\
            <parameter>param1</parameter>\
            <parameter>param2</parameter>\
            </ParamSet>\
            </UserDefinedLogFieldsConfiguration>
            """
        request = PutUserDefinedLogFieldsConfigRequest(
            userDefinedLogFieldsConfiguration: UserDefinedLogFieldsConfiguration(
                headerSet: HeaderSet(headers: ["header1", "header2", "header3"]),
                paramSet: ParamSet(parameters: ["param1", "param2"])
            )
        )
        try Serde.serializeInput(&request, &input, [Serde.serializePutUserDefinedLogFieldsConfig])
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
    }
    
    func testDeserializeGetUserDefinedLogFieldsConfig() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = GetUserDefinedLogFieldsConfigResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetUserDefinedLogFieldsConfig]))

        // normal
        let xml =
            """
            <UserDefinedLogFieldsConfiguration>
            <HeaderSet>
            <header>header1</header>
            <header>header2</header>
            <header>header3</header>
            </HeaderSet>
            <ParamSet>
            <parameter>param1</parameter>
            <parameter>param2</parameter>
            </ParamSet>
            </UserDefinedLogFieldsConfiguration>
            """
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = GetUserDefinedLogFieldsConfigResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetUserDefinedLogFieldsConfig]))
        XCTAssertEqual(result.userDefinedLogFieldsConfiguration?.headerSet?.headers, ["header1", "header2", "header3"])
        XCTAssertEqual(result.userDefinedLogFieldsConfiguration?.paramSet?.parameters, ["param1", "param2"])
    }
}
