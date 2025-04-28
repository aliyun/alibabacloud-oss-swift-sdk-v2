# Alibaba Cloud OSS SDK for Swift v2

[![GitHub version](https://badge.fury.io/gh/aliyun%2Falibabacloud-oss-swift-sdk-v2.svg)](https://badge.fury.io/gh/aliyun%2Falibabacloud-oss-swift-sdk-v2)

alibabacloud-oss-swift-sdk-v2 is the Developer Preview for the v2 of the OSS SDK for the Swift programming language

## [简体中文](README-CN.md)

## About
> - This Swift SDK is based on the official APIs of [Alibaba Cloud OSS](http://www.aliyun.com/product/oss/).
> - Alibaba Cloud Object Storage Service (OSS) is a cloud storage service provided by Alibaba Cloud, featuring massive capacity, security, a low cost, and high reliability.
> - The OSS can store any type of files and therefore applies to various websites, development enterprises and developers.
> - With this SDK, you can upload, download and manage data on any app anytime and anywhere conveniently.

## Running Environment
 - Applicable to`Swift 5.9`or above
 - Platform: iOS, macOS, visionOS, watchOS, tvOS, Linux, Windows
 
## Installing
### Install the sdk through Swift Package Manager
This SDK uses the Swift Package Manager to manage its code dependencies. To use it in your codebase, add a dependency to the package in your own Package.swift dependencies.
```swift
dependencies: [
    .package(url: "https://github.com/aliyun/alibabacloud-oss-swift-sdk-v2.git", from: "0.1.0-beta")
]
```
Then add target dependencies you want to use.
```swift
targets: [
    .target(name: "YourTarget", dependencies: [
        .product(name: "AlibabaCloudOSS", package: "alibabacloud-oss-swift-sdk-v2"),
        //.product(name: "AlibabaCloudOSSExtension", package: "alibabacloud-oss-swift-sdk-v2"),
    ]),
]
```
> **Note:**
> </br>`AlibabaCloudOSS` provides bucket basic api, all object api, and high-level api (such as paginator, presinger).
> </br>`AlibabaCloudOSSExtension` provides other bucket control apis, such as BucketCors.

### Install the sdk through Swift Package Manager in Xcode
- First, create or open an existing project in Xcode, then select `Project`-`Package Dependencies` and click on it`+`
- Search `https://github.com/aliyun/alibabacloud-oss-swift-sdk-v2.git`, find `alibabacloud-oss-swift-sdk-v2` in the search results, click on `Add Package`

## Getting Started
#### List Buckets
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

#### Put Bucket
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

#### Delete Bucket
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

#### List Objects
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

#### Put Object
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

#### Get Object
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

#### Get Object to local file
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

#### Delete Object
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

##  Complete Example
More example projects can be found in the `Sample` folder

### Running Example
> - Go to the sample code folder `Sample`。
> - Configure credentials values from the environment variables, like `export OSS_ACCESS_KEY_ID="your access key id"`, `export OSS_ACCESS_KEY_SECRET="your access key secrect"`
> - Take ListBuckets as an example，run `swift run ListBuckets --region cn-hangzhou` command。

## License
> - Apache-2.0, see [license file](LICENSE)
