//
//  AppCheckProviderFactory.swift
//  Twerking Girl
//
//  Created by Brianna Zamora on 10/12/21.
//

import Foundation
import Firebase
import FirebaseAppCheck

class TGAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
    func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
        if #available(iOS 14.0, *) {
            return AppAttestProvider(app: app)
        } else {
            return DeviceCheckProvider(app: app)
        }
    }
}
