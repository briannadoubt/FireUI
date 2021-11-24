//
//  FireSettingsView.swift
//  FireUI
//
//  Created by Brianna Doubt on 11/19/21.
//

@_exported import SwiftUI

public struct FireSettingsView<Human: Person, Settings: View>: View {
    
    @EnvironmentObject private var user: FirebaseUser
    @StateObject private var person: FirestoreDocument<Human>
    
    @ViewBuilder private let settings: () -> Settings
    
    public init(uid: PersonID, @ViewBuilder settings: @escaping () -> Settings) {
        self._person = StateObject(wrappedValue: FirestoreDocument<Human>(collection: Human.basePath(), id: uid))
        self.settings = settings
    }
    
    public var body: some View {
        settings()
            .observe(person)
            .environmentObject(person)
    }
}

//struct FireSettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        FireSettingsView<<#Human: Person#>, <#Settings: View#>>()
//    }
//}
