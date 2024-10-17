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
    
    private func addPalette(colorPalette: ColorPalette?) -> Palette? {
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
    
    func addArtist(title: String, coverArtwork: UIImage?, headerArtwork: UIImage?, palette: ColorPalette?) -> Artist {
        let artist = Artist(context: viewContext)
        artist.title = title
        artist.coverArtwork = coverArtwork?.pngData()
        artist.headerArtwork = headerArtwork?.pngData()
        artist.palette = addPalette(colorPalette: palette)
        return artist
    }
    
    func addAlbum(title: String, coverArtwork: UIImage?, headerArtwork: UIImage?, palette: ColorPalette?, artist: Artist) -> Album {
        let album = Album(context: viewContext)
        album.title = title
        album.coverArtwork = coverArtwork?.pngData()
        album.headerArtwork = headerArtwork?.pngData()
        album.palette = addPalette(colorPalette: palette)
        artist.addToAlbums(album)
        return album
    }
    
    func addSong(title: String, isExplicit: Bool, album: Album) -> Song {
        let song = Song(context: viewContext)
        song.title = title
        song.isExplicit = isExplicit
        song.id = UUID()
        album.addToSongs(song)
        album.artist.addToSongs(song)
        return song
    }
    
    func updateArtist(artist: Artist, title: String, coverArtwork: UIImage?, headerArtwork: UIImage?, palette: ColorPalette?) {
        artist.title = title
        artist.coverArtwork = coverArtwork?.pngData()
        artist.headerArtwork = headerArtwork?.pngData()
        
        if let oldPalette = artist.palette {
            deletePalette(palette: oldPalette)
        }
        artist.palette = addPalette(colorPalette: palette)
    }
    
    func updateAlbum(album: Album, title: String, coverArtwork: UIImage?, headerArtwork: UIImage?, palette: ColorPalette?, artist: Artist) {
        album.title = title
        album.coverArtwork = coverArtwork?.pngData()
        album.headerArtwork = headerArtwork?.pngData()
        
        if let oldPalette = album.palette {
            deletePalette(palette: oldPalette)
        }
        album.palette = addPalette(colorPalette: palette)
        
        
        let oldArtist = album.artist
        artist.addToAlbums(album)
        
        // Delete old artist if they have no albums left
        if let oldArtistAlbums = oldArtist.albums, oldArtistAlbums.count == 0 {
            deleteArtist(artist: oldArtist)
        }
    }
    
    func updateSong(song: Song, title: String, isExplicit: Bool, album: Album) {
        song.title = title
        song.isExplicit = isExplicit
        
        let oldAlbum = song.album
        album.addToSongs(song)
        album.artist.addToSongs(song)
        
        // Delete old album if they have no songs left
        if let oldAlbumSongs = oldAlbum.songs, oldAlbumSongs.count == 0 {
            deleteAlbum(album: oldAlbum)
            
            // Delete old artist if they have no albums left
            let oldArtist = oldAlbum.artist
            if let oldArtistAlbums = oldArtist.albums, oldArtistAlbums.count == 0 {
                deleteArtist(artist: oldArtist)
            }
        }
    }
    
    private func deletePalette(palette: Palette) {
        viewContext.delete(palette)
    }
    
    func deleteArtist(artist: Artist) {
        // Delete all albums in artist
        if let albums = artist.albums {
            for album in albums {
                if let album = album as? Album {
                    // Delete album palette
                    if let albumPalette = album.palette {
                        viewContext.delete(albumPalette)
                    }
                    
                    // Delete all songs in album
                    if let albumSongs = album.songs {
                        for song in albumSongs {
                            if let song = song as? Song {
                                viewContext.delete(song)
                            }
                        }
                    }
                    viewContext.delete(album)
                }
            }
        }
        
        // Delete palette
        if let artistPalette = artist.palette {
            viewContext.delete(artistPalette)
        }
        
        viewContext.delete(artist)
    }
    
    func deleteAlbum(album: Album) {
//        // Delete all songs in album
//        if let albumSongs = album.songs {
//            for song in albumSongs {
//                if let song = song as? Song {
//                    viewContext.delete(song)
//                }
//            }
//        }
        
        // Delete artist if they have no albums left
        if let artistAlbums = album.artist.albums, artistAlbums.count == 1 {
            // Delete artist palette
            if let artistPalette = album.artist.palette {
                viewContext.delete(artistPalette)
            }
            viewContext.delete(album.artist)
        }
        
        // Delete album palette
        if let albumPalette = album.palette {
            viewContext.delete(albumPalette)
        }
        
        viewContext.delete(album)
    }
    
    func deleteSong(song: Song) {
        // Delete album if they have no songs left
        if let albumSongs = song.album.songs, albumSongs.count == 1 {
            deleteAlbum(album: song.album)
        }
        
        // Delete artist if they have no songs left
        if let artistSongs = song.artist.songs, artistSongs.count == 1 {
            deleteArtist(artist: song.artist)
        }
        
        viewContext.delete(song)
    }
    
    func save() {
        do {
            try viewContext.save()
        } catch let error {
            print("An error occurred while saving view context. \(error)")
        }
    }
    
    func undo() {
        viewContext.rollback()
    }

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
