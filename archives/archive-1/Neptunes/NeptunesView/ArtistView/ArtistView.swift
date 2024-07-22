//
//  ArtistView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-20.
//

import SwiftUI

struct ArtistView: View {
    @ObservedObject private var viewModel: ArtistViewModel
    @Environment(\.colorScheme) var colorScheme
    
    init(viewModel: ArtistViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NeptunesView(headerArtwork: viewModel.artist.headerArtwork, backgroundColor: viewModel.artist.palette?.background(colorScheme) ?? .clear) {
            ArtworkView(coverArtwork: viewModel.artist.coverArtwork, paddingHorizontal: 124, isCircle: true)
            
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Artist")
                        .font(.subheadline)
                        .foregroundColor(viewModel.artist.palette?.secondary(colorScheme) ?? .secondary)
                    Text(viewModel.artist.title)
                        .foregroundColor(viewModel.artist.palette?.primary(colorScheme) ?? .primary)
                        .fontWeight(.bold)
                        .font(.title2)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    if let albums = viewModel.artist.albums {
                        ForEach(Array(albums as! Set<Album>)) { album in
                            NavigationLink {
                                AlbumView(viewModel: .init(album: album))
                            } label: {
                                VStack(alignment: .leading) {
                                    Image(data: album.coverArtwork, fallback: "defaultcover")
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(8)
                                    Text(album.title)
                                        .font(.headline)
                                        .foregroundColor(viewModel.artist.palette?.primary(colorScheme) ?? .primary)
                                        .fontWeight(.bold)
                                        .lineLimit(1)
                                }
                                .frame(width: 164)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            if let songs = viewModel.artist.songs {
                SongListView(
                    songs: Array(songs as! Set<Song>),
                    labelColor: viewModel.artist.palette?.secondary(colorScheme) ?? .secondary,
                    foregroundColor: viewModel.artist.palette?.primary(colorScheme) ?? .primary,
                    explicitSignColor: viewModel.artist.palette?.accent(colorScheme) ?? .primary,
                    menuColor: viewModel.artist.palette?.secondary(colorScheme) ?? .secondary,
                    isDetailed: true
                )
            }
            Spacer()
            
        } menu: {
            Button(action: {}) {
                Label("Edit Artist...", systemImage: "wand.and.stars")
            }
        }
        
    }
}

