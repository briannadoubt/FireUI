//
//  FireClient.swift
//  FireUI
//
//  Created by Brianna Doubt on 10/9/21.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

public struct FireClient<Human: Person>: ViewModifier {
    public func body(content: Content) -> some View {
        Client<Human, Content> {
            content
        }
    }
}

extension View {
    public func onFire<Human: Person>(_ personType: Human.Type) -> some View {
        modifier(FireClient<Human>())
    }
}

public struct Client<Human: Person, Content: View>: View {

    @StateObject public var user: FirebaseUser
    
    let contentView: (_ uid: String) -> FireContentView<Human, Content>
    let authenticationView: AuthenticationView<Human>
    
    public init(
        personBasePath: String = "users",
        @ViewBuilder authenticationView: @escaping () -> AuthenticationView<Human> = { AuthenticationView<Human>() },
        @ViewBuilder content: @escaping () -> Content
    ) {
        _user = StateObject(wrappedValue: FirebaseUser(basePath: personBasePath))
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
        .tint(Color("AccentColor"))
    }
}

extension Bundle {
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
}

struct FireClient_Previews: PreviewProvider {
    static var previews: some View {
        DemoContentView().onFire(DemoPerson.self)
    }
}
