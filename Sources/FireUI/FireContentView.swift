//
//  FireContentView.swift
//  FireUI
//
//  Created by Brianna Doubt on 10/15/21.
//

#if os(WASI)
import SwiftWebUI
#else
import SwiftUI
#endif

public struct FireContentView<Human: Person, Content: View>: View {
    
    @EnvironmentObject private var user: FirebaseUser
    @ObservedObject private var person: FirestoreDocument<Human>
    
    private let content: Content
    
    public init(personBasePath: String, uid: PersonID, @ViewBuilder content: @escaping () -> Content) {
        self.person = FirestoreDocument(collection: personBasePath , id: uid)
        self.content = content()
    }
    
    public var body: some View {
        content
            .observe(person)
            .environmentObject(person)
    }
}

struct FireContentView_Previews: PreviewProvider {
    static var previews: some View {
        FireContentView<DemoPerson, DemoContentView>(personBasePath: "users", uid: "test") {
            DemoContentView()
        }
    }
}
