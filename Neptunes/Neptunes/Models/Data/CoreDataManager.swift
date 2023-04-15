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
