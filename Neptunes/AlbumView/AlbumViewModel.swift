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
    @Published var colors: [Color]
    
    init(album: Album) {
        self.album = album
        self.colors = ColorAnalyzer.getColors(albumArt: album.image, headerArt: album.header!, 3)
    }
}
