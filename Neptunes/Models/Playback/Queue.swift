//
//  Queue.swift
//  Queue
//
//  Created by Saruggan Thiruchelvan on 2021-08-11.
//

import Foundation

struct Queue {
    private var songs: [Song] = []
    
    var isEmpty: Bool {
        return songs.isEmpty
    }
    
    var currentSong: Song? {
        if isEmpty { return nil }
        return songs[0]
    }
    
    mutating func goToNext() {
        if isEmpty { return }
        songs.removeFirst()
    }
}
