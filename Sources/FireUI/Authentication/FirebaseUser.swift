//
//  FirebaseUser.swift
//  FireUI
//
//  Created by Brianna Doubt on 8/30/20.
//

@_exported import Foundation
@_exported import Firebase
@_exported import SwiftUI

public class FirebaseUser: ObservableObject, FirestoreObservable {

    @Published public var isAuthenticated: Bool = false
    @Published public var uid: String?
    
    @Published public var nickname = ""
    @Published public var email = ""
    @Published public var password = ""
    @Published public var verifyPassword = ""

    public var listener: ListenerRegistration?
    
    public init(basePath: String) {
        self.basePath = basePath
        if FirebaseApp.app() != nil && Auth.auth().currentUser != nil {
            self.isAuthenticated = true
        }
    }
    
    private var basePath: String
    private var authHandler: AuthStateDidChangeListenerHandle?
    
    private func stateDidChangeListener(auth: Auth, newUser: User?) {
        DispatchQueue.main.async {
            withAnimation {
                guard let newUser = newUser else {
                    self.uid = nil
                    self.isAuthenticated = false
                    return
                }
                self.uid = newUser.uid
                self.isAuthenticated = true
            }
        }
    }

    public func setListener() {
        Auth.auth().useAppLanguage()
        authHandler = Auth.auth().addStateDidChangeListener(stateDidChangeListener)
    }

    @available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *)
    public func signUp<Human: Person>(newPerson: (_ uid: PersonID, _ email: String, _ nickname: String) async throws -> Human) async throws {
        
        if listener == nil {
            setListener()
        }
        
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

        let user = try await Auth.auth().createUser(withEmail: email, password: password).user

        try await user.sendEmailVerification()
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = nickname

        let uid = user.uid

        let person = try await newPerson(uid, email, nickname)
        try person.save()
    }
    
    public func signUp<Human: Person>(
        newPerson: @escaping (_ uid: PersonID, _ email: String, _ nickname: String) -> Human = Human.new,
        complete: ((_ person: Human?, _ error: Error?) -> ())? = nil
    ) {
        if listener == nil {
            setListener()
        }
        
        guard nickname != "" else {
            complete?(nil, FireUIError.missingNickname)
            return
        }
        guard email != "" else {
            complete?(nil, FireUIError.missingEmailAddress)
            return
        }
        guard password != "" else {
            complete?(nil, FireUIError.missingPassword)
            return
        }
        guard verifyPassword != "" else {
            complete?(nil, FireUIError.missingPasswordVerification)
            return
        }
        guard password == verifyPassword else {
            complete?(nil, FireUIError.failedPasswordVerification)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { snapshot, error in
            if let error = error {
                complete?(nil, error)
                Crashlytics.crashlytics().record(error: error)
                return
            }
            guard let uid = snapshot?.user.uid else {
                complete?(nil, FireUIError.userNotFound)
                Crashlytics.crashlytics().record(error: FireUIError.userNotFound)
                return
            }

            let person = newPerson(uid, self.email, self.nickname)

            do {
                try person.save()
                complete?(person, nil)
            } catch {
                complete?(nil, error)
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }

    @available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *)
    public func updateEmail(email: String) async throws {
        if listener == nil {
            setListener()
        }
        try await Auth.auth().currentUser?.updateEmail(to: email)
    }
    
    public func updateEmail(email: String) {
        if listener == nil {
            setListener()
        }
        Auth.auth().currentUser?.updateEmail(to: email) { error in
            if let error = error {
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }

    func signOut() throws {
        if listener == nil {
            setListener()
        }
        try Auth.auth().signOut()
    }

    @available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *)
    func signIn() async throws {
        if listener == nil {
            setListener()
        }
        
        if email.isEmpty {
            throw FireUIError.missingEmailAddress
        }

        if password.isEmpty {
            throw FireUIError.missingPassword
        }

        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func signIn() throws {
        if listener == nil {
            setListener()
        }
        
        if email.isEmpty {
            throw FireUIError.missingEmailAddress
        }

        if password.isEmpty {
            throw FireUIError.missingPassword
        }
        
        Auth.auth().signIn(withEmail: email, password: password)
    }

    @available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *)
    func delete<Human: Person>(person: Human) async throws {
        if listener == nil {
            setListener()
        }
        guard let user = Auth.auth().currentUser else {
            throw FireUIError.userNotFound
        }
        try await user.delete()
        try await person.delete()
    }
    
    func delete<Human: Person>(person: Human) throws {
        if listener == nil {
            setListener()
        }
        guard let user = Auth.auth().currentUser else {
            throw FireUIError.userNotFound
        }
        user.delete()
        try person.delete()
    }

    @available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *)
    private func updateUserProfile(displayName: String?) async throws {
        if listener == nil {
            setListener()
        }
        guard let user = Auth.auth().currentUser else {
            throw FireUIError.userNotFound
        }
        let changeRequest = user.createProfileChangeRequest()
        if let displayName = displayName {
            changeRequest.displayName = displayName
        }
        try await changeRequest.commitChanges()
    }
    
    private func updateUserProfile(displayName: String?) throws {
        if listener == nil {
            setListener()
        }
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
