////
////  PlayerViewModel.swift
////  Neptunes
////
////  Created by Saruggan Thiruchelvan on 2023-04-11.
////
//
//import Foundation
//import AVFoundation
//import SwiftUI
//
//final class PlayerViewModel: ObservableObject {
//    @Published var player: AssetPlayer
//
//    var isPlaying: Bool {
//        if isBeingScrubbed { return true }
//        return player.playerState == .playing
//    }
//
//    var song: Song? {
//        return player.currentSong
//    }
//
//    var duration: TimeInterval {
//        return player.duration
//    }
//
//    var currentTime: TimeInterval {
//        return player.currentTime
//    }
//
//    var percentage: Double {
//        get {
//            return currentTime / duration
//        }
//        set {
//            playValue = duration * newValue
//        }
//    }
//
//    var palette: Palette? {
//        return song?.album.palette
//    }
//
//    @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//    @Published var playValue: TimeInterval = 0.0
//    @Published var isOnRepeat: Bool = false
//    @Published var isOnRepeatOne: Bool = false
//    @Published var isOnShuffle: Bool = false
//    @Published var isBeingScrubbed: Bool = false
//
//    init(player: AssetPlayer) {
//        self.player = player
//        self.player.pause()
//    }
//
//    func onScrubberChanged() {
//        if isPlaying {
//            isBeingScrubbed = true
//        }
//        player.pause()
//        player.seek(to: playValue)
//    }
//
//    func onScrubberEnded() {
//        if isBeingScrubbed {
//            player.play()
//            if player.finished { next() }
//            isBeingScrubbed = false
//        }
//    }
//
//    func onUpdate() {
//        if isPlaying {
//            playValue = player.currentTime
//            if player.finished {
//                if isOnRepeatOne {
//                    player.currentTime = 0.0
//                    player.finished = false
//                    play()
//                } else if player.hasReachedEnd {
//                    if isOnRepeat {
//                        next()
//                    } else {
//                        player.nextTrack()
//                        player.pause()
//                    }
//                } else {
//                    next()
//                }
//            }
//        }
//
//        if player.nowPlayingIsReplaced {
//            play()
//            player.nowPlayingIsReplaced = false
//        }
//
//        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//    }
//
//    func playPause() {
//        player.togglePlayPause()
//    }
//
//    func play() {
//        player.play()
//        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//    }
//
//    func pause() {
//        player.pause()
//    }
//
//    func next() {
//        player.nextTrack()
//        if isOnRepeatOne {
//            isOnRepeatOne = false
//            isOnRepeat = true
//        }
//        playValue = currentTime
//        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//    }
//
//    func previous() {
//        if playValue < 5.0 {
//            player.previousTrack()
//            if isOnRepeatOne {
//                isOnRepeatOne = false
//                isOnRepeat = true
//            }
//        } else {
//            player.seek(to: 0.0)
//        }
//        playValue = currentTime
//        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//    }
//
//    func toggleRepeat() {
//        if isOnRepeat {
//            isOnRepeat = false
//            isOnRepeatOne = true
//        } else if isOnRepeatOne {
//            isOnRepeat = false
//            isOnRepeatOne = false
//        } else {
//            isOnRepeat = true
//            isOnRepeatOne = false
//        }
//    }
//
//    func toggleShuffle() {
//        if isOnShuffle {
//            isOnShuffle = false
//            player.isShuffled = false
//        } else {
//            isOnShuffle = true
//            player.isShuffled = true
//        }
//    }
//}

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
    
    var palette: Palette? {
        return song?.album.palette
    }
    
    @Published var currentTime: Double = 0.0
    @Published var isBeingScrubbed: Bool = false
    @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(player: AssetPlayer) {
//        self.player = try! AssetPlayer()
        self.player = player
        
//        let song1 = Song(title: "Not Around", filename: "song1", artist: "Drake", album: "Certified Lover Boy")
//        let song2 = Song(title: "Hell of a Night", filename: "song2", artist: "Travis Scott", album: "Owl Pharoah")
//        let song3 = Song(title: "Wither", filename: "song3", artist: "Frank Ocean", album: "Endless")
//        let song4 = Song(title: "Rushes", filename: "song4", artist: "Frank Ocean", album: "Endless")
//        let song5 = Song(title: "Cancun", filename: "song5", artist: "Playboi Carti", album: "Cancun")
//        player.replaceNowPlaying(songs: [song1, song2, song3, song4], from: 0)
//        player.addToQueue(song: song5)
    }
    
    func togglePlayPause() {
        player.togglePlayPause()
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    func onUpdate() {
        if !isBeingScrubbed {
            currentTime = player.currentTime
        }
        
        
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
        player.pause()
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

