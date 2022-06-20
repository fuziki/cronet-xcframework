// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Cronet",
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
            url: "https://github.com/fuziki/cronet-xcframework/releases/download/104.0.5112-8/Cronet.xcframework.zip",
            checksum: "44ee3c1e667cf8ae7055b05c00ad7d928297d77dfbcfb8880d6636d8b940b3d5")
    ]
)
