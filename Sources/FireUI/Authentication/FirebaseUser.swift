//
//  FirebaseUser.swift
//  FireUI
//
//  Created by Brianna Doubt on 8/30/20.
//

@_exported import Foundation
@_exported import Firebase
@_exported import SwiftUI

public class FirebaseUser<AppState: FireState>: ObservableObject, FirestoreObservable {
    
    @Published public var uid: String?
    
    @Published public var nickname = ""
    @Published public var email = ""
    @Published public var password = ""
    @Published public var verifyPassword = ""

    public var listener: ListenerRegistration?
    
    public init(basePath: String) {
        self.basePath = basePath
    }
    
    private var basePath: String
    private var authHandler: AuthStateDidChangeListenerHandle?
    
    private func stateDidChangeListener(auth: Auth, newUser: User?) {
        DispatchQueue.main.async {
            withAnimation {
                self.uid = newUser?.uid
//                if let uid = self.uid {
//                    FireWindows<AppState>.content(uid).open(closeCurrentWindow: true)
//                }
            }
        }
        if let user = newUser {
            print("User is authenticated")
            print(user.uid)
            
        } else {
            print("User is not authenticated")
            DispatchQueue.main.async {
                withAnimation {
                    self.uid = nil
//                    FireWindows<AppState>.auth.open(closeCurrentWindow: true)
                }
            }
        }
    }

    public func setListener() throws {
        Auth.auth().useAppLanguage()
//        Auth.auth().shareAuthStateAcrossDevices = true
//        try Auth.auth().useUserAccessGroup("group." + AppState.appName)
        authHandler = Auth.auth().addStateDidChangeListener(stateDidChangeListener)
    }
    
    public func signOut() throws {
        if listener == nil {
            try setListener()
        }
        try Auth.auth().signOut()
    }
}

// MARK: async versions

@available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *)
public extension FirebaseUser {
    
    func signUp<Human: Person>(newPerson: (_ uid: PersonID, _ email: String, _ nickname: String) async throws -> Human) async throws {
        
        if listener == nil {
            try setListener()
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
    
    func signIn() async throws {
        if listener == nil {
            try setListener()
        }
        
        if email.isEmpty {
            throw FireUIError.missingEmailAddress
        }

        if password.isEmpty {
            throw FireUIError.missingPassword
        }

        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func updateEmail(email: String) async throws {
        if listener == nil {
            try setListener()
        }
        try await Auth.auth().currentUser?.updateEmail(to: email)
    }
    
    func delete<Human: Person>(_ human: Human.Type = Human.self) async throws {
        if listener == nil {
            try setListener()
        }
        guard let user = Auth.auth().currentUser else {
            throw FireUIError.userNotFound
        }
        guard let uid = uid else {
            throw FireUIError.userNotFound
        }
        let person = FirestoreDocument<Human>(collection: Human.basePath(), id: uid)
        try await user.delete()
        try await person.document?.delete()
    }
    
    func updateUserProfile(displayName: String?) async throws {
        if listener == nil {
            try setListener()
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
}

// MARK: Completion handler API
extension FirebaseUser {
    
    typealias SignUpComplete<Human: Person> = (_ person: Human?, _ error: Error?) -> ()
    typealias CompleteWithError = (_ error: Error?) -> ()
    
    func signUp<Human: Person>(newPerson: @escaping Human.New = Human.new, complete: @escaping SignUpComplete<Human>) {
        if listener == nil {
            do {
                try setListener()
            } catch {
                complete(nil, error)
                return
            }
        }
        
        if nickname == "" {
            complete(nil, FireUIError.missingNickname)
            return
        }
        if email == "" {
            complete(nil, FireUIError.missingEmailAddress)
            return
        }
        if password == "" {
            complete(nil, FireUIError.missingPassword)
            return
        }
        if verifyPassword == "" {
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
    
    func updateEmail(email: String, _ complete: @escaping CompleteWithError) {
        if listener == nil {
            do {
                try setListener()
            } catch {
                complete(error)
                return
            }
        }
        Auth.auth().currentUser?.updateEmail(to: email) { error in
            if let error = error {
                complete(error)
            }
            complete(nil)
        }
    }
    
    func signIn(_ complete: @escaping CompleteWithError) {
        if listener == nil {
            do {
                try setListener()
            } catch {
                complete(error)
                return
            }
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
    
    func delete<Human: Person>(_ human: Human.Type = Human.self, _ complete: @escaping CompleteWithError) {
        if listener == nil {
            do {
                try setListener()
            } catch {
                complete(error)
                return
            }
        }
        guard let user = Auth.auth().currentUser else {
            complete(FireUIError.userNotFound)
            return
        }
        guard let uid = uid else {
            complete(FireUIError.userNotFound)
            return
        }
        let person = FirestoreDocument<Human>(collection: Human.basePath(), id: uid)
        user.delete { error in
            if let error = error {
                complete(error)
                return
            }
        }
        do {
            try person.document?.delete()
            complete(nil)
        } catch {
            complete(error)
        }
    }
    
    func updateUserProfile(displayName: String?, _ complete: @escaping CompleteWithError) {
        if listener == nil {
            do {
                try setListener()
            } catch {
                complete(error)
                return
            }
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
