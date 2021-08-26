//
//  ArtistFinderView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-30.
//

import SwiftUI

struct ArtistFinderView: View {
    var body: some View {
        FinderView(title: "Artists", findables: MusicData().artists) { findable in
            if let artist = findable as? Artist {
                ArtistFinderItemView(artist: artist)
            }
        }
    }
}

struct ArtistFinderItemView: View {
    var artist: Artist
    var body: some View {
        NavigationLink(destination: ArtistView(viewModel: .init(artist: artist))) {
            HStack(spacing: 15) {
                Image(artist.artwork ?? "default_album_art")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 48)
                    .clipShape(Circle())
                Text(artist.title!)
                    .bold()
                    .lineLimit(1)
                Spacer()
            }
            .foregroundColor(.primary)
            .padding(5)
        }
    }
}

struct ArtistFinderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArtistFinderView()
        }
    }
}
