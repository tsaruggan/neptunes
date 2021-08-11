//
//  NowPlaying.swift
//  NowPlaying
//
//  Created by Saruggan Thiruchelvan on 2021-08-11.
//

import Foundation

struct NowPlaying {
    private var songs: [Song]
    private var currentIndex: Int
    
    var isEmpty: Bool {
        return songs.isEmpty
    }
    
    var currentSong: Song? {
        if isEmpty { return nil }
        if currentIndex >= 0 && currentIndex < songs.count {
            return songs[currentIndex]
        } else {
            return nil
        }
    }
    
    init(songs: [Song], from currentIndex: Int) {
        self.songs = songs
        self.currentIndex = currentIndex
    }
    
    mutating func goToNext() {
        if isEmpty { return }
        currentIndex += 1
        if currentIndex >= songs.count {
            currentIndex = 0
        }
    }
    
    mutating func goToPrevious() {
        if isEmpty { return }
        currentIndex -= 1
        if currentIndex < 0 {
            currentIndex = songs.count - 1
        }
    }
}
