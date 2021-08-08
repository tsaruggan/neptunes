//
//  PlayerViewModel.swift
//  PlayerViewModel
//
//  Created by Saruggan Thiruchelvan on 2021-08-07.
//

import Foundation
import AVFoundation

final class PlayerViewModel: ObservableObject {
    @Published var song: Song
    @Published var duration: Int = 100
    @Published var percentage: CGFloat = 0.5
    @Published var isPlaying: Bool = false
    @Published var palette: Palette
    
    init(song: Song) {
        self.song = song
//        self.palette = ColorAnalyzer.generatePalette(artwork: song.artwork, header: song.header)
        self.palette = Palette()
    }
    
    func playPause() {
        isPlaying.toggle()
    }
}
