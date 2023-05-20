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
import MediaPlayer

class Player: ObservableObject {
//    var player: AVPlayer = AVPlayer()
    var player: AssetPlayer
    
//    var session: MPNowPlayingSession
    
    var queue: Queue = Queue()
    var nowPlaying: NowPlaying = NowPlaying()
    var currentSong: Song?
    
    var isPlaying: Bool {
        return player.playerState == .playing
    }
    
    var duration: TimeInterval {
        guard let currentItem = player.player.currentItem else { return 0.0 }
        return currentItem.duration.seconds
    }
    
    var currentTime: TimeInterval {
        get {
            return player.player.currentTime().seconds
        }
        set {
//            player.seek(to: CMTime(seconds: newValue, preferredTimescale: 1))
            player.seek(to: newValue)
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
//        self.session = MPNowPlayingSession(players: [self.player])
//        self.session.automaticallyPublishesNowPlayingInfo = true
//        self.session.remoteCommandCenter.playCommand.addTarget { event in
//            self.play()
//            return .success
//        }
//        self.session.remoteCommandCenter.pauseCommand.addTarget { event in
//            self.pause()
//            return .success
//        }
//
        
        
//        do {
//            
//            
//        } catch {
//            print(error)
//        }
        ConfigModel.shared = ConfigModel(nowPlayableBehavior: IOSNowPlayableBehavior())
        player = try! AssetPlayer()
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
            if isPlayingFromQueue {
                isPlayingFromQueue = false
            } else {
                nowPlaying.goToPrevious()
            }
            currentSong = nowPlaying.currentSong
            player.player.replaceCurrentItem(with: nowPlaying.currentPlayerItem)
            play()
        }
    }
    
    func next() {
        currentTime = 0.0
        finished = false
        if nowPlaying.isEmpty && queue.isEmpty {
            currentSong = nil
            isPlayingFromQueue = false
        } else if queue.isEmpty {
            nowPlaying.goToNext()
            currentSong = nowPlaying.currentSong
            player.player.replaceCurrentItem(with: nowPlaying.currentPlayerItem)
            player.play()
            isPlayingFromQueue = false
        } else {
            currentSong = queue.currentSong
            player.player.replaceCurrentItem(with: queue.currentPlayerItem)
            play()
            queue.goToNext()
            isPlayingFromQueue = true
        }
    }
    
    func replaceNowPlaying(songs: [Song], from: Int) {
        nowPlaying = NowPlaying(songs: songs, from: from)
        nowPlaying.isShuffled = isShuffled
        currentSong = nowPlaying.currentSong
        player.player.replaceCurrentItem(with: nowPlaying.currentPlayerItem)
        currentTime = 0.0
        finished = false
        nowPlayingIsReplaced = true
    }
    
    func addToQueue(song: Song) {
        queue.add(song: song)
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        finished = true
    }
}
