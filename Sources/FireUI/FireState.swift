//
//  FireApp.swift
//  FireUI
//
//  Created by Bri on 10/20/21.
//

@_exported import SwiftUI

public protocol FireState: ObservableObject {
    
    static var shared: Self { get set }
    
    static var appName: String { get }
    static var appStyle: AppStyle { get }
    
    var appId: String { get }
    
    init()
}

public extension FireState {
    var baseComponents: URLComponents {
        URLComponents(string: appId + "://")!
    }
}
