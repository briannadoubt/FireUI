//
//  SettingsView.swift
//  FireUI
//
//  Created by Bri on 11/16/21.
//

import FireUI

struct SettingsView: View {
    
    private enum Tabs: Hashable {
        case general, advanced
    }
    
    @State private var error: Error?
    
    var body: some View {
        StyledRootView(
            state: FireUIAppState.self,
            label: "Settings",
            systemImage: "gear",
            tag: "settings"
        ) {
            Form {
                Section {
                    SignOutButton(error: $error)
                }
                Section {
                    DeleteUserButton<Human>(error: $error)
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
