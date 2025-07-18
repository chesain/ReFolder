//
//  LegacyColorPanel.swift
//  ReFolder
//
//  Created by Chetan Vanteddu on 7/16/25.
//


import SwiftUI
import AppKit

struct LegacyColorPanel: NSViewRepresentable {
    @Binding var color: Color            // ← change to SwiftUI.Color

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeNSView(context: Context) -> NSButton {
        NSButton(title: "Choose Color",
                 target: context.coordinator,
                 action: #selector(Coordinator.openPanel))
    }

    func updateNSView(_ nsView: NSButton, context: Context) { }

    final class Coordinator: NSObject {
        var parent: LegacyColorPanel
        init(_ parent: LegacyColorPanel) { self.parent = parent }

        @objc func openPanel() {
            let panel = NSColorPanel.shared;
            panel.color = NSColor(parent.color)                  // value → AppKit
            panel.setTarget(self)
            panel.setAction(#selector(colorChanged(_:)))
            panel.makeKeyAndOrderFront(nil)
        }

        @objc func colorChanged(_ sender: NSColorPanel) {
            parent.color = Color(nsColor: sender.color)          // AppKit → value
        }
    }
}
