//
//  EditorViewModel.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-11.
//

import Foundation
import CoreData
import SwiftUI
import AVFoundation

final class EditorViewModel: ObservableObject {
    @Published var songTitle: String
    @Published var albumTitle: String
    @Published var albumCoverArtwork: Data?
    @Published var artistTitle: String
    @Published var artistCoverArtwork: Data?
    @Published var url: URL?
    
    var viewContext: NSManagedObjectContext
    var dataManager: CoreDataManager
    var fileManager: LocalFileManager = LocalFileManager()
    
    @Published var currentAlbum: Album?
    @Published var currentArtist: Artist?
    
    @Published var audioPlayer: AVPlayer?
    @Published var isPlaying: Bool = false
    
    init(metadata: Metadata, viewContext: NSManagedObjectContext) {
        self.songTitle = metadata.songTitle ?? ""
        self.albumTitle = metadata.albumTitle ?? ""
        self.albumCoverArtwork = metadata.albumCoverArtwork
        self.artistTitle = metadata.artistTitle ?? ""
        self.url = metadata.url
        
        self.viewContext = viewContext
        self.dataManager = CoreDataManager(viewContext: viewContext)
    }
    
    func togglePlay() {
        if audioPlayer == nil {
            let temp = fileManager.saveSongTemp(url: url!)
            audioPlayer = AVPlayer(url: temp!)
        }
        
        if audioPlayer != nil {
            if audioPlayer!.rate != 0 {
                audioPlayer!.pause()
                isPlaying = false
            } else {
                audioPlayer!.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
                audioPlayer!.play()
                isPlaying = true
            }
        }
        
    }
    
    func addSong() {
        
        let song = dataManager.initializeSong(title: songTitle, id: UUID())
    
        
        if let album = currentAlbum {
            song.album = album
        } else {
            let album = dataManager.initializeAlbum(title: albumTitle, coverArtwork: albumCoverArtwork)
            song.album = album
        }
        
        if let artist = currentArtist {
            song.artist = artist
        } else {
            let artist = dataManager.initializeArtist(title: artistTitle, coverArtwork: artistCoverArtwork)
            song.artist = artist
            song.album.artist = artist
        }
        
        fileManager.saveSongFromURL(url: url!, song: song)
        dataManager.saveData()
    }
}
