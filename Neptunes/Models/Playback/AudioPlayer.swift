//
//  AudioPlayer.swift
//  AudioPlayer
//
//  Created by Saruggan Thiruchelvan on 2021-08-09.
//

import Foundation
import AVFoundation

class AudioPlayer: ObservableObject {
    var player: AVPlayer = AVPlayer()
    var playerItems: [AVPlayerItem] = []
    var queue: [Song] = []
    var currentSongIndex = 0
    var currentSong: Song {
        return queue[currentSongIndex]
    }
    var duration: TimeInterval {
        guard let currentItem = player.currentItem else { return 0.0 }
        return currentItem.duration.seconds
    }
    var currentTime: TimeInterval {
        get {
            return player.currentTime().seconds
        }
        set {
            player.seek(to: CMTime(seconds: newValue, preferredTimescale: 1))
        }
    }
    let assetKeys = ["playable"]
    
    init() {
        addToQueue(song: MusicData().songs[0])
        player.replaceCurrentItem(with: playerItems[currentSongIndex])
    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    func previous() {
        if currentSongIndex - 1 < 0 {
            currentSongIndex = playerItems.count - 1
        } else {
            currentSongIndex -= 1
        }
        
        if playerItems.count > 0 {
            currentTime = 0.0
            player.replaceCurrentItem(with: playerItems[currentSongIndex])
            player.play()
        }
    }
    
    func next() {
        if currentSongIndex + 1 > playerItems.count - 1 {
            currentSongIndex = 0
        } else {
            currentSongIndex += 1
        }
        
        if playerItems.count > 0 {
            currentTime = 0.0
            player.replaceCurrentItem(with: playerItems[currentSongIndex])
            player.play()
        }
    }
    
    func addToQueue(song: Song) {
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: song.file, ofType: "mp3")!)
        let avAsset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: avAsset, automaticallyLoadedAssetKeys: assetKeys)
        playerItems.append(playerItem)
        queue.append(song)
    }
}
