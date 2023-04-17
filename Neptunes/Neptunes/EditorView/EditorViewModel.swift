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
import PhotosUI

final class EditorViewModel: ObservableObject {
    @Published var songTitle: String
    @Published var url: URL?
    
    var viewContext: NSManagedObjectContext
    var dataManager: CoreDataManager
    var fileManager: LocalFileManager = LocalFileManager()
    
    @Published var albumTitle: String
    @Published var albumCoverArtwork: Data?
    var albumColorPalette: ColorPalette?
    @Published private var _currentAlbum: Album?
    var currentArtist: Artist? {
        get {
            return self._currentArtist
        }
        
        set {
            self._currentArtist = newValue
            if newValue != nil {
                if self._currentAlbum != nil && self._currentAlbum!.artist != newValue {
                    self._currentAlbum = nil
                }
            } else {
                self._currentAlbum = nil
            }
        }
    }
    
    @Published var artistTitle: String
    @Published var artistCoverArtwork: Data?
    var artistColorPalette: ColorPalette?
    @Published private var _currentArtist: Artist?
    var currentAlbum: Album? {
        get {
            return self._currentAlbum
        }
        
        set {
            self._currentAlbum = newValue
            if newValue != nil {
                self._currentArtist = newValue!.artist
            }
        }
    }

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
        
        if let album = _currentAlbum {
            album.addToSongs(song)
        } else {
            let album = dataManager.initializeAlbum(title: albumTitle, coverArtwork: albumCoverArtwork)
            album.addToSongs(song)
            
            let albumPalette = dataManager.initializePalette(colorPalette: albumColorPalette)
            album.palette = albumPalette
        }
        
        if let artist = _currentArtist {
            artist.addToSongs(song)
        } else {
            let artist = dataManager.initializeArtist(title: artistTitle, coverArtwork: artistCoverArtwork)
            artist.addToSongs(song)
            artist.addToAlbums(song.album)
            
            let artistPalette = dataManager.initializePalette(colorPalette: artistColorPalette)
            artist.palette = artistPalette
        }
        
        fileManager.saveSongFromURL(url: url!, song: song)
        dataManager.saveData()
    }
    
    func updateAlbumCoverArtwork(item: PhotosPickerItem?) {
        Task {
            if let imageData = try? await item?.loadTransferable(type: Data.self) {
                albumColorPalette = ColorAnalyzer.generatePalette(coverArtwork: imageData, headerArtwork: nil)
                DispatchQueue.main.async {
                    self.albumCoverArtwork = imageData
                }
            }
        }
    }
    
    func updateArtistCoverArtwork(item: PhotosPickerItem?) {
        Task {
            if let imageData = try? await item?.loadTransferable(type: Data.self) {
                artistColorPalette = ColorAnalyzer.generatePalette(coverArtwork: imageData, headerArtwork: nil)
                DispatchQueue.main.async {
                    self.artistCoverArtwork = imageData
                }
            }
        }
    }
}
