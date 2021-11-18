//
//  FireUIDemoApp.swift
//  Shared
//
//  Created by Bri on 10/16/21.
//

import SwiftUI
import FireUI

@main
struct FireUIDemoApp: App {
    var body: some Scene {
        FireScene<ContentView, DemoAppState, DemoPerson> {
            ContentView()
        }
        .activate()
    }
}

class DemoAppState: FireState {
    
    @Published var selectedViewIdentifier: String?
    
    var appName: String = "Demo App"
    
    var appStyle = FireAppStyle(
        iphoneStyle: .tabbed,
        ipadStyle: .sidebar,
        macStyle: .sidebar,
        watchStyle: .paged
    )
    
    var personBasePath: String = "users"
    
    var firebaseEnabled: Bool = false
    
    var storeEnabled: Bool = false
    
    var adsEnabled: Bool = false
    
    var showsWelcomeScreen: Bool = true
    
    var coreDataEnabled: Bool = false
    
    required init() { }
}
