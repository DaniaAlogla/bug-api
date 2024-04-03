// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "bug-api",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "bug-api",
            targets: ["bug-api"]),
    ],
    dependencies: [
        .package(name: "Firebase",
                url: "https://github.com/firebase/firebase-ios-sdk.git",
                from: "8.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "bug-api",
            dependencies: [
                .product(name: "FirebaseStorage", package: "Firebase")
            ]),
        .testTarget(
            name: "bug-apiTests",
            dependencies: ["bug-api"]),
    ]
)
