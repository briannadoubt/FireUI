//
//  DemoPerson.swift
//  FireUI
//
//  Created by Brianna Doubt on 10/16/21.
//

import SwiftUI
import FireUI
import FirebaseFirestoreSwift

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
