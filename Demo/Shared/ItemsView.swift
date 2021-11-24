//
//  ItemsView.swift
//  FireUI Demo
//
//  Created by Bri on 11/16/21.
//

import FireUI
import SwiftUI

struct ItemsView: View {
    
    @ObservedObject var state: FireUIAppState
    @Binding var selectedViewIdentifier: String?
    
    @FirestoreQuery(collectionPath: Item.basePath()) fileprivate var items: [Item]
    
    var body: some View {
        StyledRootView(
            selectedViewIdentifier: $selectedViewIdentifier,
            state: state,
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
                            } catch let error as FireUIError {
                                handleError(error)
                            } catch {
                                handleError(error)
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
        ItemsView(state: FireUIAppState(), selectedViewIdentifier: .constant("items"))
    }
}
