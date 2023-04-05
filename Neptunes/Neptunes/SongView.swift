//
//  SongView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-05.
//

import SwiftUI

struct SongView: View {
    var song: Song
    
    var body: some View {
        HStack{
            if let coverArtwork = song.album.coverArtwork, let image = UIImage(data: coverArtwork) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
            } else {
                Image("defaultcover")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
            }
            
            VStack(alignment: .leading) {
                Text(song.title)
                    .font(.headline)
                Text(song.album.title)
                    .font(.subheadline)
                Text(song.artist.title)
                    .font(.caption)
            }
            Spacer()
        }
    }
}

