//
//  SignUpView.swift
//  FireUI
//
//  Created by Brianna Lee on 8/29/20.
//

@_exported import SwiftUI
@_exported import Firebase

struct SignUpView<Human: Person>: View {
    
    var namespace: Namespace.ID
    
    @Binding var nickname: String
    @Binding var email: String
    @Binding var password: String
    @Binding var verifyPassword: String

    @Binding var error: Error?
    @Binding var authViewState: AuthenticationViewState

    var newPerson: (_ uid: String, _ email: String, _ nickname: String) -> Human
    
    var changeAuthMethod: (_ viewState: AuthenticationViewState) -> ()
    
    @EnvironmentObject fileprivate var user: FirebaseUser
    @FocusState var focus: String?

    var body: some View {
        VStack(spacing: 8) {
            NicknameInput(nickname: $nickname)
                .focused($focus, equals: "nicknameInput")
                .onSubmit {
                    focus = "emailInput"
                }
                .onAppear {
                    focus = "nicknameInput"
                }
            
            EmailInput(email: $email)
                .focused($focus, equals: "emailInput")
                .onSubmit {
                    focus = "passwordInput"
                }
            
            
            PasswordInput(password: $password, namespace: namespace)
                .focused($focus, equals: "passwordInput")
                .onSubmit {
                    focus = "verifyPasswordInput"
                }
            
            VerifyPasswordInput(password: $verifyPassword, namespace: namespace)
                .focused($focus, equals: "verifyPasswordInput")
                .onSubmit {
                    focus = nil
                    guard nickname != "", email != "" , password != "", verifyPassword != "" else {
                        return
                    }
                    user.signUp(newPerson: Human.new) { person, error in
                        if let error = error {
                            self.error = error
                        }
                    }
                }
            
            SignUpButton<Human>(label: "Sign Up", error: $error)
        }
        .padding()
    }
}
