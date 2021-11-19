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
    }
    
    private func setAuthentication(_ authenticated: Bool, uid: String?) {
        DispatchQueue.main.async {
            withAnimation {
                self.isAuthenticated = authenticated
                self.uid = uid
            }
        }
    }
    
    private var basePath: String
    private var authHandler: AuthStateDidChangeListenerHandle?
    
    private func stateDidChangeListener(auth: Auth, newUser: User?) {
        DispatchQueue.main.async {
            withAnimation {
                guard let newUser = newUser else {
                    self.setAuthentication(false, uid: nil)
                    return
                }
                self.setAuthentication(true, uid: newUser.uid)
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
        complete: @escaping (_ person: Human?, _ error: Error?) -> ()
    ) {
        if listener == nil {
            setListener()
        }
        
        guard nickname != "" else {
            complete(nil, FireUIError.missingNickname)
            return
        }
        guard email != "" else {
            complete(nil, FireUIError.missingEmailAddress)
            return
        }
        guard password != "" else {
            complete(nil, FireUIError.missingPassword)
            return
        }
        guard verifyPassword != "" else {
            complete(nil, FireUIError.missingPasswordVerification)
            return
        }
        guard password == verifyPassword else {
            complete(nil, FireUIError.failedPasswordVerification)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { snapshot, error in
            if let error = error {
                complete(nil, error)
                return
            }
            guard let user = snapshot?.user else {
                complete(nil, FireUIError.userNotFound)
                return
            }

            do {
                user.sendEmailVerification { error in
                    if let error = error {
                        complete(nil, error)
                        return
                    }
                }

                let person = newPerson(user.uid, self.email, self.nickname)
                
                try person.save()
                
                complete(person, nil)
            } catch {
                complete(nil, error)
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
    
    public func updateEmail(email: String, _ complete: @escaping (_ error: Error?) -> ()) {
        if listener == nil {
            setListener()
        }
        Auth.auth().currentUser?.updateEmail(to: email) { error in
            if let error = error {
                complete(error)
            }
            complete(nil)
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
    
    func signIn(_ complete: @escaping (_ error: Error?) -> ()) {
        if listener == nil {
            setListener()
        }
        
        if email.isEmpty {
            complete(FireUIError.missingEmailAddress)
        }

        if password.isEmpty {
            complete(FireUIError.missingPassword)
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { snapshot, error in
            if let error = error {
                complete(error)
                return
            }
            complete(nil)
        }
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
    
    func delete<Human: Person>(person: Human, _ complete: @escaping (_ error: Error?) -> ()) {
        if listener == nil {
            setListener()
        }
        guard let user = Auth.auth().currentUser else {
            complete(FireUIError.userNotFound)
            return
        }
        user.delete { error in
            if let error = error {
                complete(error)
                return
            }
        }
        do {
            try person.delete()
            complete(nil)
        } catch {
            complete(error)
        }
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
    
    private func updateUserProfile(
        displayName: String?,
        _ complete: @escaping (_ error: Error?) -> ()
    ) {
        if listener == nil {
            setListener()
        }
        guard let user = Auth.auth().currentUser else {
            complete(FireUIError.userNotFound)
            return
        }
        let changeRequest = user.createProfileChangeRequest()
        if let displayName = displayName {
            changeRequest.displayName = displayName
        }
        changeRequest.commitChanges { error in
            if let error = error {
                complete(error)
            }
        }
        complete(nil)
    }
}
