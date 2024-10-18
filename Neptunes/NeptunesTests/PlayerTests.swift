//
//  PlayerTests.swift
//  NeptunesTests
//
//  Created by Saruggan Thiruchelvan on 2024-07-25.
//

import XCTest
import AVFoundation
import MediaPlayer
import CoreData
@testable import Neptunes

final class PlayerTests: XCTestCase {
    let fileManager = LocalFileManager.shared
    var songs: [Song]!
    var player: Player!
    var dataManager: CoreDataManager!
    
    override func setUpWithError() throws {
        // Initialize CoreDataManager with the shared context
        let persistenceController = PersistenceController.shared
        let context = persistenceController.container.viewContext
        dataManager = CoreDataManager(viewContext: context)
        
        // Add songs using CoreDataManager
        addSong(title: "Not Around", artistTitle: "Drake", albumTitle: "Certified Lover Boy", filename: "song1")
        addSong(title: "Hell of a Night", artistTitle: "Travis Scott", albumTitle: "Owl Pharoah", filename: "song2")
        addSong(title: "Wither", artistTitle: "Frank Ocean", albumTitle: "Endless", filename: "song3")
        addSong(title: "Rushes", artistTitle: "Frank Ocean", albumTitle: "Endless", filename: "song4")
        addSong(title: "Cancun", artistTitle: "Playboi Carti", albumTitle: "Cancun", filename: "song5")
        
        // Fetch the songs from Core Data
        let fetchRequest: NSFetchRequest<Song> = Song.fetchRequest()
        songs = try context.fetch(fetchRequest)
        
        // Ensure ConfigModel is not already initialized
        ConfigModel.resetSharedInstance()
        guard ConfigModel.shared == nil else { fatalError("ConfigModel must be a singleton") }
        ConfigModel(nowPlayableBehavior: IOSNowPlayableBehavior())
        
        // Initialize player
        try player = Player()
    }
    
    private func addSong(title: String, artistTitle: String, albumTitle: String, filename: String) {
        let artist = dataManager.addArtist(title: artistTitle, coverArtwork: nil, headerArtwork: nil, palette: nil)
        let album = dataManager.addAlbum(title: albumTitle, coverArtwork: nil, headerArtwork: nil, palette: nil, artist: artist)
        let song = dataManager.addSong(title: title, isExplicit: false, album: album)
        
        // Save the song file
        fileManager.saveSong(filename: filename, song: song)
        dataManager.save()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        ConfigModel.resetSharedInstance()
        dataManager.clearAll()
        fileManager.clearAll()
    }
    
    func checkCurrentSongAlignment(expectedSong: Song) {
        let currentSong = player.currentSong
        let currentPlayerItem = player.currentPlayerItem
        let currentStaticMetadata = player.currentMetadata
        
        // Retrieve the URL and asset for the expected song
        let url = fileManager.retrieveSong(song: expectedSong)!
        let assetURL = AVURLAsset(url: url)
        
        // Check if the current song matches the expected song
        XCTAssertEqual(currentSong, expectedSong)
        
        // Check if the current player item corresponds to the asset URL
        XCTAssertEqual((currentPlayerItem?.asset as? AVURLAsset)?.url, assetURL.url)
        
        // Check if the current metadata's asset URL matches the expected asset URL
        XCTAssertEqual(currentStaticMetadata?.assetURL, assetURL.url)
        
        // Additional checks to ensure metadata correctness
        XCTAssertEqual(currentStaticMetadata?.title, expectedSong.title)
        XCTAssertEqual(currentStaticMetadata?.artist, expectedSong.artist.title)
        XCTAssertEqual(currentStaticMetadata?.albumTitle, expectedSong.album.title)
    }
    
    func testReplaceNowPlaying() throws {
        // Replace now playing songs starting from the first song
        player.replaceNowPlaying(songs: songs, from: 0)
        
        // Check current song alignment
        checkCurrentSongAlignment(expectedSong: songs[0])
    }
    
    func testNextTrack() throws {
        // Replace now playing songs starting from the first song
        player.replaceNowPlaying(songs: songs, from: 0)
        
        // Go to next track
        player.nextTrack()
        
        // Check current song alignment
        checkCurrentSongAlignment(expectedSong: songs[1])
    }
    
    func testPreviousTrack() throws {
        // Replace now playing songs starting from the first song
        player.replaceNowPlaying(songs: songs, from: 0)
        
        // Go to previous track
        player.previousTrack()
        
        // Check current song alignment
        checkCurrentSongAlignment(expectedSong: songs[songs.count-1])
    }
    
    func testNextTrackQueue1() throws {
        // Add song to queue
        player.addToQueue(song: songs.last!)
        
        // Go to next track
        player.nextTrack()
        
        // Check current song alignment
        checkCurrentSongAlignment(expectedSong: songs.last!)
    }
    
    func testNextTrackQueue2() throws {
        // Replace now playing songs starting from the second song
        player.replaceNowPlaying(songs: songs, from: 1)
        
        // Add song to queue
        player.addToQueue(song: songs.last!)
        
        // Go to next track
        player.nextTrack()
        
        // Check current song alignment
        checkCurrentSongAlignment(expectedSong: songs.last!)
    }
    
    func testPreviousTrackQueue1() throws {
        // Add song to queue
        player.addToQueue(song: songs.last!)
        
        // Go to previous track
        player.previousTrack()
        
        // Check current song is null
        XCTAssertNil(player.currentSong)
    }
    
    func testPreviousTrackQueue2() throws {
        // Replace now playing songs starting from the second song
        player.replaceNowPlaying(songs: songs, from: 1)
        
        // Add song to queue
        player.addToQueue(song: songs.last!)
        
        // Go to next track
        player.nextTrack()
        
        // Check current song alignment
        checkCurrentSongAlignment(expectedSong: songs.last!)
        
        // Go to previous track
        player.previousTrack()
        
        // Check current song alignment
        checkCurrentSongAlignment(expectedSong: songs[1])
    }
    
    func testAddToNowPlaying1() throws {
        // Add the first song to now playing
        player.addToNowPlaying(song: songs[0])
        
        // Check current song alignment
        checkCurrentSongAlignment(expectedSong: songs[0])
    }
    
    func testAddToNowPlaying2() throws {
        // Replace now playing songs starting from the second song
        player.replaceNowPlaying(songs: songs, from: 1)
        
        // Add the first song to now playing
        player.addToNowPlaying(song: songs.last!)
        
        // Check current song alignment
        checkCurrentSongAlignment(expectedSong: songs[1])
        
        // Go to previous track
        player.previousTrack()
        
        // Check current song alignment
        checkCurrentSongAlignment(expectedSong: songs.last!)
    }
    
    func testAddToNowPlaying3() throws {
        // Replace now playing songs starting from the first song
        player.replaceNowPlaying(songs: songs, from: 0)
        
        // Add the first song to now playing
        player.addToNowPlaying(song: songs[3])
        
        // Check current song alignment
        checkCurrentSongAlignment(expectedSong: songs[0])
        
        // Go to previous track
        player.previousTrack()
        
        // Check current song alignment
        checkCurrentSongAlignment(expectedSong: songs[3])
    }
    
    func testRearrangeQueue1() throws {
        // Add songs to queue
        player.addToQueue(song: songs[0])
        player.addToQueue(song: songs[1])
        player.addToQueue(song: songs[2])
        
        // Rearrange queue
        // Move last song (index 2) to the middle (index 1)
        player.rearrangeQueue(from: IndexSet(integer: 2), to: 1)
        
        // Verify the final state of the queue
        let songsInQueue = player.songsInQueue!
        XCTAssertEqual(songsInQueue, [songs[0], songs[2], songs[1]])
    }
    
    func testRearrangeNowPlaying1() throws {
        // Add songs to now playing
        player.addToNowPlaying(song: songs[0])
        player.addToNowPlaying(song: songs[1])
        player.addToNowPlaying(song: songs[2])
        
        // Rearrange now playing 0, 1, 2 ---> 0, 2, 1
        player.rearrangeNowPlaying(from: IndexSet(integer: 2), to: 1)
        
        // Verify the final state of the now playing
        let songsInNowPlaying = player.songsInNowPlaying!
        XCTAssertEqual(songsInNowPlaying, [songs[0], songs[2], songs[1]])
    }
    
    func testRearrangeNowPlaying2() throws {
        // Add songs to now playing
        player.addToNowPlaying(song: songs[0])
        player.addToNowPlaying(song: songs[1])
        player.addToNowPlaying(song: songs[2])
        
        // Go to next song 0, 1, 2 ---> 1, 2, 0
        player.nextTrack()
        
        // Rearrange now playing 1, 2, 0 ---> 1, 0, 2
        player.rearrangeNowPlaying(from: IndexSet(integer: 2), to: 1)
        
        // Verify the final state of the now playing
        let songsInNowPlaying = player.songsInNowPlaying!
        XCTAssertEqual(songsInNowPlaying, [songs[1], songs[0], songs[2]])
    }
    
}

