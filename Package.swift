//  swift-tools-version:5.4
//
//  Package.swift
//  FireUI
//
//  Created by Brianna Doubt on 10/15/21.
//

import PackageDescription

let package = Package(
    name: "FireUI",
    platforms: [.iOS(.v15), .macOS(.v11)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "FireUI",
            targets: ["FireUI"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(
            name: "Tokamak",
            url: "https://github.com/TokamakUI/Tokamak.git",
            .upToNextMajor(from: "0.0.0")
        ),
        .package(
            name: "Firebase",
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            .upToNextMajor(from: "8.0.0")
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "FireUI",
            dependencies: [
                .product(
                    name: "FirebaseAnalyticsSwift-Beta",
                    package: "Firebase",
                    condition: .when(
                        platforms: [.iOS]
                    )
                ),
                .product(
                    name: "FirebaseAppCheck",
                    package: "Firebase",
                    condition: .when(
                        platforms: [.iOS, .macOS]
                    )
                ),
                .product(
                    name: "FirebaseAppDistribution-Beta",
                    package: "Firebase",
                    condition: .when(
                        platforms: [.iOS, .macOS]
                    )
                ),
                .product(
                    name: "FirebaseAuth",
                    package: "Firebase",
                    condition: .when(
                        platforms: [.iOS, .macOS]
                    )
                ),
                .product(
                    name: "FirebaseFirestoreSwift-Beta",
                    package: "Firebase",
                    condition: .when(
                        platforms: [.iOS, .macOS]
                    )
                ),
                .product(
                    name: "FirebaseInstallations",
                    package: "Firebase",
                    condition: .when(
                        platforms: [.iOS, .macOS]
                    )
                ),
                .product(
                    name: "FirebasePerformance",
                    package: "Firebase",
                    condition: .when(
                        platforms: [.iOS, .macOS]
                    )
                )
            ]
        ),
        .testTarget(
            name: "FireUITests",
            dependencies: [
                "FireUI",
                .product(
                    name: "FirebaseAuth",
                    package: "Firebase",
                    condition: .when(
                        platforms: [.iOS, .macOS]
                    )
                ),
            ]
        ),
    ]
)
