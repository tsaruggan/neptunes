//
//  AlbumEditorViewModel.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2024-08-13.
//

import Foundation
import CoreData
import SwiftUI
import AVFoundation
import PhotosUI

final class AlbumEditorViewModel: ObservableObject {
    var editorAction: EditorActionType
    
    var viewContext: NSManagedObjectContext
    var dataManager: CoreDataManager
    var fileManager: LocalFileManager = LocalFileManager.shared
    
    @Published var albumTitle: String = ""
    @Published var albumCoverArtwork: UIImage? = nil
    @Published var albumHeaderArtwork: UIImage? = nil
    var albumColorPalette: ColorPalette? = nil
    @Published var currentAlbum: Album? = nil
    
    @Published var artistTitle: String = ""
    @Published var artistCoverArtwork: UIImage? = nil
    @Published var artistHeaderArtwork: UIImage? = nil
    var artistColorPalette: ColorPalette? = nil
    @Published var currentArtist: Artist? = nil
    
    init(album: Album, viewContext: NSManagedObjectContext) {
        self.currentAlbum = album
        self.albumTitle = album.title
        self.albumCoverArtwork = album.coverArtwork?.asUIImage
        self.albumHeaderArtwork = album.headerArtwork?.asUIImage
        self.albumColorPalette = album.palette?.toColorPalette()
        
        self.currentArtist = album.artist
        self.artistTitle = album.artist.title
        self.artistCoverArtwork = album.artist.coverArtwork?.asUIImage
        self.artistHeaderArtwork = album.artist.headerArtwork?.asUIImage
        self.artistColorPalette = album.artist.palette?.toColorPalette()
        
        self.viewContext = viewContext
        self.dataManager = CoreDataManager(viewContext: viewContext)
        self.editorAction = .edit
    }

    
    func updateAlbum() {
        var artist: Artist
        if let existingArtist = currentArtist {
            artist = existingArtist
        } else {
            artist = dataManager.addArtist(title: artistTitle, coverArtwork: artistCoverArtwork, headerArtwork: artistHeaderArtwork, palette: artistColorPalette)
        }
        
        dataManager.updateAlbum(album: currentAlbum!, title: albumTitle, coverArtwork: albumCoverArtwork, headerArtwork: albumHeaderArtwork, palette: albumColorPalette, artist: artist)
        
        dataManager.save()
        objectWillChange.send()
    }
    
    func deleteAlbum() {
        dataManager.deleteAlbum(album: currentAlbum!)
        dataManager.save()
    }
    
    func onAlbumArtworkChange() {
        Task {
            albumColorPalette = ColorAnalyzer.generatePalette(coverArtwork: albumCoverArtwork, headerArtwork: albumHeaderArtwork)
        }
    }
    
    func onArtistArtworkChange() {
        Task {
            artistColorPalette = ColorAnalyzer.generatePalette(coverArtwork: artistCoverArtwork, headerArtwork: artistHeaderArtwork)
        }
    }
    
    func validate() -> Bool {
        let artistExists = artistTitle != ""
        let albumExists = currentAlbum != nil || albumTitle != ""
        return artistExists && albumExists
    }
    
    func rearrangeSongs(from source: IndexSet, to destination: Int) {
        guard let album = currentAlbum,
              let mutableSongs = album.songs?.mutableCopy() as? NSMutableOrderedSet else {
            return
        }

        // Adjust the destination index if it is at the end of the list
        var adjustedDestination = destination
        if destination >= mutableSongs.count {
            adjustedDestination = mutableSongs.count - 1
        }

        // Rearrange the songs in the mutable ordered set
        mutableSongs.moveObjects(at: source, to: adjustedDestination)

        // Assign the updated ordered set back to the album
        album.songs = mutableSongs.copy() as? NSOrderedSet
    }

}
