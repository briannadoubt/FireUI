//
//  FirestoreDocument.swift
//  FireUI
//
//  Created by Brianna Lee on 10/15/20.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift   
import SwiftUI

public typealias DocumentPath = String

public class FirestoreDocument<T: FirestoreCodable>: ObservableObject, FirestoreObservable {
    
//    @available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *)
//    public var lazyDocument: T {
//        get async throws {
//            print(id ?? "No ID")
//            let reference = id == nil ? database.collection(collection).document() : database.collection(collection).document(id!)
//            guard let document = try await reference.getDocument().data(as: T.self) else {
//                throw FireUIError.documentNotFound
//            }
//            return document
//        }
//    }
    
    @Published public var document: T? = nil

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
    
//    @available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *)
//    public func setListener() async throws {
//        let document = id == nil ? database.collection(collection).document() : database.collection(collection).document(id!)
//        return try await withCheckedThrowingContinuation { continuation in
//            listener = document.addSnapshotListener { snapshot, error in
//                if let error = error {
//                    continuation.resume(throwing: error)
//                    return
//                }
//
//                guard let snapshot = snapshot, snapshot.exists else {
//                    continuation.resume(throwing: FireUIError.documentNotFound)
//                    return
//                }
//
//                do {
//                    self.publishedDocument = try snapshot.data(as: T.self)
//                } catch {
//                    continuation.resume(throwing: error)
//                }
//            }
//        }
//    }
    
    public func setListener() throws {
        let document = id == nil
            ? database.collection(collection).document()
            : database.collection(collection).document(id!)
        
        listener = document.addSnapshotListener { snapshot, error in
            if let error = error {
                print(error)
                return
            }

            guard let snapshot = snapshot, snapshot.exists else {
                print(FireUIError.documentNotFound)
                return
            }

            do {
                self.document = try snapshot.data(as: T.self)
            } catch {
                print(error)
            }
        }
    }
}
