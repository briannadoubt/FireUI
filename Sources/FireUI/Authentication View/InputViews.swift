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
            } catch {
                print(error)
                self.error = error
            }
        } label: {
            Label("Sign Out", systemImage: "figure.wave")
        }
    }
}

public struct SignUpButton<Human: Person>: View {
    
    public var label: String
    @Binding public var error: Error?
    
    public init(label: String, error: Binding<Error?>) {
        self.label = label
        self._error = error
    }
    
    @EnvironmentObject public var user: FirebaseUser
    
    public var body: some View {
        ConfirmationButton(label: label) {
            user.signUp(newPerson: Human.new) { human, error in
                self.error = error
            }
        }
    }
}

public struct PasswordInput: View {

    @Binding public var password: String
    public var namespace: Namespace.ID

    public var body: some View {
        SecureField("Password", text: $password)
            .textContentType(.password)
            .padding(8)
            .tag("password")
            .matchedGeometryEffect(id: "password", in: namespace)
            .accessibility(identifier: "passwordInput")
    }
}

public struct VerifyPasswordInput: View {

    @Binding public var password: String
    public var namespace: Namespace.ID

    public var body: some View {
        SecureField("Verify Password", text: $password)
            .textContentType(.newPassword)
            .padding(8)
            .tag("verifyPassword")
            .matchedGeometryEffect(id: "verifyPassword", in: namespace)
            .accessibility(identifier: "verifyPasswordInput")
    }
}

public struct EmailInput: View {

    @Binding public var email: String

    @State public var label = "Email"
    public let tag = "email"
    public let accessibilityIdentifier = "emailInput"

    public var body: some View {
        TextField(label, text: $email)
            .padding(8)
            #if !os(macOS)
            .autocapitalization(.none)
            #endif
            #if os(iOS)
            .keyboardType(.emailAddress)
            .textContentType(.emailAddress)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .tag(tag)
            .accessibility(identifier: accessibilityIdentifier)
            #endif
    }
}

public struct NicknameInput: View {

    @Binding public var nickname: String

    @State public var label = "Nickname"
    public let tag = "nickname"
    public let accessibilityIdentifier = "nicknameInput"

    public var body: some View {
        TextField(label, text: $nickname)
            .padding(8)
            #if !os(macOS)
            .autocapitalization(.none)
            #endif
            #if os(iOS)
            .keyboardType(.emailAddress)
            .textContentType(.nickname)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .tag(tag)
            .accessibility(identifier: accessibilityIdentifier)
            #endif
    }
}
