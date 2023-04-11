//
//  Queue.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-11.
//

import Foundation
import AVFoundation

struct Queue {
    var fileManager = LocalFileManager()
    
    private var songs: [Song] = []
    private var playerItems: [AVPlayerItem] = []
    let assetKeys = ["playable"]
    
    var isEmpty: Bool {
        return songs.isEmpty
    }
    
    var currentSong: Song? {
        if songs.isEmpty { return nil }
        return songs[0]
    }
    
    var currentPlayerItem: AVPlayerItem? {
        if playerItems.isEmpty { return nil }
        return playerItems[0]
    }
    
    mutating func goToNext() {
        if isEmpty { return }
        songs.removeFirst()
        playerItems.removeFirst()
    }
    
    mutating func add(song: Song) {
        if let url = fileManager.retrieveSong(song: song) {
            let playerItem = AVPlayerItem(url: url)
            songs.append(song)
            playerItems.append(playerItem)
        }
    }
}
