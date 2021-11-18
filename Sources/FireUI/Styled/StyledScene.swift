//
//  FireAppStyle.swift
//  
//
//  Created by Bri on 10/21/21.
//

import SwiftUI

public struct StyledScene<Content: View, AppState: FireState>: Scene {
    
    @Binding public var selection: String?
    @ObservedObject public var state: AppState
    @ViewBuilder public var logo: () -> Image
    @ViewBuilder public var content: Content
    
    public var body: some Scene {
        WindowGroup {
            let tabView = TabView(selection: $selection) {
                content
            }
            
            #if !os(macOS)
            let paged = tabView.tabViewStyle(PageTabViewStyle())
            #endif
            
            let list = List(selection: $selection) {
                content
            }
            
            let navigation = NavigationView {
                list.navigationTitle(state.appName)
            }
            
            let sidebar = NavigationView {
                List {
                    HStack {
                        Spacer()
                        VStack {
                            logo().resizable().scaledToFit().frame(width: 88, height: 88, alignment: .center)
                            Text(state.appName).font(.largeTitle).bold()
                            Spacer()
                        }
                        Spacer()
                    }
                    
                    content
                }
                .listStyle(SidebarListStyle())
                .navigationTitle(state.appName)
            }
            
            #if !os(macOS)
            let stacked = sidebar.navigationViewStyle(StackNavigationViewStyle())
            #endif
            
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
