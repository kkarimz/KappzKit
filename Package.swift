// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "KappzKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "KappzKit",
            targets: ["KappzKit"]
        ),
    ],
    targets: [
        .target(
            name: "KappzKit",
            dependencies: []
        ),
        .testTarget(
            name: "KappzKitTests",
            dependencies: ["KappzKit"]
        ),
    ]
)
