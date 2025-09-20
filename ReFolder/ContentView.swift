//
//  ContentView.swift
//  ReFolder
//
//  Created by Chetan Vanteddu on 7/16/25.
//

import SwiftUI
import AppKit


func refreshFinderIcon(for url: URL) {
    let script = #"tell application "Finder" to update POSIX file "\#(url.path)""#
    Task.detached {
        let proc = Process()
        proc.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
        proc.arguments = ["-e", script]
        try? proc.run();  proc.waitUntilExit()
    }
}

struct ContentView: View {
    
    
    
    @State var selectedFolderURLs: [URL] = []
    
    
    @State private var selectedColor = Color.blue
    
    
    @State private var showSuccessAlert = false

    var body: some View {
        VStack(spacing: 20) {
            
            Text("ReFolder")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundColor(selectedColor)
                .padding(.top)

            
            Button {
                let panel = NSOpenPanel()
                panel.title = "Select one or more folders"
                panel.canChooseFiles = false       // User cannot select files.
                panel.canChooseDirectories = true  // User can only select directories.
                panel.allowsMultipleSelection = true // Let the user pick many folders at once.
                
                
                if panel.runModal() == .OK {
                    // ...we get the URLs of their chosen folders and store them.
                    //selectedFolderURLs = panel.urls
                    for url in panel.urls{
                        if !selectedFolderURLs.contains(url){
                            selectedFolderURLs.append(url)
                        }
                    }
                }
            } label: {
                
                Label("Select Folders...", systemImage: "folder.badge.plus")
                    .font(.headline)
                    .padding()
                    .background(Color.secondary.opacity(0.2))
                    .cornerRadius(10)
            }
            .buttonStyle(.plain) // Use a simpler button style.

            
            if !selectedFolderURLs.isEmpty {
                List {
                    Section(header: Text("Folders to Recolor (\(selectedFolderURLs.count))")) {
                        // Loop through the array of URLs and create a text view for each one.
                        ForEach(selectedFolderURLs, id: \.self) { url in
                           
                            Label(url.lastPathComponent, systemImage: "folder")
                        }
                    }
                }
                .frame(height: 150) // Give the list a fixed height.
                .cornerRadius(10)
            }

            
            ColorPicker("Choose a Color", selection: $selectedColor)

            
            Button {
                
                for url in selectedFolderURLs {
                    
                    let didStartAccessing = url.startAccessingSecurityScopedResource()
                    
                    
                    defer {
                        if didStartAccessing {
                            url.stopAccessingSecurityScopedResource()
                        }
                    }
                    
                    
                    
                    FolderIconManager.changeColor(of: url, to: selectedColor)
                    refreshFinderIcon(for: url)
                }
                
                // After the loop finishes, trigger the success alert.
                showSuccessAlert = true
                
                // For good user experience, clear the list after applying the colors.
                selectedFolderURLs.removeAll()
            } label: {
                Label("Apply Color to Folders", systemImage: "paintpalette.fill")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity) // Make the button wide.
                    .foregroundColor(.white)
                    .background(selectedFolderURLs.isEmpty ? Color.gray : selectedColor)
                    .cornerRadius(10)
            }
            .buttonStyle(.plain)
            .disabled(selectedFolderURLs.isEmpty) // Disable the button if no folders are selected.
            .padding(.bottom)

        }
        .padding()
        .frame(minWidth: 450, minHeight: 450) // Give window a nice default size.
        
        .alert("Success!", isPresented: $showSuccessAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("The folder icons have been updated.")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
