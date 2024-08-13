//
//  SongFinderView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-08-01.
//

import SwiftUI
import CoreData

struct SongFinderView: View {
    @ObservedObject var viewModel: FinderViewModel<Song>
    
    init(viewContext: NSManagedObjectContext) {
        self.viewModel = FinderViewModel<Song>(entityName: "Song", viewContext: viewContext)
    }
    
    var body: some View {
        FinderView(title: "Songs", findables: viewModel.findables) { findable in
            if let song = findable as? Song {
                SongFinderItemView(song: song)
            }
        }
    }
}

struct SongFinderItemView: View {
    @EnvironmentObject var audioPlayer: Player
    @ObservedObject var song: Song
    var body: some View {
        DetailedSongView(
            song: song,
            artistLabelColor: .secondary,
            foregroundColor: .primary,
            explicitSignColor: .red,
            menuColor: .secondary) {
                audioPlayer.replaceNowPlaying(songs: [song], from: 0)
            }
    }
}
