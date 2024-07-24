import Combine

final class LibraryViewModel: ObservableObject {
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
    
    var songsInNowPlaying: [Song]? {
        return player.songsInNowPlaying
    }
    
    var songsInQueue: [Song]? {
        return player.songInQueue
    }
    
    func addToQueue(song: Song) {
        player.addToQueue(song: song)
    }
    
    func addToNowPlaying(song: Song) {
        player.addToNowPlaying(song: song)
    }
}
