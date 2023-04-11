//
//  Player.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-11.
//

import Foundation
import AVFoundation
import NotificationCenter
import CoreData

class Player: ObservableObject {
    var player: AVPlayer = AVPlayer()
    
    var queue: Queue = Queue()
    var nowPlaying: NowPlaying = NowPlaying()
    var currentSong: Song?
    
    var _isPlaying: Bool = false
    var isPlaying: Bool {
        return _isPlaying || (self.player.rate != 0 && self.player.error == nil)
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
    
    var finished: Bool = false
    var isPlayingFromQueue: Bool = false
    var nowPlayingIsReplaced: Bool = false
    var hasReachedEnd: Bool { return nowPlaying.hasReachedEnd }
    
    private var _isShuffled: Bool = false
    var isShuffled: Bool {
        get {
            return _isShuffled
        }
        set {
            _isShuffled = newValue
            nowPlaying.isShuffled = newValue
        }
    }
    
    let assetKeys = ["playable"]
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func play() {
        player.play()
        _isPlaying = true
    }
    
    func pause() {
        player.pause()
        _isPlaying = false
    }
    
    func previous() {
        currentTime = 0.0
        finished = false
        if nowPlaying.isEmpty {
            currentSong = nil
            _isPlaying = false
        } else {
            if isPlayingFromQueue {
                isPlayingFromQueue = false
            } else {
                nowPlaying.goToPrevious()
            }
            currentSong = nowPlaying.currentSong
            player.replaceCurrentItem(with: nowPlaying.currentPlayerItem)
            play()
        }
    }
    
    func next() {
        currentTime = 0.0
        finished = false
        if nowPlaying.isEmpty && queue.isEmpty {
            currentSong = nil
            isPlayingFromQueue = false
            _isPlaying = false
        } else if queue.isEmpty {
            nowPlaying.goToNext()
            currentSong = nowPlaying.currentSong
            player.replaceCurrentItem(with: nowPlaying.currentPlayerItem)
            player.play()
            isPlayingFromQueue = false
        } else {
            currentSong = queue.currentSong
            player.replaceCurrentItem(with: queue.currentPlayerItem)
            play()
            queue.goToNext()
            isPlayingFromQueue = true
        }
    }
    
    func replaceNowPlaying(songs: [Song], from: Int) {
        nowPlaying = NowPlaying(songs: songs, from: from)
        nowPlaying.isShuffled = isShuffled
        currentSong = nowPlaying.currentSong
        player.replaceCurrentItem(with: nowPlaying.currentPlayerItem)
        currentTime = 0.0
        finished = false
        nowPlayingIsReplaced = true
        _isPlaying = false
    }
    
    func addToQueue(song: Song) {
        queue.add(song: song)
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        finished = true
    }
}
