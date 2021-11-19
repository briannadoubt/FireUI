//
//  FireClient.swift
//  FireUI
//
//  Created by Brianna Doubt on 10/9/21.
//

@_exported import Firebase
@_exported import FirebaseFirestoreSwift
@_exported import SwiftUI

public struct FireClient<Human: Person, Logo: View, Footer: View, Content: View, Settings: View, AppState: FireState>: View {
    
    @ViewBuilder fileprivate let authenticationView: AuthenticationView<Logo, Footer, Human>
    @ViewBuilder fileprivate let content: (_ uid: String) -> FireContentView<Human, Content>
    @ViewBuilder fileprivate let settings: (_ uid: String) -> FireSettingsView<Human, Settings>
    
    @EnvironmentObject fileprivate var state: AppState
    @EnvironmentObject fileprivate var user: FirebaseUser
    
    public init(
        state: AppState.Type,
        person: Human.Type,
        @ViewBuilder authenticationView: @escaping () -> AuthenticationView<Logo, Footer, Human> = {
            AuthenticationView<Logo, Footer, Human>()
        },
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder settings: @escaping () -> Settings
    ) {
        self.authenticationView = authenticationView()
        self.content = { uid in
            FireContentView<Human, Content>(uid: uid, content: content)
        }
        self.settings = { uid in
            FireSettingsView<Human, Settings>(uid: uid, settings: settings)
        }
    }

    public var body: some View {
        if let uid = user.uid, user.isAuthenticated {
            content(uid)
                .environmentObject(state)
                .accentColor(.accentColor)
        } else {
            authenticationView
                .environmentObject(state)
                .accentColor(.accentColor)
                .ignoresSafeArea(.container, edges: .all)
        }
    }
}

extension Bundle {
    public var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
}

//struct FireClient_Previews: PreviewProvider {
//    static var previews: some View {
//        FireClient(state: DemoAppState.shared, personType: DemoPerson.self) {
//            Text("Hello, world!").padding()
//        }
//    }
//}
