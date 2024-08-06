//
//  CoreDataManager.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-11.
//

import Foundation
import CoreData
import SwiftUI

struct CoreDataManager {
    var viewContext: NSManagedObjectContext
    
    func initializeSong(title: String, id: UUID, isExplicit: Bool=true) -> Song {
        let song = Song(context: viewContext)
        song.title = title
        song.id = id
        song.isExplicit = isExplicit
        return song
    }
    
    func initializeAlbum(title: String, coverArtwork: UIImage?, headerArtwork: UIImage?) -> Album {
        let album = Album(context: viewContext)
        album.title = title
        album.coverArtwork = coverArtwork?.pngData()
        album.headerArtwork = headerArtwork?.pngData()
        return album
    }
    
    func initializeArtist(title: String, coverArtwork: UIImage?, headerArtwork: UIImage?) -> Artist {
        let artist = Artist(context: viewContext)
        artist.title = title
        artist.coverArtwork = coverArtwork?.pngData()
        artist.headerArtwork = headerArtwork?.pngData()
        return artist
    }
    
    func initializePalette(colorPalette: ColorPalette?) -> Palette? {
        guard let (primaryTheme, secondaryTheme, accentTheme, backgroundTheme) = colorPalette else {
            return nil
        }
        
        let palette = Palette(context: viewContext)
        palette.primaryLight = primaryTheme.lightColor.hex
        palette.primaryDark = primaryTheme.darkColor.hex
        palette.secondaryLight = secondaryTheme.lightColor.hex
        palette.secondaryDark = secondaryTheme.darkColor.hex
        palette.accentLight = accentTheme.lightColor.hex
        palette.accentDark = accentTheme.darkColor.hex
        palette.backgroundLight = backgroundTheme.lightColor.hex
        palette.backgroundDark = backgroundTheme.darkColor.hex
        return palette
    }
    
    func saveData() {
        do {
            try viewContext.save()
        } catch let error {
            print("An error occurred while saving. \(error)")
        }
    }
    
    func undoChanges() {
        viewContext.rollback()
    }
    
    func initializeTestSongs() {
        let songsData = [
            ("Not Around", "Drake", "Certified Lover Boy", "song1"),
            ("Hell of a Night", "Travis Scott", "Owl Pharoah", "song2"),
            ("Wither", "Frank Ocean", "Endless", "song3"),
            ("Rushes", "Frank Ocean", "Endless", "song4"),
            ("Cancun", "Playboi Carti", "Cancun", "song5")
        ]
        
        for (title, artistTitle, albumTitle, filename) in songsData {
            let song = initializeSong(title: title, id: UUID())
            var artist: Artist
            var album: Album
            
            if let existingArtist = fetchArtist(by: artistTitle) {
                artist = existingArtist
            } else {
                artist = initializeArtist(title: artistTitle, coverArtwork: nil, headerArtwork: nil)
            }
            
            if let existingAlbum = fetchAlbum(by: albumTitle) {
                album = existingAlbum
            } else {
                album = initializeAlbum(title: albumTitle, coverArtwork: nil, headerArtwork: nil)
                artist.addToAlbums(album)
            }
            
            album.addToSongs(song)
            artist.addToSongs(song)
            
            // Assuming you have an instance of LocalFileManager
            let fileManager = LocalFileManager()
            fileManager.saveSong(filename: filename, song: song)
        }
        
        saveData()
    }

    // Add fetch methods for existing artists and albums
    func fetchArtist(by title: String) -> Artist? {
        let request: NSFetchRequest<Artist> = Artist.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        return try? viewContext.fetch(request).first
    }

    func fetchAlbum(by title: String) -> Album? {
        let request: NSFetchRequest<Album> = Album.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        return try? viewContext.fetch(request).first
    }

    
    
}
