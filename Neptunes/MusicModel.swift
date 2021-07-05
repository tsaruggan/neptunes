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
    var header: String { get set }
}

extension Viewable {
    var header: String {
        get { return "" } set {}
    }
}

protocol Sortable {
    var title: String { get set }
    var date: Date { get }
}

protocol Arrangeable {
    var songs: [Song] { get set }
}

struct Artist: Viewable, Identifiable {
    var title: String
    var image: String = "default_artist_image"
    var id: String {
        return title
    }
}

struct Song: Sortable, Identifiable {
    var title: String
    var date: Date
    var album: Album
    var image: String {
        album.image
    }
    var artist: Artist {
        album.artist
    }
    var id = UUID()
}

struct Album: Sortable, Viewable, Arrangeable, Identifiable {
    var title: String
    var artist: Artist
    var date: Date
    var image: String = "default_album_image"
    var songs: [Song]
    var isSingle: Bool
    var released: Date?
    var genre: String?
    var publisher: String?
    var producer: String?
    var id = UUID()
}

struct Playlist: Sortable, Viewable, Arrangeable, Identifiable {
    var title: String
    var date: Date
    var image: String
    var songs: [Song]
    var id: String {
        return title
    }
}
