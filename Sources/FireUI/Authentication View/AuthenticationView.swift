//
//  AuthenticationView.swift
//  FireUI
//
//  Created by Brianna Lee on 8/29/20.
//

import SwiftUI
import Firebase

public struct AuthenticationView<Human: Person>: View  {
    
    public init(
        @ViewBuilder image: @escaping () -> Image = { Image(systemName: "circle") },
        newPerson: @escaping (_ uid: String, _ email: String, _ nickname: String) async throws -> Human = Human.new,
        @ViewBuilder footer: @escaping () -> Text = { Text("♥️") }
    ) {
        self.image = image
        self.newPerson = newPerson
        self.footer = footer
    }
    
    @ViewBuilder private var image: () -> Image
    private var newPerson: (_ uid: String, _ email: String, _ nickname: String) async throws -> Human
    @ViewBuilder private var footer: () -> Text
    
    @State private var viewState: AuthenticationViewState = .signIn
    @State private var error: Error?
    @Namespace private var namespace
    
    @EnvironmentObject private var user: FirebaseUser
    @State private var isShowingForm = false

    private func changeAuthMethod(to viewState: AuthenticationViewState) {
        withAnimation {
            error = nil
            self.viewState = viewState
        }
    }

    public var body: some View {
        VStack {
            ScrollView([.horizontal, .vertical]) {
                VStack(spacing: 0) {
                    image()
                        .resizable()
                        .frame(width: 128, height: 128)
                    
                    if isShowingForm {
                        VStack(spacing: 0) {
                            Text(viewState.title)
                                .foregroundColor(.primary)
                                .font(.largeTitle)
                                .bold()
                                .transition(.opacity)
                            
                            ErrorView(error: $error.animation(), floating: true)
                                .padding(.top)
                            
                            VStack(spacing: 8) {
                                switch viewState {
                                case .signUp:
                                    SignUpView(
                                        namespace: namespace,
                                        nickname: $user.nickname,
                                        email: $user.email,
                                        password: $user.password,
                                        verifyPassword: $user.verifyPassword,
                                        error: $error,
                                        authViewState: $viewState,
                                        newPerson: newPerson,
                                        changeAuthMethod: changeAuthMethod
                                    )
                                case .signIn:
                                    SignInView(
                                        namespace: namespace,
                                        email: $user.email,
                                        password: $user.password,
                                        error: $error,
                                        authViewState: $viewState,
                                        changeAuthMethod: changeAuthMethod(to:)
                                    )
                                }
                            }
                        }
                        .padding()
                        .background(Color("BackgroundColor"))
                        .cornerRadius(10)
                        .frame(minWidth: 320, maxWidth: 320)
                        .lineLimit(nil)
                        .padding([.bottom, .top], 10)
                        
                        switch viewState {
                        case .signUp:
                            VStack {
                                Text("Already have an account?")
                                Button(action: { changeAuthMethod(to: .signIn) }) {
                                    HStack {
                                        Text("Sign In here").bold()
                                        Image(systemName: "arrow.right")
                                            .resizable()
                                            .frame(width: 10, height: 10)
                                    }
                                }
                                .accessibility(identifier: "signInHereButton")
                                .foregroundColor(.accentColor)
                            }
                        case .signIn:
                            VStack {
                                Text("Need an account?")
                                Button(action: { changeAuthMethod(to: .signUp) }) {
                                    HStack {
                                        Text("Sign up here").bold()
                                        Image(systemName: "arrow.right")
                                            .resizable()
                                            .frame(width: 10, height: 10)
                                    }
                                }
                                .accessibility(identifier: "signUpHereButton")
                                .foregroundColor(.accentColor)
                            }
                        }
                    }
                }
                .accentColor(Color("AccentColor"))
                .tint(Color("AccentColor"))
            }
            .onAppear {
                withAnimation(Animation.linear.delay(0.5)) {
                    isShowingForm = true
                }
            }
            
            footer().font(.caption)
        }
    }
}
