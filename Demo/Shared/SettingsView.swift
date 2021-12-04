//
//  SettingsView.swift
//  FireUI
//
//  Created by Bri on 11/16/21.
//

import FireUI
import SwiftUI

struct SettingsView: View {
    
    @Binding var selectedViewIdentifier: String?
    
    @State private var error: Error?
    
    var body: some View {
        let form = Form {
            Section {
                SignOutButton<FireUIAppState>(error: $error)
                DeleteUserButton<Human, FireUIAppState>(error: $error)
            }
        }
        #if os(macOS)
        form
        #else
        StyledRootView(
            selectedViewIdentifier: $selectedViewIdentifier,
            state: FireUIAppState.self,
            person: Human.self,
            label: "Settings",
            systemImage: "gearshape",
            tag: "settings"
        ) {
            form
        }
        #endif
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(selectedViewIdentifier: .constant("settings"))
    }
}
