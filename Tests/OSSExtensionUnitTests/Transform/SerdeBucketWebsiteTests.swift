import AlibabaCloudOSS
@testable import AlibabaCloudOSSExtension
import XCTest

class SerdeBucketWebsiteTests: XCTestCase {
    func testSerializePutBucketWebsite() throws {
        var input = OperationInput()

        var xml = "<WebsiteConfiguration />"
        var request = PutBucketWebsiteRequest(websiteConfiguration: WebsiteConfiguration())
        try Serde.serializeInput(&request, &input, [Serde.serializePutBucketWebsite])
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
        
        xml =
            """
            <WebsiteConfiguration>\
            <IndexDocument>\
            <Suffix>index.html</Suffix>\
            <SupportSubDir>true</SupportSubDir>\
            <Type>0</Type>\
            </IndexDocument>\
            <ErrorDocument>\
            <Key>error.html</Key>\
            <HttpStatus>404</HttpStatus>\
            </ErrorDocument>\
            <RoutingRules>\
            <RoutingRule>\
            <RuleNumber>1</RuleNumber>\
            <Condition>\
            <KeyPrefixEquals>abc/</KeyPrefixEquals>\
            <KeySuffixEquals>cba</KeySuffixEquals>\
            <HttpErrorCodeReturnedEquals>404</HttpErrorCodeReturnedEquals>\
            <IncludeHeader>\
            <Key>key</Key>\
            <Equals>equals</Equals>\
            <StartsWith>startsWith</StartsWith>\
            <EndsWith>endsWith</EndsWith>\
            </IncludeHeader>\
            </Condition>\
            <Redirect>\
            <RedirectType>Mirror</RedirectType>\
            <MirrorSNI>true</MirrorSNI>\
            <MirrorFollowRedirect>true</MirrorFollowRedirect>\
            <MirrorIsExpressTunnel>true</MirrorIsExpressTunnel>\
            <MirrorDstVpcId>mirrorDstVpcId</MirrorDstVpcId>\
            <MirrorTunnelId>mirrorTunnelId</MirrorTunnelId>\
            <MirrorTaggings>\
            <Taggings>\
            <Key>key</Key>\
            <Value>value</Value>\
            </Taggings>\
            </MirrorTaggings>\
            <MirrorReturnHeaders>\
            <ReturnHeader>\
            <Key>key</Key>\
            <Value>value</Value>\
            </ReturnHeader>\
            </MirrorReturnHeaders>\
            <PassQueryString>true</PassQueryString>\
            <ReplaceKeyPrefixWith>replaceKeyPrefixWith</ReplaceKeyPrefixWith>\
            <MirrorProxyPass>true</MirrorProxyPass>\
            <MirrorUsingRole>true</MirrorUsingRole>\
            <TransparentMirrorResponseCodes>code</TransparentMirrorResponseCodes>\
            <MirrorCheckMd5>true</MirrorCheckMd5>\
            <ReplaceKeyWith>replaceKeyWith</ReplaceKeyWith>\
            <MirrorURLSlave>mirrorURLSlave</MirrorURLSlave>\
            <MirrorAllowVideoSnapshot>true</MirrorAllowVideoSnapshot>\
            <MirrorPassQueryString>true</MirrorPassQueryString>\
            <EnableReplacePrefix>true</EnableReplacePrefix>\
            <HttpRedirectCode>1</HttpRedirectCode>\
            <MirrorRole>mirrorRole</MirrorRole>\
            <MirrorAsyncStatus>1</MirrorAsyncStatus>\
            <MirrorAuth>\
            <AuthType>authType</AuthType>\
            <Region>region</Region>\
            <AccessKeyId>accessKeyId</AccessKeyId>\
            <AccessKeySecret>accessKeySecret</AccessKeySecret>\
            </MirrorAuth>\
            <Protocol>protocol</Protocol>\
            <MirrorDstSlaveVpcId>mirrorDstSlaveVpcId</MirrorDstSlaveVpcId>\
            <MirrorSaveOssMeta>true</MirrorSaveOssMeta>\
            <MirrorHeaders>\
            <PassAll>true</PassAll>\
            <Pass>myheader-key1</Pass>\
            <Pass>myheader-key2</Pass>\
            <Remove>myheader-key3</Remove>\
            <Remove>myheader-key4</Remove>\
            <Set>\
            <Key>myheader-key5</Key>\
            <Value>myheader-value5</Value>\
            </Set>\
            </MirrorHeaders>\
            <HostName>hostName</HostName>\
            <MirrorDstRegion>mirrorDstRegion</MirrorDstRegion>\
            <MirrorAllowHeadObject>true</MirrorAllowHeadObject>\
            <MirrorPassOriginalSlashes>true</MirrorPassOriginalSlashes>\
            <MirrorAllowGetImageInfo>true</MirrorAllowGetImageInfo>\
            <MirrorMultiAlternates>\
            <MirrorMultiAlternate>\
            <MirrorMultiAlternateNumber>1</MirrorMultiAlternateNumber>\
            <MirrorMultiAlternateURL>mirrorMultiAlternateURL</MirrorMultiAlternateURL>\
            <MirrorMultiAlternateVpcId>mirrorMultiAlternateVpcId</MirrorMultiAlternateVpcId>\
            <MirrorMultiAlternateDstRegion>mirrorMultiAlternateDstRegion</MirrorMultiAlternateDstRegion>\
            </MirrorMultiAlternate>\
            </MirrorMultiAlternates>\
            <MirrorURL>http://example.com/</MirrorURL>\
            <MirrorUserLastModified>true</MirrorUserLastModified>\
            <MirrorSwitchAllErrors>true</MirrorSwitchAllErrors>\
            <MirrorURLProbe>mirrorURLProbe</MirrorURLProbe>\
            </Redirect>\
            </RoutingRule>\
            </RoutingRules>\
            </WebsiteConfiguration>
            """
        request = PutBucketWebsiteRequest(
            websiteConfiguration: WebsiteConfiguration(
                indexDocument: IndexDocument(suffix: "index.html", supportSubDir: true, type: 0),
                errorDocument: ErrorDocument(key: "error.html", httpStatus: 404),
                routingRules: RoutingRules(
                    routingRules: [RoutingRule(
                        ruleNumber: 1,
                        condition: RoutingRuleCondition(
                            keyPrefixEquals: "abc/",
                            keySuffixEquals: "cba",
                            httpErrorCodeReturnedEquals: 404,
                            includeHeaders: [IncludeHeader(key: "key", equals: "equals", startsWith: "startsWith", endsWith: "endsWith")]
                        ),
                        redirect: RoutingRuleRedirect(
                            redirectType: "Mirror",
                            mirrorSNI: true,
                            mirrorFollowRedirect: true,
                            mirrorIsExpressTunnel: true,
                            mirrorDstVpcId: "mirrorDstVpcId",
                            mirrorTunnelId: "mirrorTunnelId",
                            mirrorTaggings: MirrorTaggings(taggings: [Taggings(key: "key", value: "value")]),
                            mirrorReturnHeaders: MirrorReturnHeaders(returnHeaders: [ReturnHeader(key: "key", value: "value")]),
                            passQueryString: true,
                            replaceKeyPrefixWith: "replaceKeyPrefixWith",
                            mirrorProxyPass: true,
                            mirrorUsingRole: true,
                            transparentMirrorResponseCodes: "code",
                            mirrorCheckMd5: true,
                            replaceKeyWith: "replaceKeyWith",
                            mirrorURLSlave: "mirrorURLSlave",
                            mirrorAllowVideoSnapshot: true,
                            mirrorPassQueryString: true,
                            enableReplacePrefix: true,
                            httpRedirectCode: 1,
                            mirrorRole: "mirrorRole",
                            mirrorAsyncStatus: 1,
                            mirrorAuth: MirrorAuth(authType: "authType", region: "region", accessKeyId: "accessKeyId", accessKeySecret: "accessKeySecret"),
                            protocol: "protocol",
                            mirrorDstSlaveVpcId: "mirrorDstSlaveVpcId",
                            mirrorSaveOssMeta: true,
                            mirrorHeaders: MirrorHeaders(passAll: true,
                                                         pass: ["myheader-key1", "myheader-key2"],
                                                         removes: ["myheader-key3", "myheader-key4"],
                                                         sets: [Set(key: "myheader-key5", value: "myheader-value5")]),
                            hostName: "hostName",
                            mirrorDstRegion: "mirrorDstRegion",
                            mirrorAllowHeadObject: true,
                            mirrorPassOriginalSlashes: true,
                            mirrorAllowGetImageInfo: true,
                            mirrorMultiAlternates: MirrorMultiAlternates(mirrorMultiAlternates: [MirrorMultiAlternate(mirrorMultiAlternateNumber: 1,
                                                                                                                      mirrorMultiAlternateURL: "mirrorMultiAlternateURL",
                                                                                                                      mirrorMultiAlternateVpcId: "mirrorMultiAlternateVpcId",
                                                                                                                      mirrorMultiAlternateDstRegion: "mirrorMultiAlternateDstRegion")]),
                            mirrorURL: "http://example.com/",
                            mirrorUserLastModified: true,
                            mirrorSwitchAllErrors: true,
                            mirrorURLProbe: "mirrorURLProbe",
                        )
                    )])
            )
        )
        try Serde.serializeInput(&request, &input, [Serde.serializePutBucketWebsite])
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))

        xml =
            """
            <WebsiteConfiguration>\
            <IndexDocument>\
            <Suffix>index.html</Suffix>\
            <SupportSubDir>true</SupportSubDir>\
            <Type>0</Type>\
            </IndexDocument>\
            <ErrorDocument>\
            <Key>error.html</Key>\
            <HttpStatus>404</HttpStatus>\
            </ErrorDocument>\
            <RoutingRules>\
            <RoutingRule>\
            <RuleNumber>1</RuleNumber>\
            <Condition>\
            <KeyPrefixEquals>abc/</KeyPrefixEquals>\
            <HttpErrorCodeReturnedEquals>404</HttpErrorCodeReturnedEquals>\
            </Condition>\
            <Redirect>\
            <RedirectType>Mirror</RedirectType>\
            <MirrorFollowRedirect>true</MirrorFollowRedirect>\
            <PassQueryString>true</PassQueryString>\
            <MirrorCheckMd5>false</MirrorCheckMd5>\
            <MirrorPassQueryString>true</MirrorPassQueryString>\
            <MirrorHeaders>\
            <PassAll>true</PassAll>\
            <Pass>myheader-key1</Pass>\
            <Pass>myheader-key2</Pass>\
            <Remove>myheader-key3</Remove>\
            <Remove>myheader-key4</Remove>\
            <Set>\
            <Key>myheader-key5</Key>\
            <Value>myheader-value5</Value>\
            </Set>\
            </MirrorHeaders>\
            <MirrorURL>http://example.com/</MirrorURL>\
            </Redirect>\
            </RoutingRule>\
            <RoutingRule>\
            <RuleNumber>2</RuleNumber>\
            <Condition>\
            <KeyPrefixEquals>abc/</KeyPrefixEquals>\
            <HttpErrorCodeReturnedEquals>404</HttpErrorCodeReturnedEquals>\
            <IncludeHeader>\
            <Key>host</Key>\
            <Equals>test.oss-cn-beijing-internal.aliyuncs.com</Equals>\
            </IncludeHeader>\
            </Condition>\
            <Redirect>\
            <RedirectType>AliCDN</RedirectType>\
            <PassQueryString>false</PassQueryString>\
            <ReplaceKeyWith>prefix/${key}.suffix</ReplaceKeyWith>\
            <HttpRedirectCode>301</HttpRedirectCode>\
            <Protocol>http</Protocol>\
            <HostName>example.com</HostName>\
            </Redirect>\
            </RoutingRule>\
            <RoutingRule>\
            <RuleNumber>3</RuleNumber>\
            <Condition>\
            <HttpErrorCodeReturnedEquals>404</HttpErrorCodeReturnedEquals>\
            </Condition>\
            <Redirect>\
            <RedirectType>External</RedirectType>\
            <PassQueryString>false</PassQueryString>\
            <ReplaceKeyWith>prefix/${key}</ReplaceKeyWith>\
            <EnableReplacePrefix>false</EnableReplacePrefix>\
            <HttpRedirectCode>302</HttpRedirectCode>\
            <Protocol>http</Protocol>\
            <HostName>example.com</HostName>\
            </Redirect>\
            </RoutingRule>\
            </RoutingRules>\
            </WebsiteConfiguration>
            """
        request = PutBucketWebsiteRequest(
            websiteConfiguration: WebsiteConfiguration(
                indexDocument: IndexDocument(suffix: "index.html", supportSubDir: true, type: 0),
                errorDocument: ErrorDocument(key: "error.html", httpStatus: 404),
                routingRules: RoutingRules(
                    routingRules: [RoutingRule(
                        ruleNumber: 1,
                        condition: RoutingRuleCondition(
                            keyPrefixEquals: "abc/",
                            httpErrorCodeReturnedEquals: 404,
                        ),
                        redirect: RoutingRuleRedirect(
                            redirectType: "Mirror",
                            mirrorFollowRedirect: true,
                            passQueryString: true,
                            mirrorCheckMd5: false,
                            mirrorPassQueryString: true,
                            mirrorHeaders: MirrorHeaders(passAll: true,
                                                         pass: ["myheader-key1", "myheader-key2"],
                                                         removes: ["myheader-key3", "myheader-key4"],
                                                         sets: [Set(key: "myheader-key5", value: "myheader-value5")]),
                            mirrorURL: "http://example.com/",
                        )
                    ), RoutingRule(
                        ruleNumber: 2,
                        condition: RoutingRuleCondition(
                            keyPrefixEquals: "abc/",
                            httpErrorCodeReturnedEquals: 404,
                            includeHeaders: [IncludeHeader(key: "host", equals: "test.oss-cn-beijing-internal.aliyuncs.com")]
                        ),
                        redirect: RoutingRuleRedirect(
                            redirectType: "AliCDN",
                            passQueryString: false,
                            replaceKeyWith: "prefix/${key}.suffix",
                            httpRedirectCode: 301,
                            protocol: "http",
                            hostName: "example.com",
                        )
                    ), RoutingRule(
                        ruleNumber: 3,
                        condition: RoutingRuleCondition(
                            httpErrorCodeReturnedEquals: 404,
                        ),
                        redirect: RoutingRuleRedirect(
                            redirectType: "External",
                            passQueryString: false,
                            replaceKeyWith: "prefix/${key}",
                            enableReplacePrefix: false,
                            httpRedirectCode: 302,
                            protocol: "http",
                            hostName: "example.com"
                        )
                    )])
            )
        )
        try Serde.serializeInput(&request, &input, [Serde.serializePutBucketWebsite])
        XCTAssertEqual(try input.body?.readData(), xml.data(using: .utf8))
    }

    func testDeserializeGetBucketWebsite() {
        // body is null
        var output = OperationOutput(statusCode: 200,
                                     headers: [:])
        var result = GetBucketWebsiteResult()
        XCTAssertThrowsError(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketWebsite]))

        // normal
        var xml =
            """
            <WebsiteConfiguration>\
            <IndexDocument>\
            <Suffix>index.html</Suffix>\
            <SupportSubDir>true</SupportSubDir>\
            <Type>0</Type>\
            </IndexDocument>\
            <ErrorDocument>\
            <Key>error.html</Key>\
            <HttpStatus>404</HttpStatus>\
            </ErrorDocument>\
            <RoutingRules>\
            <RoutingRule>\
            <RuleNumber>1</RuleNumber>\
            <Condition>\
            <KeyPrefixEquals>abc/</KeyPrefixEquals>\
            <KeySuffixEquals>cba</KeySuffixEquals>\
            <HttpErrorCodeReturnedEquals>404</HttpErrorCodeReturnedEquals>\
            <IncludeHeader>\
            <Key>key</Key>\
            <Equals>equals</Equals>\
            <StartsWith>startsWith</StartsWith>\
            <EndsWith>endsWith</EndsWith>\
            </IncludeHeader>\
            </Condition>\
            <Redirect>\
            <RedirectType>Mirror</RedirectType>\
            <MirrorSNI>true</MirrorSNI>\
            <MirrorFollowRedirect>true</MirrorFollowRedirect>\
            <MirrorIsExpressTunnel>true</MirrorIsExpressTunnel>\
            <MirrorDstVpcId>mirrorDstVpcId</MirrorDstVpcId>\
            <MirrorTunnelId>mirrorTunnelId</MirrorTunnelId>\
            <MirrorTaggings>\
            <Taggings>\
            <Key>key</Key>\
            <Value>value</Value>\
            </Taggings>\
            </MirrorTaggings>\
            <MirrorReturnHeaders>\
            <ReturnHeader>\
            <Key>key</Key>\
            <Value>value</Value>\
            </ReturnHeader>\
            </MirrorReturnHeaders>\
            <PassQueryString>true</PassQueryString>\
            <ReplaceKeyPrefixWith>replaceKeyPrefixWith</ReplaceKeyPrefixWith>\
            <MirrorProxyPass>true</MirrorProxyPass>\
            <MirrorUsingRole>true</MirrorUsingRole>\
            <TransparentMirrorResponseCodes>code</TransparentMirrorResponseCodes>\
            <MirrorCheckMd5>true</MirrorCheckMd5>\
            <ReplaceKeyWith>replaceKeyWith</ReplaceKeyWith>\
            <MirrorURLSlave>mirrorURLSlave</MirrorURLSlave>\
            <MirrorAllowVideoSnapshot>true</MirrorAllowVideoSnapshot>\
            <MirrorPassQueryString>true</MirrorPassQueryString>\
            <EnableReplacePrefix>true</EnableReplacePrefix>\
            <HttpRedirectCode>1</HttpRedirectCode>\
            <MirrorRole>mirrorRole</MirrorRole>\
            <MirrorAsyncStatus>1</MirrorAsyncStatus>\
            <MirrorAuth>\
            <AuthType>authType</AuthType>\
            <Region>region</Region>\
            <AccessKeyId>accessKeyId</AccessKeyId>\
            <AccessKeySecret>accessKeySecret</AccessKeySecret>\
            </MirrorAuth>\
            <Protocol>protocol</Protocol>\
            <MirrorDstSlaveVpcId>mirrorDstSlaveVpcId</MirrorDstSlaveVpcId>\
            <MirrorSaveOssMeta>true</MirrorSaveOssMeta>\
            <MirrorHeaders>\
            <PassAll>true</PassAll>\
            <Pass>myheader-key1</Pass>\
            <Pass>myheader-key2</Pass>\
            <Remove>myheader-key3</Remove>\
            <Remove>myheader-key4</Remove>\
            <Set>\
            <Key>myheader-key5</Key>\
            <Value>myheader-value5</Value>\
            </Set>\
            </MirrorHeaders>\
            <HostName>hostName</HostName>\
            <MirrorDstRegion>mirrorDstRegion</MirrorDstRegion>\
            <MirrorAllowHeadObject>true</MirrorAllowHeadObject>\
            <MirrorPassOriginalSlashes>true</MirrorPassOriginalSlashes>\
            <MirrorAllowGetImageInfo>true</MirrorAllowGetImageInfo>\
            <MirrorMultiAlternates>\
            <MirrorMultiAlternate>\
            <MirrorMultiAlternateNumber>1</MirrorMultiAlternateNumber>\
            <MirrorMultiAlternateURL>mirrorMultiAlternateURL</MirrorMultiAlternateURL>\
            <MirrorMultiAlternateVpcId>mirrorMultiAlternateVpcId</MirrorMultiAlternateVpcId>\
            <MirrorMultiAlternateDstRegion>mirrorMultiAlternateDstRegion</MirrorMultiAlternateDstRegion>\
            </MirrorMultiAlternate>\
            </MirrorMultiAlternates>\
            <MirrorURL>http://example.com/</MirrorURL>\
            <MirrorUserLastModified>true</MirrorUserLastModified>\
            <MirrorSwitchAllErrors>true</MirrorSwitchAllErrors>\
            <MirrorURLProbe>mirrorURLProbe</MirrorURLProbe>\
            </Redirect>\
            </RoutingRule>\
            </RoutingRules>\
            </WebsiteConfiguration>
            """
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = GetBucketWebsiteResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketWebsite]))
        XCTAssertEqual(result.websiteConfiguration?.indexDocument?.suffix, "index.html")
        XCTAssertEqual(result.websiteConfiguration?.indexDocument?.supportSubDir, true)
        XCTAssertEqual(result.websiteConfiguration?.indexDocument?.type, 0)
        XCTAssertEqual(result.websiteConfiguration?.errorDocument?.key, "error.html")
        XCTAssertEqual(result.websiteConfiguration?.errorDocument?.httpStatus, 404)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.ruleNumber, 1)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.condition?.keyPrefixEquals, "abc/")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.condition?.keySuffixEquals, "cba")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.condition?.httpErrorCodeReturnedEquals, 404)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.condition?.includeHeaders?.first?.key, "key")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.condition?.includeHeaders?.first?.equals, "equals")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.condition?.includeHeaders?.first?.startsWith, "startsWith")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.condition?.includeHeaders?.first?.endsWith, "endsWith")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.redirectType, "Mirror")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorSNI, true)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorFollowRedirect, true)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorIsExpressTunnel, true)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorDstVpcId, "mirrorDstVpcId")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorTunnelId, "mirrorTunnelId")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorTaggings?.taggings?.first?.key, "key")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorTaggings?.taggings?.first?.value, "value")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorReturnHeaders?.returnHeaders?.first?.key, "key")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorReturnHeaders?.returnHeaders?.first?.value, "value")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.passQueryString, true)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.replaceKeyPrefixWith, "replaceKeyPrefixWith")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorProxyPass, true)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorUsingRole, true)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.transparentMirrorResponseCodes, "code")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorCheckMd5, true)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.replaceKeyWith, "replaceKeyWith")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorURLSlave, "mirrorURLSlave")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorAllowVideoSnapshot, true)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorPassQueryString, true)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.enableReplacePrefix, true)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.httpRedirectCode, 1)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorRole, "mirrorRole")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorAsyncStatus, 1)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorAuth?.authType, "authType")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorAuth?.region, "region")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorAuth?.accessKeyId, "accessKeyId")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorAuth?.accessKeySecret, "accessKeySecret")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.protocol, "protocol")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorDstSlaveVpcId, "mirrorDstSlaveVpcId")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorSaveOssMeta, true)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorHeaders?.passAll, true)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorHeaders?.pass, ["myheader-key1", "myheader-key2"])
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorHeaders?.removes, ["myheader-key3", "myheader-key4"])
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorHeaders?.sets?.first?.key, "myheader-key5")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorHeaders?.sets?.first?.value, "myheader-value5")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.hostName, "hostName")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorDstRegion, "mirrorDstRegion")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorAllowHeadObject, true)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorPassOriginalSlashes, true)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorAllowGetImageInfo, true)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorMultiAlternates?.mirrorMultiAlternates?.first?.mirrorMultiAlternateNumber, 1)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorMultiAlternates?.mirrorMultiAlternates?.first?.mirrorMultiAlternateURL, "mirrorMultiAlternateURL")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorMultiAlternates?.mirrorMultiAlternates?.first?.mirrorMultiAlternateVpcId, "mirrorMultiAlternateVpcId")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorMultiAlternates?.mirrorMultiAlternates?.first?.mirrorMultiAlternateDstRegion, "mirrorMultiAlternateDstRegion")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorURL, "http://example.com/")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorUserLastModified, true)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorSwitchAllErrors, true)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?.first?.redirect?.mirrorURLProbe, "mirrorURLProbe")

        xml =
            """
            <WebsiteConfiguration>\
            <IndexDocument>\
            <Suffix>index.html</Suffix>\
            <SupportSubDir>true</SupportSubDir>\
            <Type>0</Type>\
            </IndexDocument>\
            <ErrorDocument>\
            <Key>error.html</Key>\
            <HttpStatus>404</HttpStatus>\
            </ErrorDocument>\
            <RoutingRules>\
            <RoutingRule>\
            <RuleNumber>1</RuleNumber>\
            <Condition>\
            <KeyPrefixEquals>abc/</KeyPrefixEquals>\
            <HttpErrorCodeReturnedEquals>404</HttpErrorCodeReturnedEquals>\
            </Condition>\
            <Redirect>\
            <RedirectType>Mirror</RedirectType>\
            <MirrorFollowRedirect>true</MirrorFollowRedirect>\
            <PassQueryString>true</PassQueryString>\
            <MirrorCheckMd5>false</MirrorCheckMd5>\
            <MirrorPassQueryString>true</MirrorPassQueryString>\
            <MirrorHeaders>\
            <PassAll>true</PassAll>\
            <Pass>myheader-key1</Pass>\
            <Pass>myheader-key2</Pass>\
            <Remove>myheader-key3</Remove>\
            <Remove>myheader-key4</Remove>\
            <Set>\
            <Key>myheader-key5</Key>\
            <Value>myheader-value5</Value>\
            </Set>\
            </MirrorHeaders>\
            <MirrorURL>http://example.com/</MirrorURL>\
            </Redirect>\
            </RoutingRule>\
            <RoutingRule>\
            <RuleNumber>2</RuleNumber>\
            <Condition>\
            <KeyPrefixEquals>abc/</KeyPrefixEquals>\
            <HttpErrorCodeReturnedEquals>404</HttpErrorCodeReturnedEquals>\
            <IncludeHeader>\
            <Key>host</Key>\
            <Equals>test.oss-cn-beijing-internal.aliyuncs.com</Equals>\
            </IncludeHeader>\
            </Condition>\
            <Redirect>\
            <RedirectType>AliCDN</RedirectType>\
            <PassQueryString>false</PassQueryString>\
            <ReplaceKeyWith>prefix/${key}.suffix</ReplaceKeyWith>\
            <HttpRedirectCode>301</HttpRedirectCode>\
            <Protocol>http</Protocol>\
            <HostName>example.com</HostName>\
            </Redirect>\
            </RoutingRule>\
            <RoutingRule>\
            <RuleNumber>3</RuleNumber>\
            <Condition>\
            <HttpErrorCodeReturnedEquals>404</HttpErrorCodeReturnedEquals>\
            </Condition>\
            <Redirect>\
            <RedirectType>External</RedirectType>\
            <PassQueryString>false</PassQueryString>\
            <ReplaceKeyWith>prefix/${key}</ReplaceKeyWith>\
            <EnableReplacePrefix>false</EnableReplacePrefix>\
            <HttpRedirectCode>302</HttpRedirectCode>\
            <Protocol>http</Protocol>\
            <HostName>example.com</HostName>\
            </Redirect>\
            </RoutingRule>\
            </RoutingRules>\
            </WebsiteConfiguration>
            """
        output = OperationOutput(statusCode: 200,
                                 headers: [:],
                                 body: .data(xml.data(using: .utf8)!))
        result = GetBucketWebsiteResult()
        XCTAssertNoThrow(try Serde.deserializeOutput(&result, &output, [Serde.deserializeGetBucketWebsite]))
        XCTAssertEqual(result.websiteConfiguration?.indexDocument?.suffix, "index.html")
        XCTAssertEqual(result.websiteConfiguration?.indexDocument?.supportSubDir, true)
        XCTAssertEqual(result.websiteConfiguration?.indexDocument?.type, 0)
        XCTAssertEqual(result.websiteConfiguration?.errorDocument?.key, "error.html")
        XCTAssertEqual(result.websiteConfiguration?.errorDocument?.httpStatus, 404)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[0].ruleNumber, 1)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[0].condition?.keyPrefixEquals, "abc/")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[0].condition?.httpErrorCodeReturnedEquals, 404)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[0].redirect?.redirectType, "Mirror")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[0].redirect?.mirrorFollowRedirect, true)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[0].redirect?.passQueryString, true)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[0].redirect?.mirrorCheckMd5, false)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[0].redirect?.mirrorPassQueryString, true)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[0].redirect?.mirrorHeaders?.passAll, true)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[0].redirect?.mirrorHeaders?.pass, ["myheader-key1", "myheader-key2"])
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[0].redirect?.mirrorHeaders?.removes, ["myheader-key3", "myheader-key4"])
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[0].redirect?.mirrorHeaders?.sets?.first?.key, "myheader-key5")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[0].redirect?.mirrorHeaders?.sets?.first?.value, "myheader-value5")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[0].redirect?.mirrorURL, "http://example.com/")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[1].ruleNumber, 2)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[1].condition?.keyPrefixEquals, "abc/")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[1].condition?.httpErrorCodeReturnedEquals, 404)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[1].condition?.includeHeaders?.first?.key, "host")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[1].condition?.includeHeaders?.first?.equals, "test.oss-cn-beijing-internal.aliyuncs.com")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[1].redirect?.redirectType, "AliCDN")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[1].redirect?.passQueryString, false)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[1].redirect?.replaceKeyWith, "prefix/${key}.suffix")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[1].redirect?.httpRedirectCode, 301)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[1].redirect?.protocol, "http")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[1].redirect?.hostName, "example.com")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[2].ruleNumber, 3)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[2].condition?.httpErrorCodeReturnedEquals, 404)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[2].redirect?.redirectType, "External")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[2].redirect?.passQueryString, false)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[2].redirect?.replaceKeyWith, "prefix/${key}")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[2].redirect?.enableReplacePrefix, false)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[2].redirect?.httpRedirectCode, 302)
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[2].redirect?.protocol, "http")
        XCTAssertEqual(result.websiteConfiguration?.routingRules?.routingRules?[2].redirect?.hostName, "example.com")
    }
}
