//
//  FireApp.swift
//  FireUI
//
//  Created by Bri on 10/20/21.
//

import SwiftUI

public protocol FireState: ObservableObject {
    
    static var shared: Self { get set }
    
    /// The current selected view's identifier
    /// Setting the default value for this var tells FireUI which view to load first.
    var selectedViewIdentifier: String? { get set }
    
    var appName: String { get }
    var appStyle: AppStyle { get }
    
    init()
}
