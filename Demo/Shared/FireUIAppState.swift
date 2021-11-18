//
//  FireUIAppState.swift
//  Demo
//
//  Created by Bri on 10/23/21.
//

import FireUI
import Combine

final class FireUIAppState: FireState {
    
    // Set default view
    @Published var selectedViewIdentifier: String? = "items"
    
    static var shared: FireUIAppState = FireUIAppState()
    
    var appName: String = "FireUI"
    var appStyle = AppStyle.default
}
