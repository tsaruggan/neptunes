//
//  ArtistViewModel.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-28.
//

import Foundation
import UIKit
import SwiftUI

final class ArtistViewModel: ObservableObject {
    @Published var artist: Artist
    @Published var palette: Palette
    
    init(artist: Artist) {
        self.artist = artist
        self.palette = ColorAnalyzer.generatePalette(artwork: "travis_scott_artist_art", header: "travis_scott_header_art")
//        self.palette = Palette()
    }
}
