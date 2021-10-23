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
            name: "AdMobUI",
            url: "https://github.com/briannadoubt/AdMobUI.git",
            .upToNextMajor(from: "0.1.0")
        ),
        .package(
            name: "SwiftWebUI",
            url: "https://github.com/SwiftWebUI/SwiftWebUI.git",
            .upToNextMajor(from: "0.3.0")
        )
    ],
    targets: [
        .target(
            name: "FireUI",
            dependencies: [
                .product(
                    name: "AdMobUI",
                    package: "AdMobUI"
                ),
                .product(
                    name: "FirebaseAuth",
                    package: "Firebase",
                    condition: .when(platforms: [.iOS, .macOS, .watchOS, .tvOS])
                ),
                .product(
                    name: "FirebaseFirestoreSwift-Beta",
                    package: "Firebase",
                    condition: .when(platforms: [.iOS, .macOS, .watchOS, .tvOS])
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
                    condition: .when(platforms: [.iOS, .macOS, .tvOS])
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
                ),
                .product(
                    name: "SwiftWebUI",
                    package: "SwiftWebUI",
                    condition: .when(platforms: [.wasi])
                )
            ]
        )
//        .testTarget(
//            name: "FireUITests",
//            dependencies: [
//                "FireUI",
//                .product(
//                    name: "FirebaseAuth",
//                    package: "Firebase"
//                ),
//            ]
//        ),
    ]
)
