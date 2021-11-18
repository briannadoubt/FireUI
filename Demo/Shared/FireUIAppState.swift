//
//  DemoAppState.swift
//  Demo
//
//  Created by Bri on 10/23/21.
//

import FireUI
import Combine

final class MyAppState: FireState {
    
    // Set default view
    @Published var selectedViewIdentifier: String? = "objects"
    
    static var shared: MyAppState = MyAppState()
    
    var appName: String = "FireUI"
    
    var appStyle = AppStyle(
        iphoneStyle: .tabbed,
        ipadStyle: .sidebar,
        macStyle: .sidebar,
        watchStyle: .paged
    )
}
