//
//  AlbumViewModel.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-07.
//

import Foundation
import UIKit

final class AlbumViewModel: ObservableObject {
    @Published var album: Album?
    @Published var backgroundColor: UIColor?
    
    func setBackgroundColor() {
//        let image = UIImage(named: album!.image)
//        let colors = getColorsFromAlbumArt(uiImage: image!)
//        backgroundColor = colors[0]
        backgroundColor = UIColor.green
    }
}
