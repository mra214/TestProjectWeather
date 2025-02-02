// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WeatherCore",
    platforms: [.iOS(.v16), .macOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "WeatherCore",
            targets: ["WeatherCore"]),
    ],
    dependencies: [
        .package(path: "../CoreUI"),
        .package(path: "../WeatherAPI"),
        .package(path: "../WeatherAPIClient"),
        .package(path: "../WeatherRepository")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "WeatherCore",
            dependencies: [
                .product(name: "CoreUI", package: "CoreUI"),
                .product(name: "WeatherAPI", package: "WeatherAPI"),
                .product(name: "WeatherAPIClient", package: "WeatherAPIClient"),
                .product(name: "WeatherRepository", package: "WeatherRepository")
            ]
        ),
        .testTarget(
            name: "WeatherCoreTests",
            dependencies: ["WeatherCore"]
        ),
    ]
)
