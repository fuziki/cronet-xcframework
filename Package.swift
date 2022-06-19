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
            url: "https://github.com/fuziki/cronet-xcframework/releases/download/104.0.8-5112/Cronet.xcframework.zip",
            checksum: "e4d2fbdf8516acce7cde8497e765eae315e990d12da9070a4f4e0e1bd045ded9")
    ]
)
