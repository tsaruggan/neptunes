////
////  NowPlaying.swift
////  Neptunes
////
////  Created by Saruggan Thiruchelvan on 2023-04-11.
////
//
//import Foundation
//import AVFoundation
//import MediaPlayer
//
//struct NowPlaying {
//    var fileManager = LocalFileManager()
//
//    private var songs: [Song] = []
//    private var playerItems: [AVPlayerItem] = []
//    private var staticMetadatas: [NowPlayableStaticMetadata] = []
//    let assetKeys = ["playable"]
//    private var currentIndex: Int = 0
//
//    private var _isShuffled: Bool = false
//    private var currentShuffledIndex: Int = 0
//    private var shuffledIndices: [Int] = []
//    var isShuffled: Bool {
//        get {
//            return _isShuffled
//        }
//        set {
//            _isShuffled = newValue
//            if newValue == true {
//                currentShuffledIndex = 0
//                shuffledIndices = Array(0..<songs.count)
//                shuffledIndices.remove(at: currentIndex)
//                shuffledIndices.shuffle()
//                shuffledIndices.insert(currentIndex, at: 0)
//            }
//        }
//    }
//
//    var isEmpty: Bool {
//        return songs.isEmpty
//    }
//
//    var currentSong: Song? {
//        if songs.isEmpty { return nil }
//        if isShuffled {
//            if currentShuffledIndex >= 0 && currentShuffledIndex < songs.count {
//                return songs[shuffledIndices[currentShuffledIndex]]
//            } else {
//                return nil
//            }
//        } else {
//            if currentIndex >= 0 && currentIndex < songs.count {
//                return songs[currentIndex]
//            } else {
//                return nil
//            }
//        }
//    }
//
//    var currentPlayerItem: AVPlayerItem? {
//        if playerItems.isEmpty { return nil }
//        if isShuffled {
//            if currentShuffledIndex >= 0 && currentShuffledIndex < songs.count {
//                return playerItems[shuffledIndices[currentShuffledIndex]]
//            } else {
//                return nil
//            }
//        } else {
//            if currentIndex >= 0 && currentIndex < playerItems.count {
//                return playerItems[currentIndex]
//            } else {
//                return nil
//            }
//        }
//    }
//
//    var currentStaticMetadata: NowPlayableStaticMetadata? {
//        if playerItems.isEmpty { return nil }
//        if isShuffled {
//            if currentShuffledIndex >= 0 && currentShuffledIndex < songs.count {
//                return staticMetadatas[shuffledIndices[currentShuffledIndex]]
//            } else {
//                return nil
//            }
//        } else {
//            if currentIndex >= 0 && currentIndex < playerItems.count {
//                return staticMetadatas[currentIndex]
//            } else {
//                return nil
//            }
//        }
//    }
//
//    var hasReachedEnd: Bool {
//        if isEmpty { return false }
//        if isShuffled {
//            return currentShuffledIndex == songs.count - 1
//        } else {
//            return currentIndex == songs.count - 1
//        }
//    }
//
//    init() {}
//
//    init(songs: [Song], from currentIndex: Int) {
//        self.currentIndex = currentIndex
//        for song in songs {
//            add(song: song)
//        }
//        self.shuffledIndices = Array(0..<songs.count)
//    }
//
//    mutating func goToNext() {
//        if isEmpty { return }
//        if isShuffled {
//            currentShuffledIndex += 1
//            if currentShuffledIndex >= songs.count {
//                currentShuffledIndex = 0
//            }
//        } else {
//            currentIndex += 1
//            if currentIndex >= songs.count {
//                currentIndex = 0
//            }
//        }
//    }
//
//    mutating func goToPrevious() {
//        if isEmpty { return }
//        if isShuffled {
//            currentShuffledIndex -= 1
//            if currentShuffledIndex < 0 {
//                currentShuffledIndex = songs.count - 1
//            }
//        } else {
//            currentIndex -= 1
//            if currentIndex < 0 {
//                currentIndex = songs.count - 1
//            }
//        }
//    }
//
//    //    mutating func add(song: Song) {
//    //        if let url = fileManager.retrieveSong(song: song) {
//    //            let playerItem = AVPlayerItem(url: url)
//    //
//    //            var artwork = MPMediaItemArtwork(image: UIImage(named: "defaultcover")!)
//    //            if let coverArtwork = song.album.coverArtwork, let uiImage = UIImage(data: coverArtwork) {
//    //                artwork = MPMediaItemArtwork(image: uiImage)
//    //            }
//    //
//    //            let title = song.title
//    //
//    //            playerItem.nowPlayingInfo = [
//    //                MPMediaItemPropertyTitle: title,
//    //                MPMediaItemPropertyArtwork: artwork
//    //            ]
//    //
//    //            songs.append(song)
//    //            playerItems.append(playerItem)
//    //        }
//    //    }
//
//    mutating func add(song: Song) {
//        if let url = fileManager.retrieveSong(song: song) {
//            let image = UIImage(named: "defaultcover")!
//            let artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in image }
//
//            let staticMetadata = NowPlayableStaticMetadata(assetURL: url,
//                                                     mediaType: .audio,
//                                                     isLiveStream: false,
//                                                     title: song.title,
//                                                     artist: song.artist.title,
//                                                     artwork: artwork,
//                                                     albumArtist: song.artist.title,
//                                                     albumTitle: song.album.title)
//
//            let playerItem = AVPlayerItem(asset: AVURLAsset(url: url), automaticallyLoadedAssetKeys: [AssetPlayer.mediaSelectionKey])
//
//            songs.append(song)
//            playerItems.append(playerItem)
//            staticMetadatas.append(staticMetadata)
//        }
//    }
//}

//
//  NowPlaying.swift
//  player-demo
//
//  Created by Saruggan Thiruchelvan on 2023-04-24.
//


import Foundation
import AVFoundation
import MediaPlayer

struct NowPlaying {
    var fileManager = LocalFileManager()
    private var songs: [Song] = []
    private var playerItems: [AVPlayerItem] = []
    private var staticMetadatas: [NowPlayableStaticMetadata] = []
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
        if let url = fileManager.retrieveSong(song: song) {
            let image = UIImage(named: "defaultcover")!
            let artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in image }
            
            let staticMetadata = NowPlayableStaticMetadata(assetURL: url,
                                                     mediaType: .audio,
                                                     isLiveStream: false,
                                                     title: song.title,
                                                           artist: song.artist.title,
                                                     artwork: artwork,
                                                           albumArtist: song.artist.title,
                                                           albumTitle: song.album.title)
            
            let playerItem = AVPlayerItem(asset: AVURLAsset(url: url), automaticallyLoadedAssetKeys: [AssetPlayer.mediaSelectionKey])
            
            songs.append(song)
            playerItems.append(playerItem)
            staticMetadatas.append(staticMetadata)
        }
    }
    
    /*
     mutating func add(song: Song) {
         let url = URL(fileURLWithPath: Bundle.main.path(forResource: song.filename, ofType: "mp3")!)
         let playerItem = AVPlayerItem(url: url)
         
         let artwork = MPMediaItemArtwork(image: UIImage(named: "defaultcover")!)
         let title = song.title
         
         playerItem.nowPlayingInfo = [
             MPMediaItemPropertyTitle: title,
             MPMediaItemPropertyArtwork: artwork
         ]
         
         songs.append(song)
         playerItems.append(playerItem)
     }
     */

}
