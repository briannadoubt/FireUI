//
//  FirestoreObserver.swift
//  FireUI
//
//  Created by Brianna Lee on 4/27/21.
//

#if os(WASI)
import SwiftWebUI
#else
import SwiftUI
#endif
import Combine
import Firebase

public protocol FirestoreObservable {
    var listener: ListenerRegistration? { get set }
    func setListener() throws
}

extension View {
    public func observe(_ observers: [FirestoreObservable], _ firebaseEnabled: Bool = true) -> some View {
        modifier(FirestoreObserver(observers: observers))
    }
    public func observe(_ observer: FirestoreObservable, _ firebaseEnabled: Bool = true) -> some View {
        modifier(FirestoreObserver(observer: observer))
    }
}

public struct FirestoreObserver: ViewModifier {

    private var firebaseEnabled = false
    
    private var observers: [FirestoreObservable]?
    private var observer: FirestoreObservable?
    
    public init(observers: [FirestoreObservable], _ firebaseEnabled: Bool = true) {
        self.observers = observers
        self.firebaseEnabled = firebaseEnabled
    }
    
    public init(observer: FirestoreObservable, _ firebaseEnabled: Bool = true) {
        self.observer = observer
        self.firebaseEnabled = firebaseEnabled
    }
    
    public func body(content: Content) -> some View {
        content.onAppear {
            guard firebaseEnabled else {
                return
            }
            do {
                try setObservers()
            } catch {
                print(error)
            }
        }
    }
    
    private func setObservers() throws {
        if let observers = observers {
            for observer in observers {
                try setListener(on: observer)
            }
        }
    }
    
    private func setListener(on observer: FirestoreObservable) throws {
        guard observer.listener == nil else {
            return
        }
        try observer.setListener()
    }
}
