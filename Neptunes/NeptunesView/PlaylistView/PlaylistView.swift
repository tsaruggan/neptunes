//
//  PlaylistView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-15.
//

import SwiftUI

struct PlaylistView: View {
    @ObservedObject private var viewModel: PlaylistViewModel
    @Environment(\.colorScheme) var colorScheme
    
    init(viewModel: PlaylistViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NeptunesView(headerURI: viewModel.playlist.headerURI, backgroundColor: viewModel.palette.background(colorScheme)) {
            ArtworkView(artworkURI: viewModel.playlist.artworkURI)
            playlistInformation
            SongListView(
                songs: Array(_immutableCocoaArray: viewModel.playlist.songs),
                labelColor: viewModel.palette.secondary(colorScheme),
                foregroundColor: viewModel.palette.primary(colorScheme),
                explicitSignColor: viewModel.palette.accent(colorScheme),
                menuColor: viewModel.palette.secondary(colorScheme),
                isDetailed: true
            )
            Spacer()
        } menu: {
            Button(action: {}) {
                Label("Import Music...", systemImage: "plus")
            }
            Button(action: {}) {
                Label("Edit Album...", systemImage: "wand.and.stars")
            }
            Button(action: {}) {
                Label("Share Album...", systemImage: "square.and.arrow.up")
            }
        }
    }
    
    var playlistInformation: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Playlist")
                .font(.subheadline)
                .foregroundColor(viewModel.palette.secondary(colorScheme))
            Text(viewModel.playlist.title)
                .foregroundColor(viewModel.palette.primary(colorScheme))
                .fontWeight(.bold)
                .font(.title2)
        }
        .frame(width: 320, alignment: .leading)
    }
}

struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistView(viewModel: .init(playlist: MusicData().playlists[0]))
    }
}
