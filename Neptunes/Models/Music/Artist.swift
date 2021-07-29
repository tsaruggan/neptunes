//
//  Artist.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-07.
//

import Foundation

struct Artist: Sortable, Viewable {
    var title: String
    var date: Date = Date()
    var artwork: String?
    var header: String?
    var id: String { return title }
    var albums: [Album] = []
    var songs: [Song] {
        var songs: [Song] = []
        for album in self.albums {
            for song in album.songs {
                songs.append(song)
            }
        }
        songs = songs.sorted(by: {
            $0.title < $1.title
        })
        return songs
    }
}
