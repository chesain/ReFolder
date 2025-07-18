//
//  MainViewController.swift
//  ReFolder
//
//  Created by Chetan Vanteddu on 7/16/25.
//

import Cocoa

final class ViewController: NSViewController {

    // make the view layer-backed so we can color it
    override func viewDidAppear() {
        super.viewDidAppear()
        view.wantsLayer = true
    }

    /// Called when the user clicks a “Choose Color” button in Interface Builder
    @IBAction func chooseColor(_ sender: Any?) {
        let panel = NSColorPanel.shared                      // singleton instance
        panel.setTarget(self)
        panel.setAction(#selector(handleColor(_:)))          // receives color changes
        panel.isContinuous = true                            // deliver live updates
        panel.showsAlpha  = true                             // include opacity slider
        panel.mode        = .RGB                             // start in RGB wheel
        panel.color       = view.layer?.backgroundColor
                            .flatMap(NSColor.init(cgColor:)) ?? .systemBlue
        panel.makeKeyAndOrderFront(nil)                      // bring panel onscreen
    }

    @objc private func handleColor(_ sender: NSColorPanel) {
        view.layer?.backgroundColor = sender.color.cgColor   // apply to the view
    }
}
