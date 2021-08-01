//
//  PlaylistFinderView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-08-01.
//

import SwiftUI

struct PlaylistFinderView: View {
    @State var searchText = ""
    
    init() {
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    var body: some View {
        ScrollView{
            VStack {
                ForEach(playlists) { playlist in
                    PlaylistFinderItemView(playlist: playlist)
                    Divider()
                }
                Spacer()
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .navigationTitle("Albums")
            .navigationBarTitleDisplayMode(.inline)
        }
        .padding()
    }
    
    var playlists: [Playlist] {
        let playlists = MusicModel().playlists.sorted { $0.title < $1.title }
        if searchText.isEmpty {
            return playlists
        } else {
            return playlists.filter{
                $0.title.letters.caseInsensitiveContains(searchText.letters)
            }
        }
    }
}

struct PlaylistFinderItemView: View {
    var playlist: Playlist
    var body: some View {
        NavigationLink(destination: PlaylistView(viewModel: .init(playlist: playlist))) {
            HStack(spacing: 15) {
                Image(playlist.artwork ?? "default_album_art")
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
        .isDetailLink(false)
    }
}

struct PlaylistFinderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PlaylistFinderView()
        }
    }
}
