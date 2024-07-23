//
//  ConfigAsset.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-05-07.
//

import Foundation
import AVFoundation

/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
`ConfigAsset` is a wrapper struct around an `AVURLAsset` and its metadata.
*/

struct ConfigAsset {
    
    // The `AVURLAsset` corresponding to an asset.
    
    let urlAsset: AVURLAsset
    
    var shouldPlay: Bool

    // Metadata properties of this asset.
    
    let metadata: NowPlayableStaticMetadata
    
    // Initialize a new asset.
    
    init(metadata: NowPlayableStaticMetadata) {
        
        self.urlAsset = AVURLAsset(url: metadata.assetURL)
        self.shouldPlay = true
        self.metadata = metadata
    }
    
}

