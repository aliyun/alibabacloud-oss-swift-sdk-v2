// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let targets = ["AbortMultipartUpload", "AppendObject",
               "CompleteMultipartUpload", "CopyObject",
               "DeleteBucket", "DeleteMultipleObjects", "DeleteObject", "DeleteObjectTagging", "DescribeRegions",
               "GetBucketAcl", "GetBucketInfo", "GetBucketLocation", "GetBucketStat", "GetBucketVersioning", "GetObject", "GetObjectACL", "GetObjectMeta", "GetObjectTagging", "GetObjectToFile", "GetSymlink",
               "HeadObject",
               "InitiateMultipartUpload", "IsBucketExist", "IsObjectExist",
               "ListBuckets", "ListMultipartUploads", "ListObjects", "ListObjectsV2", "ListObjectVersions", "ListParts",
               "PutBucket", "PutBucketAcl", "PutBucketVersioning", "PutObject", "PutObjectACL", "PutObjectTagging", "PutSymlink",
               "RestoreObject",
               "UploadPart", "UploadPartCopy"]

let package = Package(
    name: "alibabacloud-oss-samples",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(
            url: "https://github.com/apple/swift-argument-parser.git",
            from: "1.5.0"
        ),
        .package(
            name: "alibabacloud-oss-swift-sdk-v2",
            path: "../"
        ),
    ],
    targets: targets.map {
        .executableTarget(
            name: $0,
            dependencies: [
                .product(name: "AlibabaCloudOSS", package: "alibabacloud-oss-swift-sdk-v2"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "./Sources/\($0)/"
        )
    }
)
