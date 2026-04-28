// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "KievAlertMap",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "KievAlertMap", targets: ["KievAlertMap"])
    ],
    dependencies: [
        .package(path: "../KievAlertDomain")
    ],
    targets: [
        .target(
            name: "KievAlertMap",
            dependencies: ["KievAlertDomain"],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "KievAlertMapTests",
            dependencies: ["KievAlertMap", "KievAlertDomain"]
        )
    ]
)

