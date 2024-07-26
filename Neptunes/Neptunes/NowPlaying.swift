//
//  NowPlaying.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-24.
//


import Foundation
import AVFoundation
import MediaPlayer

class NowPlaying: ObservableObject {
    
    @Published private var songs: [Song] = []
    @Published private var playerItems: [AVPlayerItem] = []
    @Published private var staticMetadatas: [NowPlayableStaticMetadata] = []
    
    let assetKeys = ["playable"]
    @Published private var currentIndex: Int = 0
    
    @Published private var _isShuffled: Bool = false
    @Published private var currentShuffledIndex: Int = 0
    @Published private var shuffledIndices: [Int] = []
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
            if currentShuffledIndex >= 0 && currentShuffledIndex < playerItems.count {
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
    
    var currentStaticMetadata: NowPlayableStaticMetadata? {
        if staticMetadatas.isEmpty { return nil }
        if isShuffled {
            if currentShuffledIndex >= 0 && currentShuffledIndex < staticMetadatas.count {
                return staticMetadatas[shuffledIndices[currentShuffledIndex]]
            } else {
                return nil
            }
        } else {
            if currentIndex >= 0 && currentIndex < staticMetadatas.count {
                return staticMetadatas[currentIndex]
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
    
    var songsInNowPlaying: [Song]? {
        if songs.isEmpty { return nil }
        if isShuffled {
            if currentShuffledIndex >= 0 && currentShuffledIndex < songs.count {
                return Array(songs[currentShuffledIndex...]) + Array(songs[..<currentShuffledIndex])
            } else {
                return nil
            }
        } else {
            if currentIndex >= 0 && currentIndex < songs.count {
                return Array(songs[currentIndex...]) + Array(songs[..<currentIndex])
            } else {
                return nil
            }
        }
    }
    
    init() {}
    
    init(songs: [Song], from currentIndex: Int) {
        self.currentIndex = currentIndex
        for song in songs {
            push(song: song)
        }
        self.shuffledIndices = Array(0..<songs.count)
    }
    
    func goToNext() {
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
    
    func goToPrevious() {
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
    
    func push(song: Song) {
        if let url = LocalFileManager().retrieveSong(song: song) {
            let image = UIImage(named: "defaultcover")!
            let artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in image }
            
            let staticMetadata = NowPlayableStaticMetadata(assetURL: url,
                                                           mediaType: .audio,
                                                           isLiveStream: false,
                                                           title: song.title,
                                                           artist: song.artist,
                                                           artwork: artwork,
                                                           albumArtist: song.artist,
                                                           albumTitle: song.album)
            
            let playerItem = AVPlayerItem(asset: AVURLAsset(url: url), automaticallyLoadedAssetKeys: [Player.mediaSelectionKey])
            
            songs.append(song)
            playerItems.append(playerItem)
            staticMetadatas.append(staticMetadata)
        }
    }
    
    func add(song: Song) {
        if let url = LocalFileManager().retrieveSong(song: song) {
            let image = UIImage(named: "defaultcover")!
            let artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in image }
            
            let staticMetadata = NowPlayableStaticMetadata(assetURL: url,
                                                           mediaType: .audio,
                                                           isLiveStream: false,
                                                           title: song.title,
                                                           artist: song.artist,
                                                           artwork: artwork,
                                                           albumArtist: song.artist,
                                                           albumTitle: song.album)
            
            let playerItem = AVPlayerItem(asset: AVURLAsset(url: url), automaticallyLoadedAssetKeys: [Player.mediaSelectionKey])
            
            let insertionIndex = currentIndex == 0 ? songs.count : currentIndex - 1
            songs.insert(song, at: insertionIndex)
            playerItems.insert(playerItem, at: insertionIndex)
            staticMetadatas.insert(staticMetadata, at: insertionIndex)
            
            // Update shuffled indices if shuffle mode is enabled
            if isShuffled {
                shuffledIndices = Array(0..<songs.count)
                shuffledIndices.remove(at: currentIndex)
                shuffledIndices.shuffle()
                shuffledIndices.insert(currentIndex, at: 0)
            }
        }
    }
    
    func rearrange(from source: IndexSet, to destination: Int) {
        
    }
}
