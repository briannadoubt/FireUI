//
//  FireContentView.swift
//  FireUI
//
//  Created by Brianna Doubt on 10/15/21.
//

@_exported import SwiftUI

public struct FireContentView<Human: Person, Content: View>: View {
    
    @EnvironmentObject private var user: FirebaseUser
    @StateObject private var person: FirestoreDocument<Human>
    
    @ViewBuilder private let content: () -> Content
    
    public init(uid: PersonID, @ViewBuilder content: @escaping () -> Content) {
        self._person = StateObject(wrappedValue: FirestoreDocument<Human>(collection: Human.basePath(), id: uid))
        self.content = content
    }
    
    public var body: some View {
        AnyView {
            content()
        }
        .observe(person)
        .environmentObject(person)
    }
}
