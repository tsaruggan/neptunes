//
//  ArtistView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-28.
//

import SwiftUI

struct ArtistView: View {
    @ObservedObject private var viewModel: ArtistViewModel
    @Environment(\.colorScheme) var colorScheme
    
    init(viewModel: ArtistViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NeptunesView(headerURI: viewModel.artist.headerURI, backgroundColor: viewModel.palette.background(colorScheme)) {
            ArtworkView(artworkURI: viewModel.artist.artworkURI, paddingHorizontal: 124, isCircle: true)
            
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Artist")
                        .font(.subheadline)
                        .foregroundColor(viewModel.palette.secondary(colorScheme))
                    Text(viewModel.artist.title)
                        .foregroundColor(viewModel.palette.primary(colorScheme))
                        .fontWeight(.bold)
                        .font(.title2)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(Array(viewModel.artist.albums as! Set<Album>)) { album in
                        NavigationLink {
                            AlbumView(viewModel: .init(album: album))
                        } label: {
                            VStack(alignment: .leading) {
                                Image(imageURI: album.artworkURI, default: "default_album_art")
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(8)
                                Text(album.title)
                                    .font(.headline)
                                    .foregroundColor(viewModel.palette.primary(colorScheme))
                                    .fontWeight(.bold)
                                    .lineLimit(1)
                            }
                            .frame(width: 164)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
            }
            
            SongListView(
                songs: Array(viewModel.artist.songs as! Set<Song>),
                labelColor: viewModel.palette.secondary(colorScheme),
                foregroundColor: viewModel.palette.primary(colorScheme),
                explicitSignColor: viewModel.palette.accent(colorScheme),
                menuColor: viewModel.palette.secondary(colorScheme),
                isDetailed: true
            )
            
            Spacer()
            
        } menu: {
            Button(action: {}) {
                Label("Edit Artist...", systemImage: "wand.and.stars")
            }
        }
        
    }
}

struct ArtistView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            NavigationView{
                ArtistView(viewModel: .init(artist: MusicData().artists[1]))
            }
            .preferredColorScheme($0)
        }
    }
}
