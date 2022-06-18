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
            url: "https://github.com/fuziki/Cronet.xcframework/releases/download/103.0.53-5060/Cronet.xcframework.zip",
            checksum: "92b3492975a0bde3c52b0e24aefcc57ec9dc871d4b660f1c0c59b57eb253a79a")
    ]
)
