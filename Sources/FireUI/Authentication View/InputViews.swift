//
//  InputViews.swift
//  FireUI
//
//  Created by Brianna Doubt on 10/11/21.
//

@_exported import SwiftUI

public struct SignOutButton: View {
    
    @Binding public var error: Error?
    
    public init(error: Binding<Error?>) {
        self._error = error
    }
    
    @EnvironmentObject var user: FirebaseUser
    
    public var body: some View {
        Button {
            do {
                try user.signOut()
            } catch let error as FireUIError {
                self.error = error
                handleError(error, message: "Failed to sign out")
            } catch {
                self.error = error
                handleError(error, message: "Failed to sign out")
            }
        } label: {
            Label("Sign Out", systemImage: "figure.wave")
        }
        .accessibility(identifier: "signOutButton")
    }
}

public struct SignUpButton<Human: Person>: View {
    
    public var label: String
    @Binding public var error: Error?
    public var namespace: Namespace.ID
    
    public let tag = "signUp"
    public let accessibilityIdentifier = "signUpButton"
    
    @EnvironmentObject private var user: FirebaseUser
    
    public var body: some View {
        ConfirmationButton(label: label) {
            if #available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *) {
                Task {
                    do {
                        try await user.signUp(newPerson: Human.new)
                    } catch let error as FireUIError {
                        self.error = error
                        handleError(error, message: "Failed to sign up")
                    } catch {
                        self.error = error
                        handleError(error, message: "Failed to sign up")
                    }
                }
            } else {
                user.signUp(newPerson: Human.new) { human, error in
                    if let error = error as? FireUIError {
                        self.error = error
                        handleError(error, message: "Failed to sign up")
                    } else if let error = error {
                        self.error = error
                        handleError(error, message: "Failed to sign up")
                    }
                }
            }
        }
        .tag(tag)
        .matchedGeometryEffect(id: "confirmationButton", in: namespace)
        .accessibility(identifier: "signUpButton")
    }
}

public struct PasswordInput: View {

    @Binding public var password: String
    public var namespace: Namespace.ID
    
    public var label = "Password"
    public let tag = "password"
    public let accessibilityIdentifier = "passwordInput"

    public var body: some View {
        SecureField(label, text: $password)
            .textContentType(.password)
            .padding(8)
            .tag(tag)
            .matchedGeometryEffect(id: tag, in: namespace)
            .accessibility(identifier: accessibilityIdentifier)
    }
}

public struct VerifyPasswordInput: View {

    @Binding public var password: String
    public var namespace: Namespace.ID
    
    public var label = "Verify Password"
    public let tag = "verifyPassword"
    public let accessibilityIdentifier = "verifyPasswordInput"

    public var body: some View {
        SecureField(label, text: $password)
            .textContentType(.newPassword)
            .padding(8)
            .tag(tag)
            .matchedGeometryEffect(id: tag, in: namespace)
            .accessibility(identifier: accessibilityIdentifier)
    }
}

public struct EmailInput: View {

    @Binding public var email: String
    public var namespace: Namespace.ID

    public var label = "Email"
    public let tag = "email"
    public let accessibilityIdentifier = "emailInput"

    public var body: some View {
        let input = TextField(label, text: $email)
            .padding(8)
            .accessibility(identifier: accessibilityIdentifier)
            .tag(tag)
            .matchedGeometryEffect(id: tag, in: namespace)
            #if !os(macOS)
            .autocapitalization(.none)
            #endif
            #if os(iOS)
            .keyboardType(.emailAddress)
            .textContentType(.emailAddress)
            #endif
        
        if #available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *) {
            input.textInputAutocapitalization(.never)
        } else {
            input
        }
    }
}

public struct NicknameInput: View {

    @Binding public var nickname: String
    public var namespace: Namespace.ID

    public var label = "Nickname"
    public let tag = "nickname"
    public let accessibilityIdentifier = "nicknameInput"

    public var body: some View {
        let input = TextField(label, text: $nickname)
            .padding(8)
            .tag(tag)
            .accessibility(identifier: accessibilityIdentifier)
            .matchedGeometryEffect(id: tag, in: namespace)
            #if !os(macOS)
            .autocapitalization(.none)
            #endif
            #if os(iOS)
            .keyboardType(.emailAddress)
            .textContentType(.nickname)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            #endif
        
        if #available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *) {
            input.textInputAutocapitalization(.never)
        } else {
            input
        }
    }
}

struct SignInAnonymouslyButton: View {
    
    public var label: String
    @Binding public var error: Error?
    public var namespace: Namespace.ID
    
    public let tag = "signInAnonymously"
    public let accessibilityIdentifier = "signInAnonymouslyButton"
    
    @EnvironmentObject private var user: FirebaseUser
    
    var body: some View {
        ConfirmationButton(label: "Sign In Anonymously") {
            if #available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *) {
                Task {
                    do {
                        try await Auth.auth().signInAnonymously()
                    } catch let error as FireUIError {
                        self.error = error
                        handleError(error, message: "Failed to sign in anonymously")
                    } catch {
                        self.error = error
                        handleError(error, message: "Failed to sign in anonymously")
                    }
                }
            } else {
                Auth.auth().signInAnonymously() { snapshot, error in
                    if let error = error as? FireUIError {
                        self.error = error
                        handleError(error, message: "Failed to sign in anonymously")
                    } else if let error = error {
                        self.error = error
                        handleError(error, message: "Failed to sign in anonymously")
                    }
                }
            }
        }
        .tag(tag)
        .matchedGeometryEffect(id: "confirmationButton", in: namespace)
        .accessibility(identifier: accessibilityIdentifier)
    }
}
