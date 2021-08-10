//
//  PlayerViewModel.swift
//  PlayerViewModel
//
//  Created by Saruggan Thiruchelvan on 2021-08-07.
//

import Foundation
import AVFoundation

final class PlayerViewModel: ObservableObject {
    @Published var audioPlayer: AudioPlayer
    @Published var isPlaying: Bool = false
    
    var song: Song {
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
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Published var playValue: TimeInterval = 0.0
    @Published var palette: Palette = Palette()
    
    init(audioPlayer: AudioPlayer) {
        self.audioPlayer = audioPlayer
    }
    
    func onScrubberChanged() {
        audioPlayer.pause()
        audioPlayer.currentTime = playValue
    }
    
    func onScrubberEnded() {
        if isPlaying {
            audioPlayer.play()
        }
    }
    
    func onScrubberUpdate() {
        if isPlaying {
            playValue = audioPlayer.currentTime
        } else {
            timer.upstream.connect().cancel()
        }
    }
    
    func playPause() {
        if isPlaying {
            audioPlayer.pause()
            isPlaying = false
        } else {
            audioPlayer.play()
            isPlaying = true
            timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        }
    }
    
    func next() {
        audioPlayer.next()
    }
    
    func previous() {
        audioPlayer.previous()
    }
    
}
