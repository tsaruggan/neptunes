//
//  CoreDataManager.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-11.
//

import Foundation
import CoreData

struct CoreDataManager {
    var viewContext: NSManagedObjectContext
    
    func initializeSong(title: String, id: UUID) -> Song {
        let song = Song(context: viewContext)
        song.title = title
        song.id = id
        return song
    }
    
   func initializeAlbum(title: String, coverArtwork: Data?) -> Album {
        let album = Album(context: viewContext)
        album.title = title
        album.coverArtwork = coverArtwork
        return album
    }
    
    func initializeArtist(title: String, coverArtwork: Data?) -> Artist {
        let artist = Artist(context: viewContext)
        artist.title = title
        artist.coverArtwork = coverArtwork
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
    
    
}
