//
//  SongListView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-11.
//

import SwiftUI

struct SongListView: View {
    var songs: [Song]
    var body: some View {
        VStack(spacing: 0) {
            ForEach(songs.indices) { i in
                SongView(song: songs[i], index: i+1)
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 8)
    }
}

struct SongListView_Previews: PreviewProvider {
    static var previews: some View {
        SongListView(songs: MusicModel().albums[1].songs)
    }
}
