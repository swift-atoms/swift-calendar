// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-calendar",
    platforms: [.macOS(.v27), .iOS(.v27), .tvOS(.v27), .watchOS(.v27), .visionOS(.v27)],
    products: [
        .library(name: "Calendar", targets: ["Calendar"]),

        .library(name: "Calendar Foundation Integration", targets: ["Calendar Foundation Integration"]),
        .library(name: "Calendar Test Support", targets: ["Calendar Test Support"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-coordinate.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-polarity.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-magnitude.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-cardinal.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-time.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-difference.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-tagged.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-optic.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-either.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Calendar",
            dependencies: [
                .product(name: "Coordinate", package: "swift-coordinate"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Magnitude", package: "swift-magnitude"),
                .product(name: "Polarity", package: "swift-polarity"),
                .product(name: "Time", package: "swift-time"),
                .product(name: "Difference", package: "swift-difference"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Optic", package: "swift-optic"),
                .product(name: "Either", package: "swift-either"),
            ],
            path: "Sources/Calendar"
        ),
        
        .target(
            name: "Calendar Foundation Integration",
            dependencies: [
                .target(name: "Calendar"),
            ],
            path: "Sources/Calendar Foundation Integration"
        ),
        .target(
            name: "Calendar Test Support",
            dependencies: [
                .target(name: "Calendar"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Calendar Tests",
            dependencies: [
                .product(name: "Polarity", package: "swift-polarity"),
                .product(name: "Magnitude", package: "swift-magnitude"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .target(name: "Calendar"),
                .product(name: "Time", package: "swift-time"),
                .product(name: "Difference", package: "swift-difference"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Optic", package: "swift-optic"),
                .product(name: "Either", package: "swift-either"),
                .target(name: "Calendar Test Support"),
                .target(name: "Calendar Foundation Integration"),
            ],
            path: "Tests/Calendar Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
