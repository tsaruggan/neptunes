//
//  AudioPlayer.swift
//  AudioPlayer
//
//  Created by Saruggan Thiruchelvan on 2021-08-09.
//

import Foundation
import AVFoundation
import NotificationCenter

class AudioPlayer: ObservableObject {
    var player: AVPlayer = AVPlayer()
    var queue: Queue = Queue()
    var nowPlaying: NowPlaying = NowPlaying()
    var currentSong: Song?
    
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
    
    var finished: Bool = false
    
    let assetKeys = ["playable"]
    
    init() {
        replaceNowPlaying(songs: MusicData().songs, from: 1)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    func previous() {
        currentTime = 0.0
        finished = false
        if nowPlaying.isEmpty {
            currentSong = nil
        } else {
            nowPlaying.goToPrevious()
            currentSong = nowPlaying.currentSong
            player.replaceCurrentItem(with: nowPlaying.currentPlayerItem)
            player.play()
        }
    }
    
    func next() {
        currentTime = 0.0
        finished = false
        if nowPlaying.isEmpty && queue.isEmpty {
            currentSong = nil
        } else if queue.isEmpty {
            nowPlaying.goToNext()
            currentSong = nowPlaying.currentSong
            player.replaceCurrentItem(with: nowPlaying.currentPlayerItem)
            player.play()
        } else {
            currentSong = queue.currentSong
            player.replaceCurrentItem(with: queue.currentPlayerItem)
            player.play()
            queue.goToNext()
        }
    }
    
    func replaceNowPlaying(songs: [Song], from: Int) {
        nowPlaying = NowPlaying(songs: songs, from: from)
        currentSong = nowPlaying.currentSong
        player.replaceCurrentItem(with: nowPlaying.currentPlayerItem)
        currentTime = 0.0
        finished = false
    }
    
    func addToQueue(song: Song) {
        queue.add(song: song)
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        finished = true
    }
}
