# cronet-xcframework

![Platform](https://img.shields.io/badge/platform-ios-lightgray.svg)
![Language](https://img.shields.io/badge/language-Swift%205.6-orange.svg)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

cronet-xcframework is xcframework wrapper for [Cronet](https://chromium.googlesource.com/chromium/src/+/master/components/cronet).  
Supports installation via Swift Package Manager.  
  
Cronet is the networking stack of Chromium put into a library for use on mobile.  
This is the same networking stack that is used in the Chrome browser by over a billion people.  
It offers an easy-to-use, high performance, standards-compliant, and secure way to perform HTTP requests.  
[https://chromium.googlesource.com/chromium/src/+/master/components/cronet](https://chromium.googlesource.com/chromium/src/+/master/components/cronet)

> **Warning**  
> Cronet is not support bitcode.

# Installation
Add cronet-xcframework to a Package.swift manifest.

```swift
let package = Package(
    // ...
    dependencies: [
        .package(url: "https://github.com/fuziki/cronet-xcframework", exact: "103.0.53-5060"),
    ],
    targets: [
        .target(
            name: "MyLibrary",
            dependencies: [
                .product(name: "Cronet", package: "cronet-xcframework")
            ]),
    ]
)
```

# Usage
## Setup

```swift
Cronet.setQuicEnabled(true)

Cronet.start()

Cronet.registerHttpProtocolHandler() // setup for URLSession.shared
// ↑ or ↓
let configuration = URLSessionConfiguration.default
Cronet.install(into: configuration)
```

See Cronet.h↓ for more opsions.  
[https://chromium.googlesource.com/chromium/src/+/master/components/cronet/ios/Cronet.h](https://chromium.googlesource.com/chromium/src/+/master/components/cronet/ios/Cronet.h)

## Request

```swift
let session = URLSession.shared
// ↑ or ↓
let session = URLSession(configuration: configuration)

let response: (Data, URLResponse) = try await session.data(from: url)
```




