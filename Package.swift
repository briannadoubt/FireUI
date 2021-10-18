//  swift-tools-version:5.5
//
//  Package.swift
//  FireUI
//
//  Created by Brianna Doubt on 10/15/21.
//

import PackageDescription

let package = Package(
    name: "FireUI",
    platforms: [.iOS(.v14), .macOS(.v11)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "FireUI",
            targets: ["FireUI"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(
            name: "Firebase",
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            .upToNextMajor(from: "8.0.0")
        ),
        .package(
            name: "SwiftWebUI",
            url: "https://github.com/SwiftWebUI/SwiftWebUI.git",
            .upToNextMajor(from: "0.3.0")
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "FireUI",
            dependencies: [
                .product(
                    name: "FirebaseAuth",
                    package: "Firebase"
                ),
                .product(
                    name: "FirebaseFirestoreSwift-Beta",
                    package: "Firebase"
                ),
                .product(
                    name: "SwiftWebUI",
                    package: "SwiftWebUI", condition: TargetDependencyCondition.when(platforms: [.wasi])
                ),
            ]
        ),
        .testTarget(
            name: "FireUITests",
            dependencies: [
                "FireUI",
                .product(
                    name: "FirebaseAuth",
                    package: "Firebase"
                ),
            ]
        ),
    ]
)
