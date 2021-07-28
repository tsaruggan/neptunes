//
//  ArtistView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-28.
//

import SwiftUI

struct ArtistView: View {
    @ObservedObject private var viewModel: ArtistViewModel
    @Environment(\.colorScheme) var colorScheme

    init(viewModel: ArtistViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ArtistView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            NavigationView{
                ArtistView(viewModel: .init(artist: MusicModel().artists[1]))
            }
            .preferredColorScheme($0)
        }
    }
}
