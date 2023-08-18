//
//  ViewModel.swift
//  player-demo
//
//  Created by Saruggan Thiruchelvan on 2023-04-24.
//

import Foundation
import AVFoundation
import MediaPlayer
import SwiftUI

final class ViewModel: ObservableObject {
    @Published var player: AssetPlayer
    
    var song: Song? {
        return player.currentSong
    }
    
    var isPlaying: Bool {
        return player.playerState == .playing
    }
    
    var percentage: Double {
        get {
            return player.currentTime / duration
        }
        set {
            currentTime = duration * newValue
        }
    }
    
    var duration: Double {
        return player.duration
    }
    
    var shuffleState: AssetPlayer.ShuffleState {
        get {
            return player.shuffleState
        }
        set {
            player.shuffleState = newValue
        }
    }
    
    var repeatState: AssetPlayer.RepeatState {
        get {
            return player.repeatState
        }
        set {
            player.repeatState = newValue
        }
    }
    
    @Published var currentTime: Double = 0.0
    @Published var isBeingScrubbed: Bool = false
    @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init() {
        self.player = try! AssetPlayer()
        
        let song1 = Song(title: "Not Around", filename: "song1", artist: "Drake", album: "Certified Lover Boy")
        let song2 = Song(title: "Hell of a Night", filename: "song2", artist: "Travis Scott", album: "Owl Pharoah")
        let song3 = Song(title: "Wither", filename: "song3", artist: "Frank Ocean", album: "Endless")
        let song4 = Song(title: "Rushes", filename: "song4", artist: "Frank Ocean", album: "Endless")
        let song5 = Song(title: "Cancun", filename: "song5", artist: "Playboi Carti", album: "Cancun")
        player.replaceNowPlaying(songs: [song1, song2, song3, song4], from: 0)
        player.addToQueue(song: song5)
    }
    
    func togglePlayPause() {
        player.togglePlayPause()
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    func onUpdate() {
        currentTime = player.currentTime

        if player.nowPlayingIsReplaced {
            player.play()
            player.nowPlayingIsReplaced = false
        }
        
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    func onScrubberChanged() {
        if isPlaying {
            isBeingScrubbed = true
        }
//        player.pause()
        player.seek(to: currentTime)
    }
    
    func onScrubberEnded() {
        if isBeingScrubbed {
            player.play()
            isBeingScrubbed = false
        }
    }
    
    func previous() {
        player.previous()
    }
    
    func next() {
        player.next()
    }
    
    func toggleRepeat() {
        switch repeatState {
        case .repeating:
            repeatState = .repeatingone
        case .repeatingone:
            repeatState = .unrepeating
        case .unrepeating:
            repeatState = .repeating
        }
    }
    
    func toggleShuffle() {
        switch shuffleState {
        case .shuffled:
            shuffleState = .unshuffled
        case .unshuffled:
            shuffleState = .shuffled
        }
    }
}

