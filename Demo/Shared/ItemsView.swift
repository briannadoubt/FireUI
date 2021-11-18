//
//  ItemsView.swift
//  FireUI Demo
//
//  Created by Bri on 11/16/21.
//

import SwiftUI
import FireUI
import FirebaseFirestoreSwift

struct ItemsView: View {
    
    @FirestoreQuery(collectionPath: Item.basePath()) fileprivate var items: [Item]
    
    var body: some View {
        StyledRootView(
            state: FireUIAppState.self,
            label: "Objects",
            systemImage: "1.circle",
            tag: "objects",
            content: {
                List {
                    Text("Something")
                    ForEach(items) { item in
                        NavigationLink(item.text, destination: ItemView(item: item))
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            try! Item(text: "New Item: \(UUID().uuidString)", created: Date(), updated: Date()).save()
                        } label: {
                            Label("New Item", systemImage: "plus")
                        }
                    }
                }
            }
        )
    }
}

@available(iOS 15.0, macOS 12.0, watchOS 8.0, tvOS 15.0, *)
struct DemoObjectsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView()
    }
}
