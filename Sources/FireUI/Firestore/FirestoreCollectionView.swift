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

public struct FirestoreCollectionView<Content: View, Object: FirestoreCodable>: View {
 
    @ObservedObject public var objects: FirestoreCollection<Object>
    
    private let content: Content
    
    public init(_ path: String, @ViewBuilder content: @escaping () -> Content) {
        objects = FirestoreCollection(path)
        self.content = content()
    }
    
    public var body: some View {
        content
    }
}

//struct FirestoreCollectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        FirestoreCollectionView()
//    }
//}
