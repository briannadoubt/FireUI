//
//  SwiftUIView.swift
//  
//
//  Created by Bri on 11/26/21.
//

import SwiftUI

public struct FirestoreDocumentView<Document: FirestoreCodable, AppState: FireState, Content: View>: View {
    
    @ViewBuilder fileprivate var content: (_ document: Document) -> Content
    @ObservedObject fileprivate var document: FirestoreDocument<Document>
    
    public init(
        collection: String,
        id: String,
        @ViewBuilder content: @escaping (_ document: Document) -> Content
    ) {
        self.content = content
        self.document = FirestoreDocument<Document>(collection: collection, id: id)
    }
    
    public var body: some View {
        StyledView(state: AppState.self) {
            if let doc = document.document {
                content(doc)
            }
        }
        .observe(document)
    }
}

//struct FirestoreDocumentView_Previews: PreviewProvider {
//    static var previews: some View {
//        FirestoreDocumentView(
//            collection: "previewItems",
//            id: "preview0"
//        ) { document in
//
//        }
//    }
//}
