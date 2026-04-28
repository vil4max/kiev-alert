// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "KievAlertDomain",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "KievAlertDomain", targets: ["KievAlertDomain"])
    ],
    targets: [
        .target(
            name: "KievAlertDomain"
        ),
        .testTarget(
            name: "KievAlertDomainTests",
            dependencies: ["KievAlertDomain"]
        )
    ]
)

