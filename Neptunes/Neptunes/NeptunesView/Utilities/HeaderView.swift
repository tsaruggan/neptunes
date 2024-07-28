//
//  HeaderView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-17.
//

import SwiftUI

struct HeaderView: View {
    var headerArtwork: Data?
    var body: some View {
        if headerArtwork != nil {
            GeometryReader { g in
                Image(data: headerArtwork, fallback: "")
                    .resizable()
                    .scaledToFill()
                    .offset(y: g.frame(in: .global).minY > 0 ? -g.frame(in: .global).minY : 0)
                    .frame(width: UIScreen.main.bounds.width,
                           height: g.frame(in: .global).minY > 0 ?
                           UIScreen.main.bounds.width / 3 + g.frame(in: .global).minY
                           : UIScreen.main.bounds.width / 3)
            }
            .frame(height: UIScreen.main.bounds.width / 3, alignment: .center)
        }
    }
}
