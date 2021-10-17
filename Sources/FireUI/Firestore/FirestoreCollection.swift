//
//  FirestoreCollection.swift
//  FireUI
//
//  Created by Brianna Lee on 10/15/20.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

typealias CollectionPath = String

class FirestoreCollection<T: FirestoreCodable>: ObservableObject, FirestoreObservable {

    @Published var collection: [T] = []
    @Published var error: Error?
    
    var listener: ListenerRegistration?
    
    private var path: String
    private var whereField: String?
    private var isEqualTo: Any?
    private var database = Firestore.firestore()

    init(_ path: String) {
        self.path = path
    }
    
    init(_ path: String, whereField: String, isEqualTo: Any) {
        self.path = path
        self.whereField = whereField
        self.isEqualTo = isEqualTo
    }
    
    deinit {
        listener?.remove()
    }
    
    private func handle(querySnapshot: QuerySnapshot?, error: Error?) {
        do {
            if let error = error {
                throw error
            }
            guard let documents = querySnapshot?.documents else {
                throw FireUIError.documentNotFound
            }
            self.collection = try documents.compactMap({ try $0.data(as: T.self) })
        } catch {
            print(error)
            self.error = error
        }
    }

    func setListener() {
        var query: Query
        let collection = database.collection(path)
        if let field = whereField, let value = isEqualTo {
            query = collection.whereField(field, isEqualTo: value)
        } else {
            query = collection
        }
        listener = query
            .addSnapshotListener { snapshot, error in
                self.handle(querySnapshot: snapshot, error: error)
            }
    }
}
