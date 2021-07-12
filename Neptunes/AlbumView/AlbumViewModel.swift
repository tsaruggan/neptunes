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
            primary: ColorTheme(light: .black, dark: .white),
            secondary: ColorTheme(light: .blue, dark: .teal),
            tertiary: ColorTheme(light: .green, dark: .mint),
            accent: ColorTheme(light: .indigo, dark: .purple),
            background: ColorTheme(light: .white, dark: .black)
        )
    }
}
