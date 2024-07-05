// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SteamKit",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v8),
    ],
    products: [
        .library(
            name: "SteamKit",
            targets: ["SteamKit"]
        ),
        .executable(
            name: "SteamKitCLI",
            targets: ["SteamKitCLI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0")
    ],
    targets: [
        .target(
            name: "SteamKit",
            dependencies: []
        ),
        .executableTarget(
            name: "SteamKitCLI",
            dependencies: [
                "SteamKit",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            sources: ["SteamKitCLI.swift"]
        ),
        .testTarget(
            name: "SteamKitTests",
            dependencies: ["SteamKit"]
        ),
    ]
)
