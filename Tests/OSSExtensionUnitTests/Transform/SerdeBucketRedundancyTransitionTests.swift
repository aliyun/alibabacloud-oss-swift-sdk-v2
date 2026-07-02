import AlibabaCloudOSS
@testable import AlibabaCloudOSSExtension
import XCTest

class SerdeBucketRedundancyTransitionTests: XCTestCase {
    func testSerializeGetBucketDataRedundancyTransition() throws {
        var input = OperationInput()

        var request = GetBucketDataRedundancyTransitionRequest()
        try Serde.serializeInput(&request, &input, [Serde.serializeGetBucketDataRedundancyTransition])
        XCTAssertNil(input.parameters["x-oss-redundancy-transition-taskid"] as Any?)
        
        request = GetBucketDataRedundancyTransitionRequest(redundancyTransitionTaskid: "taskID")
        try Serde.serializeInput(&request, &input, [Serde.serializeGetBucketDataRedundancyTransition])
        XCTAssertEqual(input.parameters["x-oss-redundancy-transition-taskid"], "taskID")
    }
    
    func testDdeserializeGetBucketDataRedundancyTransition() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = GetBucketDataRedundancyTransitionResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketDataRedundancyTransition]))

        // normal
        let xml =
            """
            <BucketDataRedundancyTransition>\
            <Bucket>examplebucket</Bucket>\
            <TaskId>909c6c818dd041d1a44e0fdc66aa****</TaskId>\
            <Status>Finished</Status>\
            <CreateTime>2023-11-17T09:14:39.000Z</CreateTime>\
            <StartTime>2023-11-17T09:14:39.000Z</StartTime>\
            <ProcessPercentage>100</ProcessPercentage>\
            <EstimatedRemainingTime>0</EstimatedRemainingTime>\
            <EndTime>2023-11-18T09:14:39.000Z</EndTime>\
            </BucketDataRedundancyTransition>
            """
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = GetBucketDataRedundancyTransitionResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketDataRedundancyTransition]))
        XCTAssertEqual(result.bucketDataRedundancyTransition?.bucket, "examplebucket")
        XCTAssertEqual(result.bucketDataRedundancyTransition?.taskId, "909c6c818dd041d1a44e0fdc66aa****")
        XCTAssertEqual(result.bucketDataRedundancyTransition?.status, "Finished")
        XCTAssertEqual(result.bucketDataRedundancyTransition?.createTime, "2023-11-17T09:14:39.000Z")
        XCTAssertEqual(result.bucketDataRedundancyTransition?.startTime, "2023-11-17T09:14:39.000Z")
        XCTAssertEqual(result.bucketDataRedundancyTransition?.endTime, "2023-11-18T09:14:39.000Z")
        XCTAssertEqual(result.bucketDataRedundancyTransition?.processPercentage, 100)
        XCTAssertEqual(result.bucketDataRedundancyTransition?.estimatedRemainingTime, 0)
    }

    func testDeserializeListBucketDataRedundancyTransition() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = ListBucketDataRedundancyTransitionResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeListBucketDataRedundancyTransition]))

        // normal
        let xml =
            """
            <ListBucketDataRedundancyTransition>
            <BucketDataRedundancyTransition>
            <Bucket>examplebucket</Bucket>
            <TaskId>4be5beb0f74f490186311b268bf6****</TaskId>
            <Status>Queueing</Status>
            <CreateTime>2023-11-17T08:40:17.000Z</CreateTime>
            <StartTime>2023-11-18T08:40:17.000Z</StartTime>
            <EndTime>2023-11-19T08:40:17.000Z</EndTime>
            <ProcessPercentage>100</ProcessPercentage>
            <EstimatedRemainingTime>0</EstimatedRemainingTime>
            </BucketDataRedundancyTransition>
            <BucketDataRedundancyTransition>
            <Bucket>examplebucket</Bucket>
            <TaskId>2be5beb0f74f490186311b268bf6****</TaskId>
            <Status>Processing</Status>
            <CreateTime>2023-11-17T09:40:17.000Z</CreateTime>
            <StartTime>2023-11-18T09:40:17.000Z</StartTime>
            <EndTime>2023-11-19T09:40:17.000Z</EndTime>
            <ProcessPercentage>100</ProcessPercentage>
            <EstimatedRemainingTime>0</EstimatedRemainingTime>
            </BucketDataRedundancyTransition>
            </ListBucketDataRedundancyTransition>
            """
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = ListBucketDataRedundancyTransitionResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeListBucketDataRedundancyTransition]))
        XCTAssertEqual(result.listBucketDataRedundancyTransition?.bucketDataRedundancyTransition?.count, 2)
        XCTAssertEqual(result.listBucketDataRedundancyTransition?.bucketDataRedundancyTransition?[0].bucket, "examplebucket")
        XCTAssertEqual(result.listBucketDataRedundancyTransition?.bucketDataRedundancyTransition?[0].taskId, "4be5beb0f74f490186311b268bf6****")
        XCTAssertEqual(result.listBucketDataRedundancyTransition?.bucketDataRedundancyTransition?[0].status, "Queueing")
        XCTAssertEqual(result.listBucketDataRedundancyTransition?.bucketDataRedundancyTransition?[0].createTime, "2023-11-17T08:40:17.000Z")
        XCTAssertEqual(result.listBucketDataRedundancyTransition?.bucketDataRedundancyTransition?[0].startTime, "2023-11-18T08:40:17.000Z")
        XCTAssertEqual(result.listBucketDataRedundancyTransition?.bucketDataRedundancyTransition?[0].endTime, "2023-11-19T08:40:17.000Z")
        XCTAssertEqual(result.listBucketDataRedundancyTransition?.bucketDataRedundancyTransition?[0].processPercentage, 100)
        XCTAssertEqual(result.listBucketDataRedundancyTransition?.bucketDataRedundancyTransition?[0].estimatedRemainingTime, 0)
        XCTAssertEqual(result.listBucketDataRedundancyTransition?.bucketDataRedundancyTransition?[1].bucket, "examplebucket")
        XCTAssertEqual(result.listBucketDataRedundancyTransition?.bucketDataRedundancyTransition?[1].taskId, "2be5beb0f74f490186311b268bf6****")
        XCTAssertEqual(result.listBucketDataRedundancyTransition?.bucketDataRedundancyTransition?[1].status, "Processing")
        XCTAssertEqual(result.listBucketDataRedundancyTransition?.bucketDataRedundancyTransition?[1].createTime, "2023-11-17T09:40:17.000Z")
        XCTAssertEqual(result.listBucketDataRedundancyTransition?.bucketDataRedundancyTransition?[1].startTime, "2023-11-18T09:40:17.000Z")
        XCTAssertEqual(result.listBucketDataRedundancyTransition?.bucketDataRedundancyTransition?[1].endTime, "2023-11-19T09:40:17.000Z")
        XCTAssertEqual(result.listBucketDataRedundancyTransition?.bucketDataRedundancyTransition?[1].processPercentage, 100)
        XCTAssertEqual(result.listBucketDataRedundancyTransition?.bucketDataRedundancyTransition?[1].estimatedRemainingTime, 0)
    }
    
    func testSerializeCreateBucketDataRedundancyTransition() throws {
        var input = OperationInput()

        var request = CreateBucketDataRedundancyTransitionRequest()
        try Serde.serializeInput(&request, &input, [Serde.serializeCreateBucketDataRedundancyTransition])
        XCTAssertNil(input.parameters["x-oss-target-redundancy-type"] as Any?)
        
        request = CreateBucketDataRedundancyTransitionRequest(targetRedundancyType: "targetRedundancyType")
        try Serde.serializeInput(&request, &input, [Serde.serializeCreateBucketDataRedundancyTransition])
        XCTAssertEqual(input.parameters["x-oss-target-redundancy-type"], "targetRedundancyType")
    }
    
    func testDeserializeCreateBucketDataRedundancyTransition() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = CreateBucketDataRedundancyTransitionResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeCreateBucketDataRedundancyTransition]))

        // normal
        let xml =
            """
            <BucketDataRedundancyTransition>
            <TaskId>4be5beb0f74f490186311b268bf6****</TaskId>
            </BucketDataRedundancyTransition>
            """
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = CreateBucketDataRedundancyTransitionResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeCreateBucketDataRedundancyTransition]))
        XCTAssertEqual(result.bucketDataRedundancyTransition?.taskId, "4be5beb0f74f490186311b268bf6****")
    }
    
    func testSerializeDeleteBucketDataRedundancyTransition() throws {
        var input = OperationInput()

        var request = DeleteBucketDataRedundancyTransitionRequest()
        try Serde.serializeInput(&request, &input, [Serde.serializeDeleteBucketDataRedundancyTransition])
        XCTAssertNil(input.parameters["x-oss-redundancy-transition-taskid"] as Any?)
        
        request = DeleteBucketDataRedundancyTransitionRequest(redundancyTransitionTaskid: "taskID")
        try Serde.serializeInput(&request, &input, [Serde.serializeDeleteBucketDataRedundancyTransition])
        XCTAssertEqual(input.parameters["x-oss-redundancy-transition-taskid"], "taskID")
    }
}
