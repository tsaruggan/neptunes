//
//  NowPlaying.swift
//  NowPlaying
//
//  Created by Saruggan Thiruchelvan on 2021-08-11.
//

import Foundation
import AVFoundation

struct NowPlaying {
    private var songs: [Song] = []
    private var playerItems: [AVPlayerItem] = []
    let assetKeys = ["playable"]
    private var currentIndex: Int = 0
    
    var isEmpty: Bool {
        return songs.isEmpty
    }
    
    var currentSong: Song? {
        if songs.isEmpty { return nil }
        if currentIndex >= 0 && currentIndex < songs.count {
            return songs[currentIndex]
        } else {
            return nil
        }
    }
    
    var currentPlayerItem: AVPlayerItem? {
        if playerItems.isEmpty { return nil }
        if currentIndex >= 0 && currentIndex < playerItems.count {
            return playerItems[currentIndex]
        } else {
            return nil
        }
    }
    
    var hasReachedEnd: Bool {
        if isEmpty { return false }
        return currentIndex == songs.count - 1
    }
    
    init() {
        self.songs = []
    }
    
    init(songs: [Song], from currentIndex: Int) {
        self.currentIndex = currentIndex
        for song in songs {
            add(song: song)
        }
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
    
    mutating func add(song: Song) {
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: song.file, ofType: "mp3")!)
        let avAsset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: avAsset, automaticallyLoadedAssetKeys: assetKeys)
        songs.append(song)
        playerItems.append(playerItem)
    }
    

}
