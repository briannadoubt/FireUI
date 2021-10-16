import XCTest
import SwiftUI
import FirebaseFirestoreSwift

@testable import FireUI

final class FireUITests: XCTestCase {
    
    var user: FirebaseUser!

    override func setUp() {
        XCUIApplication().launch()
        user = FirebaseUser(basePath: "users")
        print("Setting up Firebase emulator localhost:8080")
        let firestoreSettings = Firestore.firestore().settings
        firestoreSettings.host = "localhost:8080"
        firestoreSettings.isPersistenceEnabled = false
        firestoreSettings.isSSLEnabled = false
        Firestore.firestore().settings = firestoreSettings
    }

    func testSetUp() throws { }

    struct TestPerson: Person {
        
        @DocumentID var id: PersonID?
        
        var nickname = "Test"
        var role: TestRole?
        var email: String = "test@test.com"
        
        var created: Date = Date()
        var updated: Date = Date()
        
        func basePath() -> String {
            "users"
        }
        
        static func new(uid: PersonID, email: String, nickname: String) -> TestPerson {
            TestPerson(
                id: uid,
                nickname: nickname,
                email: email
            )
        }
    }

    enum TestRole: String, PersonRole {
        case test
        var id: String { rawValue }
        var title: String { rawValue }
    }
}
