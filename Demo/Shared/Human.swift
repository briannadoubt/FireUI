//
//  DemoPerson.swift
//  FireUI
//
//  Created by Brianna Doubt on 10/16/21.
//

import FireUI
import FirebaseFirestoreSwift
import Foundation

struct Human: Person {
    
    @DocumentID var id: PersonID?
    
    var nickname: String
    var role: Role?
    var email: String
    
    var created: Date
    var updated: Date
    
    static func basePath() -> String {
        "humans"
    }
    
    static func new(uid: PersonID, email: String, nickname: String) -> Human {
        Human(
            id: uid,
            nickname: nickname,
            email: email,
            created: Date(),
            updated: Date()
        )
    }
}

enum Role: String, PersonRole {
    case test
    var id: String { rawValue }
    var title: String { rawValue.localizedCapitalized }
}
