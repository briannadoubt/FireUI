//
//  DemoPerson.swift
//  FireUI
//
//  Created by Brianna Doubt on 10/16/21.
//

#if os(WASI)
import SwiftWebUI
#else
import SwiftUI
#endif

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
        FireScene<DemoContentView, DemoAppState> {
            DemoContentView()
        }
    }
}

class DemoAppState: FireState {
    
    var appName: String = "Demo App"
    
    @Published var selectedViewIdentifier: String?
    
    var appStyle: FireAppStyle = .default
    
    required init() { }
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
