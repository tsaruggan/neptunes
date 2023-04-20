//
//  ArtistViewModel.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-20.
//

import Foundation
import UIKit
import SwiftUI

final class ArtistViewModel: ObservableObject {
    @Published var artist: Artist
    
    init(artist: Artist) {
        self.artist = artist
    }
}
