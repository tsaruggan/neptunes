//
//  EditorView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-03.
//

import SwiftUI
import PhotosUI

struct EditorView: View {
    
    @ObservedObject public var viewModel: EditorViewModel
    
    @Binding var presentingEditor: Bool
    
    @State private var selectedItem: PhotosPickerItem? = nil
    
    var body: some View {
        
        Form {
            Section(header: Text("Song Information")) {
                TextField("Title", text: $viewModel.songTitle)
            }
            
            Section(header: Text("Album Information")) {
                TextField("Album", text: $viewModel.albumTitle)
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    if let artwork = viewModel.albumCoverArtwork, let image = UIImage(data: artwork) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    } else {
                        Image("defaultcover")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    }
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            viewModel.albumCoverArtwork = data
                        }
                    }
                }
            }
            
            
            Section(header: Text("Artist Information")) {
                TextField("Artist", text: $viewModel.artistTitle)
            }
            
            Button("Add song") {
                viewModel.addSong()
                presentingEditor = false
            }
            
        }
    }
    
    
}


