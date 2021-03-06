//
//  AlbumView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-01.
//

import SwiftUI

struct AlbumView: View {
    @ObservedObject private var viewModel: AlbumViewModel
    @Environment(\.colorScheme) var colorScheme
    
    @State private var showingEditor = false
    
    init(viewModel: AlbumViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NeptunesView(headerURI: viewModel.album.headerURI, backgroundColor: viewModel.palette.background(colorScheme)) {
            ArtworkView(artworkURI: viewModel.album.artworkURI)
            albumInformation
            SongListView(
                songs: Array(_immutableCocoaArray: viewModel.album.songs),
                labelColor: viewModel.palette.secondary(colorScheme),
                foregroundColor: viewModel.palette.primary(colorScheme),
                explicitSignColor: viewModel.palette.accent(colorScheme),
                menuColor: viewModel.palette.secondary(colorScheme),
                isDetailed: false
            )
            Spacer()
        } menu: {
            Button(action: {}) {
                Label("Import Music...", systemImage: "plus")
            }
            Button {
                showingEditor.toggle()
            } label: {
                Label("Edit Album...", systemImage: "wand.and.stars")
            }
            Button(action: {}) {
                Label("Share Album...", systemImage: "square.and.arrow.up")
            }
        }
        .sheet(isPresented: $showingEditor) {
            AlbumEditorView(viewModel: .init(album: viewModel.album))
        }
        
    }
    
    
    var albumInformation: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(viewModel.album.isSingle ? "Single" : "Album")
                .font(.subheadline)
                .foregroundColor(viewModel.palette.secondary(colorScheme))
            Text(viewModel.album.title)
                .foregroundColor(viewModel.palette.primary(colorScheme))
                .fontWeight(.bold)
                .font(.title2)
                .padding(.bottom, 4)
            NavigationLink {
                ArtistView(viewModel: .init(artist: viewModel.album.artist))
            } label: {
                HStack {
                    Image(imageURI: viewModel.album.artist.artworkURI, default: "default_album_art")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(height: 24)
                    Text(viewModel.album.artist.title)
                        .foregroundColor(viewModel.palette.secondary(colorScheme))
                }
            }
            .buttonStyle(.plain)
        }
        .frame(width: 320, alignment: .leading)
    }
}

struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            NavigationView{
                AlbumView(viewModel: .init(album: MusicData().albums[1]))
            }
            .preferredColorScheme($0)
        }
        
    }
}
