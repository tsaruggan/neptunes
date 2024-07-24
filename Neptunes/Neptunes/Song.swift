//
//  Song.swift
//  player-demo
//
//  Created by Saruggan Thiruchelvan on 2023-05-20.
//

import Foundation


struct Song {
    var title: String
    var filename: String
    var artist: String
    var album: String
    var id: UUID
    
    init(title: String, filename: String, artist: String, album: String) {
        self.title = title
        self.filename = filename
        self.artist = artist
        self.album = album
        self.id = UUID()
        save()
    }
    
    private func save() {
        LocalFileManager().saveSong(filename: self.filename, song: self)
    }
}

extension Song : Identifiable {

}
