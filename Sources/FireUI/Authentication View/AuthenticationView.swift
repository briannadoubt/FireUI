//
//  AuthenticationView.swift
//  FireUI
//
//  Created by Brianna Lee on 8/29/20.
//

@_exported import SwiftUI
@_exported import Firebase

public struct AuthenticationView<Logo: View, Footer: View, Human: Person, AppState: FireState>: View  {
    
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
    
    @State private var viewState: AuthenticationViewState = .signUp
    @State private var error: Error?
    @Namespace private var namespace
    
    @EnvironmentObject private var user: FirebaseUser<AppState>
    @State private var isShowingForm = false

    public typealias ChangeAuthMethod = (_ viewState: AuthenticationViewState) -> ()
    private func changeAuthMethod(to viewState: AuthenticationViewState) {
        withAnimation {
            error = nil
            self.viewState = viewState
        }
    }
    
    fileprivate var spacing: CGFloat {
        #if os(macOS)
        return 0
        #else
        return 8
        #endif
    }

    public var body: some View {
        let authView = Group {
            HStack {
                Spacer()
                if let logo = logo() {
                    logo
                        .aspectRatio(nil, contentMode: .fit)
                        .accessibility(identifier: "logo")
                }
                Spacer()
            }
            .frame(height: 128)
            
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Text(viewState.title)
                        .font(.largeTitle)
                        .bold()
                        .transition(.opacity)
                        .accessibility(identifier: "authenticationTitle")
                    
                    ErrorView(error: $error.animation(), floating: true)
                        .padding(.top)
                    
                    VStack(spacing: spacing) {
                        if #available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *) {
                            switch viewState {
                            case .signUp:
                                SignUpView(
                                    namespace: namespace,
                                    state: AppState.self,
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
                                    state: AppState.self,
                                    email: $user.email,
                                    password: $user.password,
                                    error: $error,
                                    authViewState: $viewState,
                                    changeAuthMethod: changeAuthMethod(to:)
                                )
                            }
                        } else {
                            Text("Sorry, this view is only available on macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, and watchOS 8.0.0.")
                            
                            #if os(macOS)
                            .buttonStyle(LinkButtonStyle())
                            #endif
                            .accessibility(identifier: "signInAnonymouslyButton")
                        }
                    }
                }
                .padding()
                .background(Color("BackgroundColor"))
                .cornerRadius(10)
                .frame(minWidth: 320, maxWidth: 320)
                .lineLimit(nil)
                .padding([.bottom, .top], 10)
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .accessibility(identifier: "authenticationForm")
                
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
                        .foregroundColor(Color("AccentColor"))
                        #endif
                        .accessibility(identifier: "signInHereButton")
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
                        .foregroundColor(Color("AccentColor"))
                        #endif
                        .accessibility(identifier: "signUpHereButton")
                    }
                }
                
                if let footer = footer() {
                    Divider().padding()
                    footer
                        .font(.caption)
                        .accessibility(identifier: "footer")
                }
            }
            .accessibility(identifier: "authenticationForm")
        }
        .accessibility(identifier: "authenticationView")
        
        let scrollView = ScrollView([.horizontal, .vertical]) {
            authView
        }
        .accessibility(identifier: "authenticationScrollView")
        
        #if !os(macOS)
        scrollView
        #else
        authView
            .frame(minWidth: 320)
            .fixedSize(horizontal: true, vertical: false)
        #endif
    }
}
