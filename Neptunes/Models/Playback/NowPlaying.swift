//
//  NowPlaying.swift
//  NowPlaying
//
//  Created by Saruggan Thiruchelvan on 2021-08-11.
//

import Foundation
import AVFoundation

struct NowPlaying {
    private var songs: [Song] = []
    private var playerItems: [AVPlayerItem] = []
    let assetKeys = ["playable"]
    private var currentIndex: Int = 0
    
    private var _isShuffled: Bool = false
    private var currentShuffledIndex: Int = 0
    private var shuffledIndices: [Int] = []
    var isShuffled: Bool {
        get {
            return _isShuffled
        }
        set {
            _isShuffled = newValue
            if newValue == true {
                currentShuffledIndex = 0
                shuffledIndices = Array(0..<songs.count)
                shuffledIndices.remove(at: currentIndex)
                shuffledIndices.shuffle()
                shuffledIndices.insert(currentIndex, at: 0)
            }
        }
    }
    
    var isEmpty: Bool {
        return songs.isEmpty
    }
    
    var currentSong: Song? {
        if songs.isEmpty { return nil }
        if isShuffled {
            if currentShuffledIndex >= 0 && currentShuffledIndex < songs.count {
                return songs[shuffledIndices[currentShuffledIndex]]
            } else {
                return nil
            }
        } else {
            if currentIndex >= 0 && currentIndex < songs.count {
                return songs[currentIndex]
            } else {
                return nil
            }
        }
    }
    
    var currentPlayerItem: AVPlayerItem? {
        if playerItems.isEmpty { return nil }
        if isShuffled {
            if currentShuffledIndex >= 0 && currentShuffledIndex < songs.count {
                return playerItems[shuffledIndices[currentShuffledIndex]]
            } else {
                return nil
            }
        } else {
            if currentIndex >= 0 && currentIndex < playerItems.count {
                return playerItems[currentIndex]
            } else {
                return nil
            }
        }
    }
    
    var hasReachedEnd: Bool {
        if isEmpty { return false }
        if isShuffled {
            return currentShuffledIndex == songs.count - 1
        } else {
            return currentIndex == songs.count - 1
        }
    }
    
    init() {}
    
    init(songs: [Song], from currentIndex: Int) {
        self.currentIndex = currentIndex
        for song in songs {
            add(song: song)
        }
        self.shuffledIndices = Array(0..<songs.count)
    }
    
    mutating func goToNext() {
        if isEmpty { return }
        if isShuffled {
            currentShuffledIndex += 1
            if currentShuffledIndex >= songs.count {
                currentShuffledIndex = 0
            }
        } else {
            currentIndex += 1
            if currentIndex >= songs.count {
                currentIndex = 0
            }
        }
    }
    
    mutating func goToPrevious() {
        if isEmpty { return }
        if isShuffled {
            currentShuffledIndex -= 1
            if currentShuffledIndex < 0 {
                currentShuffledIndex = songs.count - 1
            }
        } else {
            currentIndex -= 1
            if currentIndex < 0 {
                currentIndex = songs.count - 1
            }
        }
    }
    
    mutating func add(song: Song) {
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: song.file, ofType: "mp3")!)
        let avAsset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: avAsset, automaticallyLoadedAssetKeys: assetKeys)
        songs.append(song)
        playerItems.append(playerItem)
    }

}
