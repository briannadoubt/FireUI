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
                Text(item.created.formatted())
            }
            .navigationTitle(Text(item.text))
        }
    }
}

struct DemoObjectView_Previews: PreviewProvider {
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
