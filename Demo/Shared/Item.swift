//
//  DemoObject.swift
//  FireUI Demo
//
//  Created by Bri on 11/16/21.
//

import Foundation
import FireUI
import FirebaseFirestoreSwift

struct Item: FirestoreCodable {
    
    @DocumentID var id: String?
    
    var text: String
    
    var created: Date
    var updated: Date
    
    static func basePath() -> String {
        "items"
    }
}
