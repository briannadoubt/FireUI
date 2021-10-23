//
//  FireClient.swift
//  FireUI
//
//  Created by Brianna Doubt on 10/9/21.
//

import Firebase
import FirebaseFirestoreSwift
#if os(WASI)
import SwiftWebUI
#else
import SwiftUI
#endif

extension View {
    public func onFire<Human: Person, AppState: FireState>(_ personType: Human.Type, _ appStateType: AppState.Type) -> some View {
        modifier(Client<Human, AppState>())
    }
}

public struct Client<Human: Person, AppState: FireState>: ViewModifier {
    
    @EnvironmentObject private var state: AppState
    
    public func body(content: Content) -> some View {
        FireClient<Human, Content, AppState>(firebaseEnabled: state.firebaseEnabled) {
            content
        }
    }
}

public struct FireClient<Human: Person, Content: View, AppState: FireState>: View {

    @StateObject public var user: FirebaseUser
    
    private let contentView: (_ uid: String) -> FireContentView<Human, Content>
    private let authenticationView: AuthenticationView<Human>
    
    @EnvironmentObject private var state: AppState
    
    public init(
        personBasePath: String = "users",
        firebaseEnabled: Bool = false,
        @ViewBuilder authenticationView: @escaping () -> AuthenticationView<Human> = { AuthenticationView<Human>() },
        @ViewBuilder content: @escaping () -> Content
    ) {
        _user = StateObject(wrappedValue: FirebaseUser(firebaseEnabled, basePath: personBasePath))
        self.contentView = { uid in
            FireContentView<Human, Content>(
                personBasePath: personBasePath,
                uid: uid,
                content: content
            )
        }
        self.authenticationView = authenticationView()
    }

    public var body: some View {
        Group {
            if user.isAuthenticated, let uid = user.uid {
                contentView(uid)
                    .environmentObject(user)
                    .observe(user)
            } else {
                authenticationView
                    .environmentObject(user)
                    .observe(user)
            }
        }
        .accentColor(Color("AccentColor"))
        #if os(iOS)
//        .tint(Color("AccentColor"))
        #endif
    }
}

extension Bundle {
    public var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
}

struct FireClient_Previews: PreviewProvider {
    static var previews: some View {
        DemoContentView().onFire(DemoPerson.self, DemoAppState.self)
    }
}
