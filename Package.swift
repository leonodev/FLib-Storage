// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FLibStorage",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FLibStorage",
            targets: ["FLibStorage"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/leonodev/FLib-Utils.git", .upToNextMajor(from: "1.0.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "FLibStorage",
            dependencies: [
                // Modules FHK
                .product(name: "FLibUtils", package: "FLib-Utils")
            ]
        ),
        .testTarget(
            name: "FLibStorageTests",
            dependencies: ["FLibStorage"]
        ),
    ]
)
