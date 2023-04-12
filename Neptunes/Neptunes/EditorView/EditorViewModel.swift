//
//  EditorViewModel.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-11.
//

import Foundation
import CoreData

final class EditorViewModel: ObservableObject {
    @Published var songTitle: String
    @Published var albumTitle: String
    @Published var albumCoverArtwork: Data?
    @Published var artistTitle: String
    @Published var url: URL?
    
    var viewContext: NSManagedObjectContext
    var dataManager: CoreDataManager
    var fileManager: LocalFileManager = LocalFileManager()
    
    @Published var currentAlbum: Album?
    @Published var currentArtist: Artist?
    
    init(metadata: Metadata, viewContext: NSManagedObjectContext) {
        self.songTitle = metadata.songTitle ?? ""
        self.albumTitle = metadata.albumTitle ?? ""
        self.albumCoverArtwork = metadata.albumCoverArtwork
        self.artistTitle = metadata.artistTitle ?? ""
        self.url = metadata.url
        
        self.viewContext = viewContext
        self.dataManager = CoreDataManager(viewContext: viewContext)
        
//        self.currentAlbum = dataManager.initializeAlbum(title: metadata.albumTitle ?? "", coverArtwork: metadata.albumCoverArtwork)
//        self.currentArtist = dataManager.initializeArtist(title: metadata.artistTitle ?? "")
    }
    
    func addSong() {
//        currentAlbum.artist = currentArtist
//        
//        currentSong.album = currentAlbum
//        currentSong.artist = currentArtist
//        
//        fileManager.saveSongFromURL(url: url!, song: currentSong)
//        
//        dataManager.saveData()
        
        
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
            let artist = dataManager.initializeArtist(title: artistTitle)
            song.artist = artist
            song.album.artist = artist
        }
        
        fileManager.saveSongFromURL(url: url!, song: song)
        dataManager.saveData()
    }
}
