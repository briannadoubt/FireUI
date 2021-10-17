//
//  Person.swift
//  FireUI
//
//  Created by Brianna Doubt on 10/11/21.
//

import Foundation
import FirebaseFirestoreSwift

public typealias PersonID = String

public protocol Person: FirestoreCodable {
    
    var nickname: String { get }
    var role: Role? { get }
    var email: String { get }
    
    associatedtype Role: PersonRole
    
    static func new(uid: PersonID, email: String, nickname: String) -> Self
}

/// The role of the person
public protocol PersonRole: Hashable, Identifiable, CaseIterable, Codable {
    var id: String { get }
    var title: String { get }
}
