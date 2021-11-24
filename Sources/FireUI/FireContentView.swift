//
//  FireContentView.swift
//  FireUI
//
//  Created by Brianna Doubt on 10/15/21.
//

@_exported import SwiftUI

public struct FireContentView<Human: Person, Settings: View, Content: View>: View {
    
    @EnvironmentObject private var user: FirebaseUser
    @StateObject private var person: FirestoreDocument<Human>
    
    @ViewBuilder private let content: () -> Content
    @ViewBuilder private let settings: () -> FireSettingsView<Human, Settings>
    
    public init(
        uid: PersonID,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder settings: @escaping () -> FireSettingsView<Human, Settings>
    ) {
        self._person = StateObject(wrappedValue: FirestoreDocument<Human>(collection: Human.basePath(), id: uid))
        self.content = content
        self.settings = settings
    }
    
    public var body: some View {
        content()
            .observe(person)
            .environmentObject(person)
        settings()
            .observe(person)
            .environmentObject(person)
    }
}
