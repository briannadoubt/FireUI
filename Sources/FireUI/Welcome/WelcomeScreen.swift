//
//  WelcomeScreen.swift
//  Taro
//
//  Created by Brianna Zamora on 9/21/21.
//

import SwiftUI

import SwiftUI

struct WelcomeScreen: View {
    
    @Binding var hasLaunchedBefore: Bool
    @Binding var showingOnboarding: Bool
    
    #if os(iOS) || os(macOS)
    @State private var height = CGFloat.zero
    #endif
    
    var body: some View {
        
        #if os(watchOS)
        let title = Text("Welcome to Taro")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        #else
        let title = Group {
            Spacer()
            Text("Welcome to Taro")
                .font(.custom("Pacifico", size: 34, relativeTo: .largeTitle))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 48)
            Spacer()
        }
        #endif
        
        #if !AppClip
        let features = Group {
            FeatureCell(
                image: "doc.text.viewfinder",
                title: "Scan Tarot Cards",
                subtitle: "Scan cards using AR to interpret your future. (iPhone/iPad only)",
                color: .blue
            )
            FeatureCell(
                image: "text.badge.checkmark",
                title: "Full Card Descriptions",
                subtitle: "View a card's full meaning to make the most out of your reading.",
                color: .green
            )
            FeatureCell(
                image: "clock",
                title: "Scan History",
                subtitle: "See a detailed list of all the cards you've ever scanned!",
                color: .red
            )
            FeatureCell(
                image: "books.vertical",
                title: "All 78 Cards",
                subtitle: "Look up a card's meaning whenever, wherever!",
                color: .purple
            )
        }
        .lineLimit(nil)
        #else
        let features = Group {
            FeatureCell(
                image: "doc.text.viewfinder",
                title: "Scan Tarot Cards",
                subtitle: "Scan cards using AR to interpret your future.",
                color: .blue
            )
            FeatureCell(
                image: "text.badge.checkmark",
                title: "Full Card Descriptions",
                subtitle: "View a card's full meaning to make the most out of your reading.",
                color: .green
            )
            FeatureCell(
                image: "clock",
                title: "Reading Overview",
                subtitle: "See a detailed list of all the cards you've scanned! (Download the full app to save your readings)",
                color: .red
            )
        }
        .lineLimit(nil)
        #endif
        
        let button = Button {
            showingOnboarding = false
            hasLaunchedBefore = true
        } label: {
            HStack {
                Spacer()
                Text("Continue")
                    .padding()
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }
        }
        .background(Color("AccentColor"))
        .cornerRadius(10)
        
        #if os(watchOS)
        let views = Group {
            title
            features
            button
        }
        #elseif os(iOS)
        let views = Group {
            title
            
            VStack(alignment: .leading, spacing: 24) {
                features
            }
            .padding(.leading)
            
            Spacer()
            Spacer()
            
            button
                .frame(height: 50)
        }
        .padding()
        .frame(height: height)
        #elseif os(macOS)
        let views = VStack {
            title
            
            VStack(alignment: .leading, spacing: 24) {
                features
            }
            .padding(.leading)
            
            Spacer()
            
            button
                .frame(height: 50)
                .layoutPriority(1000)
        }
        .padding()
        #endif
        
        #if os(iOS)
        ScrollView(.vertical, showsIndicators: false) {
            views
        }
        .background(
            GeometryReader { geometry in
                Color.clear.onAppear {
                    height = geometry.size.height
                }
            }
        )
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    hasLaunchedBefore = true
                    showingOnboarding = false
                } label: {
                    Text("Continue")
                }
            }
        }
        #elseif os(watchOS)
        List {
            views
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    hasLaunchedBefore = true
                    showingOnboarding = false
                } label: {
                    Text("Done")
                }
            }
        }
        #elseif os(macOS)
        VStack {
            views
        }
        #endif
    }
}

struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen(hasLaunchedBefore: .constant(false), showingOnboarding: .constant(true))
    }
}
