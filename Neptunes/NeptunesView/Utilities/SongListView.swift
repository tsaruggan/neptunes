//
//  SongListView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-11.
//

import SwiftUI

struct SongListView: View {
    var songs: [Song]
    var indexLabelColor: Color
    var foregroundColor: Color
    var explicitSignColor: Color
    var menuColor: Color
    var body: some View {
        VStack(spacing: 0) {
            ForEach(songs.indices) { i in
                SongView(
                    song: songs[i],
                    index: i+1,
                    indexLabelColor: indexLabelColor,
                    foregroundColor: foregroundColor,
                    explicitSignColor: explicitSignColor,
                    menuColor: menuColor
                )
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 8)
    }
}
