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
    
    func initializeSong(title: String, audioURI: URL, id: UUID, isExplicit: Bool=false) -> Song {
        let song = Song(context: persistentContainer.viewContext)
        song.title = title
        song.audioURI = audioURI
        song.isExplicit = isExplicit
        song.id = id
        return song
    }
    
   func initializeAlbum(title: String, id: UUID, artworkURI: URL?=nil, headerURI: URL?=nil, isSingle: Bool=false) -> Album {
        let album = Album(context: persistentContainer.viewContext)
        album.title = title
        album.artworkURI = artworkURI
        album.headerURI = headerURI
        album.isSingle = isSingle
        album.id = id
        return album
    }
    
    func initializeArtist(title: String, id: UUID, artworkURI: URL?=nil, headerURI: URL?=nil) -> Artist {
        let artist = Artist(context: persistentContainer.viewContext)
        artist.title = title
        artist.artworkURI = artworkURI
        artist.headerURI = headerURI
        artist.id = id
        return artist
    }
    
    func saveData() {
        do {
            try persistentContainer.viewContext.save()
        } catch let error {
            print("An error occurred while saving. \(error)")
        }
    }
    
    func undoChanges() {
        persistentContainer.viewContext.rollback()
    }
    
    
}
