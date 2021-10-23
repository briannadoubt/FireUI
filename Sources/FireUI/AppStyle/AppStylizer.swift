//
//  FireAppStyle.swift
//  
//
//  Created by Bri on 10/21/21.
//

import SwiftUI

public extension View {
    
    func asTabItem<SelectionValue: Hashable>(label: String, systemImage: String, selection: Binding<SelectionValue?>, tag: SelectionValue) -> some View {
        modifier(TabItemWrapper(label: label, systemImage: systemImage, selection: selection, tag: tag))
    }
    
    func asNavigationLink<SelectionValue: Hashable>(
        label: String,
        systemImage: String,
        selection: Binding<SelectionValue?>,
        tag: SelectionValue
    ) -> some View {
        modifier(NavigationLinkWrapper(
            label: label,
            systemImage: systemImage,
            selection: selection,
            tag: tag
        ))
    }
    
    func asNavigationView(_ title: String) -> some View {
        modifier(NavigationViewWrapper(title: title))
    }
}

public struct NavigationLinkWrapper<SelectionValue: Hashable>: ViewModifier {
    
    public let label: String
    public let systemImage: String
    @Binding public var selection: SelectionValue?
    public let tag: SelectionValue
    
    public func body(content: Content) -> some View {
        NavigationLink(
            destination: content,
            tag: tag,
            selection: $selection
        ) {
            Label(label, systemImage: systemImage)
        }
    }
}

public struct TabItemWrapper<SelectionValue: Hashable>: ViewModifier {
    
    public let label: String
    public let systemImage: String
    @Binding public var selection: SelectionValue?
    public let tag: SelectionValue
    
    public func body(content: Content) -> some View {
        content
            .tabItem {
                Label(label, systemImage: selection == tag ? systemImage + ".fill" : systemImage)
            }
    }
}

public struct NavigationViewWrapper: ViewModifier {
    
    var title: String
    
    public func body(content: Content) -> some View {
        NavigationView {
            content
                .navigationTitle(Text(title))
        }
    }
}

public extension View {
    func appStyle<SelectionValue: Hashable, AppState: FireState>(selection: Binding<SelectionValue?>, appStyle: FireAppStyle = FireAppStyle.default, state: AppState) -> some View {
        modifier(AppStylizer(selection: selection, state: state))
    }
}

public struct AppStylizer<SelectionValue: Hashable, AppState: FireState>: ViewModifier {
    
    @Binding public var selection: SelectionValue?
    @ObservedObject public var state: AppState
    
    public func body(content: Content) -> some View {
        let tabView = TabView(selection: $selection) {
            content
        }
        let list = List(selection: $selection) {
            content
        }
        #if os(iOS)
        Group {
            switch UIDevice.current.userInterfaceIdiom {
            case .mac:
                Text("FireUI does not support macOS Catalyst. Run the native app instead.")
            case .carPlay:
                Text("FireUI does not yet support CarPlay")
            case .pad:
                switch state.appStyle.ipadStyle {
                case .tabbed:
                    tabView
                case .sidebar:
                    NavigationView {
                        list
                            .listStyle(SidebarListStyle())
                            .navigationTitle("Taro")
                    }
                case .stacked:
                    NavigationView {
                        List(selection: $selection) {
                            content
                        }
                        .listStyle(SidebarListStyle())
                        .navigationTitle("Taro")
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                case .paged:
                    TabView(selection: $selection) {
                        content
                    }
                    .tabViewStyle(PageTabViewStyle())
                case .plain:
                    content
                }
            case .tv:
                Text("FireUI does not yet support tvOS")
            case .phone:
                switch state.appStyle.iphoneStyle {
                case .tabbed:
                    TabView {
                        content
                    }
                case .navigation:
                    NavigationView {
                        List(selection: $selection) {
                            content
                        }
                        .listStyle(SidebarListStyle())
                        .navigationTitle("Taro")
                    }
                case .paged:
                    TabView {
                        content
                    }
                    .tabViewStyle(PageTabViewStyle())
                case .plain:
                    content
                }
            case .unspecified:
                Text("Where are you?")
            @unknown default:
                Text("What is happening??")
            }
        }
        #elseif os(macOS)
        switch state.appStyle.macStyle {
        case .sidebar:
            list
                .listStyle(.sidebar)
                .asNavigationView(state.appName)
        case .tabbed:
            TabView(selection: $selection) {
                content
            }
        case .plain:
            content
        }
        #elseif os(watchOS)
        switch state.appStyle.watchStyle {
        case .paged:
            TabView {
                content
            }
            .tabViewStyle(PageTabViewStyle())
        case .navigation:
            list
                .listStyle(.plain)
                .asNavigationView(title)
        }
        #elseif os(WASI)
        content
        #else
        content
        #endif
    }
}
