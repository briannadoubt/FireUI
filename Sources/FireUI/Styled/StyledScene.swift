//
//  FireAppStyle.swift
//  
//
//  Created by Bri on 10/21/21.
//

import SwiftUI

public struct StyledScene<Logo: View, Content: View, Settings: View, AppState: FireState>: Scene {
    
    @ViewBuilder public var logo: () -> Logo?
    @ViewBuilder public var settings: () -> Settings
    @ViewBuilder public var content: () -> Content
    
    @ObservedObject private var state: AppState
    @ObservedObject private var user: FirebaseUser
    
    public init(
        selectedViewIdentifier: Binding<String?>,
        state: AppState,
        user: FirebaseUser,
        @ViewBuilder logo: @escaping () -> Logo?,
        @ViewBuilder settings: @escaping () -> Settings,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._selectedViewIdentifier = selectedViewIdentifier
        self.state = state
        self.user = user
        self.logo = logo
        self.settings = settings
        self.content = content
    }
    
    @Binding private var selectedViewIdentifier: String?
    
    public var body: some Scene {
        WindowGroup {
            let content = content()
                .environmentObject(state)
                .environmentObject(user)
            
            let settings = settings()
                .environmentObject(state)
                .environmentObject(user)
            
            let tabView = TabView(selection: $selectedViewIdentifier) {
                content
                settings
            }
            
            #if !os(macOS)
            let paged = tabView.tabViewStyle(PageTabViewStyle())
            #endif
            
            let list = List(selection: $selectedViewIdentifier) {
                content
                settings
            }
            
            let navigation = NavigationView {
                list.navigationTitle(state.appName)
            }
            
            let sidebar = NavigationView {
                List {
                    HStack {
                        Spacer()
                        VStack {
                            if let logo = logo() {
                                logo.scaledToFit().frame(width: 88, height: 88, alignment: .center)
                            }
                            Text(state.appName).font(.largeTitle).bold()
                            Spacer()
                        }
                        Spacer()
                    }
                    
                    content
                    settings
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
            if !user.isAuthenticated {
                content.padding().fixedSize()
            } else {
                switch state.appStyle.macStyle {
                case .sidebar:
                    sidebar
                case .tabbed:
                    tabView
                case .plain:
                    content
                }
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
