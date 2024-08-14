//
//  AlbumEditorView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2024-08-13.
//

import SwiftUI
import PhotosUI
import AVFoundation
import Mantis

struct AlbumEditorView: View {
    
    @ObservedObject public var viewModel: AlbumEditorViewModel
    
    @Binding var presentingEditor: Bool
    
    @State private var selectedAlbumCoverArtworkPhotosPickerItem: PhotosPickerItem? = nil
    @State private var selectedArtistCoverArtworkPhotosPickerItem: PhotosPickerItem? = nil
    @State private var selectedAlbumHeaderArtworkPhotosPickerItem: PhotosPickerItem? = nil
    @State private var selectedArtistHeaderArtworkPhotosPickerItem: PhotosPickerItem? = nil
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Artist.title, ascending: true)],
        animation: .default)
    public var existingArtists: FetchedResults<Artist>
    
    @State private var editMode: EditMode = .active
    
    init(viewModel: AlbumEditorViewModel, presentingEditor: Binding<Bool>) {
        self.viewModel = viewModel
        self._presentingEditor = presentingEditor
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = .systemBackground
    }
    
    func getTitle(_ editorAction: EditorActionType) -> String {
        return "Edit Album"
    }
    
    var body: some View {
        NavigationView {
            Form {
                albumInformation
                artistInformation
                songs
            }
            .environment(\.editMode, $editMode)
            .navigationTitle(getTitle(viewModel.editorAction))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        presentingEditor = false
                    }
                    .foregroundColor(.red)
                    
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Update") {
                        viewModel.updateAlbum()
                        presentingEditor = false
                    }
                    .disabled(!viewModel.validate())
                }
            }
            .interactiveDismissDisabled()
        }
    }
    
    var albumInformation: some View {
        Section(header: Text("Album Information")) {
            TextField("Title", text: $viewModel.albumTitle)
            albumCoverArtworkPicker
            albumHeaderArtworkPicker
        }
    }
    
    var artistInformation: some View {
        Section("Artist Information") {
            existingArtistInformation
            if viewModel.currentArtist == nil {
                TextField("Title", text: $viewModel.artistTitle)
                artistCoverArtworkPicker
                artistHeaderArtworkPicker
            }
        }
    }
    
    var existingArtistInformation: some View {
        Picker(selection: $viewModel.currentArtist) {
            Text("None").tag(nil as Artist?)
            ForEach(existingArtists) { artist in
                HStack {
                    Image(data: artist.coverArtwork, fallback: "defaultartist")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .clipShape(Circle())
                    Text(artist.title)
                }
                .tag(Optional(artist))
            }
        } label: {
            Text("Existing Artist")
        }
        .pickerStyle(.navigationLink)
    }
    
    var artistCoverArtworkPicker: some View {
        InitializedDisclosureGroup(isExpanded: true) {
            PhotoPickerView(image: $viewModel.artistCoverArtwork,
                            type: .artist,
                            onChange: viewModel.onArtistArtworkChange)
        } label: {
            Text("Artwork")
        }
    }
    
    var artistHeaderArtworkPicker: some View {
        InitializedDisclosureGroup(isExpanded: true) {
            PhotoPickerView(image: $viewModel.artistHeaderArtwork,
                            type: .header,
                            onChange: viewModel.onArtistArtworkChange)
        } label: {
            Text("Header")
        }
    }
    
    var albumCoverArtworkPicker: some View {
        InitializedDisclosureGroup(isExpanded: true) {
            PhotoPickerView(image: $viewModel.albumCoverArtwork,
                            type: .album,
                            onChange: viewModel.onAlbumArtworkChange)
        } label: {
            Text("Artwork")
        }
    }
    
    var albumHeaderArtworkPicker: some View {
        InitializedDisclosureGroup(isExpanded: true) {
            PhotoPickerView(image: $viewModel.albumHeaderArtwork,
                            type: .header,
                            onChange: viewModel.onAlbumArtworkChange)
        } label: {
            Text("Header")
        }
    }
    
    var songs: some View {
        let songsArray = viewModel.currentAlbum?.songs?.array as? [Song] ?? []

        return Section("Songs") {
            ForEach(songsArray, id: \.id) { song in
                HStack {
                    VStack(alignment: .leading) {
                        Text(song.title)
                            .fontWeight(.semibold)
                        Text(song.artist.title)
                            .font(.callout)
                    }
                    Spacer()
                }
            }
            .onMove(perform: viewModel.rearrangeSongs)
        }
    }
}
