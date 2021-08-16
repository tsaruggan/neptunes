//
//  PlayerViewModel.swift
//  PlayerViewModel
//
//  Created by Saruggan Thiruchelvan on 2021-08-07.
//

import Foundation
import AVFoundation
import SwiftUI

final class PlayerViewModel: ObservableObject {
    @Published var audioPlayer: AudioPlayer
    @Published var isPlaying: Bool = false
    
    var song: Song? {
        audioPlayer.currentSong
    }
    
    var duration: TimeInterval {
        return audioPlayer.duration
    }
    var percentage: Double {
        get {
            return audioPlayer.currentTime / audioPlayer.duration
        }
        set {
            playValue = audioPlayer.duration * newValue
        }
    }
    @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Published var playValue: TimeInterval = 0.0
    var palette: Palette {
        return audioPlayer.currentSong!.palette
    }
    
    @Published var isOnRepeat: Bool = false
    @Published var isOnRepeatOne: Bool = false
    @Published var isOnShuffle: Bool = false
    
    init(audioPlayer: AudioPlayer) {
        self.audioPlayer = audioPlayer
        self.audioPlayer.pause()
    }
    
    func onScrubberChanged() {
        audioPlayer.pause()
        audioPlayer.currentTime = playValue
    }
    
    func onScrubberEnded() {
        if isPlaying {
            audioPlayer.play()
            if audioPlayer.finished { next() }
        }
    }
    
    func onUpdate() {
        if isPlaying {
            playValue = audioPlayer.currentTime
            if audioPlayer.finished {
                if isOnRepeatOne {
                    audioPlayer.currentTime = 0.0
                    audioPlayer.finished = false
                    play()
                } else if audioPlayer.hasReachedEnd {
                    if isOnRepeat {
                        next()
                    } else {
                        audioPlayer.next()
                        audioPlayer.pause()
                        isPlaying = false
                    }
                } else {
                    next()
                }
            }
        }
        
        if audioPlayer.nowPlayingIsReplaced {
            play()
            audioPlayer.nowPlayingIsReplaced = false
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
        audioPlayer.play()
        isPlaying = true
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    func pause() {
        audioPlayer.pause()
        isPlaying = false
    }
    
    func next() {
        audioPlayer.next()
        isPlaying = true
        if isOnRepeatOne {
            isOnRepeatOne = false
            isOnRepeat = true
        }
        playValue = audioPlayer.currentTime
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    func previous() {
        if playValue < 5.0 {
            audioPlayer.previous()
            isPlaying = true
            if isOnRepeatOne {
                isOnRepeatOne = false
                isOnRepeat = true
            }
        } else {
            audioPlayer.currentTime = 0.0
        }
        playValue = audioPlayer.currentTime
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
        } else {
            isOnShuffle = true
        }
    }
}
