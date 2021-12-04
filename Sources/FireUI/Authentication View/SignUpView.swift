//
//  SignUpView.swift
//  FireUI
//
//  Created by Brianna Lee on 8/29/20.
//

@_exported import SwiftUI
@_exported import Firebase

@available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *)
struct SignUpView<Human: Person, AppState: FireState>: View {
    
    var namespace: Namespace.ID
    var state: AppState.Type
    
    @Binding var nickname: String
    @Binding var email: String
    @Binding var password: String
    @Binding var verifyPassword: String

    @Binding var error: Error?
    @Binding var authViewState: AuthenticationViewState

    var newPerson: Human.New
    var changeAuthMethod: AuthenticationView.ChangeAuthMethod
    
    @EnvironmentObject fileprivate var user: FirebaseUser<AppState>
    @FocusState var focus: String?

    var body: some View {
        VStack(spacing: 8) {
            NicknameInput(nickname: $nickname, namespace: namespace)
                .focused($focus, equals: "nicknameInput")
                .onSubmit {
                    focus = "emailInput"
                }
                .onAppear {
                    focus = "nicknameInput"
                }
            
            EmailInput(email: $email, namespace: namespace)
                .focused($focus, equals: "emailInput")
                .onSubmit {
                    focus = "newPasswordInput"
                }
            
            NewPasswordInput(password: $password, namespace: namespace)
                .focused($focus, equals: "newPasswordInput")
                .onSubmit {
                    focus = "verifyPasswordInput"
                }
            
            VerifyPasswordInput(password: $verifyPassword, namespace: namespace)
                .focused($focus, equals: "verifyPasswordInput")
                .onSubmit {
                    focus = nil
                    user.signUp(newPerson: Human.new) { person, error in
                        if let error = error {
                            self.error = error
                        }
                    }
                }
            
            SignUpButton<Human, AppState>(label: "Sign Up", error: $error, namespace: namespace)
        }
        .padding()
        .accessibility(identifier: "signUpView")
    }
}
