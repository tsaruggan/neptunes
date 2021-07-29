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
        NeptunesView(header: viewModel.artist.header, backgroundColor: viewModel.palette.background(colorScheme)) {
            ArtworkView(artwork: viewModel.artist.artwork ?? "default_album_art", paddingHorizontal: 124, isCircle: true)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(viewModel.artist.title)
                        .foregroundColor(viewModel.palette.primary(colorScheme))
                        .fontWeight(.bold)
                        .font(.title)
                    Spacer()
                }
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(viewModel.artist.albums + viewModel.artist.albums) { album in
                        VStack(alignment: .leading) {
                            Image(album.artwork ?? "default_album_art")
                                .resizable()
                                .scaledToFill()
                                .cornerRadius(8)
                            Text(album.title)
                                .font(.headline)
                                .foregroundColor(.primary)
                                .fontWeight(.bold)
                                .lineLimit(1)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)

            }
            .frame(height: 220)
            
            Divider()
            
            SongListView(
                songs: viewModel.artist.songs,
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
                ArtistView(viewModel: .init(artist: MusicModel().artists[1]))
            }
            .preferredColorScheme($0)
        }
    }
}
