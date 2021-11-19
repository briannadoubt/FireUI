//
//  FireScene.swift
//  FireUI
//
//  Created by Bri on 10/20/21.
//

@_exported import SwiftUI
@_exported import Firebase
@_exported import StoreKit

#if !os(watchOS)
import FirebaseAppCheck
#endif

public struct FireScene<Logo: View, Settings: View, Footer: View, Content: View, AppState: FireState, Merch: ProductRepresentable, Human: Person>: Scene {
    
    @ViewBuilder fileprivate var content: () -> Content
    @ViewBuilder fileprivate var logo: () -> Logo?
    @ViewBuilder fileprivate var settings: () -> Settings?
    @ViewBuilder fileprivate var footer: () -> Footer?
    
    fileprivate let newPerson: Human.New
    
    @StateObject public var user = FirebaseUser(basePath: Human.basePath())
    @StateObject public var store = Store<Merch>()
    @StateObject public var state = AppState.shared
    
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var showingWelcomeScreen = false
    
    public init(
        state: AppState.Type,
        product: Merch.Type,
        newPerson: @escaping Human.New = Human.new(uid:email:nickname:),
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder logo: @escaping () -> Logo? = { nil },
        @ViewBuilder settings: @escaping () -> Settings,
        @ViewBuilder footer: @escaping () -> Footer? = { nil }
    ) {
        self.newPerson = newPerson
        self.content = content
        self.logo = logo
        self.settings = settings
        self.footer = footer
        
        startFirebase()
    }
    
    fileprivate func startFirebase() {
        createAppCheck()
        FirebaseApp.configure()
    }

    fileprivate func createAppCheck() {
        let appCheckProviderFactory = FireAppChackProviderFactory()
        AppCheck.setAppCheckProviderFactory(appCheckProviderFactory)
    }
    
    fileprivate func checkAuthStatus() {
        if Auth.auth().currentUser == nil {
            user.isAuthenticated = false
            user.uid = nil
        }
    }
    
    public var body: some Scene {
        StyledScene(
            selectedViewIdentifier: $state.selectedViewIdentifier,
            state: state,
            user: user,
            logo: logo
        ) {
            FireClient(
                state: AppState.self,
                person: Human.self,
                authenticationView: {
                    AuthenticationView(
                        newPerson: newPerson,
                        logo: logo,
                        footer: footer
                    )
                },
                content: content,
                settings: settings
            )
            .environmentObject(state)
            .environmentObject(store)
            .environmentObject(user)
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                store.start()
                checkAuthStatus()
            case .background:
                store.stop()
            case .inactive:
                store.stop()
            @unknown default:
                break
            }
        }
        #if os(macOS)
        SwiftUI.Settings {
            settings()
                .environmentObject(state)
                .environmentObject(user)
        }
        #endif
    }
}
