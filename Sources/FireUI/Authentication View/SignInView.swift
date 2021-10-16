//
//  LoginView.swift
//  iOS
//
//  Created by Brianna Lee on 8/29/20.
//

import SwiftUI
import AuthenticationServices
import Firebase

@available(iOS 14.0, *)
struct SignInView: View {

    var namespace: Namespace.ID

    @Binding var email: String
    @Binding var password: String

    @Binding var error: Error?
    @Binding var authViewState: AuthenticationViewState

    var changeAuthMethod: (_ state: AuthenticationViewState) -> ()

    var body: some View {
        VStack(spacing: 8) {
            EmailInput(email: $email, label: "Email")
                .onChange(of: email, perform: { (newEmail) in
                    email = newEmail.lowercased()
                })

            PasswordInput(password: $password, namespace: namespace)
            
            SignInButton(label: "Sign in with Email", error: $error)
        }
        .padding()
    }
}
