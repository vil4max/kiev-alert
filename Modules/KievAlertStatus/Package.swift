// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "KievAlertStatus",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "KievAlertStatus", targets: ["KievAlertStatus"])
    ],
    dependencies: [
        .package(path: "../KievAlertDomain")
    ],
    targets: [
        .target(
            name: "KievAlertStatus",
            dependencies: ["KievAlertDomain"]
        ),
        .testTarget(
            name: "KievAlertStatusTests",
            dependencies: ["KievAlertStatus", "KievAlertDomain"]
        )
    ]
)

