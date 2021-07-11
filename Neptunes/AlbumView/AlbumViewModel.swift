//
//  AlbumViewModel.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-07.
//

import Foundation
import UIKit

final class AlbumViewModel: ObservableObject {
    @Published var album: Album
    @Published var backgroundColor: UIColor
    @Published var colors: [UIColor]
    
    init(album: Album) {
        self.album = album
//        self.backgroundColor = .green
        let image = UIImage(named: album.image)
        let colors = getColorsFromAlbumArt(uiImage: image!)
        self.backgroundColor = colors[1]
        self.colors = colors
    }
    
    func setBackgroundColor() {
//        let image = UIImage(named: album!.image)
//        let colors = getColorsFromAlbumArt(uiImage: image!)
//        backgroundColor = colors[0]
        backgroundColor = UIColor.green
    }
}
