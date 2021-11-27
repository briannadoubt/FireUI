//
//  FireUIError.swift
//  FireUI
//
//  Created by Brianna Lee on 10/15/20.
//

@_exported import Foundation

#if canImport(SwiftUI)
import SwiftUI
public extension View {
    
    func handleError(_ error: FireUIError, message: String? = nil) {
        // These assertions only run on DEBUG
//        if let message = message {
//            assertionFailure(message + ": " + error.description)
//        } else {
//            assertionFailure(error.description)
//        }
        #if canImport(FirebaseCrashlytics)
        record(error: error)
        #endif
    }
    
    func handleError(_ error: Error, message: String? = nil) {
        // These assertions only run on DEBUG
//        if let message = message {
//            assertionFailure(message + ": " + error.localizedDescription)
//        } else {
//            assertionFailure(error.localizedDescription)
//        }
        #if canImport(FirebaseCrashlytics)
        record(error: error)
        #endif
    }
}
#endif

#if canImport(FirebaseCrashlytics)
import FirebaseCrashlytics
public extension View {
    /// Use Crashlytics to report errors
    func record(error: Error) {
        Crashlytics.crashlytics().record(error: error)
    }
}
#endif

public enum FireUIError: Error {

    case IdNotFound
    case dataNotFound
    case notAllowed
    case documentNotFound
    case urlNotFound
    case userNotFound
    case failedEncoding
    case missingEmailAddress
    case missingPassword
    case fileNameNotFound
    case missingNickname
    case missingPasswordVerification
    case failedPasswordVerification
    case badInput
    
    public var description: String {
        switch self {
        case .IdNotFound:
            return "ID Not found"
        case .dataNotFound:
            return "Data not found"
        case .notAllowed:
            return "Not allowed to perform this action"
        case .documentNotFound:
            return "No document found"
        case .urlNotFound:
            return "URL not found"
        case .userNotFound:
            return "User Not Found"
        case .failedEncoding:
            return "Failed to encode object"
        case .missingEmailAddress:
            return "An email address is required"
        case .missingPassword:
            return "A password is required"
        case .fileNameNotFound:
            return "File name not found"
        case .missingNickname:
            return "A name is required"
        case .missingPasswordVerification:
            return "Password verification is required"
        case .failedPasswordVerification:
            return "Failed to verify password"
        case .badInput:
            return "Bad input"
        }
    }
}
