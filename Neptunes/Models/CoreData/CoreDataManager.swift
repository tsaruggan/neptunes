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
            initializeData()
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
    
    private func initializeSong(title: String, audioURI: String, isExplicit: Bool=false) -> Song {
        let song = Song(context: persistentContainer.viewContext)
        song.title = title
        song.audioURI = audioURI
        song.isExplicit = isExplicit
        song.id = UUID()
        return song
    }
    
    private func initializeAlbum(title: String, artworkURI: String?=nil, headerURI: String?=nil, isSingle: Bool=false) -> Album {
        let album = Album(context: persistentContainer.viewContext)
        album.title = title
        album.artworkURI = artworkURI
        album.headerURI = headerURI
        album.isSingle = isSingle
        album.id = UUID()
        return album
    }
    
    private func initializeArtist(title: String, artworkURI: String?=nil, headerURI: String?=nil) -> Artist {
        let artist = Artist(context: persistentContainer.viewContext)
        artist.title = title
        artist.artworkURI = artworkURI
        artist.headerURI = headerURI
        artist.id = UUID()
        return artist
    }
    
    private func initializeData() {
        let song1 = initializeSong(title: "Not Around", audioURI: "song1", isExplicit: true)
        let album1 = initializeAlbum(title: "Not Around", artworkURI: "drake_album_art_2", isSingle: true)
        album1.addToSongs(song1)
        let artist1 = initializeArtist(title: "Drake", artworkURI: "drake_artist_art")
        artist1.addToSongs(song1)
        artist1.addToAlbums(album1)
        
        let song3 = initializeSong(title: "Wither", audioURI: "song3")
        let song4 = initializeSong(title: "Rushes", audioURI: "song4", isExplicit: true)
        let album2 = initializeAlbum(title: "Endless", artworkURI: "frank_ocean_album_art_1")
        album2.addToSongs([song3, song4])
        let artist2 = initializeArtist(title: "Frank Ocean", artworkURI: "frank_ocean_artist_art")
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
