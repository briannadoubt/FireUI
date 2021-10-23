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

public struct StyledScene<SelectionValue: Hashable, Content: View, AppState: FireState>: Scene {
    
    @Binding public var selection: SelectionValue?
    @ObservedObject public var state: AppState
    @ViewBuilder public var content: Content
    
    public var body: some Scene {
        WindowGroup {
            let tabView = TabView(selection: $selection) {
                content
            }
            let paged = tabView.tabViewStyle(PageTabViewStyle())
            let list = List(selection: $selection) {
                content
            }
            let navigation = NavigationView {
                list.navigationTitle(state.appName)
            }
            let sidebar = navigation.listStyle(SidebarListStyle())
            let stacked = sidebar.navigationViewStyle(StackNavigationViewStyle())
            #if os(iOS)
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
                    sidebar
                case .stacked:
                    stacked
                case .paged:
                    paged
                case .plain:
                    content
                }
            case .tv:
                Text("FireUI does not yet support tvOS")
            case .phone:
                switch state.appStyle.iphoneStyle {
                case .tabbed:
                    tabView
                case .navigation:
                    sidebar
                case .paged:
                    paged
                case .plain:
                    content
                }
            case .unspecified:
                Text("Where are you?")
            @unknown default:
                Text("What is happening??")
            }
            #elseif os(macOS)
            switch state.appStyle.macStyle {
            case .sidebar:
                sidebar
            case .tabbed:
                tabView
            case .plain:
                content
            }
            #elseif os(watchOS)
            switch state.appStyle.watchStyle {
            case .paged:
                paged
            case .navigation:
                navigation
            }
            #elseif os(WASI)
            content
            #else
            content
            #endif
        }
    }
}
