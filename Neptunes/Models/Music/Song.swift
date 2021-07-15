//
//  Song.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-07.
//

import Foundation

struct Song: Sortable, Identifiable {
    var title: String
    var date: Date = Date()
    var album: Album?
    var artwork: String? {
        if let image = album?.artwork { return image }
        return nil
    }
    var artist: Artist? {
        if let artist = album?.artist { return artist }
        return nil
    }
    var isExplicit: Bool = false
    var id = UUID()
}
