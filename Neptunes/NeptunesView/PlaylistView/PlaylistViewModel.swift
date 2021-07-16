//
//  PlaylistViewModel.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-15.
//

import Foundation
import UIKit
import SwiftUI

final class PlaylistViewModel: ObservableObject {
    @Published var playlist: Playlist
    @Published var palette: Palette
    
    init(playlist: Playlist) {
        self.playlist = playlist
        self.palette = ColorAnalyzer.generatePalette(artwork: playlist.artwork, header: playlist.header)
//        self.palette = Palette()
    }
}
