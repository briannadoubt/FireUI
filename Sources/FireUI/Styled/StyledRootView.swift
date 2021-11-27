//
//  ViewStylizer.swift
//  
//
//  Created by Bri on 10/22/21.
//

@_exported import SwiftUI

public struct StyledRootView<Content: View, AppState: FireState, Human: Person>: View {
    
    @Binding fileprivate var selectedViewIdentifier: String?
    
    public let label: String
    public let systemImage: String
    public let tag: String
    
    @ViewBuilder public var content: () -> Content
    
    public init(
        selectedViewIdentifier: Binding<String?>,
        state: AppState.Type,
        person: Human.Type,
        label: String,
        systemImage: String,
        tag: String,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._selectedViewIdentifier = selectedViewIdentifier
        self.label = label
        self.systemImage = systemImage
        self.tag = tag
        self.content = content
    }
    
    public var body: some View {
        
        let content = StyledView<Content, AppState>(state: AppState.self, content: content)
            #if os(macOS)
            .frame(minWidth: 320, maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(VStack {
                Divider()
                Spacer()
            })
            #endif
        
        let label = Label(label, systemImage: selectedViewIdentifier == tag ? systemImage + ".fill" : systemImage)
        
        let tabItem = NavigationView {
            content
                .navigationTitle(Text(self.label))
        }
        .tag(tag)
        .tabItem {
            label
        }
        
        let navigationLink = NavigationLink(destination: content, tag: tag, selection: $selectedViewIdentifier) {
            label
        }
        
        #if os(iOS)
        switch UIDevice.current.userInterfaceIdiom {
        case .carPlay:
            Text("FireUI does not yet support CarPlay")
        case .mac:
            switch AppState.appStyle.macStyle {
            case .sidebar:
                navigationLink
            case .tabbed:
                tabItem
            case .plain:
                content
                    .tag(tag)
                    .id(tag)
            }
        case .pad:
            switch AppState.appStyle.ipadStyle {
                case .tabbed:
                    tabItem
                case .sidebar:
                    navigationLink
                case .stacked:
                    navigationLink
                case .paged:
                    tabItem
                case .plain:
                    content
            }
        case .phone:
            switch AppState.appStyle.iphoneStyle {
            case .tabbed:
                tabItem
            case .navigation:
                navigationLink
            case .paged:
                tabItem
            case .plain:
                content
                    .tag(tag)
                    .id(tag)
            }
        case .tv:
            Text("FireUI does not yet support tvOS")
        case .unspecified:
            Text("Where are you?")
        @unknown default:
            Text("What is happening??")
        }
        #elseif os(macOS)
        switch AppState.appStyle.macStyle {
        case .sidebar:
            navigationLink
        case .tabbed:
            tabItem
        case .plain:
            content
                .tag(tag)
                .id(tag)
        }
        #elseif os(watchOS)
        switch AppState.appStyle.watchStyle {
        case .paged:
            tabItem
        case .navigation:
            navigationLink
        }
        #elseif os(tvOS)
        Text("FireUI does not yet support tvOS")
        #elseif os(WASI)
        content
            .tag(tag)
            .id(tag)
        #else
        content
            .tag(tag)
            .id(tag)
        #endif
    }
}
