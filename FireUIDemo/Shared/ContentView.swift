//
//  ContentView.swift
//  Shared
//
//  Created by Bri on 10/16/21.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var state: DemoAppState
    
    enum Tab: String {
        
        case a, b
        
        var id: String { rawValue }
        var label: String { rawValue.localizedCapitalized }
        
        var systemImage: String {
            switch self {
            case .a:
                return "circle"
            case .b:
                return "square"
            }
        }
    }
    
    var body: some View {
        Text("Hello, World!")
            .padding()
            .viewStyle(
                state,
                label: Tab.a.label,
                systemImage: Tab.a.systemImage,
                selection: $state.selectedViewIdentifier,
                tag: Tab.a.id
            )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
