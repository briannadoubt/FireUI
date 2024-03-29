//
//  Item.swift
//  FireUI Demo
//
//  Created by Bri on 11/16/21.
//

import FireUI

struct Item: FirestoreCodable {
    
    @DocumentID var id: String?
    
    var text: String
    
    var created: Date
    var updated: Date
    
    static func basePath() -> String {
        "items"
    }
}
