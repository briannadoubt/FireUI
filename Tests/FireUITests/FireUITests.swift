import XCTest
#if os(WASI)
import SwiftWebUI
#else
import SwiftUI
#endif
import Firebase
import FirebaseFirestoreSwift

@testable import FireUI

final class FireUITests: XCTestCase {
    
    var user: FirebaseUser!

    override func setUp() {
        let appOptions = FirebaseOptions(
            googleAppID: "1:501834001924:ios:dcad14e697355122cdcf51",
            gcmSenderID: "501834001924"
        )
        appOptions.apiKey = "AIzaSyAls2v2gRa-GIsrZfTJd0V0ORcjEeu8ArU"
        appOptions.projectID = "fireui-demo"
        FirebaseApp.configure(options: appOptions)
        
        print("Setting up Firebase emulator localhost:8080")
        
        let firestoreSettings = Firestore.firestore().settings
        firestoreSettings.host = "localhost:8080"
        firestoreSettings.isPersistenceEnabled = false
        firestoreSettings.isSSLEnabled = false
        Firestore.firestore().settings = firestoreSettings
        
        Auth.auth().useEmulator(withHost: "localhost", port: 9099)
        
        user =  FirebaseUser(basePath: "users", initialize: false)
    }

    func testSetUp() throws { }

}
