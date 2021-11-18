//
//  DemoApp.swift
//  Shared
//
//  Created by Bri on 10/23/21.
//

import FireUI
import SwiftUI

@main
struct DemoApp: App {
    
    var body: some Scene {
        FireScene(stateType: MyAppState.self, newPerson: DemoPerson.new) {
            ContentView()
        } logo: {
            Image("logo")
                .resizable()
                .foregroundColor(Color("AccentColor"))
        } settings: {
            SettingsView()
        } footer: {
            // The footer is displayed at the bottom of the AuthenticationView and the SettingsView
            // Delete this
            Text("Proudly built with FireUI 🔥")
        }
    }
}
