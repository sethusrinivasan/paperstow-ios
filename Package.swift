// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "Paperstow",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(name: "PaperstowCore", targets: ["PaperstowCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-crypto.git", from: "3.10.0"),
    ],
    targets: [
        .target(
            name: "PaperstowCore",
            dependencies: [
                .product(name: "Crypto", package: "swift-crypto"),
            ]
        ),
        .testTarget(
            name: "PaperstowCoreTests",
            dependencies: ["PaperstowCore"]
        ),
    ]
)
