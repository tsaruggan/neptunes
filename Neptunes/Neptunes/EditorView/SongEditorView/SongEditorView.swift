//
//  EditorView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-03.
//

import SwiftUI
import PhotosUI
import AVFoundation
import Mantis

struct SongEditorView: View {
    
    @ObservedObject public var viewModel: SongEditorViewModel
    
    @Binding var presentingEditor: Bool
    
    @State private var selectedAlbumCoverArtworkPhotosPickerItem: PhotosPickerItem? = nil
    @State private var selectedArtistCoverArtworkPhotosPickerItem: PhotosPickerItem? = nil
    @State private var selectedAlbumHeaderArtworkPhotosPickerItem: PhotosPickerItem? = nil
    @State private var selectedArtistHeaderArtworkPhotosPickerItem: PhotosPickerItem? = nil
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Artist.title, ascending: true)],
        animation: .default)
    public var existingArtists: FetchedResults<Artist>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Album.title, ascending: true)],
        animation: .default)
    public var existingAlbums: FetchedResults<Album>
    
    init(viewModel: SongEditorViewModel, presentingEditor: Binding<Bool>) {
        self.viewModel = viewModel
        self._presentingEditor = presentingEditor
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = .systemBackground
    }
    
    func getTitle(_ editorAction: EditorActionType) -> String {
        var title = ""
        if (editorAction == .new) {
            title = "New Song"
        } else if (editorAction == .edit) {
            title = "Edit Song"
        }
        return title
    }
    
    var body: some View {
        NavigationView {
            Form {
                previewPlayer
                songInformation
                artistInformation
                albumInformation
                
                if (viewModel.editorAction == .edit) {
                    deleteButton
                }
            }
            .navigationTitle(getTitle(viewModel.editorAction))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        presentingEditor = false
                    }
                    .foregroundColor(.red)
                    
                }
                if (viewModel.editorAction == .new) {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add") {
                            viewModel.addSong()
                            presentingEditor = false
                        }
                        .disabled(!viewModel.validate())
                    }
                } else if (viewModel.editorAction == .edit) {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Update") {
                            viewModel.updateSong()
                            presentingEditor = false
                        }
                        .disabled(!viewModel.validate())
                    }
                }
                
            }
            .interactiveDismissDisabled()
        }
    }
    
    var previewPlayer: some View {
        Section {
            PreviewPlayerView(viewModel: .init(url: viewModel.url))
        } header: {
            Text("Preview")
        } footer: {
            if let url = viewModel.url {
                Text(url.lastPathComponent)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
        }

    }
    
    var songInformation: some View {
        Section(header: Text("Song Information")) {
            TextField("Title", text: $viewModel.songTitle)
            Toggle(isOn: $viewModel.isExplicit) {
                HStack {
                    Text("Explicit Content")
                    if (viewModel.isExplicit) {
                        Spacer()
                        Image(systemName: "e.square.fill")
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
    
    var albumInformation: some View {
        Section(header: Text("Album Information")) {
            existingAlbumInformation
            if viewModel.currentAlbum == nil {
                TextField("Title", text: $viewModel.albumTitle)
                albumCoverArtworkPicker
                albumHeaderArtworkPicker
            }
        }
    }

    var existingAlbumInformation: some View {
        VStack {
            HStack {
                Picker(selection: $viewModel.currentAlbum) {
                    Text("None").tag(nil as Album?)
                    ForEach(existingAlbums.filter({ viewModel.currentArtist == nil || $0.artist == viewModel.currentArtist })) { album in
                        HStack {
                            Image(data: album.coverArtwork, fallback: "defaultcover")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 36, height: 36)
                            VStack(alignment: .leading) {
                                Text(album.title).bold()
                                Text(album.artist.title)
                            }
                        }
                        .tag(Optional(album))
                    }
                } label: {
                    Text("Existing Album")
                }
                .pickerStyle(.navigationLink)
            }
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
    
    var deleteButton: some View {
        Button {
            viewModel.deleteSong()
            presentingEditor = false
        } label: {
            HStack {
                Spacer()
                Text("Delete Song")
                    .foregroundColor(.red)
                Spacer()
            }
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

extension UIImage {
    convenience init?(data: Data?, fallback: String) {
        if let artwork = data {
            self.init(data: artwork)
        } else {
            self.init(named: fallback)
        }
    }
}

struct InitializedDisclosureGroup<Content: View, Label: View>: View {
    @State private var isExpanded: Bool

    let content: () -> Content
    let label: () -> Label

    init(isExpanded: Bool = false, @ViewBuilder content: @escaping () -> Content, @ViewBuilder label: @escaping () -> Label) {
        self._isExpanded = State(initialValue: isExpanded)
        self.content = content
        self.label = label
    }

    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            content()
        } label: {
            label()
        }
    }
}
