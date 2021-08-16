//
//  SongFinderView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-08-01.
//

import SwiftUI

struct SongFinderView: View {
    var body: some View {
        FinderView(title: "Songs", findables: MusicData().songs) { findable in
            if let song = findable as? Song {
                SongFinderItemView(song: song)
            }
        }
    }
}

struct SongFinderItemView: View {
    @EnvironmentObject var audioPlayer: AudioPlayer
    var song: Song
    var body: some View {
        DetailedSongView(
            song: song,
            artistLabelColor: .secondary,
            foregroundColor: .primary,
            explicitSignColor: .accentColor,
            menuColor: .secondary) {
                audioPlayer.replaceNowPlaying(songs: [song], from: 0)
            }
    }
}

struct SongFinderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            SongFinderView()
        }
    }
}
