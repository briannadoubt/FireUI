//
//  DocumentObserver.swift
//  FireUI
//
//  Created by Brianna Doubt on 10/11/21.
//

import SwiftUI

struct DocumentObserver<Document: FirestoreCodable>: ViewModifier {
    
    @ObservedObject private var document: FirestoreDocument<Document>
    var newValue: (_ newValue: Document) -> ()
    
    init(collection: String, id: String, newValue: @escaping (_ newValue: Document) -> ()) {
        document = FirestoreDocument<Document>(collection: collection, id: id)
        self.newValue = newValue
    }
    
    func body(content: Content) -> some View {
        content.observe(document)
    }
}

extension View {
    func observe<Document: FirestoreCodable>(collection: String, id: String, newValue: @escaping (_ newValue: Document) -> ()) -> some View {
        modifier(DocumentObserver<Document>(collection: collection, id: id, newValue: newValue))
    }
}
