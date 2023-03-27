//
//  AlbumViewModel.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-07.
//

import Foundation
import UIKit
import SwiftUI

final class AlbumViewModel: ObservableObject {
    @Published var album: Album
    @Published var palette: Palette
    
    init(album: Album) {
        self.album = album
//        self.palette = ColorAnalyzer.generatePalette(artwork: "frank_ocean_album_art_2", header: "frank_ocean_header_art_2")
//        self.palette = album.palette
        self.palette = Palette()
    }
}
