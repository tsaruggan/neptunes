//
//  AlbumView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-17.
//

import SwiftUI
import Shiny

struct AlbumView: View {
    @ObservedObject private var viewModel: AlbumViewModel
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var presentingAlbumEditor = false
    
    init(viewModel: AlbumViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NeptunesView(headerArtwork: viewModel.album.headerArtwork, backgroundColor: viewModel.album.palette?.background(colorScheme) ?? .clear) {
            ArtworkView(coverArtwork: viewModel.album.coverArtwork, paddingBottom: 12)
            albumInformation
            if viewModel.album.songs != nil{
                SongListView(
                    source: viewModel.album,
                    labelColor: viewModel.album.palette?.secondary(colorScheme) ?? .secondary,
                    foregroundColor: viewModel.album.palette?.primary(colorScheme) ?? .primary,
                    explicitSignColor: viewModel.album.palette?.accent(colorScheme) ?? .red,
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
                presentingAlbumEditor = true
            } label: {
                Label("Edit Album...", systemImage: "wand.and.stars")
            }
            Button(action: {}) {
                Label("Share Album...", systemImage: "square.and.arrow.up")
            }
        }
        .sheet(isPresented: $presentingAlbumEditor) {
            AlbumEditorView(viewModel: .init(album: viewModel.album, viewContext: viewContext), presentingEditor: $presentingAlbumEditor)
        }
    }
    
    var albumInformation: some View {
        HStack {
            Spacer()
            VStack(alignment: .center, spacing: 0) {
                Text(viewModel.album.title)
                    .foregroundColor(viewModel.album.palette?.primary(colorScheme) ?? .primary)
                    .font(.title.width(.expanded))
                    .fontWeight(.bold)
                    .padding(.bottom, 4)
                NavigationLink {
                    ArtistView(viewModel: .init(artist: viewModel.album.artist))
                } label: {
                    HStack {
                        Spacer()
                        Image(data: viewModel.album.artist.coverArtwork, fallback: "defaultartist")
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(height: 24)
                        Text(viewModel.album.artist.title)
                            .foregroundColor(viewModel.album.palette?.secondary(colorScheme) ?? .secondary)
                            .font(.body.width(.expanded))
                        Spacer()
                    }
                }
                .buttonStyle(.plain)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

