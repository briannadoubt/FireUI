//
//  File.swift
//  
//
//  Created by Bri on 10/22/21.
//

import Foundation

public struct FireAppStyle {
    
    public var iphoneStyle: iOSAppStyle
    public var ipadStyle: iPadOSAppStyle
    public var macStyle: macOSAppStyle
    public var watchStyle: watchOSAppStyle
    
    public static var `default` = FireAppStyle(
        iphoneStyle: .tabbed,
        ipadStyle: .sidebar,
        macStyle: .sidebar,
        watchStyle: .paged
    )
}

public enum iOSAppStyle {
    case tabbed
    case navigation
    case paged
    case plain
}

public enum watchOSAppStyle {
    case paged
    case navigation
}

public enum iPadOSAppStyle {
    case tabbed
    case sidebar
    case stacked
    case paged
    case plain
}

public enum macOSAppStyle {
    case tabbed
    case sidebar
    case plain
}
