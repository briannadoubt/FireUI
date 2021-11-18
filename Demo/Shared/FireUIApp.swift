//
//  FireUIApp.swift
//  Shared
//
//  Created by Bri on 10/23/21.
//

import FireUI
import SwiftUI

@main
struct FireUIApp: App {
    
    var body: some Scene {
        // Wrap FireScene around ContentView
        FireScene(stateType: FireUIAppState.self, newPerson: Human.new) {
            // This is your run of the mill ContentView
            ContentView()
        } logo: {
            // The logo image is displayed on the AuthenticationView, the SettingsView, and at the top of the Sidebar on macOS.
            // By default this template has loaded an image named "logo" in the Assets catelog and references it below.
            // To omit a logo, delete this parameter.
            Image("logo")
                .resizable()
                .foregroundColor(Color("AccentColor"))
        } settings: {
            // TODO: Make SettingsView customizable
            SettingsView()
        } footer: {
            // The footer is displayed at the bottom of the AuthenticationView and the SettingsView.
            // Delete this parameter to remove the footer from your app.
            Text("Proudly built with FireUI 🔥")
        }
    }
}
