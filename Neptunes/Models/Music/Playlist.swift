//
//  Playlist.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-07.
//

import Foundation

struct Playlist: Collectable, Findable, Identifiable {
    var title: String
    var date: Date = Date()
    var artwork: String?
    var header: String?
    var songs: [Song] = []
    var id: String { return title }
    
    mutating func addSongs(_ songs: Song...) {
        for song in songs {
            self.songs.append(song)
        }
    }
}
