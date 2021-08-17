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
        self.artists = [
            Artist(title: "Drake", artwork: "drake_artist_art", header: "drake_header_art"),
            Artist(title: "Travis Scott", artwork: "travis_scott_artist_art", header: "travis_scott_header_art"),
            Artist(title: "Frank Ocean", artwork: "frank_ocean_artist_art", header: "frank_ocean_header_art"),
        ]
        
        self.albums = [
            Album(title: "Not Around", artist: self.artists[0], artwork: "drake_album_art_2", isSingle: true),
            Album(title: "Owl Pharaoh", artist: self.artists[1], artwork: "travis_scott_album_art_1"),
            Album(title: "Endless", artist: self.artists[2], artwork: "frank_ocean_album_art_1")
        ]
        
//        let palette1 = ColorAnalyzer.generatePalette(artwork: self.albums[0].artwork, header: self.albums[0].header)
//        let palette2 = ColorAnalyzer.generatePalette(artwork: self.albums[1].artwork, header: self.albums[1].header)
//        let palette3 = ColorAnalyzer.generatePalette(artwork: self.albums[2].artwork, header: self.albums[2].header)
//        self.albums[0].palette = palette1
//        self.albums[1].palette = palette2
//        self.albums[2].palette = palette3
        
        self.albums[0].addSongs(Song(title: "Not Around",isExplicit: true ,file: "song1"))
        self.artists[0].albums.append(self.albums[0])
        self.albums[0].artist = self.artists[0]
        
        
        self.albums[1].addSongs(Song(title: "Hell of a Night", file: "song2"))
        self.artists[1].albums.append(self.albums[1])
        self.albums[1].artist = self.artists[1]
        
        
        self.albums[2].addSongs(Song(title: "Wither", file: "song3"))
        self.albums[2].addSongs(Song(title: "Rushes", file: "song4"))
        self.artists[2].albums.append(self.albums[2])
        self.albums[2].artist = self.artists[2]
        
        self.collectables = self.albums + self.playlists
    }
}
