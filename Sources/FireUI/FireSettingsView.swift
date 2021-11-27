//
//  FireSettingsView.swift
//  FireUI
//
//  Created by Brianna Doubt on 11/19/21.
//

@_exported import SwiftUI

public struct FireSettingsView<Human: Person, AppState: FireState, Settings: View>: View {
    
    @EnvironmentObject private var user: FirebaseUser<AppState>
    @StateObject private var person: FirestoreDocument<Human>
    private let uid: String
    
    @ViewBuilder private let settings: (_ person: FirestoreDocument<Human>) -> Settings
    
    public init(
        uid: PersonID,
        @ViewBuilder settings: @escaping (_ uid: String?) -> Settings
    ) {
        self.uid = uid
        let personDocument = FirestoreDocument<Human>(
            collection: Human.basePath(),
            id: uid
        )
        self._person = StateObject(wrappedValue: personDocument)
        self.settings = { person in
            settings(person.id)
        }
    }
    
    public var body: some View {
        settings(person)
            .observe(person)
            .environmentObject(person)
    }
}

//struct FireSettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        FireSettingsView<<#Human: Person#>, <#Settings: View#>>()
//    }
//}
