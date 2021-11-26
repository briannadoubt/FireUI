//
//  ContentView.swift
//  Shared
//
//  Created by Bri on 10/23/21.
//

import FireUI
import SwiftUI

struct ContentView: View {
    
    @Binding var selectedViewIdentifier: String?
    @EnvironmentObject var state: FireUIAppState
    
    var body: some View {
        ItemsView(selectedViewIdentifier: $selectedViewIdentifier)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(selectedViewIdentifier: .constant("items"))
    }
}
