//
//  FireApp.swift
//  FireUI
//
//  Created by Bri on 10/20/21.
//

#if Web
import Foundation
import SwiftWebUI
#else
import SwiftUI
#endif

public protocol FireState: ObservableObject {
    
    var appName: String { get }
    var selectedViewIdentifier: String? { get set }
    var appStyle: FireAppStyle { get }
    
    var personBasePath: String { get }
    
    var storeEnabled: Bool { get }
    var adsEnabled: Bool { get }
    var showsWelcomeScreen: Bool { get }
    var firebaseEnabled: Bool { get }
    var coreDataEnabled: Bool { get }
    
    init()
}
