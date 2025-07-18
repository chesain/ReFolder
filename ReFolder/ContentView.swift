//
//  ContentView.swift
//  ReFolder
//
//  Created by Chetan Vanteddu on 7/16/25.
//

import SwiftUI

struct ContentView: View {
    
    
    // A state variable to hold an array of URLs for the folders the user picks.
    @State var selectedFolderURLs: [URL] = []
    
    // A state variable to store the color chosen from the color picker.
    @State private var selectedColor = Color.blue
    
    // A new state variable to control showing the success alert.
    @State private var showSuccessAlert = false

    var body: some View {
        VStack(spacing: 20) {
            
            Text("ReFolder")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundColor(selectedColor)
                .padding(.top)

            // This button's action is to open the system's file selection panel.
            Button {
                let panel = NSOpenPanel()
                panel.title = "Select one or more folders"
                panel.canChooseFiles = false       // User cannot select files.
                panel.canChooseDirectories = true  // User can only select directories.
                panel.allowsMultipleSelection = true // Let the user pick many folders at once.
                
                // Show the panel. If the user clicks the "Open" button...
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
                // The button's appearance.
                Label("Select Folders...", systemImage: "folder.badge.plus")
                    .font(.headline)
                    .padding()
                    .background(Color.secondary.opacity(0.2))
                    .cornerRadius(10)
            }
            .buttonStyle(.plain) // Use a simpler button style.

            // Display a list of the folders that have been selected.
            // This section only appears if at least one folder is chosen.
            if !selectedFolderURLs.isEmpty {
                List {
                    Section(header: Text("Folders to Recolor (\(selectedFolderURLs.count))")) {
                        // Loop through the array of URLs and create a text view for each one.
                        ForEach(selectedFolderURLs, id: \.self) { url in
                            // Show the folder icon and just the name of the folder.
                            Label(url.lastPathComponent, systemImage: "folder")
                        }
                    }
                }
                .frame(height: 150) // Give the list a fixed height.
                .cornerRadius(10)
            }

            // The color picker for the user to choose their desired color.
            ColorPicker("Choose a Color", selection: $selectedColor)

            // The button to apply the changes.
            Button {
                // Loop through every folder URL the user selected.
                for url in selectedFolderURLs {
                    // --- KEY FIX: Securely access the folder before changing it ---
                    // This tells macOS to activate the permission we got from the open panel.
                    let didStartAccessing = url.startAccessingSecurityScopedResource()
                    
                    // The 'defer' block ensures that we stop accessing the resource
                    // even if something goes wrong.
                    defer {
                        if didStartAccessing {
                            url.stopAccessingSecurityScopedResource()
                        }
                    }
                    
                    
                    
                    FolderIconManager.changeColor(of: url, to: selectedColor)
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
                    .background(selectedFolderURLs.isEmpty ? Color.gray : selectedColor) // Dynamic background color!
                    .cornerRadius(10)
            }
            .buttonStyle(.plain)
            .disabled(selectedFolderURLs.isEmpty) // Disable the button if no folders are selected.
            .padding(.bottom)

        }
        .padding()
        .frame(minWidth: 450, minHeight: 450) // Give our window a nice default size.
        // Add the .alert() modifier to the main view. It will watch the
        // 'showSuccessAlert' variable and appear when it becomes true.
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
