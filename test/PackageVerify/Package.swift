// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "PackageVerify",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    dependencies: [
        .package(
            url: "https://github.com/aliyun/alibabacloud-oss-swift-sdk-v2.git",
            from: "0.3.0"
        ),
    ],
    targets: [
        .executableTarget(
            name: "PackageVerify",
            dependencies: [
                .product(name: "AlibabaCloudOSS", package: "alibabacloud-oss-swift-sdk-v2"),
                .product(name: "AlibabaCloudOSSExtension", package: "alibabacloud-oss-swift-sdk-v2"),
            ]
        )
    ]
)
