//
//  AudioPlayer.swift
//  AudioPlayer
//
//  Created by Saruggan Thiruchelvan on 2021-08-09.
//

import Foundation
import AVFoundation

final class AudioPlayer: ObservableObject {
    @Published var audioPlayer: AVAudioPlayer
    init() {
        let sound = Bundle.main.path(forResource: "song1", ofType: "mp3")
        self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        self.audioPlayer.play()
    }
}
