//
//  FireContentView.swift
//  FireUI
//
//  Created by Brianna Doubt on 10/15/21.
//

@_exported import SwiftUI

#if os(macOS)
public struct FireContentView<Human: Person, AppState: FireState, Content: View>: View {
    
    @EnvironmentObject private var user: FirebaseUser<AppState>
    @StateObject private var person: FirestoreDocument<Human>
    
    @ViewBuilder private let content: () -> Content
    
    public init(
        uid: PersonID,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._person = StateObject(wrappedValue: FirestoreDocument<Human>(collection: Human.basePath(), id: uid))
        self.content = content
    }
    
    public var body: some View {
        content()
            .observe(person)
            .environmentObject(person)
    }
}
#else
public struct FireContentView<Human: Person, AppState: FireState, Settings: View, Content: View>: View {
    
    @EnvironmentObject private var user: FirebaseUser<AppState>
    @StateObject private var person: FirestoreDocument<Human>
    
    @ViewBuilder private let content: () -> Content
    @ViewBuilder private let settings: (_ uid: String) -> FireSettingsView<Human, AppState, Settings>?
    
    private let uid: String
    
    public init(
        uid: PersonID,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder settings: @escaping (_ uid: String) -> FireSettingsView<Human, AppState, Settings>?
    ) {
        self.uid = uid
        self._person = StateObject(wrappedValue: FirestoreDocument<Human>(collection: Human.basePath(), id: uid))
        self.content = content
        self.settings = settings
    }
    
    public var body: some View {
        content()
            .observe(person)
            .environmentObject(person)
        settings(uid)
            .observe(person)
            .environmentObject(person)
    }
}
#endif
