//
//  ArtworkView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-17.
//

import SwiftUI
import Shiny

struct ArtworkView: View {
    var coverArtwork: Data?
    var paddingHorizontal: CGFloat = 80
    var paddingBottom: CGFloat = 20
    var isCircle: Bool = false
    var body: some View {
        Image(data: coverArtwork, fallback: isCircle ? "defaultartist" : "defaultcover")
            .resizable()
            .scaledToFit()
            .clipShape(isCircle ? AnyShape(Circle()) : AnyShape(RoundedRectangle(cornerRadius: 8)))
            .padding(.horizontal, paddingHorizontal)
            .padding(.bottom, paddingBottom)
    }
}
