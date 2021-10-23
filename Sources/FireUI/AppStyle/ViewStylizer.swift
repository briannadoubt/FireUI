//
//  ViewStylizer.swift
//  
//
//  Created by Bri on 10/22/21.
//

import SwiftUI

public extension View {
    func viewStyle<SelectionValue: Hashable, AppState: FireState>(_ state: AppState, label: String, systemImage: String, selection: Binding<SelectionValue?>, tag: SelectionValue) -> some View {
        modifier(ViewStylizer<SelectionValue, AppState>(state: state, label: label, systemImage: systemImage, selection: selection, tag: tag))
    }
}

public struct ViewStylizer<SelectionValue: Hashable, AppState: FireState>: ViewModifier {
    
    @ObservedObject public var state: AppState
    public let label: String
    public let systemImage: String
    @Binding public var selection: SelectionValue?
    public let tag: SelectionValue
    
    public func body(content: Content) -> some View {
        #if os(iOS)
        switch UIDevice.current.userInterfaceIdiom {
        case .carPlay:
            Text("FireUI does not yet support CarPlay")
        case .mac:
            Text("FireUI does not support macOS Catalyst. Run the native app instead.")
        case .pad:
            switch state.appStyle.ipadStyle {
                case .tabbed:
                    content
                        .asTabItem(
                            label: label,
                            systemImage: systemImage,
                            selection: $selection,
                            tag: tag
                        )
                case .sidebar:
                    content
                        .asNavigationLink(
                            label: label,
                            systemImage: systemImage,
                            selection: $selection,
                            tag: tag
                        )
                case .stacked:
                    content
                        .asNavigationLink(
                            label: label,
                            systemImage: systemImage,
                            selection: $selection,
                            tag: tag
                        )
                case .paged:
                    content
                        .asTabItem(
                            label: label,
                            systemImage: systemImage,
                            selection: $selection,
                            tag: tag
                        )
                case .plain:
                    content
            }
        case .phone:
            switch state.appStyle.iphoneStyle {
            case .tabbed:
                content
                    .asTabItem(
                        label: label,
                        systemImage: systemImage,
                        selection: $selection,
                        tag: tag
                    )
            case .navigation:
                    content
                        .asNavigationLink(
                            label: label,
                            systemImage: systemImage,
                            selection: $selection,
                            tag: tag
                        )
            case .paged:
                content
                    .asTabItem(
                        label: label,
                        systemImage: systemImage,
                        selection: $selection,
                        tag: tag
                    )
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
        switch state.appStyle.macStyle {
        case .sidebar:
            content
                .asNavigationLink(
                    label: label,
                    systemImage: systemImage,
                    selection: $selection,
                    tag: tag
                )
        case .tabbed:
            content
                .asTabItem(
                    label: label,
                    systemImage: systemImage,
                    selection: $selection,
                    tag: tag
                )
        case .plain:
            content
        }
        #elseif os(watchOS)
        switch state.appStyle.watchStyle {
        case .paged:
            content
                .asTabItem(
                    label: label,
                    systemImage: systemImage,
                    selection: $selection,
                    tag: tag
                )
        case .navigation:
            content
                .asNavigationLink(
                    label: label,
                    systemImage: systemImage,
                    selection: $selection,
                    tag: tag
                )
        }
        #elseif os(tvOS)
        Text("FireUI does not yet support tvOS")
        #elseif os(WASI)
        content
        #else
        content
        #endif
    }
}
