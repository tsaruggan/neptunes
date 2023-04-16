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
                artistInformation
                albumInformation
                
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
            existingAlbumInformation
            if viewModel.currentAlbum == nil {
                TextField("Album", text: $viewModel.albumTitle)
                PhotosPicker(selection: $selectedAlbumPhotosPickerItem, matching: .images) {
                    Image(data: viewModel.albumCoverArtwork, fallback: "defaultcover")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }
                .onChange(of: selectedAlbumPhotosPickerItem) { newItem in
                    viewModel.updateAlbumCoverArtwork(item: newItem)
                }
            }
        }
    }
    
    var existingAlbumInformation: some View {
        Picker("Existing Album", selection: $viewModel.currentAlbum) {
            List {
                Text("None selected").tag(nil as Album?)
                ForEach(existingAlbums.filter({ viewModel.currentArtist == nil || $0.artist == viewModel.currentArtist })) { album in
                    HStack {
                        Image(data: album.coverArtwork, fallback: "defaultcover")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
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
    }
    
    var artistInformation: some View {
        Section("Artist Information") {
            existingArtistInformation
            if viewModel.currentArtist == nil {
                TextField("Artist", text: $viewModel.artistTitle)
                PhotosPicker(selection: $selectedArtistPhotosPickerItem, matching: .images) {
                    Image(data: viewModel.artistCoverArtwork, fallback: "defaultartist")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                }
                .onChange(of: selectedArtistPhotosPickerItem) { newItem in
                    viewModel.updateArtistCoverArtwork(item: newItem)
                }
            }
        }
    }
    
    var existingArtistInformation: some View {
        Picker("Existing Artist", selection: $viewModel.currentArtist) {
            List {
                Text("None selected").tag(nil as Artist?)
                ForEach(existingArtists) { artist in
                    HStack {
                        Image(data: artist.coverArtwork, fallback: "defaultartist")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .clipShape(Circle())
                        Text(artist.title)
                    }.tag(Optional(artist))
                }
            }
        }
        .pickerStyle(.navigationLink)
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

extension Image {
    init(data: Data?, fallback: String) {
        if let artwork = data,
           let image = UIImage(data: artwork) {
            self.init(uiImage: image)
        } else {
            self.init(fallback)
        }
    }
}
