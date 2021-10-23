//
//  FireApp.swift
//  FireUI
//
//  Created by Bri on 10/20/21.
//

#if Web
import SwiftWebUI
#else
import SwiftUI
#endif

#if !AppClip
import Firebase
#if !os(watchOS)
import FirebaseAppCheck
#endif
#endif

#if !AppClip && os(iOS)
import GoogleMobileAds
import StoreKit
#endif

public protocol FireState: ObservableObject {
    var appName: String { get }
    var selectedViewIdentifier: String? { get set }
    var appStyle: FireAppStyle { get }
    init()
}
