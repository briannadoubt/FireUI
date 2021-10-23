//
//  FireScene.swift
//  FireUI
//
//  Created by Bri on 10/20/21.
//

#if Web
import SwiftWebUI
#else
import SwiftUI
#endif

#if !AppClip
import Firebase
    #if !os(watchOS)
    import FirebaseAppCheck
    #endif
#endif

#if !AppClip && os(iOS)
import GoogleMobileAds
import StoreKit
#endif

struct GeneralSettingsView: View {
    @AppStorage("showPreview") private var showPreview = true
    @AppStorage("fontSize") private var fontSize = 12.0

    var body: some View {
        Form {
            Toggle("Show Previews", isOn: $showPreview)
            Slider(value: $fontSize, in: 9...96) {
                Text("Font Size (\(fontSize, specifier: "%.0f") pts)")
            }
        }
        .padding(20)
        .frame(width: 350, height: 100)
    }
}

struct SettingsView: View {
    private enum Tabs: Hashable {
        case general, advanced
    }
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(Tabs.general)
//            AdvancedSettingsView()
//                .tabItem {
//                    Label("Advanced", systemImage: "star")
//                }
//                .tag(Tabs.advanced)
        }
        .padding(20)
        .frame(width: 375, height: 150)
    }
}

public struct FireScene<Content: View, AppState: FireState, Human: Person>: Scene {
    
    public let storeEnabled: Bool
    public let adsEnabled: Bool
    public let showsWelcomeScreen: Bool
    public let firebaseEnabled: Bool
    @ViewBuilder fileprivate var content: Content
    
    #if !AppClip && os(iOS)
    @StateObject public var store = Store()
    #endif
    
    @StateObject fileprivate var state = AppState()
    
    #if !AppClip && !Web
    @StateObject fileprivate var persistenceController = PersistenceController("Model")
    
    func saveCoreDataContext() throws {
        try persistenceController.container.viewContext.save()
    }
    #endif
    
    @Environment(\.scenePhase) private var scenePhase
    
    public init(storeEnabled: Bool = false, adsEnabled: Bool = false, showsWelcomeScreen: Bool = false, firebaseEnabled: Bool = false, @ViewBuilder content: @escaping () -> Content) {
        self.storeEnabled = storeEnabled
        self.adsEnabled = adsEnabled
        self.showsWelcomeScreen = showsWelcomeScreen
        self.firebaseEnabled = firebaseEnabled
        self.content = content()
        activate()
    }
    
    public func activate() {
        if storeEnabled {
            #if !AppClip && os(iOS)
            store.start()
            #endif
        }
        
        if firebaseEnabled {
            #if !AppClip
                #if os(iOS)
                createAppCheck()
                #endif
            startFirebase()
            #endif
        }
        
        if adsEnabled {
            #if !AppClip && os(iOS)
            startGoogleMobileAds()
            #endif
        }
    }
    
    #if !AppClip
    fileprivate func startFirebase() {
        #if os(iOS)
        createAppCheck()
        #endif
        FirebaseApp.configure()
    }
    
    #if !AppClip && os(iOS)
    fileprivate func startGoogleMobileAds() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        #if DEBUG
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["c964cd9acd944b45f04919d99f0301a4"]
        #endif
    }
    #endif

    #if os(iOS)
    fileprivate func createAppCheck() {
        let appCheckProviderFactory = FireAppChackProviderFactory()
        AppCheck.setAppCheckProviderFactory(appCheckProviderFactory)
    }
    #endif
    #endif
    
    public var body: some Scene {
        WindowGroup {
            content
                .environmentObject(state)
                #if !AppClip && os(iOS)
                .environmentObject(store)
                #endif
                #if !AppClip && !Web
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                #endif
                .onFire(Human.self)
                .appStyle(selection: $state.selectedViewIdentifier, state: state)
        }
        .onChange(of: scenePhase) { newScenePhase in
            do {
                switch newScenePhase {
                case .active:
                    print("")
                case .background:
                    #if !AppClip && !Web
                    try saveCoreDataContext()
                    #endif
                case .inactive:
                    #if !AppClip && !Web
                    try saveCoreDataContext()
                    #endif
                @unknown default:
                    #if !AppClip && !Web
                    try saveCoreDataContext()
                    #endif
                }
            } catch {
                print(error)
            }
        }
        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
}
