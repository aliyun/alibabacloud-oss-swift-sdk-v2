# Alibaba Cloud OSS SDK for Swift v2

[![GitHub version](https://badge.fury.io/gh/aliyun%2Falibabacloud-oss-swift-sdk-v2.svg)](https://badge.fury.io/gh/aliyun%2Falibabacloud-oss-swift-sdk-v2)

alibabacloud-oss-swift-sdk-v2 是OSS在swift编译语言下的第二版SDK

## [English](README.md)

## 关于
> - 此Swift SDK基于[阿里云对象存储服务](http://www.aliyun.com/product/oss/)官方API构建。
> - 阿里云对象存储（Object Storage Service，简称OSS），是阿里云对外提供的海量，安全，低成本，高可靠的云存储服务。
> - OSS适合存放任意文件类型，适合各种网站、开发企业及开发者使用。
> - 使用此SDK，用户可以方便地在任何应用、任何时间、任何地点上传，下载和管理数据。

## 运行环境
 - 适用于`Swift 5.9`及以上版本
 - 支持平台: iOS, macOS, visionOS, watchOS, tvOS, Linux, Windows
 
## 安装方法
### 通过 Swift Package Manager 安装
该SDK采用 Swift 包管理器来管理其代码依赖项. 如要在您的代码库中使用，请在您自己的 Package.swift 依赖项中添加对包的依赖项。
```swift
dependencies: [
    .package(url: "https://github.com/aliyun/alibabacloud-oss-swift-sdk-v2.git", , from: "0.1.0-beta")
]
```
然后在您的目标中添加目标依赖项。
```swift
targets: [
    .target(name: "YourTarget", dependencies: [
        .product(name: "AlibabaCloudOSS", package: "alibabacloud-oss-swift-sdk-v2"),
        //.product(name: "AlibabaCloudOSSExtension", package: "alibabacloud-oss-swift-sdk-v2"),
    ]),
]
```
> **说明:**
> </br>`AlibabaCloudOSS` 提供了bucket基础接口、对象类接口 和 高级接口（例如 分页器、预签名）。
> </br>`AlibabaCloudOSSExtension` 包含除bucket基础接口以外的配置类接口, 例如 跨域资源共享接口。

### 在Xcode中通过 Swift Package Manager 安装
- 先在`Xcode`中新建或者打开已有的项目，然后选择`Project`－`Package Dependencies`，点击`+`
- 搜索`https://github.com/aliyun/alibabacloud-oss-swift-sdk-v2.git`，点击`Add Package`

## 快速使用
#### 获取存储空间列表（List Buckets）
```swift
import AlibabaCloudOSS

func main() async throws {
    let region = "cn-hangzhou"

    // Using the SDK's default configuration
    // loading credentials values from the environment variables
    let config = Configuration.default()
        .withCredentialsProvider(EnvironmentCredentialsProvider())
        .withRegion(region)
    let client = Client(config)

    // Create the Paginator for the ListBuckets operation.
    // Iterate through the bucket pages
    for try await result in client.listBucketsPaginator(ListBucketsRequest()) {
        if let buckets = result.buckets {
            for bucket in buckets {
                print("Bucket: \(bucket)")
            }
        }
    }
}
```

#### 创建存储空间（Put Bucket）
```swift
import AlibabaCloudOSS

func main() async throws {
    let region = "cn-hangzhou"
    let bucket = "your bucket name"
            
    // Using the SDK's default configuration
    // loading credentials values from the environment variables
    let config = Configuration.default()
        .withCredentialsProvider(EnvironmentCredentialsProvider())
        .withRegion(region)
    let client = Client(config)

    let result = try await client.putBucket(
        PutBucketRequest(
            bucket: bucket
        )
    )
    print("PutObject done, StatusCode:\(result.statusCode), RequestId:\(result.requestId).")
}
```

#### 删除存储空间（Delete Bucket）
```swift
import AlibabaCloudOSS

func main() async throws {
    let region = "cn-hangzhou"
    let bucket = "your bucket name"
            
    // Using the SDK's default configuration
    // loading credentials values from the environment variables
    let config = Configuration.default()
        .withCredentialsProvider(EnvironmentCredentialsProvider())
        .withRegion(region)
    let client = Client(config)

    let result = try await client.deleteBucket(
        DeleteBucketRequest(
            bucket: bucket
        )
    )
    print("PutObject done, StatusCode:\(result.statusCode), RequestId:\(result.requestId).")
}
```

#### 获取文件列表（List Objects）
```swift
import AlibabaCloudOSS

func main() async throws {
    let region = "cn-hangzhou"
    let bucket = "your bucket name"
            
    // Using the SDK's default configuration
    // loading credentials values from the environment variables
    let config = Configuration.default()
        .withCredentialsProvider(EnvironmentCredentialsProvider())
        .withRegion(region)
    let client = Client(config)

    // Create the Paginator for the ListObjectsV2 operation.
    // Lists all objects in a bucket
    for try await result in client.listObjectsV2Paginator(ListObjectsV2Request(bucket: bucket)) {
        if let objects = result.contents {
            for object in objects {
                print("object: \(object)")
            }
        }
    }
}
```

#### 上传文件（Put Object）
```swift
import AlibabaCloudOSS

func main() async throws {
    let region = "cn-hangzhou"
    let bucket = "your bucket name"
    let key = "your object name"

    // Using the SDK's default configuration
    // loading credentials values from the environment variables
    let config = Configuration.default()
        .withCredentialsProvider(EnvironmentCredentialsProvider())
        .withRegion(region)
    let client = Client(config)

    let content = "hi oss"
    let result = try await client.putObject(
        PutObjectRequest(
            bucket: bucket,
            key: key,
            body: .data(content.data(using: .utf8)!)
        )
    )
    print("PutObject done, StatusCode:\(result.statusCode), RequestId:\(result.requestId).")
}
```

#### 下载到内存（Get Object）
```swift
import AlibabaCloudOSS

func main() async throws {
    let region = "cn-hangzhou"
    let bucket = "your bucket name"
    let key = "your object name"

    // Using the SDK's default configuration
    // loading credentials values from the environment variables
    let config = Configuration.default()
        .withCredentialsProvider(EnvironmentCredentialsProvider())
        .withRegion(region)
    let client = Client(config)

    // Get data of object to memory
    let result = try await client.getObject(
        GetObjectRequest(
            bucket: bucket,
            key: key
        )
    )
    print("PutObject done, StatusCode:\(result.statusCode), RequestId:\(result.requestId).")
}
```

#### 下载到本地文件
```swift
import AlibabaCloudOSS

func main() async throws {
    let region = "cn-hangzhou"
    let bucket = "your bucket name"
    let key = "your object name"
    let filePath = "download to file path"
            
    // Using the SDK's default configuration
    // loading credentials values from the environment variables
    let config = Configuration.default()
        .withCredentialsProvider(EnvironmentCredentialsProvider())
        .withRegion(region)
    let client = Client(config)

    // Get data of object to local file
    let result = try await client.getObjectToFile(
        GetObjectRequest(
            bucket: bucket,
            key: key
        ),
        URL(filePath: filePath)
    )
    print("PutObject done, StatusCode:\(result.statusCode), RequestId:\(result.requestId).")
}
```

#### 删除文件(Delete Object)
```swift
import AlibabaCloudOSS

func main() async throws {
    let region = "cn-hangzhou"
    let bucket = "your bucket name"
    let key = "your object name"

    // Using the SDK's default configuration
    // loading credentials values from the environment variables
    let config = Configuration.default()
        .withCredentialsProvider(EnvironmentCredentialsProvider())
        .withRegion(region)
    let client = Client(config)

    let result = try await client.deleteObject(
        DeleteObjectRequest(
            bucket: bucket,
            key: key
        )
    )
    print("PutObject done, StatusCode:\(result.statusCode), RequestId:\(result.requestId).")
}
```
## 更多示例
请参看`Sample`目录

### 运行示例
> - 进入示例程序目录 `Sample`。
> - 通过环境变量，配置访问凭证, `export OSS_ACCESS_KEY_ID="your access key id"`, `export OSS_ACCESS_KEY_SECRET="your access key secrect"`
> - 以 ListBuckets 为例，执行 `swift run ListBuckets --region cn-hangzhou`。

## 许可协议
> - Apache-2.0, 请参阅 [许可文件](LICENSE)
