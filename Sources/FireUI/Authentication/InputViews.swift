//
//  InputViews.swift
//  Twerking Girl
//
//  Created by Brianna Zamora on 10/11/21.
//

import SwiftUI

@available(iOS 15.0.0, *)
struct SignOutButton: View {
    
    @EnvironmentObject var user: FirebaseUser
    
    @Binding var error: Error?
    
    var body: some View {
        Button(role: .destructive) {
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

@available(iOS 15.0.0, *)
struct DeleteUserButton<Human: Person>: View {
    
    @EnvironmentObject var user: FirebaseUser
    @EnvironmentObject var person: FirestoreDocument<Human>
    
    @Binding var error: Error?
    
    var body: some View {
        Button(role: .destructive) {
            Task {
                do {
                    try await user.delete(person: person.lazyDocument)
                } catch {
                    print(error)
                    self.error = error
                }
            }
        } label: {
            Label("Delete Account", systemImage: "person.fill.xmark")
        }
    }
}

@available(iOS 15.0.0, *)
struct SignInButton: View {
    
    var label: String
    @Binding var error: Error?
    
    @EnvironmentObject var user: FirebaseUser
    
    var body: some View {
        ConfirmationButton(label: label) {
            Task {
                do {
                    try await user.signIn()
                } catch {
                    self.error = error
                }
            }
        }
    }
}

@available(iOS 15.0.0, *)
struct SignUpButton<Human: Person>: View {
    
    var label: String
    @Binding var error: Error?
    var newPerson: (_ uid: PersonID, _ email: String, _ nickname: String) async throws -> Human
    
    @EnvironmentObject var user: FirebaseUser
    
    var body: some View {
        ConfirmationButton(label: label) {
            Task {
                do {
                    try await user.signUp(newPerson: newPerson)
                } catch {
                    self.error = error
                }
            }
        }
    }
}

@available(iOS 15.0.0, *)
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

@available(iOS 15.0.0, *)
struct EmailInput: View {

    @Binding var email: String

    @State var label = "Email"
    let tag = "email"
    let accessibilityIdentifier = "emailInput"

    var body: some View {
        TextField(label, text: $email)
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

@available(iOS 15.0.0, *)
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
