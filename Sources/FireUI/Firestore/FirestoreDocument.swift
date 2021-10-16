//
//  FirestoreDocument.swift
//  Phi
//
//  Created by Brianna Lee on 10/15/20.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift   
import SwiftUI

public typealias DocumentPath = String

/// A generic 
@available(iOS 15.0.0, *)
public class FirestoreDocument<T: FirestoreCodable>: ObservableObject, FirestoreObservable {
    
    var lazyDocument: T {
        get async throws {
            print(id ?? "No ID")
            let reference = id == nil ? database.collection(collection).document() : database.collection(collection).document(id!)
            guard let document = try await reference.getDocument().data(as: T.self) else {
                throw FireUIError.documentNotFound
            }
            return document
        }
    }
    @Published var publishedDocument: T? = nil

    private var collection: String
    private var id: String?
    private var database = Firestore.firestore()
    
    internal var listener: ListenerRegistration? = nil

    public init(collection: String, id: String?) {
        self.collection = collection
        self.id = id
    }
    
    deinit {
        listener?.remove()
    }

    internal func removeListener() {
        if let listener = listener {
            listener.remove()
        }
    }

    internal func setListener() async throws {
        let document = id == nil ? database.collection(collection).document() : database.collection(collection).document(id!)
        return try await withCheckedThrowingContinuation { continuation in
            listener = document.addSnapshotListener { snapshot, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let snapshot = snapshot, snapshot.exists else {
                    continuation.resume(throwing: FireUIError.documentNotFound)
                    return
                }

                do {
                    self.publishedDocument = try snapshot.data(as: T.self)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
