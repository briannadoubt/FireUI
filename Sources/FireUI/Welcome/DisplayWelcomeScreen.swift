//
//  File.swift
//  
//
//  Created by Bri on 10/22/21.
//

import SwiftUI

public struct DisplayWelcomeScreen: ViewModifier {
    
    @Binding public var showingWelcomeScreen: Bool
    public var enabled: Bool
    
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore: Bool = false
    
    public func body(content: Content) -> some View {
        content
            .sheet(isPresented: $showingWelcomeScreen) {
                WelcomeScreen(hasLaunchedBefore: $hasLaunchedBefore, showingOnboarding: $showingWelcomeScreen)
            }
            .onAppear {
                if !hasLaunchedBefore && enabled {
                    showingWelcomeScreen = true
                }
            }
    }
}

public extension View {
    func welcomeScreen(_ showing: Binding<Bool>, featureEnabled: Bool = true) -> some View {
        modifier(DisplayWelcomeScreen(showingWelcomeScreen: showing, enabled: featureEnabled))
    }
}
