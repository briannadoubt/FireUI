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

public struct FireScene<Logo: View, SettingsView: View, Footer: View, Content: View, AppState: FireState, Merch: ProductRepresentable, Human: Person, CustomCommands: Commands>: Scene {
    
    @Binding fileprivate var selectedViewIdentifier: String?
    
    #if os(macOS)
    @ViewBuilder fileprivate var content: (_ uid: String) -> FireContentView<Human, AppState, Content>
    #else
    @ViewBuilder fileprivate var content: (_ uid: String) -> FireContentView<Human, AppState, SettingsView, Content>
    #endif
    @ViewBuilder fileprivate var logo: () -> Logo?
    @ViewBuilder fileprivate var settings: (_ uid: String) -> FireSettingsView<Human, AppState, SettingsView>?
    @ViewBuilder fileprivate var footer: () -> Footer?
    @CommandsBuilder fileprivate var commands: () -> CustomCommands
    
    fileprivate let newPerson: Human.New
    
    @StateObject public var user = FirebaseUser<AppState>(basePath: Human.basePath())
    @StateObject public var store = Store<Merch>()
    @StateObject public var state = AppState.shared
    
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var showingWelcomeScreen = false
    
    public init(
        selectedViewIdentifier: Binding<String?>,
        state: AppState.Type,
        product: Merch.Type,
        newPerson: @escaping Human.New = Human.new(uid:email:nickname:),
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder logo: @escaping () -> Logo? = { nil },
        @ViewBuilder settings: @escaping (_ uid: String?) -> SettingsView,
        @ViewBuilder footer: @escaping () -> Footer? = { nil },
        @CommandsBuilder commands: @escaping () -> CustomCommands
    ) {
        // AppCheck
        #if DEBUG
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        #else
        let appCheckProviderFactory = FireAppChackProviderFactory()
        AppCheck.setAppCheckProviderFactory(appCheckProviderFactory)
        #endif
        
        // Configure Firebase
        FirebaseApp.configure()
        
        // Emulators
        #if DEBUG
        // Auth Emulator
        #if canImport(FirebaseAuth)
        Auth.auth().useEmulator(withHost:"localhost", port:9099)
        #endif
        
        // Firestore Emulator
        #if canImport(FirebaseFirestore)
        let firestoreSettings = Firestore.firestore().settings
        firestoreSettings.host = "localhost:8080"
        firestoreSettings.isPersistenceEnabled = false
        firestoreSettings.isSSLEnabled = false
        Firestore.firestore().settings = firestoreSettings
        #endif
        
        // Storage Emulator
        #if canImport(FirebaseStorage)
        Storage.storage().useEmulator(withHost:"localhost", port:9199)
        #endif
        
        // Functions Emulator
        #if canImport(FirebaseFunctions)
        Functions.functions().useFunctionsEmulator(origin: "http://localhost:5001")
        #endif
        
        #endif
        
        self._selectedViewIdentifier = selectedViewIdentifier
        self.newPerson = newPerson
        self.settings = { uid in
            FireSettingsView(
                uid: uid,
                settings: settings
            )
        }
        self.content = { uid in
            #if os(macOS)
            FireContentView<Human, AppState, Content>(
                uid: uid,
                content: content
            )
            #else
            FireContentView<Human, AppState, SettingsView, Content>(
                uid: uid,
                content: content,
                settings: { uid in
                    FireSettingsView<Human, AppState, SettingsView>(
                        uid: uid,
                        settings: settings
                    )
                }
            )
            #endif
        }
        self.logo = logo
        self.footer = footer
        self.commands = commands
    }
    
    public var body: some Scene {
        StyledScene(
            uid: $user.uid,
            selectedViewIdentifier: $selectedViewIdentifier,
            state: AppState.self,
            user: user,
            logo: logo,
            authentication: {
                AuthenticationView<Logo, Footer, Human, AppState>(
                    newPerson: newPerson,
                    logo: logo,
                    footer: footer
                )
            }
        ) { uid in
            content(uid)
                .environmentObject(state)
                .environmentObject(store)
                .environmentObject(user)
        }
        .commands {
            FireCommands(state: AppState.self) {
                commands()
            }
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                store.start()
                user.setListener()
            case .background:
                store.stop()
            case .inactive:
                store.stop()
            @unknown default:
                break
            }
        }
        
        #if os(macOS)
        Settings {
            if let uid = user.uid {
                settings(uid)
                    .environmentObject(user)
                    .frame(minWidth: 480, minHeight: 320)
            } else {
                Text("Please sign in to access these settings")
            }
        }
        #endif
    }
}

public struct FireCommands<CustomCommands: Commands, AppState: FireState>: Commands {
    
    @CommandsBuilder var commands: () -> CustomCommands
    
    public init(
        state: AppState.Type,
        @CommandsBuilder commands: @escaping () -> CustomCommands
    ) {
        self.commands = commands
    }
    
    @State var error: Error? = nil
    
    public var body: some Commands {
        
        CommandMenu("Account") {
            SignOutButton<AppState>(error: $error)
        }
        commands()
    }
}
