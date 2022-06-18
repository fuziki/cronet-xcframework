// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Cronet.xcframework",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Cronet",
            targets: ["Cronet"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .binaryTarget(
            name: "Cronet",
            url: "https://github.com/fuziki/Cronet.xcframework/releases/download/105.0.0-5126/Cronet.xcframework.zip",
            checksum: "5d06a9b7275d12ff82bc4df2c566566d2650cf1eb829830fd068284599675bfa"),
    ]
)
