//
//  AlbumFinderView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-31.
//

import SwiftUI

struct AlbumFinderView: View {
    var body: some View {
        FinderView(title: "Albums", findables: MusicData().albums) { findable in
            if let album = findable as? Album {
                AlbumFinderItemView(album: album)
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
                    Text(album.title!)
                        .bold()
                        .lineLimit(1)
                    Text(album.artist!.title!)
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .foregroundColor(.primary)
            .padding(5)
        }
    }
}

struct AlbumFinderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AlbumFinderView()
        }
    }
}
