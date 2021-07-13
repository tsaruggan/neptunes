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
        self.palette = Palette(
            primary: (light: .black, dark: .white),
            secondary: (light: .blue, dark: .teal),
            tertiary: (light: .green, dark: .mint),
            accent: (light: .indigo, dark: .purple),
            background: (light: .blue, dark: .blue)
        )
    }
}
