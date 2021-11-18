//
//  Person.swift
//  FireUI
//
//  Created by Brianna Doubt on 10/11/21.
//

@_exported import Foundation
@_exported import FirebaseFirestoreSwift

public typealias PersonID = String

public protocol Person: FirestoreCodable {
    
    var nickname: String { get }
    var role: Role? { get }
    var email: String { get }
    
    associatedtype Role: PersonRole
    
    static func new(uid: PersonID, email: String, nickname: String) -> Self
}

public extension Person {
    
    typealias New = (_ uid: String, _ email: String, _ nickname: String) -> Self
//    typealias AsyncNew = (_ uid: String, _ email: String, _ nickname: String) async throws -> Self
    
}

/// The role of the person
public protocol PersonRole: Hashable, Identifiable, CaseIterable, Codable {
    var id: String { get }
    var title: String { get }
}
