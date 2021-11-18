//
//  ViewStylizer.swift
//  
//
//  Created by Bri on 10/22/21.
//

@_exported import SwiftUI

public struct StyledRootView<Content: View, AppState: FireState>: View {
    
    @EnvironmentObject fileprivate var state: AppState
    
    public let label: String
    public let systemImage: String
    public let tag: String
    
    @ViewBuilder public var content: () -> Content
    
    public init(
        state: AppState.Type,
        label: String,
        systemImage: String,
        tag: String,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.label = label
        self.systemImage = systemImage
        self.tag = tag
        self.content = content
    }
    
    public var body: some View {
        
        let content = StyledView<Content, AppState>(state: AppState.self, content: content)
        
        let label = Label(label, systemImage: state.selectedViewIdentifier == tag ? systemImage + ".fill" : systemImage).tag(tag)
        let tabItem = NavigationView { content.navigationTitle(Text(self.label)) }.tabItem { label }.tag(tag)
        let navigationLink = NavigationLink(destination: content, tag: tag, selection: $state.selectedViewIdentifier) {
            label
        }
        
        #if os(iOS)
        switch UIDevice.current.userInterfaceIdiom {
        case .carPlay:
            Text("FireUI does not yet support CarPlay")
        case .mac:
            switch state.appStyle.macStyle {
            case .sidebar:
                navigationLink
            case .tabbed:
                tabItem
            case .plain:
                content
                    .tag(tag)
                    .id(tag)
            }
        case .pad:
            switch state.appStyle.ipadStyle {
                case .tabbed:
                    tabItem
                case .sidebar:
                    navigationLink
                case .stacked:
                    navigationLink
                case .paged:
                    tabItem
                case .plain:
                    content
            }
        case .phone:
            switch state.appStyle.iphoneStyle {
            case .tabbed:
                tabItem
            case .navigation:
                navigationLink
            case .paged:
                tabItem
            case .plain:
                content
                    .tag(tag)
                    .id(tag)
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
            navigationLink
        case .tabbed:
            tabItem
        case .plain:
            content
                .tag(tag)
                .id(tag)
        }
        #elseif os(watchOS)
        switch state.appStyle.watchStyle {
        case .paged:
            tabItem
        case .navigation:
            navigationLink
        }
        #elseif os(tvOS)
        Text("FireUI does not yet support tvOS")
        #elseif os(WASI)
        content
            .tag(tag)
            .id(tag)
        #else
        content
            .tag(tag)
            .id(tag)
        #endif
    }
}
