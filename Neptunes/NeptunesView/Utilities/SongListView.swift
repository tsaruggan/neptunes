//
//  SongListView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-11.
//

import SwiftUI

struct SongListView: View {
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
                ForEach(songs.indices) { i in
                    DetailedSongView(
                        song: songs[i],
                        artistLabelColor: labelColor,
                        foregroundColor: foregroundColor,
                        explicitSignColor: explicitSignColor,
                        menuColor: menuColor
                    )
                }
            } else {
                ForEach(songs.indices) { i in
                    SongView(
                        song: songs[i],
                        index: i+1,
                        indexLabelColor: labelColor,
                        foregroundColor: foregroundColor,
                        explicitSignColor: explicitSignColor,
                        menuColor: menuColor
                    )
                }
            }
        }
        .padding(.top, paddingTop)
        .padding(.bottom, paddingBottom)
        .padding(.horizontal, paddingHorizontal)
    }
}
