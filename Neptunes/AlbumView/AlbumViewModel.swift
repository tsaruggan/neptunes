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
    @Published var palette: Palette
    
    init(album: Album) {
        self.album = album
        self.colors = ColorAnalyzer.getColors(albumArt: album.image, headerArt: album.header!, 3)
        self.palette = Palette(
            primaryLight: .black,
            primaryDark: .white,
            secondaryLight: .purple,
            secondaryDark: .indigo,
            tertiaryLight: .teal,
            tertiaryDark: .blue,
            accentLight: .red,
            accentDark: .red,
            backgroundLight: .mint,
            backgroundDark: .green
        )
    }
}
