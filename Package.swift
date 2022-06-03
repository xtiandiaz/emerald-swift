// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Emerald",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "Emerald",
            targets: ["Emerald"]),
    ],
    dependencies: [
        .package(name: "Beryllium", path: "Beryllium")
    ],
    targets: [
        .target(
            name: "Emerald",
            dependencies: ["Beryllium"],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "EmeraldTests",
            dependencies: ["Emerald"]),
    ]
)
