//
//  FireContentView.swift
//  Twerking Girl
//
//  Created by Bri on 10/15/21.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
struct FireContentView<Human: Person, Content: View>: View {
    
    @EnvironmentObject private var user: FirebaseUser
    @ObservedObject private var person: FirestoreDocument<Human>
    
    private let content: Content
    
    init(personBasePath: String, uid: PersonID, @ViewBuilder content: @escaping () -> Content) {
        self.person = FirestoreDocument(collection: personBasePath , id: uid)
        self.content = content()
    }
    
    var body: some View {
        content
            .observe(person)
            .environmentObject(person)
    }
}

//struct FireContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        FireContentView()
//    }
//}
