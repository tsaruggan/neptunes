//
//  AlbumEditorView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-10-24.
//

import SwiftUI

class AlbumEditorViewModel: ObservableObject {
    @Published var album: Album
    
    @Published var albumTitle: String
    @Published var albumArtwork: URL?
    @Published var albumHeader: URL?
    
    @Published var artistTitle: String
    @Published var artistArtwork: URL?
    @Published var artistHeader: URL?
    
    @Published var songs: [Song]
    @Published var deletedSongs: [Song] = []
    @Published var songsIsEditable = true
    
    init(album: Album) {
        self.album = album
        self.albumTitle = album.title
        self.albumArtwork = album.artworkURI
        self.albumHeader = album.headerURI
        
        self.artistTitle = album.artist.title
        self.artistArtwork = album.artist.artworkURI
        self.artistHeader = album.artist.headerURI
        
        self.songs = album.songs.array as! [Song]
        
    }
    
    func rearrangeSongs(from source: IndexSet, to destination: Int) {
        songs.move(fromOffsets: source, toOffset: destination)
    }
    
    func deleteSong(from offsets: IndexSet) {
        let indices = NSIndexSet(indexSet: offsets)
        album.removeFromSongs(at: indices)
    }
    
    func save() {
        
    }
    
    func cancel() {
        
    }
}

struct AlbumEditorView: View {
    @ObservedObject private var viewModel: AlbumEditorViewModel
    
    init(viewModel: AlbumEditorViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        EditorView("Edit Album") {
            Form {
                Section("ALBUM INFORMATION") {
                    TextField("Album Title", text: $viewModel.albumTitle)
                    HStack {
                        Button("Change Album Cover Artwork") {
                            
                        }
                        Spacer()
                        Image(imageURI: viewModel.albumArtwork, default: "default_album_art")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 40)
                            .cornerRadius(5)
                    }
                    HStack {
                        Button("Change Album Header Artwork") {
                            
                        }
                        Spacer()
                        Image(imageURI: viewModel.albumHeader, default: "default_header_art")
                            .resizable()
                            .aspectRatio(3, contentMode: .fit)
                            .frame(width: 40)
                    }
                }
                
                Section("ARTIST INFORMATION") {
                    TextField("Artist Title", text: $viewModel.artistTitle)
                    HStack {
                        Button("Change Artist Cover Artwork") {
                            
                        }
                        Spacer()
                        Image(imageURI: viewModel.artistArtwork, default: "default_album_art")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 40)
                            .clipShape(Circle())
                    }
                    HStack {
                        Button("Change Artist Header Artwork") {
                            
                        }
                        Spacer()
                        Image(imageURI: viewModel.artistHeader, default: "default_header_art")
                            .resizable()
                            .aspectRatio(3, contentMode: .fit)
                            .frame(width: 40)
                    }
                }
                
                Section("SONGS") {
                    List {
                        ForEach(viewModel.songs) { song in
                            Text(song.title)
                        }
                        .onMove(perform: viewModel.rearrangeSongs)
                        .onDelete(perform: viewModel.deleteSong)
                    }
                    
                }
                
            }
        }
    }
}


