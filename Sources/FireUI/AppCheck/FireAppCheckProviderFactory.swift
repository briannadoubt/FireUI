//
//  FireAppCheckProviderFactory.swift
//  FireUI
//
//  Created by Brianna Doubt on 10/12/21.
//

import Foundation
import Firebase
import FirebaseAppCheck

class FireAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
    func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
        return AppAttestProvider(app: app)
    }
}
