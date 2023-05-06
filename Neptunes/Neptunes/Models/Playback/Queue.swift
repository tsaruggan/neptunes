//
//  Queue.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-11.
//

import Foundation
import AVFoundation
import MediaPlayer

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
            
            var artwork = MPMediaItemArtwork(image: UIImage(named: "defaultcover")!)
            if let coverArtwork = song.album.coverArtwork, let uiImage = UIImage(data: coverArtwork) {
                artwork = MPMediaItemArtwork(image: uiImage)
            }
            
            let title = song.title
            
            playerItem.nowPlayingInfo = [
                MPMediaItemPropertyTitle: title,
                MPMediaItemPropertyArtwork: artwork
            ]
            
            songs.append(song)
            playerItems.append(playerItem)
        }
    }
}
