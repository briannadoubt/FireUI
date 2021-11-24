//
//  LoginView.swift
//  FireUI
//
//  Created by Brianna Lee on 8/29/20.
//

@_exported import SwiftUI
@_exported import AuthenticationServices
@_exported import Firebase

@available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *)
struct SignInView: View {

    var namespace: Namespace.ID

    @Binding var email: String
    @Binding var password: String

    @Binding var error: Error?
    @Binding var authViewState: AuthenticationViewState

    var changeAuthMethod: AuthenticationView.ChangeAuthMethod
    
    @EnvironmentObject fileprivate var user: FirebaseUser
    
    @FocusState var focus: String?

    var body: some View {
        VStack(spacing: 8) {
            EmailInput(email: $email, namespace: namespace, label: "Email")
                .focused($focus, equals: "emailInput")
                .onSubmit {
                    focus = "passwordInput"
                }
                .onAppear {
                    focus = "emailInput"
                }

            PasswordInput(password: $password, namespace: namespace)
                .focused($focus, equals: "passwordInput")
                .onSubmit {
                    focus = nil
                    guard email != "", password != "" else {
                        return
                    }
                    user.signIn() { error in
                        self.error = error
                    }
                }
            
            SignInButton(label: "Sign in with Email", error: $error, namespace: namespace)
        }
        .padding()
        .accessibility(identifier: "signInView")
    }
}
