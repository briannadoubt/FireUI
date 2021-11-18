//
//  DemoObjectsView.swift
//  FireUI Demo
//
//  Created by Bri on 11/16/21.
//

import SwiftUI
import FireUI
import FirebaseFirestoreSwift

struct DemoObjectsView: View {
    
    @FirestoreQuery(collectionPath: DemoObject.basePath()) fileprivate var objects: [DemoObject]
    
    var body: some View {
        StyledRootView(
            state: DemoAppState.self,
            label: "Objects",
            systemImage: "1.circle",
            tag: "objects",
            content: {
                List {
                    Text("Something")
                    ForEach(objects) { object in
                        NavigationLink(object.text, destination: DemoObjectView(object: object))
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            try! DemoObject(text: "New Object: \(UUID().uuidString)", created: Date(), updated: Date()).save()
                        } label: {
                            Label("New Object", systemImage: "plus")
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
        DemoObjectsView()
    }
}
