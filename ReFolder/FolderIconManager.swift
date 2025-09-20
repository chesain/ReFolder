//
//  FolderIconManager.swift
//  ReFolder
//
//  Created by Chetan Vanteddu on 7/16/25.
//


import Cocoa
import SwiftUI // Required to convert SwiftUI Color to NSColor

class FolderIconManager {

    /**
     Takes a folder's location (URL) and a color, then generates and applies a new, colored icon.
     - Parameter folderURL: The URL of the folder to change.
     - Parameter color: The SwiftUI Color to apply to the icon.
    */
    static func changeColor(of folderURL: URL, to color: Color) {
    
        let nsColor = NSColor(color)

  
        guard let folderIcon = NSWorkspace.shared.icon(forFile: folderURL.path) as? NSImage else {
            print("Error: Could not retrieve the generic folder icon from the system.")
            return
        }

        // Create a new, blank image that is the exact same size as the original folder icon.
        let coloredFolderIcon = NSImage(size: folderIcon.size, flipped: false) { (rect) -> Bool in
            
            folderIcon.draw(in: rect)
            
            
            nsColor.withAlphaComponent(0.7).set()
            
            
            rect.fill(using: .sourceAtop)
            
            return true
        }

        
        NSWorkspace.shared.setIcon(coloredFolderIcon, forFile: folderURL.path, options: [])
    }
}

