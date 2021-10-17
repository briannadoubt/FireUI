//
//  DemoPerson.swift
//  FireUI
//
//  Created by Brianna Doubt on 10/16/21.
//

import SwiftUI
import FirebaseFirestoreSwift

struct DemoFireUIApp: App {
    
    func newPerson(uid: String, email: String, nickname: String) -> DemoPerson {
        // Add your other initial custom models as needed here
        return DemoPerson(
            id: uid,
            nickname: nickname,
            role: DemoRole.test,
            email: email,
            created: Date(),
            updated: Date()
        )
    }
    
    var body: some Scene {
        WindowGroup {
            Client(personBasePath: "users") {
                AuthenticationView(
                    image: { Image(systemName: "sparkles") },
                    newPerson: newPerson,
                    footer: { Text("FireUI Demo") })
            } content: {
                DemoContentView()
            }
        }
    }
}

struct DemoContentView: View {
    var body: some View {
        Text("Hello, World!")
            .padding()
    }
}

struct DemoPerson: Person {
    
    @DocumentID var id: PersonID?
    
    var nickname = "Test"
    var role: DemoRole?
    var email: String = "test@test.com"
    
    var created: Date = Date()
    var updated: Date = Date()
    
    func basePath() -> String {
        "users"
    }
    
    static func new(uid: PersonID, email: String, nickname: String) -> DemoPerson {
        DemoPerson(
            id: uid,
            nickname: nickname,
            email: email
        )
    }
}

enum DemoRole: String, PersonRole {
    case test
    var id: String { rawValue }
    var title: String { rawValue.localizedCapitalized }
}
