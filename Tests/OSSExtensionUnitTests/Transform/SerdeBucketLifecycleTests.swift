import AlibabaCloudOSS
@testable import AlibabaCloudOSSExtension
import XCTest

class SerdeBucketLifecycleTests: XCTestCase {
    
    func testSerializePutBucketLifecycle() throws {
        var input = OperationInput()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")

        var xml = "<LifecycleConfiguration />"
        var request = PutBucketLifecycleRequest(lifecycleConfiguration: LifecycleConfiguration())
        XCTAssertNoThrow(try Serde.serializeInput(&request, &input, [Serde.serializePutBucketLifecycle]))
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))

        // demo1
        xml =
            """
            <LifecycleConfiguration>\
            <Rule>\
            <ID>rule</ID>\
            <Status>Enabled</Status>\
            <Transition>\
            <Days>30</Days>\
            <StorageClass>IA</StorageClass>\
            </Transition>\
            <Prefix>log/</Prefix>\
            </Rule>\
            </LifecycleConfiguration>
            """
        request = PutBucketLifecycleRequest(
            bucket: "bucket",
            lifecycleConfiguration: LifecycleConfiguration(
                rules: [LifecycleRule(
                    id: "rule",
                    status: "Enabled",
                    prefix: "log/",
                    transitions: [Transition(
                        days: 30,
                        storageClass: "IA"
                    )]
                )]
            )
        )
        XCTAssertNoThrow(try Serde.serializeInput(&request, &input, [Serde.serializePutBucketLifecycle]))
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
        
        // demo2
        xml =
            """
            <LifecycleConfiguration>\
            <Rule>\
            <ID>rule</ID>\
            <Status>Enabled</Status>\
            <Prefix>log/</Prefix>\
            <Expiration>\
            <Days>90</Days>\
            </Expiration>\
            </Rule>\
            </LifecycleConfiguration>
            """
        request = PutBucketLifecycleRequest(
            bucket: "bucket",
            lifecycleConfiguration: LifecycleConfiguration(
                rules: [LifecycleRule(
                    id: "rule",
                    status: "Enabled",
                    prefix: "log/",
                    expiration: Expiration(
                        days: 90
                    )
                )]
            )
        )
        XCTAssertNoThrow(try Serde.serializeInput(&request, &input, [Serde.serializePutBucketLifecycle]))
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
        
        // demo3
        xml =
            """
            <LifecycleConfiguration>\
            <Rule>\
            <ID>rule</ID>\
            <Status>Enabled</Status>\
            <Transition>\
            <Days>30</Days>\
            <StorageClass>IA</StorageClass>\
            </Transition>\
            <Transition>\
            <Days>60</Days>\
            <StorageClass>Archive</StorageClass>\
            </Transition>\
            <Prefix>log/</Prefix>\
            <Expiration>\
            <Days>3600</Days>\
            </Expiration>\
            </Rule>\
            </LifecycleConfiguration>
            """
        request = PutBucketLifecycleRequest(
            bucket: "bucket",
            lifecycleConfiguration: LifecycleConfiguration(
                rules: [LifecycleRule(
                    id: "rule",
                    status: "Enabled",
                    prefix: "log/",
                    transitions: [Transition(days: 30,
                                             storageClass: "IA"),
                                  Transition(days: 60,
                                             storageClass: "Archive")],
                    expiration: Expiration(days: 3600)
                )]
            )
        )
        XCTAssertNoThrow(try Serde.serializeInput(&request, &input, [Serde.serializePutBucketLifecycle]))
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
        
        // demo4
        xml =
            """
            <LifecycleConfiguration>\
            <Rule>\
            <ID>rule</ID>\
            <Status>Enabled</Status>\
            <Prefix></Prefix>\
            <Expiration>\
            <ExpiredObjectDeleteMarker>true</ExpiredObjectDeleteMarker>\
            </Expiration>\
            <NoncurrentVersionExpiration>\
            <NoncurrentDays>5</NoncurrentDays>\
            </NoncurrentVersionExpiration>\
            </Rule>\
            </LifecycleConfiguration>
            """
        request = PutBucketLifecycleRequest(
            bucket: "bucket",
            lifecycleConfiguration: LifecycleConfiguration(
                rules: [LifecycleRule(
                    id: "rule",
                    status: "Enabled",
                    prefix: "",
                    expiration: Expiration(expiredObjectDeleteMarker: true),
                    noncurrentVersionExpiration: NoncurrentVersionExpiration(noncurrentDays: 5)
                )]
            )
        )
        XCTAssertNoThrow(try Serde.serializeInput(&request, &input, [Serde.serializePutBucketLifecycle]))
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
        
        // demo5
        xml =
            """
            <LifecycleConfiguration>\
            <Rule>\
            <ID>rule</ID>\
            <Status>Enabled</Status>\
            <Transition>\
            <Days>30</Days>\
            <StorageClass>Archive</StorageClass>\
            </Transition>\
            <Filter>\
            <Not>\
            <Prefix>log</Prefix>\
            <Tag>\
            <Key>key1</Key>\
            <Value>value1</Value>\
            </Tag>\
            </Not>\
            </Filter>\
            <Prefix></Prefix>\
            <Expiration>\
            <Days>100</Days>\
            </Expiration>\
            </Rule>\
            </LifecycleConfiguration>
            """
        request = PutBucketLifecycleRequest(
            bucket: "bucket",
            lifecycleConfiguration: LifecycleConfiguration(
                rules: [LifecycleRule(
                    id: "rule",
                    status: "Enabled",
                    prefix: "",
                    transitions: [Transition(days: 30,
                                             storageClass: "Archive")],
                    filter: Filter(
                        not: Not(
                            prefix: "log",
                            tag: Tag(
                                key: "key1",
                                value: "value1"
                            )
                        )
                    ),
                    expiration: Expiration(days: 100)
                )]
            )
        )
        XCTAssertNoThrow(try Serde.serializeInput(&request, &input, [Serde.serializePutBucketLifecycle]))
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
        
        // demo6
        xml =
            """
            <LifecycleConfiguration>\
            <Rule>\
            <ID>rule</ID>\
            <Status>Enabled</Status>\
            <Transition>\
            <ReturnToStdWhenVisit>true</ReturnToStdWhenVisit>\
            <Days>30</Days>\
            <StorageClass>IA</StorageClass>\
            <IsAccessTime>true</IsAccessTime>\
            </Transition>\
            <Prefix>log/</Prefix>\
            </Rule>\
            </LifecycleConfiguration>
            """
        request = PutBucketLifecycleRequest(
            bucket: "bucket",
            lifecycleConfiguration: LifecycleConfiguration(
                rules: [LifecycleRule(
                    id: "rule",
                    status: "Enabled",
                    prefix: "log/",
                    transitions: [Transition(
                        returnToStdWhenVisit: true,
                        days: 30,
                        storageClass: "IA",
                        isAccessTime: true
                    )]
                )]
            )
        )
        XCTAssertNoThrow(try Serde.serializeInput(&request, &input, [Serde.serializePutBucketLifecycle]))
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
        
        // demo7
        xml =
            """
            <LifecycleConfiguration>\
            <Rule>\
            <ID>rule</ID>\
            <Status>Enabled</Status>\
            <Prefix></Prefix>\
            <AbortMultipartUpload>\
            <Days>30</Days>\
            </AbortMultipartUpload>\
            </Rule>\
            </LifecycleConfiguration>
            """
        request = PutBucketLifecycleRequest(
            bucket: "bucket",
            lifecycleConfiguration: LifecycleConfiguration(
                rules: [LifecycleRule(
                    id: "rule",
                    status: "Enabled",
                    prefix: "",
                    abortMultipartUpload: AbortMultipartUpload(
                        days: 30
                    )
                )]
            )
        )
        XCTAssertNoThrow(try Serde.serializeInput(&request, &input, [Serde.serializePutBucketLifecycle]))
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
        
        // demo8
        xml =
            """
            <LifecycleConfiguration>\
            <Rule>\
            <ID>rule1</ID>\
            <Status>Enabled</Status>\
            <Prefix>dir1</Prefix>\
            <Expiration>\
            <Days>180</Days>\
            </Expiration>\
            </Rule>\
            <Rule>\
            <ID>rule2</ID>\
            <Status>Enabled</Status>\
            <Prefix>dir1/dir2/</Prefix>\
            <Expiration>\
            <Days>30</Days>\
            </Expiration>\
            </Rule>\
            </LifecycleConfiguration>
            """
        request = PutBucketLifecycleRequest(
            bucket: "bucket",
            lifecycleConfiguration: LifecycleConfiguration(
                rules: [
                    LifecycleRule(
                        id: "rule1",
                        status: "Enabled",
                        prefix: "dir1",
                        expiration: Expiration(
                            days: 180
                        )
                    ),
                    LifecycleRule(
                        id: "rule2",
                        status: "Enabled",
                        prefix: "dir1/dir2/",
                        expiration: Expiration(
                            days: 30
                        )
                    )
                ]
            )
        )
        XCTAssertNoThrow(try Serde.serializeInput(&request, &input, [Serde.serializePutBucketLifecycle]))
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
        
        // demo9
        xml =
            """
            <LifecycleConfiguration>\
            <Rule>\
            <ID>r0</ID>\
            <Status>Enabled</Status>\
            <Prefix>prefix0</Prefix>\
            <Expiration>\
            <Days>40</Days>\
            <ExpiredObjectDeleteMarker>false</ExpiredObjectDeleteMarker>\
            </Expiration>\
            </Rule>\
            <Rule>\
            <ID>r1</ID>\
            <Status>Enabled</Status>\
            <Filter>\
            <ObjectSizeGreaterThan>500</ObjectSizeGreaterThan>\
            <ObjectSizeLessThan>64500</ObjectSizeLessThan>\
            </Filter>\
            <Prefix>prefix1</Prefix>\
            <Expiration>\
            <CreatedBeforeDate>2006-01-02T15:04:05.000Z</CreatedBeforeDate>\
            </Expiration>\
            </Rule>\
            <Rule>\
            <ID>r3</ID>\
            <Status>Enabled</Status>\
            <Transition>\
            <Days>30</Days>\
            <StorageClass>IA</StorageClass>\
            <IsAccessTime>false</IsAccessTime>\
            </Transition>\
            <Filter>\
            <ObjectSizeGreaterThan>500</ObjectSizeGreaterThan>\
            <ObjectSizeLessThan>64500</ObjectSizeLessThan>\
            </Filter>\
            <Prefix>prefix3</Prefix>\
            <Expiration>\
            <Days>40</Days>\
            <ExpiredObjectDeleteMarker>false</ExpiredObjectDeleteMarker>\
            </Expiration>\
            </Rule>\
            <Rule>\
            <ID>r4</ID>\
            <Status>Enabled</Status>\
            <NoncurrentVersionTransition>\
            <IsAccessTime>true</IsAccessTime>\
            <ReturnToStdWhenVisit>true</ReturnToStdWhenVisit>\
            <NoncurrentDays>10</NoncurrentDays>\
            <StorageClass>IA</StorageClass>\
            </NoncurrentVersionTransition>\
            <Prefix>prefix4</Prefix>\
            <Expiration>\
            <ExpiredObjectDeleteMarker>true</ExpiredObjectDeleteMarker>\
            </Expiration>\
            <AbortMultipartUpload>\
            <CreatedBeforeDate>2015-11-11T00:00:00.000Z</CreatedBeforeDate>\
            </AbortMultipartUpload>\
            </Rule>\
            <Rule>\
            <Status>Enabled</Status>\
            <Prefix>pre_</Prefix>\
            <Expiration>\
            <CreatedBeforeDate>2006-01-02T15:04:05.000Z</CreatedBeforeDate>\
            </Expiration>\
            </Rule>\
            </LifecycleConfiguration>
            """
        request = PutBucketLifecycleRequest(
            allowSameActionOverlap: "allowSameActionOverlap",
            lifecycleConfiguration: LifecycleConfiguration(rules: [
                LifecycleRule(
                    id: "r0",
                    status: "Enabled",
                    prefix: "prefix0",
                    expiration: Expiration(
                        days: 40,
                        expiredObjectDeleteMarker: false
                    )
                ),
                LifecycleRule(
                    id: "r1",
                    status: "Enabled",
                    prefix: "prefix1",
                    filter: Filter(
                        objectSizeGreaterThan: 500,
                        objectSizeLessThan: 64500
                    ),
                    expiration: Expiration(createdBeforeDate: formatter.date(from: "2006-01-02T15:04:05.000Z"))
                ),
                LifecycleRule(
                    id: "r3",
                    status: "Enabled",
                    prefix: "prefix3",
                    transitions: [Transition(
                        days: 30,
                        storageClass: "IA",
                        isAccessTime: false
                    )],
                    filter: Filter(
                        objectSizeGreaterThan: 500,
                        objectSizeLessThan: 64500
                    ),
                    expiration: Expiration(
                        days: 40,
                        expiredObjectDeleteMarker: false
                    )
                ),
                LifecycleRule(
                    id: "r4",
                    status: "Enabled",
                    prefix: "prefix4",
                    noncurrentVersionTransitions: [NoncurrentVersionTransition(
                        isAccessTime: true,
                        returnToStdWhenVisit: true,
                        noncurrentDays: 10,
                        storageClass: "IA"
                    )],
                    expiration: Expiration(expiredObjectDeleteMarker: true),
                    abortMultipartUpload: AbortMultipartUpload(
                        createdBeforeDate: formatter.date(from: "2015-11-11T00:00:00.000Z")
                    )
                ),
                LifecycleRule(
                    status: "Enabled",
                    prefix: "pre_",
                    expiration: Expiration(createdBeforeDate: formatter.date(from: "2006-01-02T15:04:05.000Z"))
                )
            ])
        )
        XCTAssertNoThrow(try Serde.serializeInput(&request, &input, [Serde.serializePutBucketLifecycle]))
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
        XCTAssertEqual(input.headers["x-oss-allow-same-action-overlap"], "allowSameActionOverlap")
    }

    func testDeserializeGetBucketLifecycle() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = GetBucketLifecycleResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketLifecycle]))

        // normal
        let xml =
            """
            <LifecycleConfiguration>\
            <Rule>\
            <ID>id</ID>\
            <Status>status</Status>\
            <Transition>\
            <ReturnToStdWhenVisit>true</ReturnToStdWhenVisit>\
            <AllowSmallFile>true</AllowSmallFile>\
            <CreatedBeforeDate>2002-10-11T00:00:00.000Z</CreatedBeforeDate>\
            <Days>1</Days>\
            <StorageClass>archive</StorageClass>\
            <IsAccessTime>true</IsAccessTime>\
            </Transition>\
            <Tag>\
            <Key>key1</Key>\
            <Value>value1</Value>\
            </Tag>\
            <NoncurrentVersionTransition>\
            <IsAccessTime>true</IsAccessTime>\
            <AllowSmallFile>true</AllowSmallFile>\
            <NoncurrentDays>1</NoncurrentDays>\
            <StorageClass>IA</StorageClass>\
            </NoncurrentVersionTransition>\
            <Filter>\
            <Not>\
            <Prefix>prefix1</Prefix>\
            <Tag>\
            <Key>key2</Key>\
            <Value>value2</Value>\
            </Tag>\
            </Not>\
            <ObjectSizeGreaterThan>1</ObjectSizeGreaterThan>\
            <ObjectSizeLessThan>1</ObjectSizeLessThan>\
            </Filter>\
            <Prefix>prefix2</Prefix>\
            <Expiration>\
            <CreatedBeforeDate>2003-10-11T00:00:00.000Z</CreatedBeforeDate>\
            <Days>1</Days>\
            <ExpiredObjectDeleteMarker>true</ExpiredObjectDeleteMarker>\
            <Date>2004-10-11T00:00:00.000Z</Date>\
            </Expiration>\
            <AbortMultipartUpload>\
            <CreatedBeforeDate>2005-10-11T00:00:00.000Z</CreatedBeforeDate>\
            <Days>1</Days>\
            </AbortMultipartUpload>\
            <NoncurrentVersionExpiration>\
            <NoncurrentDays>1</NoncurrentDays>\
            </NoncurrentVersionExpiration>\
            <AtimeBase>1</AtimeBase>\
            </Rule>\
            </LifecycleConfiguration>
            """
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = GetBucketLifecycleResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketLifecycle]))
        XCTAssertEqual(result.lifecycleConfiguration?.rules?.first?.id, "id")
        XCTAssertEqual(result.lifecycleConfiguration?.rules?.first?.status, "status")
        XCTAssertEqual(result.lifecycleConfiguration?.rules?.first?.transitions?.first?.returnToStdWhenVisit, true)
        XCTAssertEqual(result.lifecycleConfiguration?.rules?.first?.transitions?.first?.allowSmallFile, true)
        XCTAssertEqual(result.lifecycleConfiguration?.rules?.first?.transitions?.first?.createdBeforeDate, formatter.date(from: "2002-10-11T00:00:00.000Z"))
        XCTAssertEqual(result.lifecycleConfiguration?.rules?.first?.transitions?.first?.days, 1)
        XCTAssertEqual(result.lifecycleConfiguration?.rules?.first?.transitions?.first?.storageClass, "archive")
        XCTAssertEqual(result.lifecycleConfiguration?.rules?.first?.transitions?.first?.isAccessTime, true)
        XCTAssertEqual(result.lifecycleConfiguration?.rules?.first?.tags?.first?.key, "key1")
        XCTAssertEqual(result.lifecycleConfiguration?.rules?.first?.tags?.first?.value, "value1")
        XCTAssertEqual(result.lifecycleConfiguration?.rules?.first?.noncurrentVersionTransitions?.first?.isAccessTime, true)
        XCTAssertEqual(result.lifecycleConfiguration?.rules?.first?.noncurrentVersionTransitions?.first?.allowSmallFile, true)
        XCTAssertEqual(result.lifecycleConfiguration?.rules?.first?.noncurrentVersionTransitions?.first?.noncurrentDays, 1)
        XCTAssertEqual(result.lifecycleConfiguration?.rules?.first?.noncurrentVersionTransitions?.first?.storageClass, "IA")
        XCTAssertEqual(result.lifecycleConfiguration?.rules?.first?.filter?.not?.prefix, "prefix1")
        XCTAssertEqual(result.lifecycleConfiguration?.rules?.first?.filter?.not?.tag?.key, "key2")
        XCTAssertEqual(result.lifecycleConfiguration?.rules?.first?.filter?.not?.tag?.value, "value2")
        XCTAssertEqual(result.lifecycleConfiguration?.rules?.first?.filter?.objectSizeLessThan, 1)
        XCTAssertEqual(result.lifecycleConfiguration?.rules?.first?.filter?.objectSizeGreaterThan, 1)
        XCTAssertEqual(result.lifecycleConfiguration?.rules?.first?.prefix, "prefix2")
        XCTAssertEqual(result.lifecycleConfiguration?.rules?.first?.expiration?.createdBeforeDate, formatter.date(from: "2003-10-11T00:00:00.000Z"))
        XCTAssertEqual(result.lifecycleConfiguration?.rules?.first?.expiration?.days, 1)
        XCTAssertEqual(result.lifecycleConfiguration?.rules?.first?.expiration?.expiredObjectDeleteMarker, true)
        XCTAssertEqual(result.lifecycleConfiguration?.rules?.first?.expiration?.date, formatter.date(from: "2004-10-11T00:00:00.000Z"))
        XCTAssertEqual(result.lifecycleConfiguration?.rules?.first?.abortMultipartUpload?.days, 1)
        XCTAssertEqual(result.lifecycleConfiguration?.rules?.first?.abortMultipartUpload?.createdBeforeDate, formatter.date(from: "2005-10-11T00:00:00.000Z"))
        XCTAssertEqual(result.lifecycleConfiguration?.rules?.first?.noncurrentVersionExpiration?.noncurrentDays, 1)
        XCTAssertEqual(result.lifecycleConfiguration?.rules?.first?.atimeBase, 1)
    }
}
