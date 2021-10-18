//
//  SignUpView.swift
//  FireUI
//
//  Created by Brianna Lee on 8/29/20.
//

#if os(WASI)
import SwiftWebUI
#else
import SwiftUI
#endif
import Firebase

struct SignUpView<Human: Person>: View {
    
    var namespace: Namespace.ID

    @Binding var nickname: String
    @Binding var email: String
    @Binding var password: String
    @Binding var verifyPassword: String

    @Binding var error: Error?
    @Binding var authViewState: AuthenticationViewState
    
    @EnvironmentObject var user: FirebaseUser

//    var asyncNewPerson: (_ uid: String, _ email: String, _ nickname: String) async throws -> Human
    var newPerson: (_ uid: String, _ email: String, _ nickname: String) -> Human
    
    var changeAuthMethod: (_ viewState: AuthenticationViewState) -> ()

    var body: some View {
        VStack(spacing: 8) {
            NicknameInput(nickname: $nickname)
            EmailInput(email: $email)
            PasswordInput(password: $password, namespace: namespace)
            VerifyPasswordInput(password: $verifyPassword, namespace: namespace)
            SignUpButton<Human>(label: "Sign Up", error: $error)
        }
        .padding()
    }
}
