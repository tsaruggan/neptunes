//
//  DetailedSongView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-15.
//

import SwiftUI

struct DetailedSongView: View {
    var song: Song
    var artistLabelColor: Color
    var foregroundColor: Color
    var explicitSignColor: Color
    var menuColor: Color
    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            Image(song.artwork ?? "default_album_art")
                .resizable()
                .scaledToFit()
                .cornerRadius(2)
                .frame(height: 40)
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .center, spacing: 14) {
                    Text(song.title)
                        .fontWeight(.medium)
                        .foregroundColor(foregroundColor)
                        .lineLimit(1)
                    if song.isExplicit {
                        Image(systemName: "e.square.fill")
                            .foregroundColor(explicitSignColor)
                    }
                }
                
                Text(song.artist!.title)
                    .foregroundColor(artistLabelColor)
                    .font(.callout)
                    .lineLimit(1)
            }
            Spacer(minLength: 0)
            Image(systemName: "ellipsis")
                .foregroundColor(menuColor)
        }
        .padding(12)
    }
}
