//
//  AssetPlayer.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-05-20.
//

import AVFoundation
import MediaPlayer

class Player: ObservableObject {
    
    // Possible values of the `playerState` property.
    
    enum PlayerState {
        case stopped
        case playing
        case paused
    }
    
    // Possible values of the `shuffleState` property.
    
    enum ShuffleState {
        case shuffled
        case unshuffled
    }
    
    
    // Possible values of the `repeatState` property.
    
    enum RepeatState {
        case repeating
        case repeatingone
        case unrepeating
    }
    
    // The app-supplied object that provides `NowPlayable`-conformant behavior.
    
    unowned let nowPlayableBehavior: NowPlayable
    
    // The player actually being used for playback. An app may use any system-provided
    // player, or may play content in any way that is wishes, provided that it uses
    // the NowPlayable behavior correctly.
    
    @Published var player: AVPlayer
    
    // Current song
    
    @Published var currentSong: Song?
    
    // Duration
    
    var duration: TimeInterval {
        guard let currentItem = player.currentItem else { return 0.0 }
        return currentItem.duration.seconds
    }
    
    // Current time
    
    var currentTime: TimeInterval {
        get {
            return player.currentTime().seconds
        }
        set {
            player.seek(to: CMTime(seconds: newValue, preferredTimescale: 1))
        }
    }
    
    // A playlist of items to play.
    
    @Published public var playerItems: [AVPlayerItem?] = []
    
    // Metadata for each item.
    
    @Published public var staticMetadatas: [NowPlayableStaticMetadata?] = []
    
    // Now playing
    
    @Published var nowPlaying: NowPlaying = NowPlaying()
    @Published var nowPlayingIsReplaced: Bool = false
    var hasReachedEnd: Bool { return nowPlaying.hasReachedEnd }
    var songsInNowPlaying: [Song]? {
        guard let songs = nowPlaying.songsInNowPlaying else {
            return nil
        }
        
        if isPlayingFromQueue {
            if songs.isEmpty {
                return songs
            }
            
            // Shift the first element to the end
            var shiftedSongs = songs
            let firstSong = shiftedSongs.removeFirst()
            shiftedSongs.append(firstSong)
            return shiftedSongs
        } else {
            return songs
        }
    }
    
    
    // Queue
    
    @Published var queue: Queue = Queue()
    @Published var isPlayingFromQueue: Bool = false
    var songInQueue: [Song]? { return queue.songsInQueue }
    
    // The internal state of this Player separate from the state
    // of its AVPlayer.
    
    public var playerState: PlayerState = .stopped {
        didSet {
            NSLog("%@", "**** Set player state \(playerState)")
        }
    }
    var isPlaying: Bool {
        return playerState == .playing
    }
    
    // The shuffle state of this Player.
    
    public var shuffleState: ShuffleState = .unshuffled {
        
        didSet {
            NSLog("%@", "**** Set shuffle state \(shuffleState)")
            switch shuffleState {
            case .shuffled:
                nowPlaying.isShuffled = true
            case .unshuffled:
                nowPlaying.isShuffled = false
            }
        }
        
    }
    
    // The repeat state of this Player.
    
    public var repeatState: RepeatState = .unrepeating {
        didSet {
            NSLog("%@", "**** Set repeat state \(repeatState)")
        }
    }
    
    // `true` if the current session has been interrupted by another app.
    
    public var isInterrupted: Bool = false
    
    // Private observers of notifications and property changes.
    
    public var itemObserver: NSKeyValueObservation!
    public var rateObserver: NSKeyValueObservation!
    public var statusObserver: NSObjectProtocol!
    
    // A shorter name for a very long property name.
    
    public static let mediaSelectionKey = "availableMediaCharacteristicsWithMediaSelectionOptions"
    
    
    // This does something
    let assetKeys = ["playable"]
    
    
    // Initialize a new `Player` object.
    
    init() throws {
        self.nowPlayableBehavior = ConfigModel.shared.nowPlayableBehavior
        
        // Create a player, and configure it for external playback, if the
        // configuration requires.
        
        self.player = AVPlayer()
        player.allowsExternalPlayback = ConfigModel.shared.allowsExternalPlayback
        
        // Construct lists of commands to be registered or disabled.
        
        var registeredCommands = [] as [NowPlayableCommand]
        var disabledCommands = [] as [NowPlayableCommand]
        
        for group in ConfigModel.shared.commandCollections {
            registeredCommands.append(contentsOf: group.commands.compactMap { $0.shouldRegister ? $0.command : nil })
            disabledCommands.append(contentsOf: group.commands.compactMap { $0.shouldDisable ? $0.command : nil })
        }
        
        // Configure the app for Now Playing Info and Remote Command Center behaviors.
        
        try nowPlayableBehavior.handleNowPlayableConfiguration(commands: registeredCommands,
                                                               disabledCommands: disabledCommands,
                                                               commandHandler: handleCommand(command:event:),
                                                               interruptionHandler: handleInterrupt(with:))
        
        // Start a playback session.
        
        try nowPlayableBehavior.handleNowPlayableSessionStart()
        
        
        // Trigger notification if player item plays to end time
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func observeChanges() {
        if player.currentItem != nil {
            
            itemObserver = player.observe(\.currentItem, options: .initial) {
                [unowned self] _, _ in
                self.handlePlayerItemChange()
            }
            
            rateObserver = player.observe(\.rate, options: .initial) {
                [unowned self] _, _ in
                self.handlePlaybackChange()
            }
            
            statusObserver = player.observe(\.currentItem?.status, options: .initial) {
                [unowned self] _, _ in
                self.handlePlaybackChange()
            }
        }
    }
    
    // Stop the playback session.
    
    func optOut() {
        
        itemObserver = nil
        rateObserver = nil
        statusObserver = nil
        
        player.pause()
        
        playerState = .stopped
        
        nowPlayableBehavior.handleNowPlayableSessionEnd()
    }
    
    // MARK: Now Playing Info
    
    // Helper method: update Now Playing Info when the current item changes.
    
    public func handlePlayerItemChange() {
        
        guard playerState != .stopped else { return }
        
        // Find the current item.
        
        guard let currentItem = player.currentItem else { optOut(); return }
        guard let currentIndex = playerItems.firstIndex(where: { $0 == currentItem }) else { return }
        
        // Set the Now Playing Info from static item metadata.
        
        if let metadata = staticMetadatas[currentIndex] {
            nowPlayableBehavior.handleNowPlayableItemChange(metadata: metadata)
        }
    }
    
    // Helper method: update Now Playing Info when playback rate or position changes.
    
    public func handlePlaybackChange() {
        
        guard playerState != .stopped else { return }
        
        // Find the current item.
        
        guard let currentItem = player.currentItem else { optOut(); return }
        guard currentItem.status == .readyToPlay else { return }
        
        // Create language option groups for the asset's media selection,
        // and determine the current language option in each group, if any.
        
        // Note that this is a simple example of how to create language options.
        // More sophisticated behavior (including default values, and carrying
        // current values between player tracks) can be implemented by building
        // on the techniques shown here.
        
        let asset = currentItem.asset
        
        var languageOptionGroups: [MPNowPlayingInfoLanguageOptionGroup] = []
        var currentLanguageOptions: [MPNowPlayingInfoLanguageOption] = []
        
        if asset.statusOfValue(forKey: Player.mediaSelectionKey, error: nil) == .loaded {
            
            // Examine each media selection group.
            
            for mediaCharacteristic in asset.availableMediaCharacteristicsWithMediaSelectionOptions {
                guard mediaCharacteristic == .audible || mediaCharacteristic == .legible,
                      let mediaSelectionGroup = asset.mediaSelectionGroup(forMediaCharacteristic: mediaCharacteristic) else { continue }
                
                // Make a corresponding language option group.
                
                let languageOptionGroup = mediaSelectionGroup.makeNowPlayingInfoLanguageOptionGroup()
                languageOptionGroups.append(languageOptionGroup)
                
                // If the media selection group has a current selection,
                // create a corresponding language option.
                
                if let selectedMediaOption = currentItem.currentMediaSelection.selectedMediaOption(in: mediaSelectionGroup),
                   let currentLanguageOption = selectedMediaOption.makeNowPlayingInfoLanguageOption() {
                    currentLanguageOptions.append(currentLanguageOption)
                }
            }
        }
        
        // Construct the dynamic metadata, including language options for audio,
        // subtitle and closed caption tracks that can be enabled for the
        // current asset.
        
        let isPlaying = playerState == .playing
        let metadata = NowPlayableDynamicMetadata(rate: player.rate,
                                                  position: Float(currentItem.currentTime().seconds),
                                                  duration: Float(currentItem.duration.seconds),
                                                  currentLanguageOptions: currentLanguageOptions,
                                                  availableLanguageOptionGroups: languageOptionGroups)
        
        nowPlayableBehavior.handleNowPlayablePlaybackChange(playing: isPlaying, metadata: metadata)
    }
    
    // MARK: Playback Control
    
    // The following methods handle various playback conditions triggered by remote commands.
    
    public func play() {
        
        switch playerState {
            
        case .stopped:
            playerState = .playing
            player.play()
            
        case .playing:
            break
            
        case .paused where isInterrupted:
            playerState = .playing
            
        case .paused:
            playerState = .playing
            player.play()
        }
        
        handlePlaybackChange()
    }
    
    public func pause() {
        
        switch playerState {
            
        case .stopped:
            break
            
        case .playing where isInterrupted:
            playerState = .paused
            
        case .playing:
            playerState = .paused
            player.pause()
            
        case .paused:
            break
        }
        
        handlePlaybackChange()
    }
    
    public func togglePlayPause() {
        
        switch playerState {
            
        case .stopped:
            play()
            
        case .playing:
            pause()
            
        case .paused:
            play()
        }
        
    }
    
    public func nextTrack() {
        currentTime = 0.0
        if nowPlaying.isEmpty && queue.isEmpty {
            currentSong = nil
            isPlayingFromQueue = false
            optOut()
        } else if queue.isEmpty {
            nowPlaying.goToNext()
            replaceCurrent(song: nowPlaying.currentSong,
                           playerItem: nowPlaying.currentPlayerItem,
                           staticMetadata: nowPlaying.currentStaticMetadata)
            play()
            isPlayingFromQueue = false
        } else {
            replaceCurrent(song: queue.currentSong,
                           playerItem: queue.currentPlayerItem,
                           staticMetadata: queue.currentStaticMetadata)
            play()
            queue.goToNext()
            isPlayingFromQueue = true
        }
        
        handlePlayerItemChange()
        seek(to: 0)
    }
    
    public func next() {
        if nowPlaying.hasReachedEnd && repeatState != .repeating {
            nextTrack()
            pause()
        } else {
            nextTrack()
        }
        
        if repeatState == .repeatingone {
            repeatState = .repeating
        }
    }
    
    public func previousTrack() {
        currentTime = 0.0
        if nowPlaying.isEmpty {
            currentSong = nil
            optOut()
        } else {
            if isPlayingFromQueue {
                isPlayingFromQueue = false
            } else {
                nowPlaying.goToPrevious()
            }
            replaceCurrent(song: nowPlaying.currentSong,
                           playerItem: nowPlaying.currentPlayerItem,
                           staticMetadata: nowPlaying.currentStaticMetadata)
            play()
        }
        handlePlayerItemChange()
        seek(to: 0)
    }
    
    public func previous() {
        if currentTime < 5.0 {
            previousTrack()
            if repeatState == .repeatingone {
                repeatState = .repeating
            }
        } else {
            seek(to: 0.0)
        }
    }
    
    public func seek(to time: CMTime) {
        
        if case .stopped = playerState { return }
        
        player.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero) {
            isFinished in
            if isFinished {
                self.handlePlaybackChange()
            }
        }
    }
    
    public func seek(to position: TimeInterval) {
        seek(to: CMTime(seconds: position, preferredTimescale: Int32(NSEC_PER_SEC)))
    }
    
    public func skipForward(by interval: TimeInterval) {
        seek(to: player.currentTime() + CMTime(seconds: interval, preferredTimescale: Int32(NSEC_PER_SEC)))
    }
    
    public func skipBackward(by interval: TimeInterval) {
        seek(to: player.currentTime() - CMTime(seconds: interval, preferredTimescale: Int32(NSEC_PER_SEC)))
    }
    
    public func setPlaybackRate(_ rate: Float) {
        
        if case .stopped = playerState { return }
        
        player.rate = rate
    }
    
    public func didEnableLanguageOption(_ languageOption: MPNowPlayingInfoLanguageOption) -> Bool {
        
        guard let currentItem = player.currentItem else { return false }
        guard let (mediaSelectionOption, mediaSelectionGroup) = enabledMediaSelection(for: languageOption) else { return false }
        
        currentItem.select(mediaSelectionOption, in: mediaSelectionGroup)
        handlePlaybackChange()
        
        return true
    }
    
    public func didDisableLanguageOption(_ languageOption: MPNowPlayingInfoLanguageOption) -> Bool {
        
        guard let currentItem = player.currentItem else { return false }
        guard let mediaSelectionGroup = disabledMediaSelection(for: languageOption) else { return false }
        
        guard mediaSelectionGroup.allowsEmptySelection else { return false }
        currentItem.select(nil, in: mediaSelectionGroup)
        handlePlaybackChange()
        
        return true
    }
    
    // Helper method to get the media selection group and media selection for enabling a language option.
    
    public func enabledMediaSelection(for languageOption: MPNowPlayingInfoLanguageOption) -> (AVMediaSelectionOption, AVMediaSelectionGroup)? {
        
        // In your code, you would implement your logic for choosing a media selection option
        // from a suitable media selection group.
        
        // Note that, when the current track is being played remotely via AirPlay, the language option
        // may not exactly match an option in your local asset's media selection. You may need to consider
        // an approximate comparison algorithm to determine the nearest match.
        
        // If you cannot find an exact or approximate match, you should return `nil` to ignore the
        // enable command.
        
        return nil
    }
    
    // Helper method to get the media selection group for disabling a language option`.
    
    public func disabledMediaSelection(for languageOption: MPNowPlayingInfoLanguageOption) -> AVMediaSelectionGroup? {
        
        // In your code, you would implement your logic for finding the media selection group
        // being disabled.
        
        // Note that, when the current track is being played remotely via AirPlay, the language option
        // may not exactly determine a media selection group in your local asset. You may need to consider
        // an approximate comparison algorithm to determine the nearest match.
        
        // If you cannot find an exact or approximate match, you should return `nil` to ignore the
        // disable command.
        
        return nil
    }
    
    // MARK: Remote Commands
    
    // Handle a command registered with the Remote Command Center.
    
    public func handleCommand(command: NowPlayableCommand, event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        
        switch command {
            
        case .pause:
            pause()
            
        case .play:
            play()
            
        case .stop:
            optOut()
            
        case .togglePausePlay:
            togglePlayPause()
            
        case .nextTrack:
            next()
            
        case .previousTrack:
            previous()
            
        case .changePlaybackRate:
            guard let event = event as? MPChangePlaybackRateCommandEvent else { return .commandFailed }
            setPlaybackRate(event.playbackRate)
            
        case .seekBackward:
            guard let event = event as? MPSeekCommandEvent else { return .commandFailed }
            setPlaybackRate(event.type == .beginSeeking ? -3.0 : 1.0)
            
        case .seekForward:
            guard let event = event as? MPSeekCommandEvent else { return .commandFailed }
            setPlaybackRate(event.type == .beginSeeking ? 3.0 : 1.0)
            
        case .skipBackward:
            guard let event = event as? MPSkipIntervalCommandEvent else { return .commandFailed }
            skipBackward(by: event.interval)
            
        case .skipForward:
            guard let event = event as? MPSkipIntervalCommandEvent else { return .commandFailed }
            skipForward(by: event.interval)
            
        case .changePlaybackPosition:
            guard let event = event as? MPChangePlaybackPositionCommandEvent else { return .commandFailed }
            seek(to: event.positionTime)
            
        case .enableLanguageOption:
            guard let event = event as? MPChangeLanguageOptionCommandEvent else { return .commandFailed }
            guard didEnableLanguageOption(event.languageOption) else { return .noActionableNowPlayingItem }
            
        case .disableLanguageOption:
            guard let event = event as? MPChangeLanguageOptionCommandEvent else { return .commandFailed }
            guard didDisableLanguageOption(event.languageOption) else { return .noActionableNowPlayingItem }
            
        default:
            break
        }
        
        return .success
    }
    
    // MARK: Interruptions
    
    // Handle a session interruption.
    
    public func handleInterrupt(with interruption: NowPlayableInterruption) {
        
        switch interruption {
            
        case .began:
            isInterrupted = true
            
        case .ended(let shouldPlay):
            isInterrupted = false
            
            switch playerState {
                
            case .stopped:
                break
                
            case .playing where shouldPlay:
                player.play()
                
            case .playing:
                playerState = .paused
                
            case .paused:
                break
            }
            
        case .failed(let error):
            print(error.localizedDescription)
            optOut()
        }
    }
    
    func replaceNowPlaying(songs: [Song], from: Int) {
        nowPlaying = NowPlaying(songs: songs, from: from)
        nowPlaying.isShuffled = shuffleState == .shuffled
        replaceCurrent(song: nowPlaying.currentSong,
                       playerItem: nowPlaying.currentPlayerItem,
                       staticMetadata: nowPlaying.currentStaticMetadata)
        nowPlayingIsReplaced = true
        
        play()
        seek(to: 0.0)
        handlePlayerItemChange()
    }
    
    func replaceCurrent(song: Song?, playerItem: AVPlayerItem?, staticMetadata: NowPlayableStaticMetadata?) {
        currentSong = song
        playerItems.append(playerItem)
        staticMetadatas.append(staticMetadata)
        player.replaceCurrentItem(with: playerItem)
        observeChanges()
        optOut()
    }
    
    func addToQueue(song: Song) {
        queue.add(song: song)
    }
    
    func addToNowPlaying(song: Song) {
        nowPlaying.add(song: song)
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        pause()
        if repeatState == .repeatingone {
            seek(to: 0.0)
            play()
        } else if nowPlaying.hasReachedEnd {
            if repeatState == .repeating {
                next()
                play()
            } else {
                next()
                pause()
            }
        } else {
            next()
        }
    }
    
}



