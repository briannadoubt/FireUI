//
//  FireAppStyle.swift
//  
//
//  Created by Bri on 10/21/21.
//

@_exported import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@frozen public struct TupleScene<T>: Scene {

    public var value: T

    @inlinable public init(_ value: T) {
        self.value = value
    }
}

//extension Group {
//    static func buildBlock<S0: Scene>(_ scene0: S0) -> TupleScene<(S0)> {
//        return TupleScene((scene0))
//    }
//    static func buildBlock<S0: Scene, S1: Scene>(_ scene0: S0, _ scene1: S1) -> TupleScene<(S0, S1)> {
//        return TupleScene((scene0, scene1))
//    }
//}

public struct _ConditionalScene<TrueScene: Scene, FalseScene: Scene>: Scene {
    
    @SceneBuilder var trueScene: () -> TrueScene?
    @SceneBuilder var falseScene: () -> FalseScene?
    
    init(_ trueScene: TrueScene?, _ falseScene: FalseScene?) {
        self.trueScene = { trueScene }
        self.falseScene = { falseScene }
    }
    
    public var body: some Scene {
        Group {
            trueScene()!
            falseScene()!
        }
    }
}

//extension _ConditionalScene {
//    public static func _makeScene(scene: _GraphValue<Self>, inputs: _SceneInputs) -> _SceneOutputs {
//        return _SceneOutputs(preferences: PreferencesOutputs(preferences: [:]))
//    }
//}
//
//public struct _SceneOutputs {
//    var preferences: PreferencesOutputs
//}
//
//public struct PreferencesOutputs {
//    var preferences: [String: Any]
//}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension SceneBuilder {

    /// Provides support for “if” statements in multi-statement closures,
    /// producing an optional view that is visible only when the condition
    /// evaluates to `true`.
    static func buildIf<Content: Scene>(_ content: Content?) -> Content? {
        return content
    }

    /// Provides support for "if" statements in multi-statement closures,
    /// producing conditional content for the "then" branch.
    static func buildEither<TrueScene: Scene, FalseScene: Scene>(first: TrueScene) -> _ConditionalScene<TrueScene, FalseScene> {
        return .init(first, nil)
    }

    /// Provides support for "if-else" statements in multi-statement closures,
    /// producing conditional content for the "else" branch.
    static func buildEither<TrueScene: Scene, FalseScene: Scene>(second: FalseScene) -> _ConditionalScene<TrueScene, FalseScene> {
        return .init(nil, second)
    }
}

public enum AuthenticationControlledWindowGroup<Content: View, Logo: View, Footer: View, Human: Person, AppState: FireState>: Scene {

    case isNotAuthenticated(
        _ user: FirebaseUser<AppState>,
        _ logo: () -> Logo?,
        _ content: () -> AuthenticationView<Logo, Footer, Human, AppState>
    )
    
    case isAuthenticated(
        _ uid: Binding<String?>,
        _ selectedViewIdentifier: Binding<String?>,
        _ user: FirebaseUser<AppState>,
        _ logo: () -> Logo?,
        _ content: (_ uid: String) -> Content
    )

    public var body: some Scene {
        switch self {
        case .isNotAuthenticated(let user, let logo, let content):
            AuthScene(user: user, logo: logo, content: content)
        case .isAuthenticated(let uid, let selectedViewIdentifier, let user, let logo, let content):
            MainContentScene(
                uid: uid,
                selectedViewIdentifier: selectedViewIdentifier,
                user: user,
                logo: logo,
                content: content
            )
        }
    }
}

//public enum FireWindows<AppState: FireState> {
//
//    case auth
//    case content(_ uid: String)
//
//    var window: String {
//        switch self {
//        case .auth:
//            return "auth"
//        case .content:
//            return "content"
//        }
//    }
//
//    func open(closeCurrentWindow: Bool = false) {
//        if closeCurrentWindow {
//            NSApplication.shared.keyWindow?.close()
//        }
//
//        guard let scheme = AppState.shared.baseComponents.scheme else {
//            return
//        }
//
//        guard var url = URL(string: scheme + "://" + window) else {
//            return
//        }
//
//        switch self {
//        case .auth:
//            break
//        case .content(let uid):
//            url.appendPathComponent(uid)
//        }
//
//        NSWorkspace.shared.open(url)
//    }
//}

public struct AuthScene<Logo: View, Footer: View, Human: Person, AppState: FireState>: Scene {
    
    @ObservedObject fileprivate var user: FirebaseUser<AppState>
    
    @ViewBuilder fileprivate let content: AuthenticationView<Logo, Footer, Human, AppState>
    @ViewBuilder fileprivate var logo: () -> Logo?
    
    public init(
        state: AppState.Type = AppState.self,
        user: FirebaseUser<AppState>,
        @ViewBuilder logo: @escaping () -> Logo?,
        @ViewBuilder content: @escaping () -> AuthenticationView<Logo, Footer, Human, AppState>
    ) {
        self.user = user
        self.logo = logo
        self.content = content()
    }
    
    public var body: some Scene {
        WindowGroup("Authentication") {
                content
                    .environmentObject(user)
            }
            .windowStyle(HiddenTitleBarWindowStyle())
            .windowToolbarStyle(UnifiedCompactWindowToolbarStyle())
    }
}

public struct MainContentScene<Logo: View, Content: View, AppState: FireState>: Scene {
    
    @Binding var uid: String?
    
    @Binding fileprivate var selectedViewIdentifier: String?
    @ViewBuilder fileprivate var logo: () -> Logo?
    @ViewBuilder fileprivate var content: (_ uid: String) -> Content
    
    @ObservedObject fileprivate var user: FirebaseUser<AppState>
    
    public init(
        uid: Binding<String?>,
        selectedViewIdentifier: Binding<String?>,
        state: AppState.Type = AppState.self,
        user: FirebaseUser<AppState>,
        @ViewBuilder logo: @escaping () -> Logo?,
        @ViewBuilder content: @escaping (_ uid: String) -> Content
    ) {
        self._uid = uid
        self._selectedViewIdentifier = selectedViewIdentifier
        self.user = user
        self.logo = logo
        self.content = content
    }
    
    public var body: some Scene {
        WindowGroup(AppState.appName) {
            let content = content(uid!).environmentObject(user)
            let sidebar = NavigationView {
                List {
                    content
                }
                .listStyle(SidebarListStyle())
                .navigationTitle(AppState.appName)
            }

            let tabView = TabView(selection: $selectedViewIdentifier) {
                content
            }

            switch AppState.appStyle.macStyle {
            case .sidebar:
                sidebar
            case .tabbed:
                tabView
            case .plain:
                content
            }
        }
        .windowToolbarStyle(UnifiedCompactWindowToolbarStyle())
    }
}

@frozen public struct AnyScene: Scene {

    @SceneBuilder fileprivate var scene: () -> some Scene

    init<S: Scene>(erasing scene: @escaping () -> S) {
        self.scene = scene
    }

    init(_ scene: @escaping () -> S) {
        self.scene = scene
    }

    public var body: some Scene {
        scene()
    }
}

public struct StyledScene<Logo: View, Content: View, Footer: View, Human: Person, AppState: FireState>: Scene {
    
    @Binding var uid: String?
    
    @ViewBuilder fileprivate let authentication: () -> AuthenticationView<Logo, Footer, Human, AppState>
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
        self.authentication = authentication
    }
    
    public var body: some Scene {

        #if os(macOS)
        uid != nil
        ? AuthenticationControlledWindowGroup<Content, Logo, Footer, Human, AppState>.isAuthenticated($uid, $selectedViewIdentifier, user, logo, content)
        : AuthenticationControlledWindowGroup<Content, Logo, Footer, Human, AppState>.isNotAuthenticated(user, logo, authentication)
        
        #elseif os(watchOS)
        WindowGroup(AppState.appName) {
            let content = content(uid).environmentObject(user)
            let paged = TabView(selection: $selectedViewIdentifier) {
                content
            }
            let list = List(selection: $selectedViewIdentifier) { content }
            let navigation = NavigationView {
                list.navigationTitle(AppState.appName)
            }
            switch AppState.appStyle.watchStyle {
            case .paged:
                paged
            case .navigation:
                navigation
                
            }
        }
        #else // iOS and any other platform
        WindowGroup(AppState.appName) {
            if uid == nil {
                // User is not authenticated
                authentication.environmentObject(user)
            } else if let uid = uid {
                // User is authenticated
                let content = content(uid).environmentObject(user)
                
                let tabView = TabView(selection: $selectedViewIdentifier) { content }
                
                let paged = tabView.tabViewStyle(PageTabViewStyle())
                
                let list = List(selection: $selectedViewIdentifier) { content }
                
                let navigation = NavigationView {
                    list.navigationTitle(AppState.appName)
                }
                
                let sidebar = NavigationView {
                    List {
                        content
                    }
                    .listStyle(SidebarListStyle())
                    .navigationTitle(AppState.appName)
                }
                
                let stacked = sidebar.navigationViewStyle(StackNavigationViewStyle())
                
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
            }
        }
        #endif
    }
}
