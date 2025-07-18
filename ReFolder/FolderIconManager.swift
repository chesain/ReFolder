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
        // First, convert the SwiftUI Color to an AppKit NSColor, which is needed for drawing.
        let nsColor = NSColor(color)

        // Get the generic, default folder icon from the system. This is more reliable
        // than trying to get the icon from a folder that might already have a custom one.
        guard let folderIcon = NSWorkspace.shared.icon(forFile: folderURL.path) as? NSImage else {
            print("Error: Could not retrieve the generic folder icon from the system.")
            return
        }

        // Create a new, blank image that is the exact same size as the original folder icon.
        let coloredFolderIcon = NSImage(size: folderIcon.size, flipped: false) { (rect) -> Bool in
            // 1. Draw the original folder icon shape into our new image.
            folderIcon.draw(in: rect)
            
            // 2. Set the color. We make it slightly transparent (70% opaque) for a nicer look.
            nsColor.withAlphaComponent(0.7).set()
            
            // 3. Use the `.sourceAtop` blend mode. This special mode means "only draw the color
            //    on top of the existing pixels." It perfectly fills the folder shape without
            //    coloring the transparent background.
            rect.fill(using: .sourceAtop)
            
            return true
        }

        // 4. Finally, tell the system's workspace to set our newly created image as the
        //    custom icon for the file/folder at the specified path.
        NSWorkspace.shared.setIcon(coloredFolderIcon, forFile: folderURL.path, options: [])
    }
}

