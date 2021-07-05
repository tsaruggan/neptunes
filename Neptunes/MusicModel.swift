//
//  MusicModel.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-04.
//

import Foundation

protocol Viewable {
    var title: String { get set }
    var image: String { get set }
    var header: String? { get set }
}

protocol Sortable {
    var title: String { get set }
    var date: Date { get }
}

protocol Arrangeable {
    var songs: [Song] { get set }
    mutating func addSongs(_ songs: Song...)
}

struct Artist: Viewable, Identifiable {
    var title: String
    var image: String = "default_artist_image"
    var header: String?
    var id: String { return title }
}

struct Song: Sortable, Identifiable {
    var title: String
    var date: Date = Date()
    var album: Album?
    var image: String? {
        if let image = album?.image { return image }
        return nil
    }
    var artist: Artist? {
        if let artist = album?.artist { return artist }
        return nil
    }
    var isExplicit: Bool = false
    var id = UUID()
}

struct Album: Sortable, Viewable, Arrangeable, Identifiable {
    var title: String
    var artist: Artist
    var date: Date = Date()
    var image: String = "default_album_image"
    var header: String?
    var songs: [Song] = []
    var isSingle: Bool = false
    var released: Date?
    var genre: String?
    var publisher: String?
    var producer: String?
    var id = UUID()
    
    mutating func addSongs(_ songs: Song...) {
        for song in songs {
            self.songs.append(song)
            self.songs[self.songs.endIndex - 1].album = self
        }
    }
}

struct Playlist: Sortable, Viewable, Arrangeable, Identifiable {
    var title: String
    var date: Date = Date()
    var image: String = "default_playlist_image"
    var header: String?
    var songs: [Song] = []
    var id: String { return title }
    
    mutating func addSongs(_ songs: Song...) {
        for song in songs {
            self.songs.append(song)
        }
    }
}

struct MusicModel {
    var albums: [Album]
    var artists: [Artist]
    
    init() {
        self.artists = [
            Artist(title: "Drake", image: "drake_artist_art"),
            Artist(title: "Frank Ocean", image: "frank_ocean_artist_art"),
            Artist(title: "Travis Scott", image: "travis_scott_artist_art")
        ]
        self.albums = [
            Album(title: "Not Around", artist: self.artists[0], image: "drake_album_art_1", header: "drake_header_art", isSingle: true),
            Album(title: "Endless", artist: self.artists[1], image: "frank_ocean_album_art_1", header: "frank_ocean_header_art"),
            Album(title: "Days Before Rodeo", artist: self.artists[2], image: "travis_scott_album_art_2", header: "travis_scott_header_art"),
        ]
        self.albums[0].addSongs(
            Song(title: "Not Around", isExplicit: true)
        )
        self.albums[1].addSongs(
            Song(title: "At Your Best (You Are Love)"),
            Song(title: "Alabama"),
            Song(title: "Mine", isExplicit: true),
            Song(title: "U-N-I-T-Y", isExplicit: true),
            Song(title: "Ambience 001 (A Certain Way)"),
            Song(title: "Comme des Garçons"),
            Song(title: "Xenons"),
            Song(title: "Ambience 002 (Honeybaby)"),
            Song(title: "Wither", isExplicit: true),
            Song(title: "Hublots"),
            Song(title: "In Here Somewhere"),
            Song(title: "Slide on Me"),
            Song(title: "Sideways"),
            Song(title: "Florida"),
            Song(title: "Impietas + Deathwish (ASR)"),
            Song(title: "Rushes", isExplicit: true),
            Song(title: "Rushes To"),
            Song(title: "Higgs"),
            Song(title: "Mitsubishi Sony"),
            Song(title: "Device Control (Reprise)")
        )
        self.albums[2].addSongs(
            Song(title: "Days Before Rodeo: The Prayer"),
            Song(title: "Mamacita (feat. Rich Homie Quan & Young Thug)", isExplicit: true),
            Song(title: "Quintana Pt. 2", isExplicit: true),
            Song(title: "Drugs You Should Try It"),
            Song(title: "Don't Play (feat. The 1975 & Big Sean)"),
            Song(title: "Skyfall (feat. Young Thug)"),
            Song(title: "Zonbies", isExplicit: true),
            Song(title: "Sloppy Toppy (feat. Migos & Peewee Longway)"),
            Song(title: "Basement Freestyle", isExplicit: true),
            Song(title: "Backyard", isExplicit: true),
            Song(title: "Grey"),
            Song(title: "BACC")
        )
    }
}
