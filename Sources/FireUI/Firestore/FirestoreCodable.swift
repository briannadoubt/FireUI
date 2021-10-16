//
//  FirebaseObservable.swift
//  Pods
//
//  Created by Brianna Zamora on 9/7/20.
//

import Firebase

@available(iOS 13, *)
public protocol FirestoreCodable: Identifiable, Codable, Hashable, Timestamped {
    var id: String? { get set }
    func basePath() -> String
}

@available(iOS 15.0.0, *)
extension FirestoreCodable {
    
    /// Save the current state of `self` to Firestore with the path `self.basePath() + "/" + self.id`
    public func save() throws {
        guard let path = defaultPath() else {
            try Firestore.firestore().collection(basePath()).document().setData(from: self, merge: true)
            return
        }
        try Firestore.firestore().document(path).setData(from: self, merge: true)
    }

    /// Set a value to the given key. This will throw an error if the new value's type does not match the value's of the same keypath on this object.
    public func set(_ key: String, value: Any) async throws {
        let data = [key: value, "updated": Date()]
        guard let path = defaultPath() else {
            throw FireUIError.IdNotFound
        }
        try await Firestore.firestore().document(path).updateData(data)
    }

    /// Delete the object from Firestore
    public func delete() async throws {
        guard let path = defaultPath() else {
            throw FireUIError.IdNotFound
        }
        try await Firestore.firestore().document(path).delete()
    }
}

@available(iOS 13, *)
extension FirestoreCodable {
    
    private func defaultPath() -> String? {
        guard let id = id else {
            return nil
        }
        return basePath() + "/" + id
    }
}