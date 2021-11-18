//
//  SwiftUIView.swift
//  
//
//  Created by Bri on 10/17/21.
//

#if os(WASI)
import SwiftWebUI
#else
import SwiftUI
#endif

public struct FirestoreDocumentView<Content: View, Document: FirestoreCodable>: View {
 
    @ObservedObject public var document: FirestoreDocument<Document>
    
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

public struct LazyFirestoreDocumentView<Content: View, Document: FirestoreCodable>: View {
    
    @StateObject public var document: FirestoreDocument<Document>
    
    let content: Content
    
    public init(_ collection: String, _ id: String, @ViewBuilder content: @escaping () -> Content) {
        _document = StateObject(wrappedValue: FirestoreDocument(collection: collection, id: id))
        self.content = content()
    }
    
    public var body: some View {
        content
            .observe(document)
    }
}
