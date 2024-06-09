// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "ImpressionKit",
    platforms: [
        .iOS(.v13),
        .macCatalyst(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v9),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "ImpressionKit",
            targets: ["ImpressionKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/623637646/SwiftHook.git", "3.5.2"..<"4.0.0")
    ],
    targets: [
        .target(
            name: "ImpressionKit",
            dependencies: [.product(name: "SwiftHook", package: "SwiftHook")],
            path: "ImpressionKit",
            exclude: ["ImpressionKit.h", "Info.plist"]
        ),
    ]
)
