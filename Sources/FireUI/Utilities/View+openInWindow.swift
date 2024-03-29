//
//  View+openInWindow.swift
//  FireUI
//
//  Created by Bri on 11/30/21.
//

import SwiftUI

#if os(macOS)
extension View {
    @discardableResult func openInWindow(title: String, sender: Any?) -> NSWindow {
        let controller = NSHostingController(rootView: self)
        let win = NSWindow(contentViewController: controller)
        win.contentViewController = controller
        win.title = title
        win.makeKeyAndOrderFront(sender)
        return win
    }
}
#endif
