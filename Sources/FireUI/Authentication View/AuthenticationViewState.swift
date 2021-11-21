//
//  AuthenticationViewState.swift
//  FireUI
//
//  Created by Brianna Lee on 10/27/20.
//

@_exported import Foundation
@_exported import SwiftUI

public enum AuthenticationViewState: String, CaseIterable, Identifiable {

    case signUp
    case signIn

    public var title: String {
        switch self {
        case .signUp:
            return "Sign Up"
        case .signIn:
            return "Login"
        }
    }

    public var id: String {
        return rawValue
    }
}
