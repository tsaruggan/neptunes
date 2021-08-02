//
//  SongFinderView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-08-01.
//

import SwiftUI

struct SongFinderView: View {
    var body: some View {
        FinderView(title: "Songs", findables: MusicModel().songs) { findable in
            if let song = findable as? Song {
                SongFinderItemView(song: song)
            }
        }
    }
}

struct SongFinderItemView: View {
    var song: Song
    var body: some View {
        DetailedSongView(
            song: song,
            artistLabelColor: .secondary,
            foregroundColor: .primary,
            explicitSignColor: .accentColor,
            menuColor: .secondary
        )
    }
}

struct SongFinderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            SongFinderView()
        }
    }
}
