//
//  DataTests.swift
//  NeptunesTests
//
//  Created by Saruggan Thiruchelvan on 2024-10-18.
//

import XCTest
@testable import Neptunes

final class DataTests: XCTestCase {
    let fileManager = LocalFileManager.shared
    var dataManager: CoreDataManager!
    
    var sampleColorPalette: ColorPalette!
    var sampleArtwork: UIImage?
    var sampleHeader: UIImage?
    
    override func setUpWithError() throws {
        // Initialize CoreDataManager with the shared context
        let persistenceController = PersistenceController.shared
        let context = persistenceController.container.viewContext
        dataManager = CoreDataManager(viewContext: context)
        
        sampleColorPalette = (
            primaryTheme: (
                lightColor: UIColor(red: 0.2, green: 0.6, blue: 0.86, alpha: 1.0),
                darkColor: UIColor(red: 0.1, green: 0.4, blue: 0.7, alpha: 1.0)
            ),
            secondaryTheme: (
                lightColor: UIColor(red: 0.9, green: 0.3, blue: 0.4, alpha: 1.0),
                darkColor: UIColor(red: 0.8, green: 0.2, blue: 0.3, alpha: 1.0)
            ),
            accentTheme: (
                lightColor: UIColor(red: 0.9, green: 0.7, blue: 0.2, alpha: 1.0),
                darkColor: UIColor(red: 0.8, green: 0.6, blue: 0.1, alpha: 1.0)
            ),
            backgroundTheme: (
                lightColor: UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0),
                darkColor: UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
            )
        )
        
        let bundle = Bundle(for: type(of: self))
        
        if let artworkURL = bundle.url(forResource: "artwork", withExtension: ".jpg") {
            sampleArtwork = UIImage(contentsOfFile: artworkURL.path())
        }
        
        if let headerURL = bundle.url(forResource: "header", withExtension: ".jpg") {
            sampleHeader = UIImage(contentsOfFile: headerURL.path())
        }
        
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        dataManager.clearAll()
        fileManager.clearAll()
    }
    
    func colorsAreEqual(_ color1: UIColor, _ color2: UIColor) -> Bool {
        var red1: CGFloat = 0, green1: CGFloat = 0, blue1: CGFloat = 0, alpha1: CGFloat = 0
        var red2: CGFloat = 0, green2: CGFloat = 0, blue2: CGFloat = 0, alpha2: CGFloat = 0

        color1.getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1)
        color2.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)

        print(red1, red2, green1, green2, blue1, blue2)

        let epsilon: CGFloat = 0.01
        return abs(red1 - red2) < epsilon &&
               abs(green1 - green2) < epsilon &&
               abs(blue1 - blue2) < epsilon &&
               abs(alpha1 - alpha2) < epsilon
    }
    
    func testAddArtist() throws {
        var artistTitle = "Lil Rapper"
        var artist = dataManager.addArtist(title: artistTitle, coverArtwork: sampleArtwork, headerArtwork: sampleHeader, palette: sampleColorPalette)
        
        dataManager.save()
        
        XCTAssertEqual(artist.title, artistTitle)
        XCTAssertNotNil(artist.coverArtwork)
        XCTAssertNotNil(artist.headerArtwork)
        XCTAssert(colorsAreEqual(artist.palette!.toColorPalette().primaryTheme.lightColor, sampleColorPalette.primaryTheme.lightColor))
    }
    
    func testAddAlbum() throws {
        var artistTitle = "Lil Rapper"
        var artist = dataManager.addArtist(title: artistTitle, coverArtwork: nil, headerArtwork: nil, palette: nil)
        
        var albumTitle = "Tale of my Lil Life"
        var album = dataManager.addAlbum(title: albumTitle, coverArtwork: sampleArtwork, headerArtwork: sampleHeader, palette: sampleColorPalette, artist: artist)
        
        dataManager.save()
        
        XCTAssertEqual(album.title, albumTitle)
        XCTAssertNotNil(album.coverArtwork)
        XCTAssertNotNil(album.headerArtwork)
        XCTAssert(colorsAreEqual(album.palette!.toColorPalette().secondaryTheme.darkColor, sampleColorPalette.secondaryTheme.darkColor))
        
        XCTAssertEqual(album.artist.title, artistTitle)
        XCTAssert(artist.albums!.contains(album))
    }
    
    func testAddSong() throws {
        var artistTitle = "Lil Rapper"
        var artist = dataManager.addArtist(title: artistTitle, coverArtwork: nil, headerArtwork: nil, palette: nil)
        
        var albumTitle = "Tale of my Lil Life"
        var album = dataManager.addAlbum(title: albumTitle, coverArtwork: nil, headerArtwork: nil, palette: nil, artist: artist)
        
        var songTitle = "Lil Interlude"
        var song = dataManager.addSong(title: songTitle, isExplicit: false, album: album)
        
        dataManager.save()
        
        XCTAssertEqual(song.title, songTitle)
        
        XCTAssertEqual(song.album.title, albumTitle)
        XCTAssert(album.songs!.contains(song))
        
        XCTAssertEqual(song.artist.title, artistTitle)
        XCTAssert(artist.songs!.contains(song))
    }
    
    func testUpdateArtist() throws {
        var artistTitle = "Lil Rapper"
        var artist = dataManager.addArtist(title: artistTitle, coverArtwork: nil, headerArtwork: nil, palette: nil)
        
        dataManager.save()
        
        var newArtistTitle = "Big Musician"
        dataManager.updateArtist(artist: artist, title: newArtistTitle, coverArtwork: sampleArtwork, headerArtwork: sampleHeader, palette: sampleColorPalette)
        
        dataManager.save()
        
        XCTAssertEqual(artist.title, newArtistTitle)
        XCTAssertNotNil(artist.coverArtwork)
        XCTAssertNotNil(artist.headerArtwork)
        XCTAssert(colorsAreEqual(artist.palette!.toColorPalette().accentTheme.lightColor, sampleColorPalette.accentTheme.lightColor))
        
        XCTAssertNil(dataManager.fetchArtist(by: artistTitle))
        
        XCTAssertNotNil(dataManager.fetchArtist(by: newArtistTitle))
    }
    
    func testUpdateAlbum() throws {
        var albumTitle = "Tale of my Lil Life"
        var artistTitle = "Lil Rapper"
        var artist = dataManager.addArtist(title: albumTitle, coverArtwork: nil, headerArtwork: nil, palette: nil)
        var album = dataManager.addAlbum(title: albumTitle, coverArtwork: nil, headerArtwork: nil, palette: nil, artist: artist)
        dataManager.save()
        
        var newAlbumTitle = "Story about our Big World"
        var newArtistTitle = "Big Musician"
        var newArtist = dataManager.addArtist(title: newArtistTitle, coverArtwork: nil, headerArtwork: nil, palette: nil)
        dataManager.updateAlbum(album: album, title: newAlbumTitle, coverArtwork: sampleArtwork, headerArtwork: sampleHeader, palette: sampleColorPalette, artist: newArtist)
        dataManager.save()
        
        XCTAssertEqual(album.title, newAlbumTitle)
        XCTAssertEqual(album.artist.title, newArtistTitle)
        XCTAssertNotNil(album.coverArtwork)
        XCTAssertNotNil(album.headerArtwork)
        XCTAssert(colorsAreEqual(album.palette!.toColorPalette().backgroundTheme.darkColor, sampleColorPalette.backgroundTheme.darkColor))
        
        XCTAssertNil(dataManager.fetchArtist(by: artistTitle))
        XCTAssertNil(dataManager.fetchAlbum(by: albumTitle))
        
        XCTAssertNotNil(dataManager.fetchArtist(by: newArtistTitle))
        XCTAssertNotNil(dataManager.fetchAlbum(by: newAlbumTitle))
    }
    
    func testUpdateSong() throws {
        var albumTitle = "Tale of my Lil Life"
        var artistTitle = "Lil Rapper"
        var songTitle = "Lil Interlude"
        var artist = dataManager.addArtist(title: albumTitle, coverArtwork: nil, headerArtwork: nil, palette: nil)
        var album = dataManager.addAlbum(title: albumTitle, coverArtwork: nil, headerArtwork: nil, palette: nil, artist: artist)
        var song = dataManager.addSong(title: songTitle, isExplicit: true, album: album)
        dataManager.save()
        
        var newAlbumTitle = "Story about our Big World"
        var newArtistTitle = "Big Musician"
        var newSongTitle = "Big Single"
        var newArtist = dataManager.addArtist(title: newArtistTitle, coverArtwork: nil, headerArtwork: nil, palette: nil)
        var newAlbum = dataManager.addAlbum(title: newAlbumTitle, coverArtwork: nil, headerArtwork: nil, palette: nil, artist: newArtist)
        dataManager.updateSong(song: song, title: newSongTitle, isExplicit: false, album: newAlbum)
        dataManager.save()
        
        XCTAssertEqual(song.title, newSongTitle)
        XCTAssertEqual(song.album.title, newAlbumTitle)
        XCTAssertEqual(song.artist.title, newArtistTitle)
        
        XCTAssertNil(dataManager.fetchArtist(by: artistTitle))
        XCTAssertNil(dataManager.fetchAlbum(by: albumTitle))
        XCTAssertNil(dataManager.fetchSong(by: songTitle))
        
        XCTAssertNotNil(dataManager.fetchArtist(by: newArtistTitle))
        XCTAssertNotNil(dataManager.fetchAlbum(by: newAlbumTitle))
        XCTAssertNotNil(dataManager.fetchSong(by: newSongTitle))
    }
    
    func testDeleteSong1() throws {
        var artistTitle = "Lil Rapper"
        var artist = dataManager.addArtist(title: artistTitle, coverArtwork: nil, headerArtwork: nil, palette: nil)
        
        var albumTitle = "Tale of my Lil Life"
        var album = dataManager.addAlbum(title: albumTitle, coverArtwork: nil, headerArtwork: nil, palette: nil, artist: artist)
        
        var songTitle1 = "Lil Interlude"
        var song1 = dataManager.addSong(title: songTitle1, isExplicit: false, album: album)
        
        var songTitle2 = "Big Problems"
        var song2 = dataManager.addSong(title: songTitle2, isExplicit: true, album: album)
        
        dataManager.save()
        
        dataManager.deleteSong(song: song1)
        dataManager.save()
        
        XCTAssertNil(dataManager.fetchSong(by: songTitle1))
        XCTAssertNotNil(dataManager.fetchSong(by: songTitle2))
        
        album = dataManager.fetchAlbum(by: albumTitle)!
        XCTAssertFalse(album.songs!.contains(song1))
        XCTAssertTrue(album.songs!.contains(song2))
        
        artist = dataManager.fetchArtist(by: artistTitle)!
        XCTAssertFalse(artist.songs!.contains(song1))
        XCTAssertTrue(artist.songs!.contains(song2))
    }
    
    func testDeleteSong2() throws {
        var artistTitle = "Lil Rapper"
        var artist = dataManager.addArtist(title: artistTitle, coverArtwork: nil, headerArtwork: nil, palette: nil)
        
        var albumTitle = "Tale of my Lil Life"
        var album = dataManager.addAlbum(title: albumTitle, coverArtwork: nil, headerArtwork: nil, palette: nil, artist: artist)
        
        var songTitle = "Lil Interlude"
        var song = dataManager.addSong(title: songTitle, isExplicit: false, album: album)
        
        dataManager.save()
        
        dataManager.deleteSong(song: song)
        dataManager.save()
        
        XCTAssertNil(dataManager.fetchSong(by: songTitle))
        XCTAssertNil(dataManager.fetchAlbum(by: albumTitle))
        XCTAssertNil(dataManager.fetchArtist(by: artistTitle))
    }
    
    func testDeleteAlbum1() throws {
        var artistTitle = "Lil Rapper"
        var artist = dataManager.addArtist(title: artistTitle, coverArtwork: nil, headerArtwork: nil, palette: nil)
        
        var albumTitle1 = "Tale of my Lil Life"
        var album1 = dataManager.addAlbum(title: albumTitle1, coverArtwork: nil, headerArtwork: nil, palette: nil, artist: artist)
        
        var albumTitle2 = "Tale of my Lil Life 2"
        var album2 = dataManager.addAlbum(title: albumTitle2, coverArtwork: nil, headerArtwork: nil, palette: nil, artist: artist)
        
        var songTitle1 = "Lil Interlude"
        var song1 = dataManager.addSong(title: songTitle1, isExplicit: false, album: album1)
        
        var songTitle2 = "Big Problems"
        var song2 = dataManager.addSong(title: songTitle2, isExplicit: true, album: album1)
        
        var songTitle3 = "Medium Rare"
        var song3 = dataManager.addSong(title: songTitle3, isExplicit: true, album: album2)
        
        dataManager.save()
        
        dataManager.deleteAlbum(album: album1)
        dataManager.save()
        
        XCTAssertNil(dataManager.fetchAlbum(by: albumTitle1))
        XCTAssertNotNil(dataManager.fetchAlbum(by: albumTitle2))
        XCTAssertNil(dataManager.fetchSong(by: songTitle1))
        XCTAssertNil(dataManager.fetchSong(by: songTitle2))
        XCTAssertNotNil(dataManager.fetchSong(by: songTitle3))
        
        artist = dataManager.fetchArtist(by: artistTitle)!
        XCTAssertFalse(artist.albums!.contains(album1))
        XCTAssertTrue(artist.albums!.contains(album2))
        XCTAssertFalse(artist.songs!.contains(song1))
        XCTAssertFalse(artist.songs!.contains(song2))
        XCTAssertTrue(artist.songs!.contains(song3))
    }
    
    func testDeleteAlbum2() throws {
        var artistTitle = "Lil Rapper"
        var artist = dataManager.addArtist(title: artistTitle, coverArtwork: nil, headerArtwork: nil, palette: nil)
        
        var albumTitle = "Tale of my Lil Life"
        var album = dataManager.addAlbum(title: albumTitle, coverArtwork: nil, headerArtwork: nil, palette: nil, artist: artist)
        
        var songTitle = "Lil Interlude"
        var song = dataManager.addSong(title: songTitle, isExplicit: false, album: album)
        
        dataManager.save()
        
        dataManager.deleteAlbum(album: album)
        dataManager.save()
        
        XCTAssertNil(dataManager.fetchSong(by: songTitle))
        XCTAssertNil(dataManager.fetchAlbum(by: albumTitle))
        XCTAssertNil(dataManager.fetchArtist(by: artistTitle))
    }
    
    func testDeleteArtist1() throws {
        var artistTitle1 = "Lil Rapper"
        var artist1 = dataManager.addArtist(title: artistTitle1, coverArtwork: nil, headerArtwork: nil, palette: nil)
        
        var artistTitle2 = "Big Musician"
        var artist2 = dataManager.addArtist(title: artistTitle2, coverArtwork: nil, headerArtwork: nil, palette: nil)
        
        var albumTitle1 = "Tale of my Lil Life"
        var album1 = dataManager.addAlbum(title: albumTitle1, coverArtwork: nil, headerArtwork: nil, palette: nil, artist: artist1)
        
        var albumTitle2 = "Tale of my Lil Life 2"
        var album2 = dataManager.addAlbum(title: albumTitle2, coverArtwork: nil, headerArtwork: nil, palette: nil, artist: artist2)
        
        var songTitle1 = "Lil Interlude"
        var song1 = dataManager.addSong(title: songTitle1, isExplicit: false, album: album1)
        
        var songTitle2 = "Big Problems"
        var song2 = dataManager.addSong(title: songTitle2, isExplicit: true, album: album1)
        
        var songTitle3 = "Medium Rare"
        var song3 = dataManager.addSong(title: songTitle3, isExplicit: true, album: album2)
        
        dataManager.save()
        
        dataManager.deleteArtist(artist: artist1)
        dataManager.save()
        
        XCTAssertNil(dataManager.fetchArtist(by: artistTitle1))
        XCTAssertNotNil(dataManager.fetchArtist(by: artistTitle2))
        XCTAssertNil(dataManager.fetchAlbum(by: albumTitle1))
        XCTAssertNotNil(dataManager.fetchAlbum(by: albumTitle2))
        XCTAssertNil(dataManager.fetchSong(by: songTitle1))
        XCTAssertNil(dataManager.fetchSong(by: songTitle2))
        XCTAssertNotNil(dataManager.fetchSong(by: songTitle3))
    }
    
    func testDeleteArtist2() throws {
        var artistTitle = "Lil Rapper"
        var artist = dataManager.addArtist(title: artistTitle, coverArtwork: nil, headerArtwork: nil, palette: nil)
        
        var albumTitle = "Tale of my Lil Life"
        var album = dataManager.addAlbum(title: albumTitle, coverArtwork: nil, headerArtwork: nil, palette: nil, artist: artist)
        
        var songTitle = "Lil Interlude"
        var song = dataManager.addSong(title: songTitle, isExplicit: false, album: album)
        
        dataManager.save()
        
        dataManager.deleteArtist(artist: artist)
        dataManager.save()
        
        XCTAssertNil(dataManager.fetchSong(by: songTitle))
        XCTAssertNil(dataManager.fetchAlbum(by: albumTitle))
        XCTAssertNil(dataManager.fetchArtist(by: artistTitle))
    }
}
