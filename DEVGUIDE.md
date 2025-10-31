# Developer Guide
[简体中文](DEVGUIDE-CN.md)

Alibaba Cloud Object Storage Service (OSS) is a secure, cost-effective, and highly reliable cloud storage service that allows you to store large amounts of data. You can upload and download data from any application at any time and anywhere by calling API operations. You can also simply manage data by using the web console. OSS can store all types of files and is suitable for various websites, enterprises, and developers.

This development kit hides many lower-level operations, such as identity authentication, request retry, and error handling. You can access OSS by calling API operations without complex programming.

You can refer to this developer guide to install, configure, and use the development kit.

Go to:

* [Installation](#installation)
* [Configuration](#configuration)
* [API operations](#api-operations)
* [Sample scenarios](#sample-scenarios)
* [Migration guide](#migration-guide)

# Installation

## Prerequisites

Swift 5.9 or later is installed.
For more information about how to download and install Swift, visit [Download and install](https://www.swift.org/install).
You can run the following command to check the version of Swift:
```
swift --version
```

## Install OSS SDK for Swift

### Use Swift Package Manager
Add the following dependencies to the Package.swift file:
```swift
.package(url: "https://github.com/aliyun/alibabacloud-oss-swift-sdk-v2.git", from: "0.1.0-beta")
```

### Use Swift Package Manager in XCode
- First, create or open an existing project in Xcode, then select `PROJECT`－`Package Dependencies` and click on it`+`
- Search` https://github.com/aliyun/alibabacloud-oss-swift-sdk-v2.git `Click on 'Add Package'`
 

## Verify OSS SDK for Swift
Run the following code to check the version of OSS SDK for Swift:
```swift
import AlibabaCloudOSS

func main() {
    print("OSS Swift SDK Version: \(SdkInfo.version())")
}
```

# Configuration
You can configure common settings for a client, such as the timeout period, log level, and retry policies. Most settings are optional.
However, you must specify the region and credentials for each client.  OSS SDK for Swift uses the information to sign requests and send them to the correct region.

Subtopics in this section
* [Region](#Region)
* [Credentials](#credentials)
* [Endpoints](#endpoint)
* [HTTP client](#http-client)
* [Retry](#retry)
* [Logs](#logs)
* [Configuration parameters](#configuration-parameters)

## Load configurations
You can use several methods to configure a client. We recommend that you run the following sample code to configure a client:

```swift
import AlibabaCloudOSS

func main() {
    // In this example, the China (Hangzhou) region is used.
    let region = "cn-hangzhou"

    // In this example, the credential is obtained from environment variables.
    let credentialsProvider = EnvironmentCredentialsProvider()

    let config = Configuration.default()
        .withCredentialsProvider(credentialsProvider)
        .withRegion(region)
}
```

## Region
You can specify a region to which you want the request to be sent, such as cn-hangzhou or cn-shanghai. For more information about the supported regions, see [Regions and endpoints](https://www.alibabacloud.com/help/en/oss/user-guide/regions-and-endpoints).
OSS SDK for Swift does not have a default region. You must specify the `config.withRegion` parameter to explicitly specify a region when you load the configurations. Example:
```swift
let config = Configuration.default().withRegion("cn-hangzhou")
```

>**Note**: OSS SDK for Swift uses a V4 signature by default. In this case, you must specify this parameter.

## Credentials

OSS SDK for Swift requires credentials (AccessKey pair) to sign requests sent to OSS. In this case, you must explicitly specify the credentials. The following credential configurations are supported:
* [Environment variables](#environment-variables)
* [Static credentials](#static-credentials)
* [Custom credential provider](#custom-credential-provider)

### Environment variables

OSS SDK for Swift supports obtaining credentials from environment variables. The following environment variables are supported:
* OSS_ACCESS_KEY_ID
* OSS_ACCESS_KEY_SECRET
* OSS_SESSION_TOKEN (Optional) 

The following sample code provides examples on how to configure environment variables.

1. Use Linux, OS X, or Unix
```
$ export OSS_ACCESS_KEY_ID=YOUR_ACCESS_KEY_ID
$ export OSS_ACCESS_KEY_SECRET=YOUR_ACCESS_KEY_SECRET
$ export OSS_SESSION_TOKEN=TOKEN
```

2. Use Windows
```
$ set OSS_ACCESS_KEY_ID=YOUR_ACCESS_KEY_ID
$ set OSS_ACCESS_KEY_SECRET=YOUR_ACCESS_KEY_SECRET
$ set OSS_SESSION_TOKEN=TOKEN
```

Use the credentials obtained from environment variables

```swift
let provider = EnvironmentCredentialsProvider()
let config = Configuration.default().withCredentialsProvider(provider)
```

### Static credentials

You can hardcode the static credentials in your application to explicitly specify the AccessKey pair that you want to use to access OSS.

> **Note**: Do not embed the static credentials in the application. This method is used only for testing.

1. Long-term credentials
```swift
let provider = StaticCredentialsProvider(
    accessKeyId: accessKeyId,
    accessKeySecret: accessKeySecret
)
let config = Configuration.default().withCredentialsProvider(provider)
```

2. Temporary credentials
```swift
let provider = StaticCredentialsProvider(
    accessKeyId: accessKeyId,
    accessKeySecret: accessKeySecret,
    securityToken: securityToken
)
let config = Configuration.default().withCredentialsProvider(provider)
```

### Custom credential provider

If the preceding credential configuration methods do not meet your requirements, you can specify the method that you want to use to obtain credentials. The following methods are supported:

1. Use credentials.CredentialsProvider
```swift
import AlibabaCloudOSS

struct CustomerCredentialsProvider: CredentialsProvider {
    func getCredentials() async throws -> Credentials {
        // Return long-term credentials
        return Credentials(accessKeyId: "ak", accessKeySecret: "sk")
        // Return temporary vocredentialsucher
        // return Credentials(accessKeyId: "ak", accessKeySecret: "sk", securityToken: "token")
    }
}

let config = Configuration.default()
    .withCredentialsProvider(CustomerCredentialsProvider())
```

2. Use ClosureCredentialsProvider

ClosureCredentialsProvider is an easy-to-use encapsulation for the credentials.CredentialsProvider.

```swift
let provider = ClosureCredentialsProvider {
    // The logic of obtaining credentials
    // await ...
    // Assuming to obtain the following credentials
    let accessKeyId = "ak"
    let accessKeySecret = "sk"
    // let securityToken = "token"

    // Return long-term credentials
    return Credentials(accessKeyId: accessKeyId, accessKeySecret: accessKeySecret)
    // Return temporary credentials
    // return Credentials(accessKeyId: "ak", accessKeySecret: "sk", securityToken: "token")
}
let config = Configuration.default()
    .withCredentialsProvider(provider)
```

3. Use RefreshCredentialsProvider

RefreshCredentialsProvider is an easy-to-use API operation for credentials.CredentialsFetcher.

RefreshCredentialsProvider automatically refreshes credentials based on the Expiration parameter. You can use this method when you need to periodically update the credentials.

```swift
let provider = RefreshCredentialsProvider {
    // The logic of obtaining credentials
    // await ...
    // Assuming to obtain the following credentials
    let accessKeyId = "ak"
    let accessKeySecret = "sk"
    let securityToken = "token"
    let expiration = Date()

    return Credentials(accessKeyId: accessKeyId, 
                       accessKeySecret: accessKeySecret, 
                       securityToken: securityToken, 
                       expiration: expiration)
}
let config = Configuration.default()
    .withCredentialsProvider(provider)
```

4. Use Remote signature mode

If you wish to sign through the server, you can set the signer to use remote signature mode

```swift
struct SignatureDelegateImp: SignatureDelegate {
    func signature(info: [String : String]) async throws -> [String : String] {
        // Signature version
        let version = info["version"]
        // Request method
        let method = info["method"]
        let bucket = info["bucket"]
        let key = info["key"]
        // To be signed string
        let stringToSign = info["stringToSign"]
        // Request time
        let date = info["date"]
        // The accessKeyId used for signature
        let accessKeyId = info["accessKeyId"]
        // When signing v4, an additional region and product will be returned
        let region = info["region"]
        let product = info["product"]

        // Transfer the information to the server and obtain the signature
        let signature = await ...
        
        return [
            "signature": signature,
        ]
    }
}

let provider = ClosureCredentialsProvider {
    // Return Credentials with real accessKeyId value
    // AccessKeySecret is a placeholder, such as `fake-sk`
    Credentials(accessKeyId: "ak", accessKeySecret: "fake-sk")
}
let config = Configuration.default()
    .withRegion("cn-hangzhou")
    .withCredentialsProvider(provider)
    .withSigner(RemoteSignerV4(delegate: SignatureDelegateImp()))
    // Use RemoteSignerV1 when signing v1
    // .withSigner(RemoteSignerV1(delegate: SignatureDelegateImp()))
let client = Client(config)
```

## Endpoint

You can use the Endpoint parameter to specify the endpoint of a request.

If the Endpoint parameter is not specified, OSS SDK for Swift creates a public endpoint based on the region. For example, if the value of the Region parameter is cn-hangzhou, oss-cn-hangzhou.aliyuncs.com is created as a public endpoint.

You can modify parameters to create other endpoints, such as internal endpoints, transfer acceleration endpoints, and dual-stack endpoints that support IPv6 and IPv4. For more information about OSS domain name rules, see [OSS domain names](https://www.alibabacloud.com/help/en/oss/user-guide/oss-domain-names).

If you use a custom domain name to access OSS, you must specify this parameter. When you use a custom domain name to access a bucket, you must map the custom domain name to the default domain name of the bucket. For more information, see [Map a custom domain name to the default domain name of a bucket](https://www.alibabacloud.com/help/en/oss/user-guide/map-custom-domain-names-5).


### Access OSS by using standard domain names

In the following examples, the Region parameter is set to cn-hangzhou.

1. Use a public endpoint

```swift
let config = Configuration.default()
    .withRegion("cn-hangzhou")
```
Or
```swift
let config = Configuration.default()
    .withRegion("cn-hangzhou")
    .withEndpoint("oss-cn-hanghzou.aliyuncs.com")
```

2. Use an internal endpoint

```swift
let config = Configuration.default()
    .withRegion("cn-hangzhou")
    .withUseInternalEndpoint(true)
```
Or
```swift
let config = Configuration.default()
    .withRegion("cn-hangzhou")
    .withEndpoint("oss-cn-hanghzou-internal.aliyuncs.com")
```

3. Use an OSS-accelerated endpoint
```swift
let config = Configuration.default()
    .withRegion("cn-hangzhou")
    .withUseAccelerateEndpoint(true)
```
Or
```swift
let config = Configuration.default()
    .withRegion("cn-hangzhou")
    .withEndpoint("oss-accelerate.aliyuncs.com")
```

4. Use a dual-stack endpoint
```swift
let config = Configuration.default()
    .withRegion("cn-hangzhou")
    .withUseDualStackEndpoint(true)
```
Or
```swift
let config = Configuration.default()
    .withRegion("cn-hangzhou")
    .withEndpoint("cn-hangzhou.oss.aliyuncs.com")
```

### Access OSS by using a custom domain name

In this example, the www.example-***.com domain name is mapped to the bucket-example bucket in the cn-hangzhou region.

```swift
let config = Configuration.default()
    .withRegion("cn-hangzhou")
    .withEndpoint("www.example-***.com")
    .withUseCname(true)
```

### Access private cloud or private domain

```swift
let region = "YOUR Region"
let endpoint = "YOUR Endpoint"

let config = Configuration.default()
    .withRegion(region)
    .withEndpoint(endpoint)
```

## HTTP client

In most cases, the default HTTP client that uses the default configurations can meet the business requirements. You can also change the default configurations of the HTTP client to meet the requirements of specific environments.

The following section describes how to configure an HTTP client.

### Common configurations for an HTTP client

Modify common configurations by using config. The following table describes the parameters that you can configure.

| Parameter | Description | Example |
|:-------|:-------|:-------
| timeoutIntervalForRequest | The timeout for request, Default value: 15. Unit: seconds. | withTimeoutIntervalForRequest(60)
| timeoutIntervalForResource | The maximum time allowed for resource requests, with a default value of 24 hours | withTimeoutIntervalForResource(60 * 60)
| enableTLSVerify | Specifies whether to perform SSL certificate verification. By default, the SSL certificates are verified. | withTLSVerify(true)
| enableFollowRedirect | Specifies whether to enable HTTP redirection. By default, HTTP redirection is disabled. | withFollowRedirect(true)
| maxConnectionsPerHost | Maximum number of connections per host | withMaxConnectionsPerHost(6)
| proxyHost | Specifies a proxy server. | withProxyHost("http://proxy.example-***.com")

Example

```swift
let config = Configuration.default()
    .withTimeoutIntervalForRequest(60)
```

## Retry

You can specify the retry behaviors for HTTP requests.

### Default retry policy

If you do not specify a retry policy, OSS SDK for Swift uses retry.Standard as the default retry policy of the client. Default configurations:

| Parameter | Description | Default value |
|:-------|:-------|:-------
| maxAttempts | The maximum number of retries. | 3 |
| maxBackoff | The maximum backoff time. | 20 seconds, 20 * time.Second |
| baseDelay | The base delay. | 200 milliseconds, 200 * time.Millisecond |
| backoff | The backoff algorithm. | FullJitter backoff, [0.0, 1.0) * min(2 ^ attempts * baseDealy, maxBackoff) |
| errorRetryables | The retryable errors. | For more information, visit [ErrorRetryable](Sources/OSS/Retry/ErrorRetryable.swift). |

When a retryable error occurs, the system uses the provided configurations to delay and retry the request. The overall latency of a request increases as the number of retries increases. If the default configurations do not meet your business requirements, you must configure or modify the retry parameters.

### Modify the maximum number of retries

You can use one of the following methods to modify the maximum number of retries. For example, set the maximum number of retries to 5.

```swift
let config = Configuration.default()
    .withRetryMaxAttempts(5)
```
Or
```swift
let config = Configuration.default()
    .withRetryer(StandardRetryer(maxAttempt: 5))
```

### Modify the backoff delay

For example, you can set BaseDelay to 500 milliseconds and the maximum backoff time to 25 seconds.

```swift
let config = Configuration.default()
    .withRetryer(StandardRetryer(backoff: FullJitterBackoff(baseDelay: 0.5,
                                                            maxBackoff: 25)))
```

### Modify the backoff algorithm

For example, you can use a fixed-time backoff algorithm that has a delay of 2 seconds each time.

```swift
let config = Configuration.default()
    .withRetryer(StandardRetryer(backoff: FixedDelayBackoff(fixedBackoff: 2)))
```

### Change retryable errors

For example, you can add custom retryable errors.

```swift
public struct CustomErrorCodeRetryable: ErrorRetryable {
    public func isErrorRetryable(error: Error) -> Bool {
        // Judgment error
        // return true
        return false
    }
}

let config = Configuration.default()
    .withRetryer(StandardRetryer(errorRetryable: [ServiceErrorRetryable(), ClientErrorRetryable(), CustomErrorCodeRetryable()]))
```

### Disable retry

If you want to disable all retry parameters, use retry.NopRetry.
```swift
let config = Configuration.default()
    .withRetryer(NopRetryer())
```


## Logs

To facilitate troubleshooting, OSS SDK for Swift provides the logging feature that uses debugging information in your application to debug and diagnose request issues.

If you want to use the logging feature, you must configure the log level. If the logging operation is not specified, logs are sent to the standard output (stdout) of the process by default.

Log level: LogAgentLevel.trace, LogAgentLevel.debug, LogAgentLevel.info, LogAgentLevel.warn, LogAgentLevel.error

Log operation: LogAgent

For example, to enable the logging feature, set the log level to Info and the output to OSLog

```swift
let config = Configuration.default()
    .withLogger(LogAgentOSLog(level: .info))
```

## Configuration parameters

Supported configuration parameters

| Parameter | Description | Example |
|:-------|:-------|:-------
| region | (Required) The region to which the request is sent. | withRegion("cn-hangzhou")
| credentialsProvider| (Required) The access credentials. | withCredentialsProvider(provider)
| endpoint| The endpoint used to access OSS. | withEndpoint("oss-cn-hanghzou.aliyuncs.com")
| retryMaxAttempts| The maximum number of HTTP retries. Default value: 3. | withRetryMaxAttempts(5)
| retryer| The retry configurations for HTTP requests. | withRetryer(customRetryer)
| timeoutIntervalForRequest | The timeout period for request. Default value: 15. Unit: seconds. | withTimeoutIntervalForRequest(60)
| timeoutIntervalForResource | The maximum time allowed for resource requests, with a default value of 24 hours |withTimeoutIntervalForResource(60 * 60)
| enableTLSVerify | Specifies whether to perform SSL certificate verification. By default, the SSL certificates are verified. | withTLSVerify(true)
| enableFollowRedirect | Specifies whether to enable HTTP redirection. By default, HTTP redirection is disabled. | withFollowRedirect(true)
| signerVersion | The signature version. Default value: v4 | withSignerVersion(.v4)
| logger | The log printing operation. | withLogger(customLogger)
| httpProtocal | HTTP protocol, default to HTTPS | withHttpProtocal(.https)
| usePathStyle | The path request style, which is also known as the root domain name request style. By default, the default domain name of the bucket is used. | withUsePathStyle(true)
| useCname | Specifies whether to use a custom domain name to access OSS. By default, a custom domain name is not used. | withUseCname(true)
| useDualStackEndpoint | Specifies whether to use a dual-stack endpoint to access OSS. By default, a dual-stack endpoint is not used. |withUseDualStackEndpoint(true)
| useAccelerateEndpoint | Specifies whether to use an OSS-accelerated endpoint to access OSS. By default, an OSS-accelerated endpoint is not used. |withUseAccelerateEndpoint(true)
| useInternalEndpoint | Specifies whether to use an internal endpoint to access OSS. By default, an internal endpoint is not used. |withUseInternalEndpoint(true)
| additionalHeaders | Specifies that additional headers to be signed. It's valid in V4 signature. | withAdditionalHeaders(["content-length"])
| userAgent | Specifies user identifier appended to the User-Agent header. | withUserAgent("user identifier")
| enableUploadCRC64Validation | Specifies that CRC-64 is enabled during object upload. By default, CRC-64 is enabled. |withUploadCRC64Validation(true)
| enableDownloadCRC64Validation | Specifies that CRC-64 is enabled during object download. By default, CRC-64 is enabled. |withDownloadCRC64Validation(true)
| maxConnectionsPerHost |单host最大连接数|withMaxConnectionsPerHost(6)
| proxyHost | Specifies a proxy server. | withProxyHost("http://proxy.example-***.com")

# API operations

This section describes the API operations provided by OSS SDK for Swift and how to call these API operations.

Subtopics in this section
* [Basic operations](#basic-operations)
* [Pre-signed URL](#pre-signed-url)
* [Paginator](#paginator)
* [Other API operations](#other-api-operations)
* [Comparison between upload and download operations](#comparison-between-upload-and-download-operations)

## Basic operations

OSS SDK for Swift provides operations corresponding to RESTful APIs, which are called basic operations or low-level API operations. You can call the basic operations to manage OSS, such as creating a bucket and updating and deleting the configurations of a bucket.

The basic operations use the same naming conventions and use the following syntax:

```
func <OperationName>(_ request: <OperationName>Request, _ options: OperationOptions? = nil) async throws -> <OperationName>Result
```

**Request parameters**
|Parameter|Type|Description
|:-------|:-------|:-------
|request|\<OperationName\>Request|Specifies the request parameters of a specific operation, such as bucket and key.
|options|OperationOptions|Optional. Operation-level configuration parameters, such as the parameter used to modify the read and write timeout period when you call the operation this time.

**Response parameters**
|Parameter|Type|Description
|:-------|:-------|:-------
|result|\<OperationName\>Result|The response to the operation. This parameter is valid when the value of err is nil.

## Pre-signed URL

You can call a specific operation to generate a pre-signed URL and use the pre-signed URL to grant temporary access to objects in a bucket or allow other users to upload specific objects to a bucket. You can use a pre-signed URL multiple times before the URL expires.

Syntax
```swift
func presign(_ request: <OperationName>Request, _ expiration: Foundation.Date? = nil) async throws -> PresignResult
```

**Request parameters**
|Parameter|Type|Description
|:-------|:-------|:-------
|request|<OperationName>Request|Specifies the name of the API operation that is used to generate a signed URL. The value must be the same as the value of parameters of the <OperationName>Request type.
|expiration|Foundation.Date|Optional. Specifies the validity period of the pre-signed URL. If you do not specify this parameter, the pre-signed URL uses the default value, which is 15 minutes.

**Response parameters**
|Parameter|Type|Description
|:-------|:-------|:-------
|result|PresignResult|The returned results, including the pre-signed URL, HTTP method, validity period, and request headers specified in the request.

**Supported types of request parameters**
|Type|Operation
|:-------|:-------
|GetObjectRequest|GetObject
|PutObjectRequest|PutObject
|HeadObjectRequest|HeadObject
|InitiateMultipartUploadRequest|InitiateMultipartUpload
|UploadPartRequest|UploadPart
|CompleteMultipartUploadRequest|CompleteMultipartUpload
|AbortMultipartUploadRequest|AbortMultipartUpload

> **Note**: If you use the V4 signature algorithm, the validity period can be up to seven days. If you specify both Expiration and Expires, Expiration takes precedence.

**Response parameters of PresignResult**
|Parameter|Type|Description
|:-------|:-------|:-------
|method|String|The HTTP method, which corresponds to the operation. For example, the HTTP method of the GetObject operation is GET.
|url|String|The pre-signed URL.
|expiration|Foundation.Date|The time when the pre-signed URL expires.
|signedHeaders|[Swift.String: Swift.String]|The request headers specified in the request. For example, if Content-Type is specified for PutObject, information about Content-Type is returned.


Examples
1. Generate a pre-signed URL for an object and download the object (GET request)
```swift
let client = Client(config)
let result = try await client.presign(
    GetObjectRequest(
        bucket: "bucket",
        key: "key"
    )
)

let (data, response) = try await URLSession.shared.data(from: URL(string: result.url)!)
```

2. Generate a pre-signed URL whose validity period is 10 minutes to upload an object, specify user metadata, and then upload the object (PUT request)
```swift
let client = Client(config)
let result = try await client.presign(
    PutObjectRequest(
        bucket: "bucket",
        key: "key",
        metadata: ["user": "jack"]
    ),
    Date().addingTimeInterval(10 * 60)
)

var urlRequest = URLRequest(url: URL(string: result.url)!)
urlRequest.httpMethod = result.method
for (key, value) in result.signedHeaders ?? [:] {
    urlRequest.setValue(value, forHTTPHeaderField: key)
}
let (data, response) = try await URLSession.shared.upload(for: urlRequest, from: Data())
```

For more examples, refer to the sample directory.

## Paginator

For the list operations, a paged result, which contains a tag for retrieving the next page of results, is returned if the response results are too large to be returned in a single response. If you want to obtain the next page of results, you must specify the tag when you send the request.

OSS SDK for Swift V2 provides a paginator that supports automatic pagination. If you call an API operation multiple times, OSS SDK for Swift V2 automatically obtains the results of the next page. When you use the paginator, you need to only compile the code that is used to process the results.

The paginator contains an object in the \<OperationName\>Paginator format and the paginator creation method in the New\<OperationName\>Paginator format. The paginator creation method returns a paginator object that implements the HasNext and NextPage methods. The HasNext method is used to determine whether more pages exist and the NextPage method is used to call an API operation to obtain the next page.

The request parameter type of New\<OperationName\>Paginator is the same as that of \<OperationName\>.

The returned result type of \<OperationName\>Paginator is the same as that of \<OperationName\>.

```swift
public struct <OperationName>Paginator: AsyncSequence {
...
}

func <OperationName>Paginator(_ request: <OperationName>Request, _ options: PaginatorOptions? = nil) -> <OperationName>Paginator
```

The following paginator objects are supported:
|Paginator object|Creation method|Corresponding list operation
|:-------|:-------|:-------
|ListObjectsPaginator|client.listBucketsPaginator|ListObjects: lists objects in a bucket.
|ListObjectsV2Paginator|client.listObjectsV2Paginator|ListObjectsV2: lists objects in a bucket.
|ListObjectVersionsPaginator|client.listObjectVersionsPaginator|ListObjectVersions: lists object versions in a bucket.
|ListBucketsPaginator|client.listBucketsPaginator|ListBuckets: lists buckets.
|ListPartsPaginator|client.listPartsPaginator|ListParts: lists all uploaded parts of an upload task that has a specific upload ID.
|ListMultipartUploadsPaginator|client.listMultipartUploadsPaginator|ListMultipartUploads: lists the running multipart upload tasks in a bucket.

PaginatorOptions
|Parameter|Description
|:-------|:-------
|limit|The maximum number of returned results.


In this example, ListObjects is used to describe how the paginator traverses all objects and how all objects are manually traversed.

```swift
// The paginator traverses all objects.
...
let client = Client(config)
let paginator = client.listObjectsPaginator(
    ListObjectsRequest(
        bucket: "bucket"
    )
)
for try await page in paginator {
    for object in page.contents ?? [] {
        print("key: \(object.key ?? "") storageClass: \(object.storageClass ?? "") lastModified: \(String(describing: object.lastModified))")
    }
}
```

```swift
// All objects are manually traversed.
...
let client = Client(config)
var nextMarker: String? = nil
repeat {
    let request = ListObjectsRequest(bucket: "bucket", marker: nextMarker)
    let result = try await client.listObjects(request)
    
    if let objects = result.contents {
        for object in objects {
            print("key: \(object.key ?? "") storageClass: \(object.storageClass ?? "") lastModified: \(String(describing: object.lastModified))")
        }
    }
    if let isTruncated = result.isTruncated,
        isTruncated {
        nextMarker = result.nextMarker
    } else {
        break
    }
} while true
```

## Other API operations

The following easy-to-use operations are encapsulated to improve user experience.  

| Operation | Description |
|:-------|:-------
| isObjectExist | Determines whether an object exists. |
| isBucketExist | Determines whether a bucket exists. |
| getObjectToFile | Downloads an object to the local computer. |

### isObjectExist/isBucketExist

The return values of IsObjectExist and IsBucketExist are (bool, error). If the value of the error parameter is nil and the value of bool is true, the object or the bucket exists. If the value of the error parameter is nil and the value of bool is false, the object or the bucket does not exist. If the value of error is not nil, the error message cannot be used to determine whether the object or the bucket exists.

```
func isBucketExist(_ bucket: Swift.String) async throws -> Bool
func isObjectExist(_ bucket: Swift.String, _ key: Swift.String, _ versionId: Swift.String? = nil) async throws -> Bool
```

Example: determine whether an object exists

```swift
let client = Client(config)
do {
    print("object existed: \(try await client.isObjectExist("bucket", "key"))")
} catch {
    print("error: \(error)")
}
```

### GetObjectToFile

Call the GetObject operation to download an object in a bucket to the local computer. The operation does not support concurrent downloads.

```
func getObjectToFile(_ request: GetObjectRequest,  _ file: URL, _ options: OperationOptions? = nil) async throws -> GetObjectResult
```
***note：GetObjectiToFile supports macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0 and above versions.***

Example

```swift
let client = Client(config)
let result = try await client.getObjectToFile(
    GetObjectRequest(
        bucket: "bucket",
        key: "key"
    ),
    URL(filePath: "filePath")
)
```

## Comparison between upload and download operations

Various upload and download operations are provided and you can select appropriate operations based on your business scenarios.

**Upload operations**
|Operation name|Description
|:-------|:-------
|client.putObject|Performs simple upload to upload a local file of up to 5 GiB.</br>Supports CRC-64 (enabled by default).</br>Supports the progress bar.</br>Supports the request body whose type is Data, File URL and InputStream. If the type of the request body is Data,Data and File URL, when the upload task fails, the local file is reuploaded.
|Multipart upload operations</br>client.initiateMultipartUpload</br>client.uploadPart</br>client.completeMultipartUpload|Performs multipart upload to upload a local file whose size is up to 48.8 TiB and whose part size is up to 5 GiB.</br>UploadPart supports CRC-64 (enabled by default).</br>UploadPart supports the progress bar.</br>UploadPart supports the request body whose type is Data, File URL and InputStream. If the type of the request body is Data,Data and File URL, when the upload task fails, the local file is reuploaded.
|client.appendObject|Performs append upload to upload a local file of up to 5 GiB.</br>Supports CRC-64 (enabled by default).</br>Supports the progress bar.</br>Supports the request body whose type is io.Reader. If the type of the request body is Data, File URL and InputStream. If the type of the request body is Data,Data and File URL, when the upload task fails, the local file is reuploaded. The operation is idempotent and data reupload may fail.

**Download operations**
|Operation name|Description
|:-------|:-------
|client.getObject|Performs download to memory. The type of the response body is ByteStream.</br>Supports CRC-64 (enabled by default).</br>Supports the progress bar.</br>Supports reconnection for failed connections.
|client.getObjectToFile|Downloads an object to the local computer.</br>Supports single connection download.</br>Supports CRC-64 (enabled by default).</br>Supports the progress bar.</br>Supports reconnection for failed connections.

# Sample scenarios

This section describes how to use OSS SDK for Swift in different scenarios.

Scenarios
* [Specify the progress bar](#specify-the-progress-bar)
* [Data verification](#data-verification)

## Specify the progress bar

In object upload, download, and copy scenarios, you can specify the progress bar to view the transmission progress of an object.

**Supported request parameters for the progress bar**
|Supported request parameter|Method
|:-------|:-------
|PutObjectRequest|PutObjectRequest.progress
|GetObjectRequest|GetObjectRequest.progress
|AppendObjectRequest|AppendObjectRequest.progress
|UploadPartRequest|UploadPartRequest.progress

**Syntax and parameters for ProgressDelegate**
```swift
public protocol ProgressDelegate: Sendable {
    mutating func onProgress(_ bytesIncrement: Int64, _ totalBytesTransferred: Int64, _ totalBytesExpected: Int64)
}
```
| Parameter | Type | Description |
|:-------|:-------|:-------
| bytesIncrement | Int64 | The size of the data transmitted by this callback. Unit: bytes. |
| totalBytesTransferred | Int64 | The size of transmitted data. Unit: bytes. |
| totalBytesExpected | Int64 | The size of the requested data. Unit: bytes. If the value of this parameter is -1, it specifies that the size cannot be obtained. |


Examples

1. Specify the progress bar when you upload a local file by calling PutObject

```swift
...
let client = Client(cfg)
let result = try await client.putObject(PutObjectRequest(
	bucket: "bucket",
	key: "key",
	body: .data(Data()),
	progress: ProgressClosure { bytesSent, totalBytesSent, totalBytesExpectedToSend in
		print("bytesSent: \(bytesSent), totalBytesSent: \(totalBytesSent), totalBytesExpectedToSend: \(totalBytesExpectedToSend)")
	}
))
```

2. Specify the progress bar when you download an object by calling GetObjectToFile
```swift
...
let client = Client(cfg)
let result = try await client.getObjectToFile(
    GetObjectRequest(
        bucket: "bucket",
        key: "key",
        progress: ProgressClosure { bytesSent, totalBytesSent, totalBytesExpectedToSend in
            print("bytesSent: \(bytesSent), totalBytesSent: \(totalBytesSent), totalBytesExpectedToSend: \(totalBytesExpectedToSend)")
        }
    ),
    URL(fileURLWithPath: "../oss/file")
)
```

## Data verification

OSS provides MD5 verification and CRC-64 to ensure data integrity during requests.

## MD5 verification

When a request is sent to OSS, if the Content-MD5 header is specified, OSS calculates the MD5 hash based on the received content. If the MD5 hash calculated by OSS is different from the MD5 hash configured in the upload request, the InvalidDigest error code is returned. This allows OSS to ensure data integrity for object upload.

Except for PutObject, AppendObject, and UploadPart, the basic API operations automatically calculate the MD5 hash and specify the Content-MD5 header to ensure the integrity of the request.

If you want to use MD5 verification in PutObject, AppendObject, or UploadPart, use the following syntax:

```swift
...
let client = Client(config)

let chunkSize = 8 * 1024
let file = URL(fileURLWithPath: "filePath")
let fileHandle = try FileHandle(forReadingFrom: file)
defer {
    fileHandle.closeFile()
}

var md5 = Insecure.MD5()
var done = false
while !done {
    let data = fileHandle.readData(ofLength: chunkSize)
    if data.count == 0 {
        done = true
    }
    md5.update(data: data)
}

let contentMd5 = Data(md5.finalize()).base64EncodedString()

let result = try await client.putObject(
    PutObjectRequest(
        bucket: "bucket",
        key: "key",
        contentMd5: contentMd5,
        body: .file(file)
    )
)
print("result: \(result)")
```

## CRC-64

When you upload an object by calling an API operation, such as PutObject, AppendObject, and UploadPart, CRC-64 is enabled by default to ensure data integrity.

When you download an object, take note of the following items:
* If you download an object to a local computer, CRC-64 is enabled to ensure data integrity by default. For example, CRC-64 is enabled for the GetObject and GetObjectToFile operations.

To disable CRC-64, set Configuration.withDisableDownloadCRC64Check and Configuration.withDisableUploadCRC64Check to true. Example:
```swift
let config = Configuration.default()
    .withRegion(region)
    .withCredentialsProvider(EnvironmentCredentialsProvider())
    .withUploadCRC64Validation(false)
    .withDownloadCRC64Validation(false)

let client = Client(config)
```


# Migration guide

This section describes how to upgrade OSS SDK for iOS from V1 ([aliyun-oss-ios-sdk](https://github.com/aliyun/aliyun-oss-ios-sdk)) to V2.

## Earliest version for iOS/macOS

OSS SDK for Swift V2 requires that the version for iOS_13.0/macOS_10.15 or later.

## Import path

OSS SDK for Swift V2 uses a new code repository. The code structure is adjusted and organized by functional module. The following table describes the paths and descriptions of these modules.

| Module path | Description |
|:-------|:-------
| github.com/aliyun/alibabacloud-oss-swift-sdk-v2/OSS | The core of OSS SDK for Swift, which is used to call basic and advance API operations. |
| github.com/aliyun/alibabacloud-oss-Swift-sdk-v2/OSSExtension | The extension of OSS SDK for Swift, which is used to call bucket control API operations. |

Examples

```swift
// v1 
import AliyunOSSiOS
```

```swift
// v2 
import AlibabaCloudOSS
// Import Alibaba CloudOS Extension as needed
// import AlibabaCloudOSSExtension
```

## Configuration loading

OSS SDK for Swift V2 simplifies configurations and imports the configurations to [Configuration](./Sources/OSS/Configuration.swift). OSS SDK for Swift V2 provides auxiliary functions prefixed with With to facilitate the programmatically overwriting of the default configurations.

OSS SDK for Swift V2 uses V4 signatures by default. In this case, you must specify the region.

OSS SDK for Swift V2 allows you to create an endpoint based on the region information. If you access resources in the public cloud, you do not need to create an endpoint.

Examples

```swift
// v1
import AliyunOSSiOS
...

let provider = OSSStsTokenCredentialProvider(accessKeyId: "ak",
                                             secretKeyId: "sk",
                                             securityToken: "token")
let config = OSSClientConfiguration()
// Set the timeout to 60s
config.timeoutIntervalForRequest = 60
config.signVersion = .V4

let client = OSSClient(endpoint: "https://oss-cn-hangzhou.aliyuncs.com",
                       credentialProvider: provider,
                       clientConfiguration: config)
client.region = "cn-hangzhou"
```

```swift
// v2
import AlibabaCloudOSS
...
let provider = StaticCredentialsProvider(accessKeyId: "ak",
                                         accessKeySecret: "sk",
                                         securityToken: "token")
let config = Configuration.default()
    .withRegion("cn-hangzhou") 
    .withCredentialsProvider(provider)
    .withTimeoutIntervalForRequest(60) // Set the timeout to 60s
let client = Client(config)
```

## Remote signature

The V2 version removed OSSCustomSignerCredetialProvider and added remote signing。

示例

```swift
// v1
let provider = OSSCustomSignerCredentialProvider { content, _ in
    // Transfer content and obtain signature
    let signature = ...
    return signature
}
let config = OSSClientConfiguration()
// OSSCustomSignerCredetialProvider only supports v1 version signatures
config.signVersion = .V1

let client = OSSClient(endpoint: "https://oss-cn-hangzhou.aliyuncs.com",
                       credentialProvider: provider,
                       clientConfiguration: config)
```

```swift
// v2
struct SignatureDelegateImp: SignatureDelegate {
    func signature(info: [String : String]) async throws -> [String : String] {
        // Signature version
        let version = info["version"]
        // Request method
        let method = info["method"]
        let bucket = info["bucket"]
        let key = info["key"]
        // To be signed string
        let stringToSign = info["stringToSign"]
        // Request time
        let date = info["date"]
        // The accessKeyId used for signature
        let accessKeyId = info["accessKeyId"]
        // When signing v4, an additional region and product will be returned
        let region = info["region"]
        let product = info["product"]

        // Transfer the information to the server and obtain the signature
        let signature = await ...
        
        return [
            "signature": signature,
        ]
    }
}

let provider = ClosureCredentialsProvider {
    // Return Credentials with real accessKeyId value
    // AccessKeySecret is a placeholder, such as `fake-sk`
    Credentials(accessKeyId: "ak", accessKeySecret: "fake-sk")
}
let config = Configuration.default()
    .withRegion("cn-hangzhou")
    .withCredentialsProvider(provider)
    .withSigner(RemoteSignerV4(delegate: SignatureDelegateImp()))
    // Use RemoteSignerV1 when signing v1
    // .withSigner(RemoteSignerV1(delegate: SignatureDelegateImp()))
let client = Client(config)
```

## Create a client

In OSS SDK for Swift V2, the name of client is changed OSSClient to Client. In addition, the client creation function no longer supports the endpoint and credentialProvider parameters.

Examples

```swift
// v1
let client = OSSClient(endpoint: endpoint,
                       credentialProvider: provider,
                       clientConfiguration: config)
```

```swift
// v2
let client = Client(config)
```

## Call API operations

Basic API operations are merged into a single operation method in the \<OperationName\> format, the request parameters of an operation are merged into \<OperationName\>Request, and the response parameters of an operation are merged into \<OperationName\>Result. The operation methods are imported to Client, and context.Context needs to be specified at the same time. Syntax:

```swift
func <OperationName>(_ request: <OperationName>Request, _ options: OperationOptions? = nil) async throws -> <OperationName>Result
```

For more information, see [Basic API operations](#basic-operations).

Examples

```swift
// v1
import AliyunOSSiOS

let provider = OSSStsTokenCredentialProvider(accessKeyId: "ak",
                                             secretKeyId: "sk",
                                             securityToken: "token")
let config = OSSClientConfiguration()
config.signVersion = .V4

let client = OSSClient(endpoint: "https://oss-cn-hangzhou.aliyuncs.com",
                       credentialProvider: provider,
                       clientConfiguration: config)
client.region = "cn-hangzhou"

let request = OSSPutObjectRequest()
request.bucketName = "bucket"
request.objectKey = "key"
request.uploadingData = "hello oss".data(using: .utf8)
client.putObject(request).continue({ task in
    return nil
})
```

```swift
v2
import AlibabaCloudOSS

let provider = StaticCredentialsProvider(accessKeyId: "ak",
                                         accessKeySecret: "sk",
                                         securityToken: "token")
let config = Configuration.default()
    .withRegion("cn-hangzhou") 
    .withCredentialsProvider(provider)
let client = Client(config)
let result = try await client.putObject(
    PutObjectRequest(
        bucket: "bucket",
        key: "key",
        body: .data("hello oss".data(using: .utf8)!)
    )
)
```

## Generate a pre-signed URL

In OSS SDK for Swift V2, the name of the operation used to generate a pre-signed URL is changed from SignURL to Pressign, and the operation is imported to Client. Syntax:

```swift
func presign(_ request: <OperationName>Request, _ expiration: Foundation.Date? = nil) async throws -> PresignResult
```

The type of request parameters is the same as \<OperationName\>Request in the API operation.

The response contains a pre-signed URL, the HTTP method, the expiration time of the URL, and the signed request headers. Example:
```swift
public struct PresignResult: Sendable {

    public var method: String

    public var url: String

    public var expiration: Foundation.Date?

    public var signedHeaders: [Swift.String: Swift.String]?
}
```

For more information, see [Operation used to generate a pre-signed URL](#operation-used-to-generate-a-pre-signed-URL).

The following sample code provides an example on how to migrate an object from OSS SDK for Swift V1 to OSS SDK for Swift V2 by generating a pre-signed URL that is used to download the object:

```swift
// v1
import AliyunOSSiOS

let provider = OSSStsTokenCredentialProvider(accessKeyId: "ak",
                                             secretKeyId: "sk",
                                             securityToken: "token")
let config = OSSClientConfiguration()
config.signVersion = .V4

let client = OSSClient(endpoint: "https://oss-cn-hangzhou.aliyuncs.com",
                       credentialProvider: provider,
                       clientConfiguration: config)
client.region = "cn-hangzhou"

let task = client.presignConstrainURL(withBucketName: "bucket",
                                      withObjectKey: "key",
                                      httpMethod: "GET",
                                      withExpirationInterval: 60,
                                      withParameters: [:])
task.continue({ task in
    print("\(task)")
    return nil
})
```

```swift
// v2
import AlibabaCloudOSS

clet provider = StaticCredentialsProvider(accessKeyId: "ak",
                                          accessKeySecret: "sk",
                                          securityToken: "token")
let config = Configuration.default()
    .withRegion("cn-hangzhou")
    .withCredentialsProvider(provider)
let client = Client(config)

let result = try await client.presign(
    GetObjectRequest(
        bucket: "bucket",
        key: "key"
    ),
    Date().addingTimeInterval(60)
)
print("result: \(result)")
```