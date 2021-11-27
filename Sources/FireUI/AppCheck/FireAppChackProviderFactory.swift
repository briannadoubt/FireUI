//
//  File.swift
//  
//
//  Created by Bri on 10/20/21.
//

@_exported import Firebase
@_exported import FirebaseAppCheck

#if !os(watchOS)
class FireAppChackProviderFactory: NSObject, AppCheckProviderFactory {
    func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
        if #available(iOS 14.0, macOS 11.0, watchOS 7.0, tvOS 14.0, *) {
            return AppAttestProvider(app: app)
        } else {
            return DeviceCheckProvider(app: app)
        }
    }
}
#endif
