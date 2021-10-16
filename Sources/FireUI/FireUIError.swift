//
//  FireUIError.swift
//  FirebaseUI
//
//  Created by Brianna Lee on 10/15/20.
//

import Foundation

enum FireUIError: Error {

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

    var localizedDescription: String {
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
