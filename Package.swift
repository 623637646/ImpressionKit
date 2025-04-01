// swift-tools-version:5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ImpressionKit",
    platforms: [.iOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ImpressionKit",
            targets: ["ImpressionKit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/623637646/SwiftHook.git", "3.5.3"..<"4.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        
        // Source Code
        .target(
            name: "ImpressionKit",
            dependencies: [.product(name: "SwiftHook", package: "SwiftHook")],
            path: "ImpressionKit",
            exclude: ["ImpressionKit.h", "Info.plist"]),
    ]
)
