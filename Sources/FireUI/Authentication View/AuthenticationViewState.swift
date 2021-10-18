//
//  AuthenticationViewState.swift
//  FireUI
//
//  Created by Brianna Lee on 10/27/20.
//

import Foundation
#if os(WASI)
import SwiftWebUI
#else
import SwiftUI
#endif

enum AuthenticationViewState: String, CaseIterable, Identifiable {

    case signUp
    case signIn

    var title: String {
        switch self {
        case .signUp:
            return "Sign Up"
        case .signIn:
            return "Login"
        }
    }

    var id: String {
        return rawValue
    }
}
