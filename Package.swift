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
    platforms: [.iOS(.v14), .macOS(.v11), .watchOS(.v7), .tvOS(.v14)],
    products: [
        .library(
            name: "FireUI",
            targets: ["FireUI"]
        )
    ],
    dependencies: [
        .package(
            name: "Firebase",
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            .upToNextMajor(from: "8.9.1")
        )
    ],
    targets: [
        .target(
            name: "FireUI",
            dependencies: [
                .product(
                    name: "FirebaseAuth",
                    package: "Firebase",
                    condition: .when(platforms: [.iOS, .macOS, .watchOS, .tvOS])
                ),
                .product(
                    name: "FirebaseFirestoreSwift-Beta",
                    package: "Firebase",
                    condition: .when(platforms: [.iOS, .macOS, .tvOS])
                ),
                .product(
                    name: "FirebaseAnalytics",
                    package: "Firebase",
                    condition: .when(platforms: [.iOS, .macOS, .tvOS])
                ),
                .product(
                    name: "FirebasePerformance",
                    package: "Firebase",
                    condition: .when(platforms: [.iOS, .macOS, .watchOS, .tvOS])
                ),
                .product(
                    name: "FirebaseAppCheck",
                    package: "Firebase",
                    condition: .when(platforms: [.iOS, .macOS, .watchOS, .tvOS])
                ),
                .product(
                    name: "FirebaseStorage",
                    package: "Firebase",
                    condition: .when(platforms: [.iOS, .macOS, .watchOS, .tvOS])
                ),
                .product(
                    name: "FirebaseCrashlytics",
                    package: "Firebase",
                    condition: .when(platforms: [.iOS, .macOS, .watchOS, .tvOS])
                )
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
