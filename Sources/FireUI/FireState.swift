//
//  FireApp.swift
//  FireUI
//
//  Created by Bri on 10/20/21.
//

@_exported import SwiftUI

public protocol FireState: ObservableObject {
    
    static var shared: Self { get set }
    
    var appName: String { get }
    var appStyle: AppStyle { get }
    
    init()
}
