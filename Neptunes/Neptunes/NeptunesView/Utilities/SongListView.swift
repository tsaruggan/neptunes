//
//  SongListView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-17.
//

import SwiftUI
import MediaPlayer

struct SongListView: View {
    @EnvironmentObject var assetPlayer: AssetPlayer
    var songs: [Song]
    var labelColor: Color
    var foregroundColor: Color
    var explicitSignColor: Color
    var menuColor: Color
    var isDetailed: Bool
    var paddingTop: CGFloat = 8
    var paddingBottom: CGFloat = 20
    var paddingHorizontal: CGFloat = 8
    var body: some View {
        VStack(spacing: 0) {
            if isDetailed {
                ForEach(songs.indices, id: \.self) { i in
                    DetailedSongView(
                        song: songs[i],
                        artistLabelColor: labelColor,
                        foregroundColor: foregroundColor,
                        explicitSignColor: explicitSignColor,
                        menuColor: menuColor) {
                            assetPlayer.replaceNowPlaying(songs: songs, from: i)
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
                            assetPlayer.replaceNowPlaying(songs: songs, from: i)
                        }
                }
            }
        }
        .padding(.top, paddingTop)
        .padding(.bottom, paddingBottom)
        .padding(.horizontal, paddingHorizontal)
    }
}
