import Combine
import Foundation
import MediaPlayer
import CoreData

final class LibraryViewModel: ObservableObject {
    @Published var player: Player
    private var subscriptions = Set<AnyCancellable>()
    
    let dataManager: CoreDataManager = CoreDataManager(viewContext: PersistenceController.shared.container.viewContext)
    let fileManager = LocalFileManager()
    
    init(player: Player) {
        self.player = player
        
        // Observe changes in player properties
        player.objectWillChange
            .sink { [weak self] in
                self?.objectWillChange.send()
            }
            .store(in: &subscriptions) // Updated name here
        
        // Observe changes in nowPlaying
        player.nowPlaying.objectWillChange
            .sink { [weak self] in
                self?.objectWillChange.send()
            }
            .store(in: &subscriptions) // Updated name here
        
        // Observe changes in queue
        player.queue.objectWillChange
            .sink { [weak self] in
                self?.objectWillChange.send()
            }
            .store(in: &subscriptions) // Updated name here
    }
    
    func initializeData() {
        // Add songs using CoreDataManager
        addSong(title: "Not Around", artistTitle: "Drake", albumTitle: "Certified Lover Boy", filename: "song1")
        addSong(title: "Hell of a Night", artistTitle: "Travis Scott", albumTitle: "Owl Pharoah", filename: "song2")
        addSong(title: "Wither", artistTitle: "Frank Ocean", albumTitle: "Endless", filename: "song3")
        addSong(title: "Rushes", artistTitle: "Frank Ocean", albumTitle: "Endless", filename: "song4")
        addSong(title: "Cancun", artistTitle: "Playboi Carti", albumTitle: "Cancun", filename: "song5")
    }
    
    private func addSong(title: String, artistTitle: String, albumTitle: String, filename: String) {
        var song = dataManager.initializeSong(title: title, id: UUID())
        var artist = dataManager.initializeArtist(title: artistTitle, coverArtwork: nil, headerArtwork: nil)
        var album = dataManager.initializeAlbum(title: albumTitle, coverArtwork: nil, headerArtwork: nil)
        
        album.artist = artist
        song.album = album
        song.artist = artist
        
        artist.addToSongs(song)
        album.addToSongs(song)
        artist.addToAlbums(album)
        
        // Save the song file
        fileManager.saveSongFromURL(url: URL(fileURLWithPath: "path/to/\(filename).mp3"), song: song)
        dataManager.saveData()
    }
    
    var songsInNowPlaying: [Song]? {
        if !player.isPlayingFromQueue {
            if var songs = player.songsInNowPlaying, !songs.isEmpty {
                // Hide the first song if now playing
                songs.removeFirst()
                return songs
            }
        }
        return player.songsInNowPlaying
    }
    
    var songsInQueue: [Song]? {
        return player.songsInQueue
    }
    
    func addToQueue(song: Song) {
        player.addToQueue(song: song)
    }
    
    func addToNowPlaying(song: Song) {
        player.addToNowPlaying(song: song)
    }
    
    func rearrangeQueue(from source: IndexSet, to destination: Int) {
        player.rearrangeQueue(from: source, to: destination)
    }
    
    func rearrangeNowPlaying(from source: IndexSet, to destination: Int) {
        var adjustedSource: IndexSet
        var adjustedDestination: Int
        
        // If isPlayingFromQueue is false, the first song is hidden
        if !player.isPlayingFromQueue {
            // Adjust the source and destination indices to account for the hidden first song
            adjustedSource = IndexSet(source.map { $0 + 1 })
            adjustedDestination = destination + 1
        } else {
            adjustedSource = source
            adjustedDestination = destination
        }
        player.rearrangeNowPlaying(from: adjustedSource, to: adjustedDestination)
    }
}
