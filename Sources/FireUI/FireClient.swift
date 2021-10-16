//
//  FireClient.swift
//  FireUI
//
//  Created by Brianna Zamora on 10/9/21.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

@available(iOS 15.0.0, *)
struct FireClient<Human: Person>: ViewModifier {
    func body(content: Content) -> some View {
        Client<Human, Content> {
            content
        }
    }
}

@available(iOS 15.0, *)
extension View {
    func onFire<Human: Person>(_ personType: Human.Type) -> some View {
        modifier(FireClient<Human>())
    }
}

@available(iOS 15.0.0, *)
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

    @available(iOS 15.0, *)
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

#if DEBUG
@available(macOS 10.15, iOS 14.0, *)
struct FireClient_Previews: PreviewProvider {
    static var previews: some View {
        PreviewContentView().onFire(PreviewPerson.self)
    }
}

struct PreviewContentView: View {
    var body: some View {
        Text("Hello, world!").padding()
    }
}

struct PreviewPerson: Person {
    
    @DocumentID var id: PersonID?
    
    var nickname = "Meowface"
    var role: PreviewRole?
    var email: String = "meow@meow.com"
    
    var created: Date
    var updated: Date
    
    func basePath() -> String {
        "users"
    }
    
    static func new(uid: PersonID, email: String, nickname: String) -> PreviewPerson {
        PreviewPerson(
            id: uid,
            nickname: nickname,
            role: nil,
            email: email,
            created: Date(),
            updated: Date()
        )
    }
}

enum PreviewRole: String, PersonRole {
    case developer
    var id: String { rawValue }
    var title: String { rawValue }
}
#endif
