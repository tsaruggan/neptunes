//
//  AlbumView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-01.
//

import SwiftUI

struct AlbumView: View {
    @ObservedObject private var viewModel: AlbumViewModel
    @Environment(\.colorScheme) var colorScheme
    
    init(viewModel: AlbumViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NeptunesView(header: viewModel.album.header, backgroundColor: viewModel.palette.background(colorScheme)) {
            ArtworkView(artwork: viewModel.album.artwork!)
            albumInformation
            SongListView(
                songs: viewModel.album.songs,
                indexLabelColor: viewModel.palette.secondary(colorScheme),
                foregroundColor: viewModel.palette.primary(colorScheme),
                explicitSignColor: viewModel.palette.accent(colorScheme),
                menuColor: viewModel.palette.secondary(colorScheme)
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
    
    
    var albumInformation: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(viewModel.album.isSingle ? "Single" : "Album")
                .font(.subheadline)
                .foregroundColor(viewModel.palette.secondary(colorScheme))
            Text(viewModel.album.title)
                .foregroundColor(viewModel.palette.primary(colorScheme))
                .fontWeight(.bold)
                .font(.title)
                .padding(.bottom, 4)
            HStack {
                Image(viewModel.album.artist.artwork!)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(height: 28)
                Text(viewModel.album.artist.title)
                    .foregroundColor(viewModel.palette.primary(colorScheme))
            }
        }
        .frame(width: 320, alignment: .leading)
    }
    
    
}

struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            NavigationView{
                AlbumView(viewModel: .init(album: MusicModel().albums[0]))
            }
            .preferredColorScheme($0)
        }
        
    }
}