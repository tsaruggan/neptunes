import Foundation
import AVFoundation

final class PreviewPlayerViewModel: ObservableObject {
    var fileManager: LocalFileManager = LocalFileManager()
    
    @Published var audioPlayer: AVPlayer?
    @Published var isPlaying: Bool = false
    @Published var playbackProgress: Double = 0.0
    
    private var timeObserverToken: Any?
    
    init(url: URL?) {
        if let songURL = url {
            let temp = fileManager.saveSongTemp(url: songURL)
            audioPlayer = AVPlayer(url: temp!)
            setupPlaybackObserver()
        }
    }
    
    func togglePlay() {
        guard let player = audioPlayer else { return }
        
        if player.rate != 0 {
            player.pause()
            isPlaying = false
            player.seek(to: CMTime(seconds: 0, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
        } else {
            player.play()
            isPlaying = true
        }
    }
    
    private func setupPlaybackObserver() {
        guard let player = audioPlayer else { return }
        
        // Add periodic time observer
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC)),
                                                           queue: .main) { [weak self] _ in
            self?.updatePlaybackProgress()
        }
    }
    
    private func updatePlaybackProgress() {
        guard let player = audioPlayer else { return }
        
        let currentTime = player.currentTime().seconds
        let duration = player.currentItem?.duration.seconds ?? 1.0
        playbackProgress = duration > 0 ? currentTime / duration : 0.0
    }
    
    deinit {
        if let token = timeObserverToken {
            audioPlayer?.removeTimeObserver(token)
        }
    }
}
