//
//  Queue.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-06-12.
//

import Foundation
import AVFoundation
import SwiftUI
import MediaPlayer

class Queue: ObservableObject {
    @Published private var songs: [Song] = []
    @Published private var playerItems: [AVPlayerItem] = []
    @Published private var staticMetadatas: [NowPlayableStaticMetadata] = []
    
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
    
    var songsInQueue: [Song]? {
        if songs.isEmpty { return nil }
        return songs
    }
    
    func goToNext() {
        if isEmpty { return }
        songs.removeFirst()
        playerItems.removeFirst()
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
            
            songs.append(song)
            playerItems.append(playerItem)
            staticMetadatas.append(staticMetadata)
        }
    }
}