//
//  FirestoreDocument.swift
//  FireUI
//
//  Created by Brianna Lee on 10/15/20.
//

@_exported import Foundation
@_exported import Firebase
@_exported import FirebaseFirestoreSwift
@_exported import SwiftUI

public typealias DocumentPath = String

public class FirestoreDocument<T: FirestoreCodable>: ObservableObject, FirestoreObservable {
    
    @available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *)
    public var lazyDocument: T {
        get async throws {
            print(id ?? "No ID")
            let reference = id == nil ? database.collection(collection).document() : database.collection(collection).document(id!)
            guard let document = try await reference.getDocument().data(as: T.self) else {
                throw FireUIError.documentNotFound
            }
            return document
        }
    }
    
    @Published public var document: T? = nil
    @Published public var error: Error? = nil

    private var collection: String
    private var id: String?
    private var database = Firestore.firestore()
    
    public var listener: ListenerRegistration? = nil

    public init(collection: String, id: String?) {
        self.collection = collection
        self.id = id
    }
    
    deinit {
        listener?.remove()
    }

    public func removeListener() {
        if let listener = listener {
            listener.remove()
        }
    }
    
    public func setListener() {
        let document = id == nil
            ? database.collection(collection).document()
            : database.collection(collection).document(id!)
        
        listener = document.addSnapshotListener { snapshot, error in
            do {
                guard error == nil else {
                    throw error!
                }
                guard let snapshot = snapshot, snapshot.exists else {
                    throw FireUIError.documentNotFound
                }
                self.document = try snapshot.data(as: T.self)
            } catch {
                withAnimation {
                    self.error = error
                }
            }
        }
    }
}
