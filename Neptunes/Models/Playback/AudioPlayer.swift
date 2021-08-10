//
//  AudioPlayer.swift
//  AudioPlayer
//
//  Created by Saruggan Thiruchelvan on 2021-08-09.
//

import Foundation
import AVFoundation



final class AudioPlayer: ObservableObject {
    @Published var player: AVPlayer = AVPlayer()
    @Published var playerItems: [AVPlayerItem] = []
    
    var queue = MusicData().songs
    var currentSongIndex = 0
    var currentSong: Song {
        return queue[currentSongIndex]
    }
    var duration: TimeInterval {
        guard let currentItem = player.currentItem else { return 0.0 }
        let seconds = currentItem.duration.seconds
        if seconds.isFinite { return seconds } else { return 0.0 }
    }
    var currentTime: TimeInterval {
        get {
            let seconds = player.currentTime().seconds
            if seconds.isFinite { return seconds } else { return 0.0 }
        }
        set {
            player.seek(to: CMTime(seconds: newValue, preferredTimescale: 1))
        }
    }
    let assetKeys = ["playable"]
    
    init() {
        for song in queue {
            let url = URL(fileURLWithPath: Bundle.main.path(forResource: song.file, ofType: "mp3")!)
            let avAsset = AVAsset(url: url)
            let playerItem = AVPlayerItem(asset: avAsset, automaticallyLoadedAssetKeys: assetKeys)
            playerItems.append(playerItem)
        }
        player.replaceCurrentItem(with: playerItems[currentSongIndex])
    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    func previous() {
        if currentSongIndex - 1 <= 0 {
            currentSongIndex = (playerItems.count - 1) < 0 ? 0 : (playerItems.count - 1)
        } else {
            currentSongIndex -= 1
        }
        
        if playerItems.count > 0 {
            player.replaceCurrentItem(with: playerItems[currentSongIndex])
            player.play()
        }
    }
    
    func next() {
        if currentSongIndex + 1 >= playerItems.count {
            currentSongIndex = 0
        } else {
            currentSongIndex += 1;
        }
        
        if playerItems.count > 0 {
            player.replaceCurrentItem(with: playerItems[currentSongIndex])
            player.play()
        }
    }
}
