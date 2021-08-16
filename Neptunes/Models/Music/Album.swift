//
//  Album.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-07.
//

import Foundation

struct Album: Collectable, Findable, Identifiable {
    var title: String
    var artist: Artist
    var date: Date = Date()
    var artwork: String?
    var header: String?
    var songs: [Song] = []
    var isSingle: Bool = false
    var released: Date?
    var genre: String?
    var publisher: String?
    var producer: String?
    var id = UUID()
    var palette = Palette()
    
    mutating func addSongs(_ songs: Song...) {
        for song in songs {
            self.songs.append(song)
            self.songs[self.songs.endIndex - 1].album = self
        }
    }
}

