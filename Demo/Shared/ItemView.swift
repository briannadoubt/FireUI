//
//  DemoObjectView.swift
//  FireUI Demo
//
//  Created by Bri on 11/16/21.
//

import SwiftUI

struct DemoObjectView: View {
    
    var object: DemoObject
    
    var body: some View {
        NavigationView {
            List {
                Text(object.text)
                Text(object.created.formatted())
            }
            .navigationTitle(Text(object.text))
        }
    }
}

struct DemoObjectView_Previews: PreviewProvider {
    static var previews: some View {
        DemoObjectView(
            object: DemoObject(
                id: "test",
                text: "Demo Object",
                created: Date(),
                updated: Date()
            )
        )
    }
}
