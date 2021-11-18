//
//  File.swift
//  
//
//  Created by Bri on 10/22/21.
//

import Foundation

public struct AppStyle {
    
    public var iphoneStyle: iOSAppStyle
    public var ipadStyle: iPadOSAppStyle
    public var macStyle: macOSAppStyle
    public var watchStyle: watchOSAppStyle
    
    public init(
        iphoneStyle: iOSAppStyle,
        ipadStyle: iPadOSAppStyle,
        macStyle: macOSAppStyle,
        watchStyle: watchOSAppStyle
    ) {
        self.iphoneStyle = iphoneStyle
        self.ipadStyle = ipadStyle
        self.macStyle = macStyle
        self.watchStyle = watchStyle
    }
    
    public static var `default` = AppStyle(
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
