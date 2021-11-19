//
//  ContentView.swift
//  Shared
//
//  Created by Bri on 10/23/21.
//

import FireUI

struct ContentView: View {
    var body: some View {
        ItemsView()
    }
}

@available(iOS 15.0, macOS 12.0, watchOS 8.0, tvOS 15.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
