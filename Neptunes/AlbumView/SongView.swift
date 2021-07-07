//
//  SongView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-07.
//

import SwiftUI

struct SongView: View {
    var song: Song
    var index: Int
    var body: some View {
        HStack(spacing: 14) {
            Text(index < 10 ? String(format: "%2d ", index) : String(index))
                .monospacedDigit()
                .foregroundColor(.secondary)
            Text(song.title)
                .fontWeight(.medium)
            if song.isExplicit {
                Image(systemName: "e.square.fill")
                    .foregroundColor(.red)
            }
            Spacer(minLength: 0)
            Image(systemName: "ellipsis")
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius:8))
    }
}

struct SongView_Previews: PreviewProvider {
    static var previews: some View {
        SongView(song: MusicModel().albums[0].songs[0], index: 1)
    }
}
