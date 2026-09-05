// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-calendar",
    platforms: [.macOS(.v27), .iOS(.v27), .tvOS(.v27), .watchOS(.v27), .visionOS(.v27)],
    products: [
        .library(name: "Calendar", targets: ["Calendar"]),
    ],
    dependencies: [
        .package(path: "../swift-time"),
    ],
    targets: [
        .target(name: "Calendar", dependencies: [.product(name: "Time", package: "swift-time")]),
        .testTarget(name: "Calendar Tests", dependencies: [.target(name: "Calendar"), .product(name: "Time", package: "swift-time")]),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
