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
    
//    @available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *)
//    func setListener() async throws
    
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
//            if #available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *) {
//                Task {
//                    do {
//                        try await setObservers()
//                    } catch {
//                        print(error)
//                    }
//                }
//            } else {
                do {
                    try setObservers()
                } catch {
                    print(error)
                }
//            }
        }
    }
    
//    @available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *)
//    private func setObservers() async throws {
//        if let observers = observers {
//            for observer in observers {
//                try await setListener(on: observer)
//            }
//        }
//        if let observer = observer {
//            try await setListener(on: observer)
//        }
//    }
    
    private func setObservers() throws {
        if let observers = observers {
            for observer in observers {
                try setListener(on: observer)
            }
        }
    }
    
//    @available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *)
//    private func setListener(on observer: FirestoreObservable) async throws {
//        guard observer.listener == nil else {
//            return
//        }
//        try await observer.setListener()
//    }
    
    private func setListener(on observer: FirestoreObservable) throws {
        guard observer.listener == nil else {
            return
        }
        try observer.setListener()
    }
}
