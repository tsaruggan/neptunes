//
//  PlayerViewModel.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-11.
//

import Foundation
import AVFoundation
import SwiftUI

final class PlayerViewModel: ObservableObject {
    @Published var player: Player
    
    var isPlaying: Bool {
        if isBeingScrubbed { return true }
        return player.isPlaying
    }
    
    var song: Song? {
        return player.currentSong
    }
    
    var duration: TimeInterval {
        return player.duration
    }
    
    var percentage: Double {
        get {
            return player.currentTime / player.duration
        }
        set {
            playValue = player.duration * newValue
        }
    }
    
    var palette: Palette? {
        return song?.album.palette
    }
    
    @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Published var playValue: TimeInterval = 0.0
    @Published var isOnRepeat: Bool = false
    @Published var isOnRepeatOne: Bool = false
    @Published var isOnShuffle: Bool = false
    @Published var isBeingScrubbed: Bool = false
    
    init(audioPlayer: Player) {
        self.player = audioPlayer
        self.player.pause()
    }
    
    func onScrubberChanged() {
        if isPlaying {
            isBeingScrubbed = true
        }
        player.pause()
        player.currentTime = playValue
    }
    
    func onScrubberEnded() {
        if isBeingScrubbed {
            player.play()
            if player.finished { next() }
            isBeingScrubbed = false
        }
    }
    
    func onUpdate() {
        if isPlaying {
            playValue = player.currentTime
            if player.finished {
                if isOnRepeatOne {
                    player.currentTime = 0.0
                    player.finished = false
                    play()
                } else if player.hasReachedEnd {
                    if isOnRepeat {
                        next()
                    } else {
                        player.next()
                        player.pause()
                    }
                } else {
                    next()
                }
            }
        }
        
        if player.nowPlayingIsReplaced {
            play()
            player.nowPlayingIsReplaced = false
        }
        
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    func playPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    func play() {
        player.play()
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    func pause() {
        player.pause()
    }
    
    func next() {
        player.next()
        if isOnRepeatOne {
            isOnRepeatOne = false
            isOnRepeat = true
        }
        playValue = player.currentTime
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    func previous() {
        if playValue < 5.0 {
            player.previous()
            if isOnRepeatOne {
                isOnRepeatOne = false
                isOnRepeat = true
            }
        } else {
            player.currentTime = 0.0
        }
        playValue = player.currentTime
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    func toggleRepeat() {
        if isOnRepeat {
            isOnRepeat = false
            isOnRepeatOne = true
        } else if isOnRepeatOne {
            isOnRepeat = false
            isOnRepeatOne = false
        } else {
            isOnRepeat = true
            isOnRepeatOne = false
        }
    }
    
    func toggleShuffle() {
        if isOnShuffle {
            isOnShuffle = false
            player.isShuffled = false
        } else {
            isOnShuffle = true
            player.isShuffled = true
        }
    }
}
