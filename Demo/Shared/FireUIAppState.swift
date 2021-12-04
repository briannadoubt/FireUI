//
//  FireUIAppState.swift
//  FireUI Demo
//
//  Created by Bri on 10/23/21.
//

import FireUI
import Combine

final class FireUIAppState: FireState {
    
    static var shared: FireUIAppState = FireUIAppState()
    
    static var appName: String = "FireUI"
    var appId: String = "fireui"
    static var appStyle = AppStyle.default
}
