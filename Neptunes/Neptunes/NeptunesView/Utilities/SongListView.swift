//
//  SongListView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-17.
//

import SwiftUI
import MediaPlayer

struct SongListView: View {
    @EnvironmentObject var player: Player
    var songs: [Song]
    var labelColor: Color
    var foregroundColor: Color
    var explicitSignColor: Color
    var menuColor: Color
    var isDetailed: Bool
    var paddingTop: CGFloat = 8
    var paddingBottom: CGFloat = 0
    var paddingHorizontal: CGFloat = 20
    var body: some View {
        VStack(spacing: 24) {
            if isDetailed {
                ForEach(songs.indices, id: \.self) { i in
                    DetailedSongView(
                        song: songs[i],
                        artistLabelColor: labelColor,
                        foregroundColor: foregroundColor,
                        explicitSignColor: explicitSignColor,
                        menuColor: menuColor) {
                            player.replaceNowPlaying(songs: songs, from: i)
                        }
                }
            } else {
                ForEach(songs.indices, id: \.self) { i in
                    SongView(
                        song: songs[i],
                        index: i+1,
                        indexLabelColor: labelColor,
                        foregroundColor: foregroundColor,
                        explicitSignColor: explicitSignColor,
                        menuColor: menuColor) {
                            player.replaceNowPlaying(songs: songs, from: i)
                        }
                }
            }
        }
        .padding(.top, paddingTop)
        .padding(.bottom, paddingBottom)
        .padding(.horizontal, paddingHorizontal)
    }
}
