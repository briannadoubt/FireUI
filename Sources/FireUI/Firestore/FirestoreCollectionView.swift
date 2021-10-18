//
//  SwiftUIView.swift
//  
//
//  Created by Bri on 10/17/21.
//

import SwiftUI

public struct FirestoreCollectionView<Content: View>: View {
 
    @ObservableObject public var objects: FirestoreCollection<Object>
    
    private let content: Content
    
    public init(_ path: String, @ViewBuilder content: @escaping () -> Content) {
        objects = FirestoreCollection(path)
        self.content = content()
    }
    
    public var body: some View {
        content
    }
}

public struct StaticFirestoreCollectionView: View {
    
    @StateObject public var objects: FirestoreCollection<Object>
    
    private let content: Content
    
    public init(_ path: String, @ViewBuilder content: @escaping () -> Content) {
        objects = StateObject(wrappedValue: FirestoreCollection(path))
        self.content = content()
    }
    
    public var body: some View {
        content
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
