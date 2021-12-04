//
//  ItemView.swift
//  FireUI Demo
//
//  Created by Bri on 11/16/21.
//

import SwiftUI
import FireUI

struct ItemView: View {
    
    var item: Item
    
    var body: some View {
        StyledView(state: FireUIAppState.self) {
            List {
                Text(item.text)
                if #available(macOS 12.0.0, iOS 15.0.0, tvOS 15.0.0, watchOS 8.0.0, *) {
                    Text(item.created.formatted())
                } else {
                    Text("\(item.created)")
                }
            }
            .navigationTitle(Text(item.text))
        }
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView(
            item: Item(
                id: "preview",
                text: "Preview Item",
                created: Date(),
                updated: Date()
            )
        )
    }
}
