//
//  PlayerTests.swift
//  NeptunesTests
//
//  Created by Saruggan Thiruchelvan on 2024-07-25.
//

import XCTest
import AVFoundation
import MediaPlayer
@testable import Neptunes

final class PlayerTests: XCTestCase {
    
    var songs: [Song]!
    var player: Player!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // Initialize songs
        let song1 = Song(title: "Not Around", filename: "song1", artist: "Drake", album: "Certified Lover Boy")
        let song2 = Song(title: "Hell of a Night", filename: "song2", artist: "Travis Scott", album: "Owl Pharoah")
        let song3 = Song(title: "Wither", filename: "song3", artist: "Frank Ocean", album: "Endless")
        let song4 = Song(title: "Rushes", filename: "song4", artist: "Frank Ocean", album: "Endless")
        let song5 = Song(title: "Cancun", filename: "song5", artist: "Playboi Carti", album: "Cancun")
        songs = [song1, song2, song3, song4, song5]
        
        // Ensure ConfigModel is not already initialized
        ConfigModel.resetSharedInstance()
        guard ConfigModel.shared == nil else { fatalError("ConfigModel must be a singleton") }
        ConfigModel(nowPlayableBehavior: IOSNowPlayableBehavior())
        
        // Initialize player
        try player = Player()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        ConfigModel.resetSharedInstance()
    }
    
    func checkCurrentSongAlignment(expectedSong: Song) {
        let currentSong = player.currentSong
        let currentPlayerItem = player.currentPlayerItem
        let currentStaticMetadata = player.currentMetadata
        
        // Retrieve the URL and asset for the expected song
        let url = LocalFileManager().retrieveSong(song: expectedSong)!
        let assetURL = AVURLAsset(url: url)
        
        // Check if the current song matches the expected song
        XCTAssertEqual(currentSong, expectedSong)
        
        // Check if the current player item corresponds to the asset URL
        XCTAssertEqual((currentPlayerItem?.asset as? AVURLAsset)?.url, assetURL.url)
        
        // Check if the current metadata's asset URL matches the expected asset URL
        XCTAssertEqual(currentStaticMetadata?.assetURL, assetURL.url)
        
        // Additional checks to ensure metadata correctness
        XCTAssertEqual(currentStaticMetadata?.title, expectedSong.title)
        XCTAssertEqual(currentStaticMetadata?.artist, expectedSong.artist)
        XCTAssertEqual(currentStaticMetadata?.albumTitle, expectedSong.album)
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
        player.replaceNowPlaying(songs: songs, from: 0)
        
        // Add the first song to now playing
        player.addToNowPlaying(song: songs.last!)
        
        // Check current song alignment
        checkCurrentSongAlignment(expectedSong: songs[0])
        
        // Go to previous track
        player.previousTrack()
        
        // Check current song alignment
        checkCurrentSongAlignment(expectedSong: songs.last!)
    }
}

