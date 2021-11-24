//
//  SignInButton.swift
//  
//
//  Created by Bri on 11/19/21.
//

import SwiftUI
import simd

public struct SignInButton: View {
    
    public var label: String
    @Binding public var error: Error?
    
    public var namespace: Namespace.ID
    
    public let tag = "signIn"
    public let accessibilityIdentifier = "signInButton"
    
    public init(label: String, error: Binding<Error?>, namespace: Namespace.ID) {
        self.label = label
        self._error = error
        self.namespace = namespace
    }
    
    @EnvironmentObject fileprivate var user: FirebaseUser
    
    public var body: some View {
        ConfirmationButton(label: label) {
            if #available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *) {
                Task {
                    do {
                        try await user.signIn()
                    } catch let error as FireUIError {
                        self.error = error
                        handleError(error, message: "Failed to sign in")
                    } catch {
                        self.error = error
                        handleError(error, message: "Failed to sign in")
                    }
                }
            } else {
                user.signIn { error in
                    if let error = error as? FireUIError {
                        self.error = error
                        handleError(error, message: "Failed to sign in")
                    } else if let error = error {
                        self.error = error
                        handleError(error, message: "Failed to sign in")
                    }
                }
            }
        }
        .tag(tag)
        .matchedGeometryEffect(id: "confirmationButton", in: namespace)
        .accessibility(identifier: accessibilityIdentifier)
    }
}

struct SignInButton_Previews: PreviewProvider {
    static var previews: some View {
        SignInButton(label: "Sign In", error: .constant(nil), namespace: Namespace().wrappedValue)
    }
}
