//
//  FireUIApp.swift
//  Shared
//
//  Created by Bri on 10/23/21.
//

import FireUI

@main
struct FireUIApp: App {
    
    @State var selectedViewIdentifier: String? = "items"
    
    var body: some Scene {
        // Wrap FireScene around ContentView
        FireScene(
            selectedViewIdentifier: $selectedViewIdentifier,
            state: FireUIAppState.self,
            product: FireUIProduct.self,
            newPerson: Human.new
        ) {
            // This is your run of the mill ContentView
            ContentView(selectedViewIdentifier: $selectedViewIdentifier)
            
        } logo: {
            // The logo image is displayed on the AuthenticationView, the SettingsView, and at the top of the Sidebar on macOS.
            // By default this template has loaded an image named "logo" in the Assets catelog and references it below.
            // To omit a logo, delete this parameter.
            Image("logo")
                .resizable()
                .foregroundColor(Color("AccentColor"))
            
        } settings: {
            SettingsView(selectedViewIdentifier: $selectedViewIdentifier)
            
        } footer: {
            // The footer is displayed at the bottom of the AuthenticationView and the SettingsView.
            // Delete this parameter to remove the footer from your app.
            Text("Proudly built with FireUI 🔥")
        }
    }
}
