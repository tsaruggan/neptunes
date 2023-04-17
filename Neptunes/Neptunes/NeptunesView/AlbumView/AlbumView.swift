//
//  AlbumView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-17.
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
        NeptunesView(headerArtwork: viewModel.album.headerArtwork, backgroundColor: viewModel.album.palette?.background(colorScheme) ?? .clear) {
            ArtworkView(coverArtwork: viewModel.album.coverArtwork)
            albumInformation
            if let songs = viewModel.album.songs {
                SongListView(
                    songs: Array(_immutableCocoaArray: songs),
                    labelColor: viewModel.album.palette?.secondary(colorScheme) ?? .secondary,
                    foregroundColor: viewModel.album.palette?.primary(colorScheme) ?? .primary,
                    explicitSignColor: viewModel.album.palette?.accent(colorScheme) ?? .teal,
                    menuColor: viewModel.album.palette?.secondary(colorScheme) ?? .secondary,
                    isDetailed: false
                )
            }
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
//            AlbumEditorView(viewModel: .init(album: viewModel.album))
        }
        
    }
    
    
    var albumInformation: some View {
        VStack(alignment: .leading, spacing: 0) {
//            Text(viewModel.album.isSingle ? "Single" : "Album")
//                .font(.subheadline)
//                .foregroundColor(viewModel.palette.secondary(colorScheme))
            Text(viewModel.album.title)
                .foregroundColor(viewModel.album.palette?.primary(colorScheme) ?? .primary)
                .fontWeight(.bold)
                .font(.title2)
                .padding(.bottom, 4)
            NavigationLink {
//                ArtistView(viewModel: .init(artist: viewModel.album.artist))
            } label: {
                HStack {
                    Image(data: viewModel.album.artist.coverArtwork, fallback: "defaultartist")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(height: 24)
                    Text(viewModel.album.artist.title)
                        .foregroundColor(viewModel.album.palette?.secondary(colorScheme) ?? .secondary)
                }
            }
            .buttonStyle(.plain)
        }
        .frame(width: 320, alignment: .leading)
    }
}

