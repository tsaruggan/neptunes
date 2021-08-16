//
//  DetailedSongView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-15.
//

import SwiftUI

struct DetailedSongView: View {
    @EnvironmentObject var audioPlayer: AudioPlayer
    var song: Song
    var artistLabelColor: Color
    var foregroundColor: Color
    var explicitSignColor: Color
    var menuColor: Color
    var onTap: () -> Void
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
            .onTapGesture {
                onTap()
            }
            Spacer(minLength: 0)
            Menu() {
                Button {
                    audioPlayer.addToQueue(song: song)
                } label: {
                    Label("Add To Queue", systemImage: "text.badge.plus")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(menuColor)
                
            }

        }
        .padding(12)
    }
}
