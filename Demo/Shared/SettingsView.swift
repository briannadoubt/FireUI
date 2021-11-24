//
//  SettingsView.swift
//  FireUI
//
//  Created by Bri on 11/16/21.
//

import FireUI
import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var state: FireUIAppState
    @Binding var selectedViewIdentifier: String?
    
    @State private var error: Error?
    
    var body: some View {
        StyledRootView(
            selectedViewIdentifier: $selectedViewIdentifier,
            state: state,
            person: Human.self,
            label: "Settings",
            systemImage: "gear",
            tag: "settings"
        ) {
            Form {
                if #available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *) {
                    Section {
                        SignOutButton(error: $error)
                        DeleteUserButton<Human>(error: $error)
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(selectedViewIdentifier: .constant("settings"))
    }
}
