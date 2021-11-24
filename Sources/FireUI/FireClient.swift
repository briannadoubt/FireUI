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
    @ViewBuilder fileprivate let content: (_ uid: String) -> FireContentView<Human, Settings, Content>
    
    @ObservedObject fileprivate var state: AppState
    @ObservedObject fileprivate var user: FirebaseUser
    
    public init(
        state: AppState,
        user: FirebaseUser,
        person: Human.Type,
        @ViewBuilder authenticationView: @escaping () -> AuthenticationView<Logo, Footer, Human> = {
            AuthenticationView<Logo, Footer, Human>()
        },
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder settings: @escaping () -> Settings
    ) {
        self.state = state
        self.user = user
        self.authenticationView = authenticationView()
        self.content = { uid in
            FireContentView<Human, Settings, Content>(
                uid: uid,
                content: content
            ) {
                FireSettingsView<Human, Settings>(
                    uid: uid,
                    settings: settings
                )
            }
        }
    }

    public var body: some View {
        if Auth.auth().currentUser != nil {
            if let uid = Auth.auth().currentUser?.uid {
                content(uid)
                    .environmentObject(state)
                    .accentColor(Color("AccentColor"))
            }
        } else {
            authenticationView
                .environmentObject(state)
                .ignoresSafeArea(.container, edges: .all)
                .accentColor(Color("AccentColor"))
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
