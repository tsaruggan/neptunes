//
//  PlaylistFinderView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-08-01.
//

import SwiftUI

struct PlaylistFinderView: View {
    @ObservedObject var viewModel = FinderViewModel<Playlist>(entityName: "Playlist")
    var body: some View {
        FinderView(title: "Playlists", findables: viewModel.findables) { findable in
            if let playlist = findable as? Playlist {
                PlaylistFinderItemView(playlist: playlist)
            }
        }
    }
}

struct PlaylistFinderItemView: View {
    var playlist: Playlist
    var body: some View {
        NavigationLink(destination: PlaylistView(viewModel: .init(playlist: playlist))) {
            HStack(spacing: 15) {
                Image(playlist.artworkURI ?? "default_album_art")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(5)
                    .frame(height: 48)
                Text(playlist.title)
                    .bold()
                    .lineLimit(1)
                Spacer()
            }
            .foregroundColor(.primary)
            .padding(5)
        }
    }
}

struct PlaylistFinderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PlaylistFinderView()
        }
    }
}
