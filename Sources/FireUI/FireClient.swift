//
//  FireClient.swift
//  FireUI
//
//  Created by Brianna Doubt on 10/9/21.
//

import Firebase
import FirebaseFirestoreSwift
import SwiftUI

public struct FireClient<Human: Person, Logo: View, Footer: View, Content: View, AppState: FireState>: View {
    
    private let contentView: (_ uid: String) -> FireContentView<Human, Content>
    private let authenticationView: AuthenticationView<Logo, Footer, Human>
    
    @ObservedObject private var state: AppState
    
    @EnvironmentObject var user: FirebaseUser
    
    public init(
        state: AppState,
        personType: Human.Type,
        @ViewBuilder authenticationView: @escaping () -> AuthenticationView<Logo, Footer, Human> = {
            AuthenticationView<Logo, Footer, Human>()
        },
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.state = state
        self.contentView = { uid in
            FireContentView<Human, Content>(uid: uid, content: content)
        }
        self.authenticationView = authenticationView()
    }

    public var body: some View {
        if user.isAuthenticated, let uid = user.uid {
            contentView(uid)
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
