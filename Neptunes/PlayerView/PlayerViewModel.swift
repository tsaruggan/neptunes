//
//  PlayerViewModel.swift
//  PlayerViewModel
//
//  Created by Saruggan Thiruchelvan on 2021-08-07.
//

import Foundation
import AVFoundation

final class PlayerViewModel: ObservableObject {
    @Published var song: Song
    @Published var audioPlayer: AVAudioPlayer
    @Published var isPlaying: Bool = false
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
    @Published var palette: Palette
    
    init(song: Song) {
        self.song = song
        //        self.palette = ColorAnalyzer.generatePalette(artwork: song.artwork, header: song.header)
        self.palette = Palette()
        let sound = Bundle.main.path(forResource: "song", ofType: "mp3")
        self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
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
    
}
