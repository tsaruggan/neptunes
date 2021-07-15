//
//  ArtworkView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-15.
//

import SwiftUI

struct ArtworkView: View {
    var artwork: String
    var paddingHorizontal: CGFloat = 80
    var paddingBottom: CGFloat = 20
    var body: some View {
        Image(artwork)
            .resizable()
            .scaledToFit()
            .cornerRadius(8)
            .padding(.horizontal, paddingHorizontal)
            .padding(.bottom, paddingBottom)
    }
}
