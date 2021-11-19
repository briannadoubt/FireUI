//
//  AuthenticationView.swift
//  FireUI
//
//  Created by Brianna Lee on 8/29/20.
//

@_exported import SwiftUI
@_exported import Firebase

public struct AuthenticationView<Logo: View, Footer: View, Human: Person>: View  {
    
    public init(
        newPerson: @escaping Human.New = Human.new,
        @ViewBuilder logo: @escaping () -> Logo? = { nil },
        @ViewBuilder footer: @escaping () -> Footer? = { nil }
    ) {
        self.logo = logo
        self.newPerson = newPerson
        self.footer = footer
    }
    
    @ViewBuilder private var logo: () -> Logo?
    
    private var newPerson: (_ uid: String, _ email: String, _ nickname: String) -> Human = Human.new
    
    @ViewBuilder private var footer: () -> Footer?
    
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
        ScrollView([.horizontal, .vertical]) {
            HStack {
                Spacer()
                if let logo = logo() {
                    logo
                        .aspectRatio(nil, contentMode: .fit)
                }
                Spacer()
            }
            .frame(height: 128)
            VStack(spacing: 0) {
                if isShowingForm {
                    VStack(spacing: 0) {
                        Text(viewState.title)
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
                            #if os(macOS)
                            .buttonStyle(LinkButtonStyle())
                            #endif
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
                            #if os(macOS)
                            .buttonStyle(LinkButtonStyle())
                            #endif
                            .accessibility(identifier: "signUpHereButton")
                            .foregroundColor(.accentColor)
                        }
                    }
                    
                    Divider().padding()
                    
                    if let footer = footer() {
                        footer.font(.caption)
                    }
                }
            }
        }
        .onAppear {
            withAnimation(Animation.linear.delay(0.3)) {
                isShowingForm = true
            }
        }
    }
}
