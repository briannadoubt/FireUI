//
//  SwiftUIView.swift
//  
//
//  Created by Bri on 10/17/21.
//

import SwiftUI

public struct FirestoreDocumentView<Content: View, Document: FirestoreCodable>: View {
 
    @ObservableObject public var document: FirestoreDocument<Document>
    
    let content: Content
    
    public init(_ collection: String, _ id: String, @ViewBuilder content: @escaping () -> Content) {
        document = FirestoreDocument(collection: collection, id: id)
        self.content = content()
    }
    
    public var body: some View {
        content
            .observe(document)
            .environmentObject(document)
    }
}

public struct LazyFirestoreDocumentView: View {
    
    @StateObject public var object: FirestoreDocument<Object>
    
    public init(_ collection: String, _ id: String) {
        object = StateObject(wrappedValue: FirestoreDocument(collection: collection, id: id))
    }
    
    public var body: some View {
        NavigationView {
            Text(object.document?.text ?? "")
                .observe(object) { newValue in
                    
                }
        }
    }
}

struct FirestoreDocumentView_Previews: PreviewProvider {
    static var previews: some View {
        FirestoreDocumentView()
    }
}
