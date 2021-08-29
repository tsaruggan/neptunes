//
//  CoreDataManager.swift
//  CoreDataManager
//
//  Created by Saruggan Thiruchelvan on 2021-08-28.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NeptunesContainer")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    init() {
        if fetchReccomendations().isEmpty {
            initializeReccomendations()
        }
    }
    
    func fetchReccomendations() -> [Collectable] {
        var reccomendations: [Collectable] = []
        let albumsRequest = NSFetchRequest<Album>(entityName: "Album")
        let playlistsRequest = NSFetchRequest<Playlist>(entityName: "Playlist")
        do {
            reccomendations = try persistentContainer.viewContext.fetch(albumsRequest)
            reccomendations += try persistentContainer.viewContext.fetch(playlistsRequest)
        } catch let error {
            print(error)
        }
        return reccomendations
    }
    
    func initializeReccomendations() {
        let albumArtwork1 = "drake_album_art_2"
        let artistArtwork1 = "drake_artist_art"
        
        let song1 = Song(context: persistentContainer.viewContext)
        song1.title = "Not Around"
        song1.isExplicit = false
        song1.audioURI = "song1"
        song1.id = UUID()
        
        let album1 = Album(context: persistentContainer.viewContext)
        album1.title = "Not Around"
        album1.artworkURI = albumArtwork1
        album1.id = UUID()
        album1.addToSongs(song1)
        
        let artist1 = Artist(context: persistentContainer.viewContext)
        artist1.title = "Drake"
        artist1.artworkURI = artistArtwork1
        artist1.id = UUID()
        artist1.addToSongs(song1)
        album1.artist = artist1
        
        let albumArtwork2 = "frank_ocean_album_art_1"
        let artistArtwork2 = "frank_ocean_artist_art"
        
        let song3 = Song(context: persistentContainer.viewContext)
        song3.title = "Wither"
        song3.isExplicit = false
        song3.audioURI = "song3"
        song3.id = UUID()
        
        let song4 = Song(context: persistentContainer.viewContext)
        song4.title = "Rushes"
        song4.isExplicit = false
        song4.audioURI = "song4"
        song4.id = UUID()
        
        let album2 = Album(context: persistentContainer.viewContext)
        album2.title = "Endless"
        album2.artworkURI = albumArtwork2
        album2.id = UUID()
        album2.addToSongs([song3, song4])
        
        let artist2 = Artist(context: persistentContainer.viewContext)
        artist2.title = "Frank Ocean"
        artist2.artworkURI = artistArtwork2
        artist2.id = UUID()
        artist2.addToSongs([song3, song4])
        album2.artist = artist2
        
        saveData()
    }
    
    func saveData() {
        do {
            try persistentContainer.viewContext.save()
        } catch let error {
            print("An error occurred while saving. \(error)")
        }
    }
    
    
}
