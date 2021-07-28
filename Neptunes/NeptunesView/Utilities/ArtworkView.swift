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
    var isCircle: Bool = false
    var body: some View {
        if isCircle {
            Image(artwork)
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .padding(.horizontal, paddingHorizontal)
                .padding(.bottom, paddingBottom)
        } else {
            Image(artwork)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.horizontal, paddingHorizontal)
                .padding(.bottom, paddingBottom)
        }
    }
}
