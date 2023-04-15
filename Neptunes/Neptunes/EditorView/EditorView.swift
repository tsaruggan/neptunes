//
//  EditorView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-03.
//

import SwiftUI
import PhotosUI
import AVFoundation

struct EditorView: View {
    
    @ObservedObject public var viewModel: EditorViewModel
    
    @Binding var presentingEditor: Bool
    
    @State private var selectedAlbumPhotosPickerItem: PhotosPickerItem? = nil
    @State private var selectedArtistPhotosPickerItem: PhotosPickerItem? = nil
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Artist.title, ascending: true)],
        animation: .default)
    public var existingArtists: FetchedResults<Artist>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Album.title, ascending: true)],
        animation: .default)
    public var existingAlbums: FetchedResults<Album>
    
    var body: some View {
        
        NavigationView {
            Form {
                songInformation
                albumInformation
                artistInformation
                
                Section {
                    previewPlayButton
                    addSongButton
                }
            }
        }
    }
    
    var songInformation: some View {
        Section(header: Text("Song Information")) {
            TextField("Title", text: $viewModel.songTitle)
        }
        
    }
    
    var albumInformation: some View {
        Section(header: Text("Album Information")) {
            Picker("Existing Album", selection: $viewModel.currentAlbum) {
                List {
                    Text("None selected").tag(nil as Album?)
                    ForEach(existingAlbums) { album in
                        HStack {
                            if let artwork = album.coverArtwork, let image = UIImage(data: artwork) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                            } else {
                                Image("defaultcover")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                            }
                            VStack(alignment: .leading) {
                                Text(album.title).bold()
                                Text(album.artist.title)
                            }
                        }
                        .tag(Optional(album))
                        
                        
                    }
                }
            }
            .pickerStyle(.navigationLink)
            
            if viewModel.currentAlbum == nil {
                TextField("Album", text: $viewModel.albumTitle)
                PhotosPicker(selection: $selectedAlbumPhotosPickerItem, matching: .images) {
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
                .onChange(of: selectedAlbumPhotosPickerItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            viewModel.albumCoverArtwork = data
                        }
                    }
                }
            }
        }
    }
    
    var artistInformation: some View {
        Section("Artist Information") {
            Picker("Existing Artist", selection: $viewModel.currentArtist) {
                List {
                    Text("None selected").tag(nil as Artist?)
                    ForEach(existingArtists) { artist in
                        HStack {
                            if let artwork = artist.coverArtwork, let image = UIImage(data: artwork) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                    .clipShape(Circle())
                            } else {
                                Image("defaultartist")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                    .clipShape(Circle())
                            }
                            Text(artist.title)
                        }.tag(Optional(artist))
                    }
                }
            }
            .pickerStyle(.navigationLink)
            
            if viewModel.currentArtist == nil {
                TextField("Artist", text: $viewModel.artistTitle)
                PhotosPicker(selection: $selectedArtistPhotosPickerItem, matching: .images) {
                    if let artwork = viewModel.artistCoverArtwork, let image = UIImage(data: artwork) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        Image("defaultartist")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }
                }
                .onChange(of: selectedArtistPhotosPickerItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            viewModel.artistCoverArtwork = data
                        }
                    }
                }
            }
        }
    }
    
    var previewPlayButton: some View {
        Button {
            viewModel.togglePlay()
        } label: {
            Image(systemName: viewModel.isPlaying ? "stop.circle.fill" : "play.circle.fill")
        }
    }
    
    var addSongButton: some View {
        Button("Add song") {
            viewModel.addSong()
            presentingEditor = false
        }
    }
}


