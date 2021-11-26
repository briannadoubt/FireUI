//
//  StyledView.swift
//  FireUI
//
//  Created by Bri on 10/23/21.
//

@_exported import SwiftUI

public struct StyledView<Content: View, AppState: FireState>: View {

    @ViewBuilder public var content: () -> Content
    
    public init(state: AppState.Type, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        
        let content = content()
        
        #if os(iOS)
        switch UIDevice.current.userInterfaceIdiom {
        case .carPlay:
            Text("FireUI does not yet support CarPlay")
        case .mac:
            Text("FireUI does not support macOS Catalyst. Run the native app instead.")
        case .pad:
            switch AppState.appStyle.ipadStyle {
                case .tabbed:
                    content
                case .sidebar:
                    content
                case .stacked:
                    content
                case .paged:
                    content
                case .plain:
                    content
            }
        case .phone:
            switch AppState.appStyle.iphoneStyle {
            case .tabbed:
                content
            case .navigation:
                content
            case .paged:
                content
            case .plain:
                content
            }
        case .tv:
            Text("FireUI does not yet support tvOS")
        case .unspecified:
            Text("Where are you?")
        @unknown default:
            Text("What is happening??")
        }
        #elseif os(macOS)
        switch state.appStyle.macStyle {
        case .sidebar:
            NavigationView {
                content
            }
        case .tabbed:
            NavigationView {
                content
            }
        case .plain:
            content
        }
        #elseif os(watchOS)
        switch state.appStyle.watchStyle {
        case .paged:
            content
        case .navigation:
            content
        }
        #elseif os(tvOS)
        Text("FireUI does not yet support tvOS")
        #elseif os(WASI)
        content
        #else
        content
        #endif
    }
}
