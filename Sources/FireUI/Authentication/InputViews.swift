//
//  InputViews.swift
//  FireUI
//
//  Created by Brianna Doubt on 10/11/21.
//

#if os(WASI)
import SwiftWebUI
#else
import SwiftUI
#endif

struct SignOutButton: View {
    
    @EnvironmentObject var user: FirebaseUser
    
    @Binding var error: Error?
    
    var body: some View {
        Button {
            do {
                try user.signOut()
            } catch {
                print(error)
                self.error = error
            }
        } label: {
            Label("Sign Out", systemImage: "figure.wave")
        }
    }
}

struct DeleteUserButton<Human: Person>: View {
    
    @EnvironmentObject var user: FirebaseUser
    @EnvironmentObject var person: FirestoreDocument<Human>
    
    @Binding var error: Error?
    
    var body: some View {
        Button {
//            if #available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *) {
//                Task {
//                    do {
//                        try await user.delete(person: person.lazyDocument)
//                    } catch {
//                        print(error)
//                        self.error = error
//                    }
//                }
//            } else {
                do {
                    guard let personDocument = person.document else {
                        throw FireUIError.userNotFound
                    }
                    try user.delete(person: personDocument)
                } catch {
                    print(error)
                    self.error = error
                }
//            }
        } label: {
            Label("Delete Account", systemImage: "person.fill.xmark")
        }
    }
}

struct SignInButton: View {
    
    var label: String
    @Binding var error: Error?
    
    @EnvironmentObject var user: FirebaseUser
    
    var body: some View {
        ConfirmationButton(label: label) {
//            if #available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *) {
//                Task {
//                    do {
//                        try await user.signIn()
//                    } catch {
//                        self.error = error
//                    }
//                }
//            } else {
                do {
                    try user.signIn()
                } catch {
                    self.error = error
                }
//            }
        }
    }
}

struct SignUpButton<Human: Person>: View {
    
    var label: String
    @Binding var error: Error?
    
    
    var asyncNewPerson: (_ uid: PersonID, _ email: String, _ nickname: String) async throws -> Human {
        Human.new(uid:email:nickname:)
    }
    
    var newPerson: (_ uid: PersonID, _ email: String, _ nickname: String) -> Human {
        Human.new(uid:email:nickname:)
    }
    
    @EnvironmentObject var user: FirebaseUser
    
    var body: some View {
        ConfirmationButton(label: label) {
            if #available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *) {
                Task {
                    do {
                        try await user.signUp(newPerson: asyncNewPerson)
                    } catch {
                        self.error = error
                    }
                }
            } else {
                user.signUp(newPerson: newPerson) { human, error in
                    self.error = error
                }
            }
        }
    }
}

struct PasswordInput: View {

    @Binding var password: String
    var namespace: Namespace.ID

    var body: some View {
        SecureField("Password", text: $password)
            .padding(8)
            .tag("password")
            .matchedGeometryEffect(id: "password", in: namespace)
            .accessibility(identifier: "passwordInput")
    }
}

struct VerifyPasswordInput: View {

    @Binding var password: String
    var namespace: Namespace.ID

    var body: some View {
        SecureField("Verify Password", text: $password)
            .padding(8)
            .tag("verifyPassword")
            .matchedGeometryEffect(id: "verifyPassword", in: namespace)
            .accessibility(identifier: "verifyPasswordInput")
    }
}

struct EmailInput: View {

    @Binding var email: String

    @State var label = "Email"
    let tag = "email"
    let accessibilityIdentifier = "emailInput"

    var body: some View {
        TextField(label, text: $email)
            .padding(8)
//            .autocapitalization(.none)
#if os(iOS)
            .keyboardType(.emailAddress)
            .textContentType(.emailAddress)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .tag(tag)
            .accessibility(identifier: accessibilityIdentifier)
#endif
    }
}

struct NicknameInput: View {

    @Binding var nickname: String

    @State var label = "Nickname"
    let tag = "nickname"
    let accessibilityIdentifier = "nicknameInput"

    var body: some View {
        TextField(label, text: $nickname)
            .padding(8)
            .autocapitalization(.none)
#if os(iOS)
            .keyboardType(.emailAddress)
            .textContentType(.emailAddress)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .tag(tag)
            .accessibility(identifier: accessibilityIdentifier)
#endif
    }
}
