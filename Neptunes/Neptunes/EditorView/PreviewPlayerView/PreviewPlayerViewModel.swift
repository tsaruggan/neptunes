import Foundation
import AVFoundation

final class PreviewPlayerViewModel: ObservableObject {
    var fileManager: LocalFileManager = LocalFileManager.shared
    
    var audioPlayer: AVPlayer?
    @Published var isPlaying: Bool = false
    @Published var playbackProgress: Double = 0.0
    @Published var url: URL?
    
    private var timeObserverToken: Any?
    private var progressObserverToken: Any?
    
    init(url: URL?) {
        self.url = url
    }
    
    func togglePlay() {
        if audioPlayer == nil {
            guard let songURL = url else { return }
            let temp = fileManager.saveSongTemp(url: songURL)
            audioPlayer = AVPlayer(url: temp!)
            
            // Add observers for playback end and progress
            addEndObserver()
            addProgressObserver()
        }
        
        guard let player = audioPlayer else { return }
        
        if player.rate != 0 {
            // Pause and reset playback
            player.pause()
            player.seek(to: CMTime.zero)
            isPlaying = false
            playbackProgress = 0.0
            
            // Remove progress observer to avoid unnecessary updates
            removeProgressObserver()
        } else {
            // Start playback
            player.play()
            isPlaying = true
            
            // Re-add progress observer to track progress
            addProgressObserver()
        }
    }
    
    private func addEndObserver() {
        // Remove existing observer if any
        if let token = timeObserverToken {
            audioPlayer?.removeTimeObserver(token)
            timeObserverToken = nil
        }
        
        // Add observer for playback end
        timeObserverToken = audioPlayer?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: .main) { [weak self] time in
            guard let self = self, let player = self.audioPlayer else { return }
            let duration = player.currentItem?.duration ?? CMTime.zero
            
            if CMTimeGetSeconds(time) >= CMTimeGetSeconds(duration) {
                // Add a slight delay before handling playback end to avoid state issues
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.handlePlaybackEnd()
                }
            }
        }
    }
    
    private func addProgressObserver() {
        // Remove existing observer if any
        if let token = progressObserverToken {
            audioPlayer?.removeTimeObserver(token)
            progressObserverToken = nil
        }
        
        // Add observer for playback progress
        progressObserverToken = audioPlayer?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: .main) { [weak self] time in
            guard let self = self, let player = self.audioPlayer else { return }
            let duration = player.currentItem?.duration ?? CMTime.zero
            
            let currentTime = CMTimeGetSeconds(time)
            let totalDuration = CMTimeGetSeconds(duration)
            
            // Clamp playbackProgress to the range of 0.0 to 1.0
            self.playbackProgress = totalDuration > 0 ? min(max(currentTime / totalDuration, 0.0), 1.0) : 0.0
        }
    }
    
    private func removeProgressObserver() {
        if let token = progressObserverToken {
            audioPlayer?.removeTimeObserver(token)
            progressObserverToken = nil
        }
    }
    
    private func handlePlaybackEnd() {
        guard let player = audioPlayer else { return }
        
        // Reset to the start and terminate playback
        player.seek(to: CMTime.zero)
        player.pause()
        isPlaying = false
        
        // Remove and re-add end observer
        if let token = timeObserverToken {
            player.removeTimeObserver(token)
            timeObserverToken = nil
        }
        
        addEndObserver()  // Re-add observer to detect the next end of playback
    }
}
