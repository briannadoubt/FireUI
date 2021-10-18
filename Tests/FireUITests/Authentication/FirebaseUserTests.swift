import XCTest
#if os(WASI)
import SwiftWebUI
#else
import SwiftUI
#endif
import Firebase
@testable import FireUI

final class FirebaseUserTests: XCTestCase {
    
//    var user: FirebaseUser!
//
//    override func setUp() {
//        super.setUp()
//
//        print("Setting up Firebase emulator localhost:8080")
//        
//        let settings = Firestore.firestore().settings
//        settings.host = "localhost:8080"
//        settings.isPersistenceEnabled = false
//        settings.isSSLEnabled = false
//        Firestore.firestore().settings = settings
//
//        user = FirebaseUser(basePath: "users")
//    }
//
//    func testFirebaseIsInitialized() throws {
//        XCTAssert(FirebaseApp.app() != nil)
//    }
}
