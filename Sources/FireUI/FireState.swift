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
    init()
}
