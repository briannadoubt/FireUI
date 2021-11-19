//
//  ItemsView.swift
//  FireUI Demo
//
//  Created by Bri on 11/16/21.
//

import FireUI

struct ItemsView: View {
    
    @FirestoreQuery(collectionPath: Item.basePath()) fileprivate var items: [Item]
    
    var body: some View {
        StyledRootView(
            state: FireUIAppState.self,
            person: Human.self,
            label: "Objects",
            systemImage: "1.circle",
            tag: Item.basePath(),
            content: {
                List {
                    ForEach(items) { item in
                        NavigationLink(item.text, destination: ItemView(item: item))
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            let newItem = Item(
                                text: "New Item with ID \(UUID().uuidString)",
                                created: Date(),
                                updated: Date()
                            )
                            do {
                                try newItem.save()
                            } catch {
                                // TODO: - Fix me
                                fatalError("Failed to save new Item with error: " + error.localizedDescription)
                            }
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
