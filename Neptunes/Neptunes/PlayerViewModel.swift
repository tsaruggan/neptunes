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

final class PlayerViewModel: ObservableObject {
    @Published var player: Player
    
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
    
    var shuffleState: Player.ShuffleState {
        get {
            return player.shuffleState
        }
        set {
            player.shuffleState = newValue
        }
    }
    
    var repeatState: Player.RepeatState {
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
    
    init(player: Player) {
        self.player = player
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

