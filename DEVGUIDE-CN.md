# 开发者指南
## [English](DEVGUIDE.md)

阿里云对象存储（Object Storage Service，简称OSS），是阿里云对外提供的海量、安全、低成本、高可靠的云存储服务。用户可以通过调用API，在任何应用、任何时间、任何地点上传和下载数据，也可以通过用户Web控制台对数据进行简单的管理。OSS适合存放任意文件类型，适合各种网站、开发企业及开发者使用。

该开发套件隐藏了许多较低级别的实现，例如身份验证、请求重试和错误处理, 通过其提供的接口，让您不用复杂编程即可访问阿里云OSS服务。

您可以参阅该指南，来帮助您安装、配置和使用该开发套件。

跳转到:

* [安装](#安装)
* [配置](#配置)
* [接口说明](#接口说明)
* [场景示例](#场景示例)
* [迁移指南](#迁移指南)

# 安装

## 环境准备

使用Swift 5.9及以上版本。
请参考[Swift安装](https://www.swift.org/install)下载和安装Swift编译运行环境。
您可以执行以下命令查看Swift语言版本。
```
swift --version
```

## 安装SDK

### Swift Package Manager 方式
在 Package.swift 文件中添加以下依赖。
```swift
.package(url: "https://github.com/aliyun/alibabacloud-oss-swift-sdk-v2.git", from: "0.1.0-beta")
```

### 在Xcode中通过 Swift Package Manager 安装
- 先在`Xcode`中新建或者打开已有的项目，然后选择`PROJECT`－`Package Dependencies`，点击`+`
- 搜索`https://github.com/aliyun/alibabacloud-oss-swift-sdk-v2.git`，点击`Add Package`
 
## 验证SDK
运行以下代码查看SDK版本：
```swift
import AlibabaCloudOSS

func main() {
    print("OSS Swift SDK Version: \(SdkInfo.version())")
}
```

# 配置
您可以配置服务客户端的常用设置，例如超时、日志级别和重试配置，大多数设置都是可选的。
但是，对于每个客户端，您必须指定区域和凭证。 SDK使用这些信息签署请求并将其发送到正确的区域。

此部分的其它主题
* [区域](#区域)
* [凭证](#凭证)
* [访问域名](#访问域名)
* [HTTP客户端](#http客户端)
* [重试](#重试)
* [日志](#日志)
* [配置参数汇总](#配置参数汇总)

## 加载配置
配置客户端的设置有多种方法，以下是推荐的模式。

```swift
import AlibabaCloudOSS

func main() {
    // 以华东1（杭州）为例
    let region = "cn-hangzhou"

    // 以从环境变量加载凭证为例
    let credentialsProvider = EnvironmentCredentialsProvider()

    let config = Configuration.default()
        .withCredentialsProvider(credentialsProvider)
        .withRegion(region)
}
```

## 区域
指定区域时，您可以指定向何处发送请求，例如 cn-hangzhou 或 cn-shanghai。有关所支持的区域列表，请参阅 [OSS访问域名和数据中心](https://www.alibabacloud.com/help/zh/oss/user-guide/regions-and-endpoints)。
SDK 没有默认区域，您需要加载配置时使用`config.withRegion`作为参数显式设置区域。例如
```swift
let config = Configuration.default().withRegion("cn-hangzhou")
```

>**说明**：该SDK默认使用v4签名，所以必须指定该参数。

## 凭证

SDK需要凭证（访问密钥）来签署对 OSS 的请求, 所以您需要显式指定这些信息。当前支持凭证配置如下：
* [环境变量](#环境变量)
* [静态凭证](#静态凭证)
* [自定义凭证提供者](#自定义凭证提供者)

### 环境变量

SDK 支持从环境变量获取凭证，支持的环境变量名如下：
* OSS_ACCESS_KEY_ID
* OSS_ACCESS_KEY_SECRET
* OSS_SESSION_TOKEN（可选）

以下展示了如何配置环境变量。

1. Linux、OS X 或 Unix
```
$ export OSS_ACCESS_KEY_ID=YOUR_ACCESS_KEY_ID
$ export OSS_ACCESS_KEY_SECRET=YOUR_ACCESS_KEY_SECRET
$ export OSS_SESSION_TOKEN=TOKEN
```

2. Windows
```
$ set OSS_ACCESS_KEY_ID=YOUR_ACCESS_KEY_ID
$ set OSS_ACCESS_KEY_SECRET=YOUR_ACCESS_KEY_SECRET
$ set OSS_SESSION_TOKEN=TOKEN
```

使用环境变量凭证

```swift
let provider = EnvironmentCredentialsProvider()
let config = Configuration.default().withCredentialsProvider(provider)
```

### 静态凭证

您可以在应用程序中对凭据进行硬编码，显式设置要使用的访问密钥。

> **注意:** 请勿将凭据嵌入应用程序中，此方法仅用于测试目的。

1. 长期凭证
```swift
let provider = StaticCredentialsProvider(
    accessKeyId: accessKeyId,
    accessKeySecret: accessKeySecret
)
let config = Configuration.default().withCredentialsProvider(provider)
```

2. 临时凭证
```swift
let provider = StaticCredentialsProvider(
    accessKeyId: accessKeyId,
    accessKeySecret: accessKeySecret,
    securityToken: securityToken
)
let config = Configuration.default().withCredentialsProvider(provider)
```

### 自定义凭证提供者

当以上凭证配置方式不满足要求时，您可以自定义获取凭证的方式。SDK 支持多种实现方式。

1. 实现 credentials.CredentialsProvider 接口
```swift
import AlibabaCloudOSS

struct CustomerCredentialsProvider: CredentialsProvider {
    func getCredentials() async throws -> Credentials {
        // 返回长期凭证
        return Credentials(accessKeyId: "ak", accessKeySecret: "sk")
        // 返回临时凭证
        // return Credentials(accessKeyId: "ak", accessKeySecret: "sk", securityToken: "token")
    }
}

let config = Configuration.default()
    .withCredentialsProvider(CustomerCredentialsProvider())
```

2. 通过 ClosureCredentialsProvider

ClosureCredentialsProvider 是 CredentialsProvider 的 易用性封装。

```swift
let provider = ClosureCredentialsProvider {
    // 获取凭证的逻辑
    // await ...
    // 假设获取如下凭证
    let accessKeyId = "ak"
    let accessKeySecret = "sk"
    // let securityToken = "token"
    // 返回长期凭证
    return Credentials(accessKeyId: accessKeyId, accessKeySecret: accessKeySecret)
    // 返回临时凭证
    // return Credentials(accessKeyId: accessKeyId, accessKeySecret: accessKeySecret, securityToken: securityToken)
}
let config = Configuration.default()
    .withCredentialsProvider(provider)
```

3. 通过 RefreshCredentialsProvider

RefreshCredentialsProvider 是 CredentialsFetcher 易用性接口。
RefreshCredentialsProvider 具备 根据 'Expiration' 时间，自动刷新凭证的能力，当您需要定期更新凭证时，请使用该方式。

```swift
let provider = RefreshCredentialsProvider {
    // 获取凭证的逻辑
    // await ...
    // 假设获取如下凭证
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

4. 远程签名模式

如果您希望通过服务端签名，您可以设置signer使用远程签名模式

```swift
struct SignatureDelegateImp: SignatureDelegate {
    func signature(info: [String : String]) async throws -> [String : String] {
        // 签名版本
        let version = info["version"]
        // 请求method
        let method = info["method"]
        let bucket = info["bucket"]
        let key = info["key"]
        // 待签名字符串
        let stringToSign = info["stringToSign"]
        // 请求时间
        let date = info["date"]
        // 签名使用的accessKeyId
        let accessKeyId = info["accessKeyId"]
        // v4签名时会额外返回region及product
        let region = info["region"]
        let product = info["product"]

        // 将参数传输到服务端，获取签名
        let signature = await ...
        
        return [
            "signature": signature,
        ]
    }
}

let provider = ClosureCredentialsProvider {
    // 返回带有真实accessKeyId值的Credentials
    // accessKeySecret为占位符，如`fake-sk`
    Credentials(accessKeyId: "ak", accessKeySecret: "fake-sk")
}
let config = Configuration.default()
    .withRegion("cn-hangzhou")
    .withCredentialsProvider(provider)
    .withSigner(RemoteSignerV4(delegate: SignatureDelegateImp()))
    // v1签名时使用RemoteSignerV1
    // .withSigner(RemoteSignerV1(delegate: SignatureDelegateImp()))
let client = Client(config)
```

## 访问域名

您可以通过Endpoint参数，自定义服务请求的访问域名。

当不指定时，SDK根据Region信息，构造公网访问域名。例如当Region为'cn-hangzhou'时，构造出来的访问域名为'oss-cn-hangzhou.aliyuncs.com'。

您可以通过修改配置参数，构造出其它访问域名，例如 内网访问域名，传输加速访问域名 和 双栈(IPV6,IPV4)访问域名。有关OSS访问域名规则，请参考[OSS访问域名使用规则](https://www.alibabacloud.com/help/zh/oss/user-guide/oss-domain-names)。

当通过自定义域名访问OSS服务时，您需要指定该配置参数。在使用自定义域名发送请求时，请先绑定自定域名至Bucket默认域名，具体操作详见 [绑定自定义域名](https://www.alibabacloud.com/help/zh/oss/user-guide/map-custom-domain-names-5)。


### 使用标准域名访问

以 访问 Region 'cn-hangzhou' 为例

1. 使用公网域名

```swift
let config = Configuration.default()
    .withRegion("cn-hangzhou")
```
或者
```swift
let config = Configuration.default()
    .withRegion("cn-hangzhou")
    .withEndpoint("oss-cn-hanghzou.aliyuncs.com")
```

2. 使用内网域名

```swift
let config = Configuration.default()
    .withRegion("cn-hangzhou")
    .withUseInternalEndpoint(true)
```
或者
```swift
let config = Configuration.default()
    .withRegion("cn-hangzhou")
    .withEndpoint("oss-cn-hanghzou-internal.aliyuncs.com")
```
   
3. 使用传输加速域名
```swift
let config = Configuration.default()
    .withRegion("cn-hangzhou")
    .withUseAccelerateEndpoint(true)
```
或者
```swift
let config = Configuration.default()
    .withRegion("cn-hangzhou")
    .withEndpoint("oss-accelerate.aliyuncs.com")
```   
   
4. 使用双栈域名
```swift
let config = Configuration.default()
    .withRegion("cn-hangzhou")
    .withUseDualStackEndpoint(true)
```
或者
```swift
let config = Configuration.default()
    .withRegion("cn-hangzhou")
    .withEndpoint("cn-hangzhou.oss.aliyuncs.com")
```   

### 使用自定义域名访问

以 'www.example-***.com' 域名 绑定到 'cn-hangzhou' 区域 的 bucket-example 存储空间为例

```swift
let config = Configuration.default()
    .withRegion("cn-hangzhou")
    .withEndpoint("www.example-***.com")
    .withUseCname(true)
```

### 访问专有云或专有域

```swift
let region = "YOUR Region"
let endpoint = "YOUR Endpoint"

let config = Configuration.default()
    .withRegion(region)
    .withEndpoint(endpoint)
```

## HTTP客户端

在大多数情况下，使用具有默认值的默认HTTP客户端 能够满足业务需求。您也可以更改 HTTP 客户端的默认配置，以满足特定环境下的使用需求。

本部分将介绍如何设置 HTTP 客户端。

### 设置HTTP客户端常用配置

通过config修改常用的配置，支持参数如下：

|参数名字 | 说明 | 示例 
|:-------|:-------|:-------
|timeoutIntervalForRequest|请求超时时间, 默认值为 15 秒|withTimeoutIntervalForRequest(60)
|timeoutIntervalForResource|资源请求允许花费的最长时间, 默认值为 24 小时|withTimeoutIntervalForResource(60 * 60)
|enableTLSVerify|是否进行SSL证书校验，默认检查SSL证书|withTLSVerify(true)
|enableFollowRedirect|是否开启HTTP重定向, 默认不开启|withFollowRedirect(true)
|maxConnectionsPerHost|单host最大连接数|withMaxConnectionsPerHost(6)
|proxyHost|设置代理服务器|withProxyHost("http://proxy.example-***.com")

示例

```swift
let config = Configuration.default()
    .withTimeoutIntervalForRequest(60)
```

## 重试

您可以配置对HTTP请求的重试行为。

### 默认重试策略

当没有配置重试策略时，SDK 使用 StandardRetryer 作为客户端的默认实现，其默认配置如下：

|参数名称 | 说明 | 默认值 
|:-------|:-------|:-------
|maxAttempt|最大尝试次数| 3
|maxBackoff|最大退避时间| 20秒
|baseDelay|基础延迟| 0.3秒
|backoff|退避算法| FullJitter 退避,  [0.0, 1.0) * min(2 ^ attempts * baseDealy, maxBackoff)
|errorRetryable|可重试的错误| 具体的错误信息，请参见[ErrorRetryable](Sources/OSS/Retry/ErrorRetryable.swift)

当发生可重试错误时，将使用其提供的配置来延迟并随后重试该请求。请求的总体延迟会随着重试次数而增加，如果默认配置不满足您的场景需求时，需要配置重试参数 或者修改重试实现。

### 调整最大尝试次数

您可以通过以下两种方式修改最大尝试次数。例如 最多尝试 5  次 

```swift
let config = Configuration.default()
    .withRetryMaxAttempts(5)
```
或者
```swift
let config = Configuration.default()
    .withRetryer(StandardRetryer(maxAttempt: 5))
```

### 调整退避延迟

例如 调整 BaseDelay 为 500毫秒，最大退避时间为 25秒

```swift
let config = Configuration.default()
    .withRetryer(StandardRetryer(backoff: FullJitterBackoff(baseDelay: 0.5,
                                                            maxBackoff: 25)))
```

### 调整退避算法

例如 使用固定时间退避算法，每次延迟2秒 

```swift
let config = Configuration.default()
    .withRetryer(StandardRetryer(backoff: FixedDelayBackoff(fixedBackoff: 2)))
```

### 调整重试错误

例如 在原有基础上，新增自定义可重试错误

```swift
public struct CustomErrorCodeRetryable: ErrorRetryable {
    public func isErrorRetryable(error: Error) -> Bool {
        // 判断错误
        // return true
        return false
    }
}

let config = Configuration.default()
    .withRetryer(StandardRetryer(errorRetryable: [ServiceErrorRetryable(), ClientErrorRetryable(), CustomErrorCodeRetryable()]))
```

### 禁用重试

当您希望禁用所有重试尝试时，可以使用 NopRetryer 实现
```swift
let config = Configuration.default()
    .withRetryer(NopRetryer())
```


## 日志

为了方便追查问题，SDK提供了日志记录功能，您可以在应用程序中启用调试信息以调试和诊断请求问题。

当需要启用日志记录功能时，您需要配置日志级别。当不设置日志接口时，默认将日志信息发送到进程的标准输出(stdout).

日志级别：LogAgentLevel.trace, LogAgentLevel.debug, LogAgentLevel.info, LogAgentLevel.warn, LogAgentLevel.error

日志接口: LogAgent

例如，开启日志功能，设置日志级别为 Info，输出到OSLog

```swift
let config = Configuration.default()
    .withLogger(LogAgentOSLog(level: .info))
```

## 配置参数汇总

支持的配置参数：

|参数名字 | 说明 | 示例 
|:-------|:-------|:-------
| region | (必选)请求发送的区域, 必选 | withRegion("cn-hangzhou")
| credentialsProvider | (必选)设置访问凭证 | withCredentialsProvider(provider)
| endpoint | 访问域名 | withEndpoint("oss-cn-hanghzou.aliyuncs.com")
| retryMaxAttempts | HTTP请求时的最大尝试次数, 默认值为 3 | withRetryMaxAttempts(5)
| retryer|HTTP请求时的重试实现 | withRetryer(customRetryer)
| timeoutIntervalForRequest | 请求超时时间, 默认值为 15 秒 | withTimeoutIntervalForRequest(60)
| timeoutIntervalForResource | 资源请求允许花费的最长时间, 默认值为 24 小时 | withTimeoutIntervalForResource(60 * 60)
| enableTLSVerify | 是否开启SSL证书校验，默认检查SSL证书 | withTLSVerify(true)
| enableFollowRedirect | 是否开启HTTP重定向, 默认不开启 | withFollowRedirect(true)
| signerVersion | 签名版本，默认值为v4 | withSignerVersion(.v4)
| logger | 设置日志打印接口 | withLogger(customLogger)
| httpProtocal | http协议，默认使用https | withHttpProtocal(.https)
| usePathStyle | 使用路径请求风格，即二级域名请求风格，默认为bucket托管域名 | withUsePathStyle(true)
| useCname | 是否使用自定义域名访问，默认不使用 | withUseCname(true)
| useDualStackEndpoint | 是否使用双栈域名访问，默认不使用 | withUseDualStackEndpoint(true)
| useAccelerateEndpoint | 是否使用传输加速域名访问，默认不使用 | withUseAccelerateEndpoint(true)
| useInternalEndpoint | 是否使用内网域名访问，默认不使用 | withUseInternalEndpoint(true)
| additionalHeaders | 指定额外的签名请求头，V4签名下有效 | withAdditionalHeaders(["content-length"])
| userAgent | 指定额外的User-Agent信息 | withUserAgent("user identifier")
| enableUploadCRC64Validation | 是否开启上传时的crc校验，默认开启 | withUploadCRC64Validation(true)
| enableDownloadCRC64Validation | 是否开启下载时的crc校验，默认开启 | withDownloadCRC64Validation(true)
| maxConnectionsPerHost | 单host最大连接数 | withMaxConnectionsPerHost(6)
| proxyHost | 设置代理服务器 | withProxyHost("http://proxy.example-***.com")


# 接口说明

本部分介绍SDK提供的接口, 以及如何使用这些接口。

此部分的其它主题
* [基础接口](#基础接口)
* [预签名接口](#预签名接口)
* [分页器](#分页器)
* [其它接口](#其它接口)
* [上传下载接口对比](#上传下载接口对比)

## 基础接口

SDK 提供了 与 REST API 对应的接口，把这类接口叫做 基础接口 或者 低级别API。您可以通过这些接口访问OSS的服务，例如创建存储空间，更新和删除存储空间的配置等。

这些接口采用了相同的命名规则，其接口定义如下：

```swift
func <OperationName>(_ request: <OperationName>Request, _ options: OperationOptions? = nil) async throws -> <OperationName>Result
```

**参数列表**：
|参数名|类型|说明
|:-------|:-------|:-------
|request|\<OperationName\>Request|设置具体接口的请求参数，例如bucket，key
|options|OperationOptions|(可选)接口级的配置参数, 例如修改此次调用接口时读写超时

**返回值列表**：
|返回值名|类型|说明
|:-------|:-------|:-------
|result|\<OperationName\>Result|接口返回值

## 预签名接口

您可以使用预签名接口生成预签名URL，授予对存储空间中对象的限时访问权限，或者允许他人将特定对象的上传到存储空间。在过期时间之前，您可以多次使用预签名URL。

预签名接口定义如下：
```swift
func presign(_ request: <OperationName>Request, _ expiration: Foundation.Date? = nil) async throws -> PresignResult
```

**参数列表**：
|参数名|类型|说明
|:-------|:-------|:-------
|request|<OperationName>Request|设置需要生成签名URL的接口名
|expiration|Foundation.Date|(可选)，设置过期时间，如果不指定，默认有效期为15分钟

**返回值列表**：
|返回值名|类型|说明
|:-------|:-------|:-------
|result|PresignResult|返回结果，包含 预签名URL，HTTP 方法，过期时间 和 参与签名的请求头

**request参数支持的类型**：
|类型|对应的接口
|:-------|:-------
|GetObjectRequest|GetObject
|PutObjectRequest|PutObject
|HeadObjectRequest|HeadObject
|InitiateMultipartUploadRequest|InitiateMultipartUpload
|UploadPartRequest|UploadPart
|CompleteMultipartUploadRequest|CompleteMultipartUpload
|AbortMultipartUploadRequest|AbortMultipartUpload

> **注意:** 在签名版本4下，有效期最长为7天。

**PresignResult返回值**：
|参数名|类型|说明
|:-------|:-------|:-------
|method|String|HTTP 方法，和 接口对应，例如GetObject接口，返回 GET
|url|String|预签名 URL
|expiration|Date| 签名URL的过期时间
|signedHeaders|[String:String]|被签名的请求头，例如PutObject接口，设置了Content-Type 时，会返回 Content-Type 的信息。


示例
1. 为对象生成预签名 URL，然后下载对象（GET 请求）
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

2. 为上传生成预签名 URL, 设置自定义元数据，有效期为10分钟，然后上传文件（PUT 请求）
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

更多的示例，请参考 Sample 目录

## 分页器

对于列举类接口，当响应结果太大而无法在单个响应中返回时，都会返回分页结果，该结果同时包含一个用于检索下一页结果的标记。当需要获取下一页结果时，您需要在发送请求时设置该标记。

对常用的列举接口，V2 SDK 提供了分页器（Paginator），支持自动分页，当进行多次调用时，自动为您获取下一页结果。使用分页器时，您只需要编写处理结果的代码。

分页器 包含了 分页器对象 '\<OperationName\>Paginator' 和 分页器创建方法 'client.\<OperationName\>Paginator'。分页器创建方法返回一个分页器对象，该对象实现了 'AsyncSequence'，可搭配for-await 循环使用。

分页器创建方法 'client.\<OperationName\>Paginator' 里的 request 参数类型 与 '\<OperationName\>' 接口中的 reqeust 参数类型一致。
'\<OperationName\>Paginator' 返回的结果类型 和 '\<OperationName\>' 接口 返回的结果类型 一致。


```swift
public struct <OperationName>Paginator: AsyncSequence {
...
}

func <OperationName>Paginator(_ request: <OperationName>Request, _ options: PaginatorOptions? = nil) -> <OperationName>Paginator
```

支持的分页器对象如下：
|分页器对象|创建方法|对应的列举接口
|:-------|:-------|:-------
|ListObjectsPaginator|client.listBucketsPaginator|ListObjects, 列举存储空间中的对象信息
|ListObjectsV2Paginator|client.listObjectsV2Paginator|ListObjectsV2, 列举存储空间中的对象信息
|ListObjectVersionsPaginator|client.listObjectVersionsPaginator|ListObjectVersions, 列举存储空间中的对象版本信息
|ListBucketsPaginator|client.listBucketsPaginator|ListBuckets, 列举存储空间
|ListPartsPaginator|client.listPartsPaginator|ListParts, 列举指定Upload ID所属的所有已经上传成功分片
|ListMultipartUploadsPaginator|client.listMultipartUploadsPaginator|ListMultipartUploads, 列举存储空间中的执行中的分片上传事件

PaginatorOptions 选项说明：
|参数|说明
|:-------|:-------
|limit|指定返回结果的最大数


以 ListObjects 为例，分页器遍历所有对象 和 手动分页遍历所有对象 对比

```swift
// 分页器遍历所有对象
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
// 手动分页遍历所有对象
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

## 其它接口

为了方便用户使用，封装了一些易用性接口。当前扩展的接口如下：

|接口名 | 说明
|:-------|:-------
|isObjectExist|判断对象(object)是否存在
|isBucketExist|判断存储空间(bucket)是否存在
|getObjectToFile|下载对象到本地文件

### isObjectExist/isBucketExist

这两个接口的返回值为 bool, 如果bool 为 true，表示存在，如果 bool值为 false，表示不存在。当 throw error 时，表示无法从该错误信息判断 是否存在。

```
func isBucketExist(_ bucket: Swift.String) async throws -> Bool
func isObjectExist(_ bucket: Swift.String, _ key: Swift.String, _ versionId: Swift.String? = nil) async throws -> Bool
```

例如 判断对象是否存在

```swift
let client = Client(config)
do {
    print("object existed: \(try await client.isObjectExist("bucket", "key"))")
} catch {
    print("error: \(error)")
}
```

### getObjectToFile

使用GetObject接口，把存储空间的对象下载到本地文件。

```
func getObjectToFile(_ request: GetObjectRequest,  _ file: URL, _ options: OperationOptions? = nil) async throws -> GetObjectResult
```
***注意：getObjectToFile接口，支持macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0以上版本。***

示例

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

## 上传下载接口对比

提供了各种上传下载接口，您可以根据使用场景，选择适合的接口。

**上传接口**
|接口名 | 说明
|:-------|:-------
|client.putObject|简单上传, 最大支持5GiB</br>支持CRC64数据校验(默认启用)</br>支持进度条</br>请求body类型支持Data、File URL、InputStream，当类型为Data、File URL时，具备失败重传
|分片上传接口</br>client.initiateMultipartUpload</br>client.uploadPart</br>client.completeMultipartUpload|分片上传，单个分片最大5GiB，文件最大48.8TiB</br>uploadPart接口支持CRC64校验(默认启用)</br>uploadPart接口支持进度条</br>uploadPart请求body类型支持Data、File URL、InputStream，当类型为Data、File URL时，具备失败重传
|client.appendObject|追加上传, 最终文件最大支持5GiB</br>支持CRC64数据校验(默认启用)</br>支持进度条</br>请求body类型支持Data、File URL、InputStream，当类型为Data、File URL时，具备失败重传(该接口为非幂等接口，重传时可能出现失败)

**下载接口**
|接口名| 说明
|:-------|:-------
|client.getObject|下载文件到内存, 响应体为ByteStream类型</br>支持CRC64校验(默认启用)</br>支持进度条</br>支持失败重连
|client.getObjectToFile|下载到本地文件</br>单连接下载</br>支持CRC64数据校验(默认启用)</br>支持进度条</br>支持失败重连


# 场景示例

本部分将从使用场景出发, 介绍如何使用SDK。

包含的主题
* [设置进度条](#设置进度条)
* [数据校验](#数据校验)

## 设置进度条

在对象的上传和下载场景下，您可以设置进度条，用于查看对象的传输状态。

**支持设置进度条的请求参数**
|支持的请求参数| 用法
|:-------|:-------
|PutObjectRequest|PutObjectRequest.progress
|GetObjectRequest|GetObjectRequest.progress
|AppendObjectRequest|AppendObjectRequest.progress
|UploadPartRequest|UploadPartRequest.progress

**ProgressDelegate定义和参数说明**
```swift
public protocol ProgressDelegate: Sendable {
    mutating func onProgress(_ bytesIncrement: Int64, _ totalBytesTransferred: Int64, _ totalBytesExpected: Int64)
}
```
|参数名|类型|说明
|:-------|:-------|:-------
|bytesIncrement|Int64|本次回调传输的数据大小,单位字节
|totalBytesTransferred|Int64|已传输的数据大小，单位为字节
|totalBytesExpected|Int64|本次请求的数据大小，单位为字节，如果为 -1，表示获无法获取总大小


示例

1. 上传时，设置进度条，以PutObject 为例

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

2. 下载时，设置进度条，以GetObjectToFile为例
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

## 数据校验

OSS提供基于MD5和CRC64的数据校验，确保请求的过程中的数据完整性。

## MD5校验

当向OSS发送请求时，如果设置了Content-MD5，OSS会根据接收的内容计算MD5。当OSS计算的MD5值和上传提供的MD5值不一致时，则返回InvalidDigest异常，从而保证数据的完整性。

基础接口里，除了 PutObject, AppendObject, UploadPart 接口外，会自动计算MD5, 并设置Content-MD5, 保证请求的完整性。

如果您需要在 PutObject, AppendObject, UploadPart 接口里使用MD5校验，可以参考以下写法

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

## CRC64校验

上传对象时，默认开启CRC64数据校验，以确保数据的完整性，例如 PutObject, AppendObject, UploadPart 等接口。

下载对象时，默认开启CRC64数据校验，以确保数据的完整性，例如 GetObject 和 GetObjectToFile 接口。

如果您需要关闭CRC64校验，通过Configuration.withDisableDownloadCRC64Check 和 Configuration.withDisableUploadCRC64Check 配置，例如
```swift
let config = Configuration.default()
    .withRegion(region)
    .withCredentialsProvider(EnvironmentCredentialsProvider())
    .withUploadCRC64Validation(false)
    .withDownloadCRC64Validation(false)

let client = Client(config)
```


# 迁移指南

本部分介绍如何从V1 版本([aliyun-oss-ios-sdk](https://github.com/aliyun/aliyun-oss-ios-sdk)) 迁移到 V2 版本。

## 最低 iOS/Mac 版本

V2 版本 要求 版本最低为 iOS_13.0/macOS_10.15。

## 导入路径

V2 版本使用新的代码仓库，同时也对代码结构进行了调整，按照功能模块组织，以下是这些模块路径和说明：

|模块路径 | 说明 
|:-------|:-------
|github.com/aliyun/alibabacloud-oss-swift-sdk-v2/OSS|SDK核心，接口 和 高级接口实现
|github.com/aliyun/alibabacloud-oss-swift-sdk-v2/OSSExtension|SDK扩展, Bucket管控类接口

示例 

```swift
// v1 
import AliyunOSSiOS
```

```swift
// v2 
import AlibabaCloudOSS
// 根据需要，导入 AlibabaCloudOSSExtension
// import AlibabaCloudOSSExtension
```

## 配置加载

V2 版本简化了配置设置方式，全部迁移到 [Configuration](./Sources/OSS/Configuration.swift) 下，并提供了以with为前缀的辅助函数，方便以编程方式覆盖缺省配置。

V2 默认使用 V4签名，所以必须配置区域（Region）。

V2 支持从区域（Region）信息构造 访问域名(Endpoint), 当访问的是公有云时，可以不设置Endpoint。

示例

```swift
// v1
import AliyunOSSiOS
...

// 静态访问凭证
let provider = OSSStsTokenCredentialProvider(accessKeyId: "ak",
                                             secretKeyId: "sk",
                                             securityToken: "token")
let config = OSSClientConfiguration()
// 设置超时时间60秒
config.timeoutIntervalForRequest = 60
// 使用v4签名
config.signVersion = .V4

let client = OSSClient(endpoint: "https://oss-cn-hangzhou.aliyuncs.com",
                       credentialProvider: provider,
                       clientConfiguration: config)
// 设置region
client.region = "cn-hangzhou"
```

```swift
// v2
import AlibabaCloudOSS
...
// 静态访问凭证
let provider = StaticCredentialsProvider(accessKeyId: "ak",
                                         accessKeySecret: "sk",
                                         securityToken: "token")
let config = Configuration.default()
    .withRegion("cn-hangzhou") // 设置region
    .withCredentialsProvider(provider)
    .withTimeoutIntervalForRequest(60) // 设置超时时间60秒
let client = Client(config)
```

## 远程签名

V2 版本 移除了OSSCustomSignerCredentialProvider，增加了远程签名。

示例

```swift
// v1
let provider = OSSCustomSignerCredentialProvider { content, _ in
    // 传输content，并获取签名
    let signature = ...
    return signature
}
let config = OSSClientConfiguration()
// OSSCustomSignerCredentialProvider仅支持v1版本的签名
config.signVersion = .V1

let client = OSSClient(endpoint: "https://oss-cn-hangzhou.aliyuncs.com",
                       credentialProvider: provider,
                       clientConfiguration: config)
```

```swift
// v2
struct SignatureDelegateImp: SignatureDelegate {
    func signature(info: [String : String]) async throws -> [String : String] {
        // 签名版本
        let version = info["version"]
        // 请求method
        let method = info["method"]
        let bucket = info["bucket"]
        let key = info["key"]
        // 待签名字符串
        let stringToSign = info["stringToSign"]
        // 请求时间
        let date = info["date"]
        // 签名使用的accessKeyId
        let accessKeyId = info["accessKeyId"]
        // v4签名时会额外返回region及product
        let region = info["region"]
        let product = info["product"]

        // 将参数传输到服务端，获取签名
        let signature = await ...
        
        return [
            "signature": signature,
        ]
    }
}

let provider = ClosureCredentialsProvider {
    // 返回带有真实accessKeyId值的Credentials
    // accessKeySecret为占位符，如`fake-sk`
    Credentials(accessKeyId: "ak", accessKeySecret: "fake-sk")
}
let config = Configuration.default()
    .withRegion("cn-hangzhou")
    .withCredentialsProvider(provider)
    .withSigner(RemoteSignerV4(delegate: SignatureDelegateImp()))
    // v1签名时使用RemoteSignerV1
    // .withSigner(RemoteSignerV1(delegate: SignatureDelegateImp()))
let client = Client(config)
```

## 创建Client

V2 版本 把 OSSClient 改名为 Client， 同时 创建函数 不在支持传入endpoint 以及 credentialProvider 参数。

示例

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

## 调用API操作

基础 API 接口 都 合并为 单一操作方法 '\<OperationName\>'，操作的请求参数为 '\<OperationName\>Request'，操作的返回值为 '\<OperationName\>Result'。这些操作方法都 迁移到 Client下。如下格式：

```swift
func <OperationName>(_ request: <OperationName>Request, _ options: OperationOptions? = nil) async throws -> <OperationName>Result
```

关于API接口的详细使用说明，请参考[基础接口](#基础接口)。

示例

```swift
// v1
import AliyunOSSiOS

// 静态访问凭证
let provider = OSSStsTokenCredentialProvider(accessKeyId: "ak",
                                             secretKeyId: "sk",
                                             securityToken: "token")
let config = OSSClientConfiguration()
// 使用v4签名
config.signVersion = .V4

let client = OSSClient(endpoint: "https://oss-cn-hangzhou.aliyuncs.com",
                       credentialProvider: provider,
                       clientConfiguration: config)
// 设置region
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

// 静态访问凭证
let provider = StaticCredentialsProvider(accessKeyId: "ak",
                                         accessKeySecret: "sk",
                                         securityToken: "token")
let config = Configuration.default()
    .withRegion("cn-hangzhou") // 设置region
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

## 预签名

V2 版本 把 预签名接口 名字从 SignURL 修改为 Presign，同时把 接口 迁移到 Client 下。接口形式如下：

```swift
func presign(_ request: <OperationName>Request, _ expiration: Foundation.Date? = nil) async throws -> PresignResult
```

对于 request 参数，其类型 与 API 接口中的 '\<OperationName\>Request' 一致。

对于返回结果，除了返回 预签名 URL 外，还返回 HTTP 方法，过期时间 和 被签名的请求头，如下：
```swift
public struct PresignResult: Sendable {

    public var method: String

    public var url: String

    public var expiration: Foundation.Date?

    public var signedHeaders: [Swift.String: Swift.String]?
}
```

关于预签名的详细使用说明，请参考[预签名接口](#预签名接口)。

以 生成下载对象的预签名URL 为例，如何从 V1 迁移到 V2

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
    .withRegion("cn-hangzhou") // 设置region
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