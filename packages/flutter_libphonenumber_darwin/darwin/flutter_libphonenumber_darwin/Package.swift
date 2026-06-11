// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "flutter_libphonenumber_darwin",
    platforms: [
        .iOS("13.0"),
        .macOS("10.15")
    ],
    products: [
        .library(name: "flutter-libphonenumber-darwin", targets: ["flutter_libphonenumber_darwin"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(url: "https://github.com/marmelroy/PhoneNumberKit", exact: "4.2.1")
    ],
    targets: [
        .target(
            name: "flutter_libphonenumber_darwin",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "PhoneNumberKit", package: "PhoneNumberKit")
            ],
            resources: [
                .process("PrivacyInfo.xcprivacy")
            ]
        )
    ]
)
