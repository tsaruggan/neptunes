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
            Image(data: song.album.coverArtwork, fallback: "defaultcover")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 100)
            
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

