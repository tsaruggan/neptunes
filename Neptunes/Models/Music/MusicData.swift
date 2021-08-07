//
//  MusicData.swift
//  MusicData
//
//  Created by Saruggan Thiruchelvan on 2021-08-07.
//

import Foundation

struct MusicData {
    var albums: [Album] = []
    var artists: [Artist] = []
    var playlists: [Playlist] = []
    var collectables: [Collectable] = []
    var songs: [Song] {
        var songs: [Song] = []
        for album in albums {
            for song in album.songs {
                songs.append(song)
            }
        }
        return songs
    }
    
    init() {
        self.artists = [Artist(title: "Drake", artwork: "drake_artist_art", header: "drake_header_art")]
        self.albums = [Album(title: "Not Around", artist: self.artists[0], artwork: "drake_album_art_2", isSingle: true)]
        self.albums[0].addSongs(Song(title: "Not Around"))
        self.artists[0].albums.append(self.albums[0])
        self.albums[0].artist = self.artists[0]
        self.collectables = self.albums + self.playlists
    }
}
