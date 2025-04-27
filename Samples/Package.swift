// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

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
            name: "alibabacloud-oss-v2",
            path: "../"
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        // Service's operations
        .executableTarget(
            name: "ListBuckets",
            dependencies: [
                .product(name: "AlibabaCloudOSS", package: "alibabacloud-oss-v2"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "./Sources/ListBuckets/"
        ),
        // Bucket's operations
        .executableTarget(
            name: "ListObjectsV2",
            dependencies: [
                .product(name: "AlibabaCloudOSS", package: "alibabacloud-oss-v2"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "./Sources/ListObjectsV2/"
        ),        
        .executableTarget(
            name: "GetBucketStat",
            dependencies: [
                .product(name: "AlibabaCloudOSS", package: "alibabacloud-oss-v2"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "./Sources/GetBucketStat/"
        ),
        .executableTarget(
            name: "GetBucketAcl",
            dependencies: [
                .product(name: "AlibabaCloudOSS", package: "alibabacloud-oss-v2"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "./Sources/GetBucketAcl/"
        ),
        // Object's operations
        .executableTarget(
            name: "PutObject",
            dependencies: [
                .product(name: "AlibabaCloudOSS", package: "alibabacloud-oss-v2"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "./Sources/PutObject/"
        ),
    ]
)
