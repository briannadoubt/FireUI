//
//  Bundle+displayName.swift
//  FireUI
//
//  Created by Brianna Doubt on 10/9/21.
//

@_exported import Firebase
@_exported import FirebaseFirestoreSwift
@_exported import SwiftUI

extension Bundle {
    public var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
}
