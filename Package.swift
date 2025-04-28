// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableExperimentalFeature("StrictConcurrency=complete")
]

let package = Package(
    name: "alibabacloud-oss-swift-sdk-v2",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "AlibabaCloudOSS", targets: ["AlibabaCloudOSS"]),
        .library(name: "AlibabaCloudOSSExtension", targets: ["AlibabaCloudOSSExtension"])
    ],
    dependencies: [
         .package(url: "https://github.com/apple/swift-atomics.git", from: "1.1.0"),
         .package(url: "https://github.com/apple/swift-crypto.git", "1.0.0"..<"4.0.0"),
         .package(url: "https://github.com/CoreOffice/XMLCoder.git", from: "0.17.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AlibabaCloudOSS",
            dependencies: [
                .product(name: "Crypto", package: "swift-crypto")
            ],
            path: "Sources/OSS",
            resources: [.process("Resource")],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "AlibabaCloudOSSExtension",
            dependencies: [
                "AlibabaCloudOSS",
                .product(name: "XMLCoder", package: "XMLCoder")
            ],
            path: "Sources/OSSExtension",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "AlibabaCloudOSSUnitTests",
            dependencies: [
                "AlibabaCloudOSS",
                .product(name: "Atomics", package: "swift-atomics")
            ],
            path: "Tests/OSSUnitTests"
        ),
        .testTarget(
            name: "AlibabaCloudOSSExtensionUnitTests",
            dependencies: ["AlibabaCloudOSSExtension"],
            path: "Tests/OSSExtensionUnitTests"
        ),
        .testTarget(
            name: "AlibabaCloudOSSIntegrationTests",
            dependencies: [
                "AlibabaCloudOSS",
                "AlibabaCloudOSSExtension",
            ],
            path: "Tests/OSSIntegrationTests",
            resources: [.copy("Resource/example.jpeg"),
                        .copy("Resource/train.csv"),
                        .copy("Resource/private_key.pem"),
                        .copy("Resource/public_key.der")]
        ),
        .testTarget(
            name: "AlibabaCloudOSSExtensionIntegrationTests",
            dependencies: [
                "AlibabaCloudOSS",
                "AlibabaCloudOSSExtension",
            ],
            path: "Tests/OSSExtensionIntegrationTests",
            resources: []
        )
    ]
)


