//
//  HeaderView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-07.
//

import SwiftUI

struct HeaderView: View {
    var headerURI: URL?
    var body: some View {
        if let headerURI = headerURI {
            GeometryReader { g in
                Image(imageURI: headerURI, default: "")
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

struct StickyHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
