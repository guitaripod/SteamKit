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
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SteamKit",
            dependencies: []),
        .testTarget(
            name: "SteamKitTests",
            dependencies: ["SteamKit"]
        ),
    ]
)
