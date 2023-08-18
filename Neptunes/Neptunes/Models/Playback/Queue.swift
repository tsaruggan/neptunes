////
////  Queue.swift
////  Neptunes
////
////  Created by Saruggan Thiruchelvan on 2023-04-11.
////
//
//import Foundation
//import AVFoundation
//import MediaPlayer
//
//struct Queue {
//    var fileManager = LocalFileManager()
//
//    private var songs: [Song] = []
//    private var playerItems: [AVPlayerItem] = []
//    public var staticMetadatas: [NowPlayableStaticMetadata] = []
//    let assetKeys = ["playable"]
//
//    var isEmpty: Bool {
//        return songs.isEmpty
//    }
//
//    var currentSong: Song? {
//        if songs.isEmpty { return nil }
//        return songs[0]
//    }
//
//    var currentPlayerItem: AVPlayerItem? {
//        if playerItems.isEmpty { return nil }
//        return playerItems[0]
//    }
//
//    mutating func goToNext() {
//        if isEmpty { return }
//        songs.removeFirst()
//        playerItems.removeFirst()
//    }
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
//  Queue.swift
//  player-demo
//
//  Created by Saruggan Thiruchelvan on 2023-06-12.
//

import Foundation
import AVFoundation
import SwiftUI
import MediaPlayer

struct Queue {
    var fileManager = LocalFileManager()
    private var songs: [Song] = []
    private var playerItems: [AVPlayerItem] = []
    private var staticMetadatas: [NowPlayableStaticMetadata] = []
    let assetKeys = ["playable"]
    
    var isEmpty: Bool {
        return songs.isEmpty
    }
    
    var currentSong: Song? {
        if songs.isEmpty { return nil }
        return songs[0]
    }
    
    var currentPlayerItem: AVPlayerItem? {
        if playerItems.isEmpty { return nil }
        return playerItems[0]
    }
    
    var currentStaticMetadata: NowPlayableStaticMetadata? {
        if staticMetadatas.isEmpty { return nil }
        return staticMetadatas[0]
    }
    
    mutating func goToNext() {
        if isEmpty { return }
        songs.removeFirst()
        playerItems.removeFirst()
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
}
