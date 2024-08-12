import Combine
import Foundation
import MediaPlayer
import CoreData

final class UpcomingSongsViewModel: ObservableObject {
    @Published var player: Player
    private var subscriptions = Set<AnyCancellable>()
    
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
    
    var isPlaying: Bool {
        return player.isPlaying
    }
    
    var isPlayingFromQueue: Bool {
        return player.isPlayingFromQueue
    }
    
    var currentSong: Song? {
        return player.currentSong
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
