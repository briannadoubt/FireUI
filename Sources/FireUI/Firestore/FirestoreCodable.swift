//
//  FirebaseObservable.swift
//  Pods
//
//  Created by Brianna Doubt on 9/7/20.
//

import Firebase

public protocol FirestoreCodable: Identifiable, Codable, Hashable, Timestamped {
    var id: String? { get set }
    static func basePath() -> String
}

extension FirestoreCodable {
    
    /// Save the current state of `self` to Firestore with the path `self.basePath() + "/" + self.id`
    public func save() throws {
        guard let path = defaultPath() else {
            try Firestore.firestore().collection(Self.basePath()).document().setData(from: self, merge: true)
            return
        }
        try Firestore.firestore().document(path).setData(from: self, merge: true)
    }

    /// Set a value to the given key. This will throw an error if the new value's type does not match the value's of the same keypath on this object.
    @available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *)
    public func set(_ key: String, value: Any) async throws {
        let data = [key: value, "updated": Date()]
        guard let path = defaultPath() else {
            throw FireUIError.IdNotFound
        }
        try await Firestore.firestore().document(path).updateData(data)
    }
    
    public func set(_ key: String, value: Any) throws {
        let data = [key: value, "updated": Date()]
        guard let path = defaultPath() else {
            throw FireUIError.IdNotFound
        }
        Firestore.firestore().document(path).updateData(data)
    }

    /// Delete the object from Firestore
    @available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *)
    public func delete() async throws {
        guard let path = defaultPath() else {
            throw FireUIError.IdNotFound
        }
        try await Firestore.firestore().document(path).delete()
    }
    
    public func delete() throws {
        guard let path = defaultPath() else {
            throw FireUIError.IdNotFound
        }
        Firestore.firestore().document(path).delete()
    }
}

extension FirestoreCodable {
    
    private func defaultPath() -> String? {
        guard let id = id else {
            return nil
        }
        return Self.basePath() + "/" + id
    }
}
