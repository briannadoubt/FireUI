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
    
    public init(label: String, error: Binding<Error?>) {
        self.label = label
        self._error = error
    }
    
    @EnvironmentObject fileprivate var user: FirebaseUser
    
    public var body: some View {
        ConfirmationButton(label: label) {
            user.signIn() { error in
                self.error = error
            }
        }
    }
}

struct SignInButton_Previews: PreviewProvider {
    static var previews: some View {
        SignInButton(label: "Sign In", error: .constant(nil))
    }
}
