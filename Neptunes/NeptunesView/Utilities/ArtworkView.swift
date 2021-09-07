//
//  ArtworkView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-15.
//

import SwiftUI

struct ArtworkView: View {
    var artworkURI: URL?
    var paddingHorizontal: CGFloat = 80
    var paddingBottom: CGFloat = 20
    var isCircle: Bool = false
    var body: some View {
        if isCircle {
            Image(imageURI: artworkURI, default: "default_album_art")
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .padding(.horizontal, paddingHorizontal)
                .padding(.bottom, paddingBottom)
            
        } else {
            Image(imageURI: artworkURI, default: "default_album_art")
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.horizontal, paddingHorizontal)
                .padding(.bottom, paddingBottom)
        }
    }
}


extension Image {
    public init(imageURI: URL?, default defaultImageAsset: String) {
        if let path = imageURI?.path,
           let image = UIImage(contentsOfFile: path) {
            self = Image(uiImage: image)
        } else {
            self = Image(defaultImageAsset)
        }
    }
}
