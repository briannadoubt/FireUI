//
//  FirestoreObserver.swift
//  FireUI
//
//  Created by Brianna Lee on 4/27/21.
//

@_exported import SwiftUI
@_exported import Combine
@_exported import Firebase

public protocol FirestoreObservable {
    var listener: ListenerRegistration? { get set }
    func setListener() throws
}

extension View {
    public func observe(_ observers: [FirestoreObservable]) -> some View {
        modifier(FirestoreObserver(observers: observers))
    }
    public func observe(_ observer: FirestoreObservable) -> some View {
        modifier(FirestoreObserver(observer: observer))
    }
}

public struct FirestoreObserver: ViewModifier {
    
    private var observers: [FirestoreObservable]?
    private var observer: FirestoreObservable?
    
    public init(observers: [FirestoreObservable]) {
        self.observers = observers
    }
    
    public init(observer: FirestoreObservable) {
        self.observer = observer
    }
    
    public func body(content: Content) -> some View {
        content.onAppear {
            do {
                try setObservers()
            } catch let error as FireUIError {
                assertionFailure(error.localizedDescription)
                Crashlytics.crashlytics().record(error: error)
            } catch {
                assertionFailure(error.localizedDescription)
                Crashlytics.crashlytics().record(error: error)
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
