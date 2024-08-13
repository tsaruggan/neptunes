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

enum EditorActionType {
    case new
    case edit
}

final class SongEditorViewModel: ObservableObject {
    var editorAction: EditorActionType
    
    @Published var _currentSong: Song? = nil
    @Published var songTitle: String = ""
    @Published var isExplicit: Bool = false
    @Published var url: URL?
    
    var viewContext: NSManagedObjectContext
    var dataManager: CoreDataManager
    var fileManager: LocalFileManager = LocalFileManager()
    
    @Published var albumTitle: String = ""
    @Published var albumCoverArtwork: UIImage? = nil
    @Published var albumHeaderArtwork: UIImage? = nil
    var albumColorPalette: ColorPalette? = nil
    @Published private var _currentAlbum: Album? = nil
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
    
    @Published var artistTitle: String = ""
    @Published var artistCoverArtwork: UIImage? = nil
    @Published var artistHeaderArtwork: UIImage? = nil
    var artistColorPalette: ColorPalette? = nil
    @Published private var _currentArtist: Artist? = nil
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
        self.isExplicit = false
        
        self.albumTitle = metadata.albumTitle ?? ""
        
        self.albumCoverArtwork = nil
        if let albumCoverArtworkData = metadata.albumCoverArtwork,
            let albumCoverArtwork = UIImage(data: albumCoverArtworkData) {
            self.albumCoverArtwork = albumCoverArtwork
            self.albumColorPalette = ColorAnalyzer.generatePalette(coverArtwork: albumCoverArtwork, headerArtwork: nil)
        }
        
        self.artistTitle = metadata.artistTitle ?? ""
        
        self.url = metadata.url
        
        self.viewContext = viewContext
        self.dataManager = CoreDataManager(viewContext: viewContext)
        self.editorAction = .new
    }
    
    init(song: Song, viewContext: NSManagedObjectContext) {
        self._currentSong = song
        self.songTitle = song.title
        self.isExplicit = song.isExplicit
        self.url = fileManager.retrieveSong(song: song)
        
        self._currentAlbum = song.album
        self.albumTitle = song.album.title
        self.albumCoverArtwork = song.album.coverArtwork?.asUIImage
        self.albumHeaderArtwork = song.album.headerArtwork?.asUIImage
        self.albumColorPalette = song.album.palette?.toColorPalette()
        
        self._currentArtist = song.artist
        self.artistTitle = song.artist.title
        self.artistCoverArtwork = song.artist.coverArtwork?.asUIImage
        self.artistHeaderArtwork = song.artist.headerArtwork?.asUIImage
        self.artistColorPalette = song.artist.palette?.toColorPalette()
        
        self.viewContext = viewContext
        self.dataManager = CoreDataManager(viewContext: viewContext)
        self.editorAction = .edit
    }
    
    func addSong() {
        let song = dataManager.initializeSong(title: songTitle, id: UUID())
        song.isExplicit = isExplicit
        
        if let artist = _currentArtist {
            artist.addToSongs(song)
            
            if let album = _currentAlbum {
                album.addToSongs(song)
            } else {
                let album = dataManager.initializeAlbum(title: albumTitle, coverArtwork: albumCoverArtwork, headerArtwork: albumHeaderArtwork)
                let albumPalette = dataManager.initializePalette(colorPalette: albumColorPalette)
                album.palette = albumPalette
                
                album.addToSongs(song)
                artist.addToAlbums(album)
            }
            
        } else {
            let artist = dataManager.initializeArtist(title: artistTitle, coverArtwork: artistCoverArtwork, headerArtwork: artistHeaderArtwork)
            let artistPalette = dataManager.initializePalette(colorPalette: artistColorPalette)
            artist.palette = artistPalette
            
            let album = dataManager.initializeAlbum(title: albumTitle, coverArtwork: albumCoverArtwork, headerArtwork: albumHeaderArtwork)
            let albumPalette = dataManager.initializePalette(colorPalette: albumColorPalette)
            album.palette = albumPalette
            
            artist.addToSongs(song)
            album.addToSongs(song)
            artist.addToAlbums(album)
        }
        
        fileManager.saveSongFromURL(url: url!, song: song)
        dataManager.saveData()
    }
    
    func updateSong() {
        let song = _currentSong!
        song.title = songTitle
        song.isExplicit = isExplicit
        
        if let artist = _currentArtist {
            if (song.artist != artist) {
                artist.addToSongs(song)
            }
            
            if let album = _currentAlbum {
                if (song.album != album) {
                    album.addToSongs(song)
                }
            } else {
                let album = dataManager.initializeAlbum(title: albumTitle, coverArtwork: albumCoverArtwork, headerArtwork: albumHeaderArtwork)
                let albumPalette = dataManager.initializePalette(colorPalette: albumColorPalette)
                album.palette = albumPalette
                
                album.addToSongs(song)
                artist.addToAlbums(album)
            }
            
        } else {
            let artist = dataManager.initializeArtist(title: artistTitle, coverArtwork: artistCoverArtwork, headerArtwork: artistHeaderArtwork)
            let artistPalette = dataManager.initializePalette(colorPalette: artistColorPalette)
            artist.palette = artistPalette
            
            let album = dataManager.initializeAlbum(title: albumTitle, coverArtwork: albumCoverArtwork, headerArtwork: albumHeaderArtwork)
            let albumPalette = dataManager.initializePalette(colorPalette: albumColorPalette)
            album.palette = albumPalette
            
            artist.addToSongs(song)
            album.addToSongs(song)
            artist.addToAlbums(album)
        }
        
        dataManager.saveData()
    }
    
    func onAlbumArtworkChange() {
        Task {
            albumColorPalette = ColorAnalyzer.generatePalette(coverArtwork: albumCoverArtwork, headerArtwork: albumHeaderArtwork)
        }
    }
    
    func onArtistArtworkChange() {
        Task {
            artistColorPalette = ColorAnalyzer.generatePalette(coverArtwork: artistCoverArtwork, headerArtwork: artistCoverArtwork)
        }
    }
    
    func validate() -> Bool {
        let songExists = url != nil && songTitle != ""
        let artistExists = currentArtist != nil || artistTitle != ""
        let albumExists = currentAlbum != nil || albumTitle != ""
        return songExists && artistExists && albumExists
    }
}

extension Data {
    var asUIImage: UIImage? {
        return UIImage(data: self)
    }
}
