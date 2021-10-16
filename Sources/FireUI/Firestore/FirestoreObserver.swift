//
//  FirestoreObserver.swift
//  Affirmate
//
//  Created by Brianna Lee on 4/27/21.
//

import SwiftUI
import Firebase

@available(iOS 13.0, *)
public struct FirestoreObserver: ViewModifier {

    private var observers: [FirestoreObservable]?
    private var observer: FirestoreObservable?
    
    init(observers: [FirestoreObservable]) {
        self.observers = observers
    }
    
    init(observer: FirestoreObservable) {
        self.observer = observer
    }
    
    public func body(content: Content) -> some View {
        content.onAppear {
            Task {
                do {
                    try await setObservers()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    private func setObservers() async throws {
        if let observers = observers {
            for observer in observers {
                try await setListener(on: observer)
            }
        }
        if let observer = observer {
            try await setListener(on: observer)
        }
    }
    
    private func setListener(on observer: FirestoreObservable) async throws {
        guard observer.listener == nil else {
            return
        }
        try await observer.setListener()
    }
}

protocol FirestoreObservable {
    var listener: ListenerRegistration? { get set }
    func setListener() async throws
}

extension View {
    func observe(_ observers: [FirestoreObservable]) -> some View {
        modifier(FirestoreObserver(observers: observers))
    }
    func observe(_ observer: FirestoreObservable) -> some View {
        modifier(FirestoreObserver(observer: observer))
    }
}
