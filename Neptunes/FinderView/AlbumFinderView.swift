//
//  AlbumFinderView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-31.
//

import SwiftUI

struct AlbumFinderView: View {
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
                ForEach(albums) { album in
                    AlbumFinderItemView(album: album)
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
    
    var albums: [Album] {
        let albums = MusicModel().albums.sorted { $0.title < $1.title }
        if searchText.isEmpty {
            return albums
        } else {
            return albums.filter{
                $0.title.letters.caseInsensitiveContains(searchText.letters)
            }
        }
    }
}

struct AlbumFinderItemView: View {
    var album: Album
    var body: some View {
        NavigationLink(destination: AlbumView(viewModel: .init(album: album))) {
            HStack(spacing: 15) {
                Image(album.artwork ?? "default_album_art")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(5)
                    .frame(height: 48)
                VStack(alignment: .leading, spacing: 4) {
                    Text(album.title)
                        .bold()
                        .lineLimit(1)
                    Text(album.artist.title)
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .foregroundColor(.primary)
            .padding(5)
        }
        .isDetailLink(false)
    }
}

struct AlbumFinderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AlbumFinderView()
        }
    }
}
