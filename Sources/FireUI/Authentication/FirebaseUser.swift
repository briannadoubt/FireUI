//
//  FirebaseUser.swift
//  FireUI
//
//  Created by Brianna Doubt on 8/30/20.
//

import Foundation
import Firebase
#if os(WASI)
import SwiftWebUI
#else
import SwiftUI
#endif

public class FirebaseUser: ObservableObject, FirestoreObservable {

    @Published public var isAuthenticated: Bool = true
    @Published public var uid: String?
    
    @Published public var nickname = ""
    @Published public var email = ""
    @Published public var password = ""
    @Published public var verifyPassword = ""

    public var listener: ListenerRegistration?
    
    public init(basePath: String, initialize: Bool = false) {
        #if os(iOS)
        UINavigationBar.appearance().barTintColor = UIColor(Color("BackgroundColor"))
        #endif
        
        self.basePath = basePath
        
        if initialize {
            initializeFirebase()
        }
        
        self.isAuthenticated = Auth.auth().currentUser != nil
    }
    
    private var basePath: String
    private var authHandler: AuthStateDidChangeListenerHandle?
    
    private func initializeFirebase() {
        FirebaseApp.configure()
    }
    
    private func stateDidChangeListener(auth: Auth, user: User?) {
        withAnimation {
            guard let user = user else {
                self.isAuthenticated = false
                return
            }
            self.uid = user.uid
            self.isAuthenticated = true
        }
    }

    public func setListener() {
        Auth.auth().useAppLanguage()
        Auth.auth().addStateDidChangeListener(stateDidChangeListener(auth:user:))
    }

//    @available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *)
//    public func signUp<Human: Person>(newPerson: (_ uid: PersonID, _ email: String, _ nickname: String) async throws -> Human) async throws {
//        if nickname == "" {
//            throw FireUIError.missingNickname
//        }
//        if email == "" {
//            throw FireUIError.missingEmailAddress
//        }
//        if password == "" {
//            throw FireUIError.missingPassword
//        }
//        if verifyPassword == "" {
//            throw FireUIError.missingPasswordVerification
//        }
//        guard password == verifyPassword else {
//            throw FireUIError.failedPasswordVerification
//        }
//
//        let user = try await Auth.auth().createUser(withEmail: email, password: password).user
//
//        try await user.sendEmailVerification()
//        let changeRequest = user.createProfileChangeRequest()
//        changeRequest.displayName = nickname
//
//        let uid = user.uid
//
//        let person = try await newPerson(uid, email, nickname)
//        try person.save()
//    }
    
    public func signUp<Human: Person>(newPerson: (_ uid: PersonID, _ email: String, _ nickname: String) -> Human) throws {
        if nickname == "" {
            throw FireUIError.missingNickname
        }
        if email == "" {
            throw FireUIError.missingEmailAddress
        }
        if password == "" {
            throw FireUIError.missingPassword
        }
        if verifyPassword == "" {
            throw FireUIError.missingPasswordVerification
        }
        guard password == verifyPassword else {
            throw FireUIError.failedPasswordVerification
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { snapshot, error in
//            if let error = error {
//                print(error)
//                return
//            }
//            guard let uid = snapshot?.user.uid else {
//                print("no user")
//                return
//            }
//
//            let person = newPerson(uid, self.email, self.nickname)
//
//            do {
//                try person.save()
//            } catch {
//                print(error)
//            }
        }
    }

//    @available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *)
//    public func updateEmail(email: String) async throws {
//        try await Auth.auth().currentUser?.updateEmail(to: email)
//    }
    
    public func updateEmail(email: String) {
        Auth.auth().currentUser?.updateEmail(to: email)
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

//    @available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *)
//    func signIn() async throws {
//        if email.isEmpty {
//            throw FireUIError.missingEmailAddress
//        }
//
//        if password.isEmpty {
//            throw FireUIError.missingPassword
//        }
//
//        try await Auth.auth().signIn(withEmail: email, password: password)
//    }
    
    func signIn() throws {
        if email.isEmpty {
            throw FireUIError.missingEmailAddress
        }

        if password.isEmpty {
            throw FireUIError.missingPassword
        }
        
        Auth.auth().signIn(withEmail: email, password: password)
    }

//    @available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *)
//    func delete<Human: Person>(person: Human) async throws {
//        guard let user = Auth.auth().currentUser else {
//            throw FireUIError.userNotFound
//        }
//        try await user.delete()
//        try await person.delete()
//    }
    
    func delete<Human: Person>(person: Human) throws {
        guard let user = Auth.auth().currentUser else {
            throw FireUIError.userNotFound
        }
        user.delete()
        try person.delete()
    }

//    @available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *)
//    private func updateUserProfile(displayName: String?) async throws {
//        guard let user = Auth.auth().currentUser else {
//            throw FireUIError.userNotFound
//        }
//        let changeRequest = user.createProfileChangeRequest()
//        if let displayName = displayName {
//            changeRequest.displayName = displayName
//        }
//        try await changeRequest.commitChanges()
//    }
    
    private func updateUserProfile(displayName: String?) throws {
        guard let user = Auth.auth().currentUser else {
            throw FireUIError.userNotFound
        }
        let changeRequest = user.createProfileChangeRequest()
        if let displayName = displayName {
            changeRequest.displayName = displayName
        }
        changeRequest.commitChanges()
    }
}
