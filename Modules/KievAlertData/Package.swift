// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "KievAlertData",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "KievAlertData", targets: ["KievAlertData"])
    ],
    dependencies: [
        .package(path: "../KievAlertDomain")
    ],
    targets: [
        .target(
            name: "KievAlertData",
            dependencies: ["KievAlertDomain"]
        ),
        .testTarget(
            name: "KievAlertDataTests",
            dependencies: ["KievAlertData", "KievAlertDomain"]
        )
    ]
)

