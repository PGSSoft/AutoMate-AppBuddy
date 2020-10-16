// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "AutoMate_AppBuddy",
    platforms: [
        .macOS("10.12"),
        .iOS("9.3"),
        .tvOS("9.2")
    ],
    products: [
        .library(name: "AutoMate_AppBuddy", targets: ["AutoMate_AppBuddy"])
    ],
    targets: [
        .target(
            name: "AutoMate_AppBuddy",
            path: "AutoMate-AppBuddy")
    ]
)
