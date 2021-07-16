//
//  MusicModel.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-04.
//

import Foundation

struct MusicModel {
    var albums: [Album]
    var artists: [Artist]
    var playlists: [Playlist]
    var collectables: [Collectable]
    
    init() {
        self.artists = [
            Artist(title: "Drake", artwork: "drake_artist_art"),
            Artist(title: "Frank Ocean", artwork: "frank_ocean_artist_art"),
            Artist(title: "Travis Scott", artwork: "travis_scott_artist_art"),
            Artist(title: "SZA", artwork: "sza_artist_art")
        ]
        self.albums = [
            //            Album(title: "Talk is Cheap (feat. Aaliyah & Static Major)", artist: self.artists[0], artwork: "drake_album_art_2", header: "drake_header_art", isSingle: true),
            Album(title: "Endless", artist: self.artists[1], artwork: "frank_ocean_album_art_1", header: "frank_ocean_header_art"),
            //            Album(title: "Days Before Rodeo", artist: self.artists[2], artwork: "travis_scott_album_art_2", header: "travis_scott_header_art"),
            Album(title: "nostalgia, ULTRA", artist: artists[1], artwork: "frank_ocean_album_art_2", header: "frank_ocean_header_art_2"),
            Album(title: "Love Galore (Solo Version)", artist: artists[3], artwork: "sza_album_artwork_1" ,header: "sza_header_art_1", isSingle: true)
        ]
        self.albums[0].addSongs(
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
        //        self.albums[2].addSongs(
        //            Song(title: "Days Before Rodeo: The Prayer"),
        //            Song(title: "Mamacita (feat. Rich Homie Quan & Young Thug)", isExplicit: true),
        //            Song(title: "Quintana Pt. 2", isExplicit: true),
        //            Song(title: "Drugs You Should Try It"),
        //            Song(title: "Don't Play (feat. The 1975 & Big Sean)"),
        //            Song(title: "Skyfall (feat. Young Thug)"),
        //            Song(title: "Zombies", isExplicit: true),
        //            Song(title: "Sloppy Toppy (feat. Migos & Peewee Longway)"),
        //            Song(title: "Basement Freestyle", isExplicit: true),
        //            Song(title: "Backyard", isExplicit: true),
        //            Song(title: "Grey"),
        //            Song(title: "BACC")
        //        )
        self.albums[1].addSongs(
            Song(title: "Street Fighter"),
            Song(title: "Strawberry Swing"),
            Song(title: "Novacane", isExplicit: true),
            Song(title: "We All Try"),
            Song(title: "Bitches Talkin'"),
            Song(title: "Songs for Women", isExplicit: true),
            Song(title: "Lovecrimes"),
            Song(title: "Goldeneye"),
            Song(title: "There Will Be Tears"),
            Song(title: "Swim Good"),
            Song(title: "Dust"),
            Song(title: "American Wedding"),
            Song(title: "Soul Calibur"),
            Song(title: "Nature Feels", isExplicit: true)
        )
        self.albums[2].addSongs(
            Song(title: "Love Galore (Solo Version)", isExplicit: true)
        )
        
        self.playlists = [
            Playlist(title: "SUMMER 2021", artwork: "drake_album_art_2",
                     songs: [
                        self.albums[0].songs[8],
                        self.albums[1].songs[1],
                        self.albums[2].songs[0],
                        self.albums[1].songs[2]
                     ])
        ]
        
        self.collectables = self.albums + self.playlists
    }
}
