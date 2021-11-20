//
//  LoginView.swift
//  FireUI
//
//  Created by Brianna Lee on 8/29/20.
//

@_exported import SwiftUI
@_exported import AuthenticationServices
@_exported import Firebase

struct SignInView: View {

    var namespace: Namespace.ID

    @Binding var email: String
    @Binding var password: String

    @Binding var error: Error?
    @Binding var authViewState: AuthenticationViewState

    var changeAuthMethod: (_ state: AuthenticationViewState) -> ()
    
    @EnvironmentObject fileprivate var user: FirebaseUser
    
    @FocusState var focus: String?

    var body: some View {
        VStack(spacing: 8) {
            EmailInput(email: $email, label: "Email")
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
            
            SignInButton(label: "Sign in with Email", error: $error)
        }
        .padding()
    }
}
