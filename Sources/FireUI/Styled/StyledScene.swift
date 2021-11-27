//
//  FireAppStyle.swift
//  
//
//  Created by Bri on 10/21/21.
//

@_exported import SwiftUI

public struct StyledScene<Logo: View, Content: View, Footer: View, Human: Person, AppState: FireState>: Scene {
    
    @Binding var uid: String?
    
    @ViewBuilder fileprivate let authentication: AuthenticationView<Logo, Footer, Human, AppState>
    @Binding fileprivate var selectedViewIdentifier: String?
    @ViewBuilder fileprivate var logo: () -> Logo?
    @ViewBuilder fileprivate var content: (_ uid: String) -> Content
    
    @ObservedObject fileprivate var user: FirebaseUser<AppState>
    
    public init(
        uid: Binding<String?>,
        selectedViewIdentifier: Binding<String?>,
        state: AppState.Type,
        user: FirebaseUser<AppState>,
        @ViewBuilder logo: @escaping () -> Logo?,
        @ViewBuilder authentication: @escaping () -> AuthenticationView<Logo, Footer, Human, AppState>,
        @ViewBuilder content: @escaping (_ uid: String) -> Content
    ) {
        self._uid = uid
        self._selectedViewIdentifier = selectedViewIdentifier
        self.user = user
        self.logo = logo
        self.content = content
        self.authentication = authentication()
    }
    
    public var body: some Scene {
        WindowGroup(AppState.appName) {
            if uid == nil {
                #if os(macOS)
                authentication.padding()
                    .environmentObject(user)
                #else
                authentication
                    .environmentObject(user)
                #endif
            } else if let uid = uid {
                // User is authenticated
                let content = content(uid)
                    .environmentObject(user)
            
                let tabView = TabView(selection: $selectedViewIdentifier) {
                    content
                }
                
                #if !os(macOS)
                let paged = tabView.tabViewStyle(PageTabViewStyle())
                #endif

                let list = List(selection: $selectedViewIdentifier) {
                    content
                }

                let navigation = NavigationView {
                    list.navigationTitle(AppState.appName)
                }

                let sidebar = NavigationView {
                    List {
                        HStack {
                            Spacer()
                            VStack {
                                if let logo = logo() {
                                    logo.scaledToFit().frame(width: 88, height: 88, alignment: .center)
                                }
                                Text(AppState.appName).font(.largeTitle).bold()
                                Spacer()
                            }
                            Spacer()
                        }
                        
                        content
                    }
                    .listStyle(SidebarListStyle())
                    .navigationTitle(AppState.appName)
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
                    switch AppState.appStyle.ipadStyle {
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
                    switch AppState.appStyle.iphoneStyle {
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
                switch AppState.appStyle.macStyle {
                case .sidebar:
                    sidebar
                case .tabbed:
                    tabView
                case .plain:
                    content
                }
                #elseif os(watchOS)
                switch AppState.appStyle.watchStyle {
                case .paged:
                    paged
                case .navigation:
                    navigation
                }
                #else
                content
                #endif
                
            }
        }
        #if os(macOS)
        .windowToolbarStyle(UnifiedCompactWindowToolbarStyle())
        .windowStyle(HiddenTitleBarWindowStyle())
        #endif
    }
}
