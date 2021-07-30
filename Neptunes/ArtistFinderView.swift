//
//  ArtistFinderView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-30.
//

import SwiftUI

struct ArtistFinderView: View {
    @State var searchText = ""
    var artists: [Artist] = MusicModel().artists
    
    init() {
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    var body: some View {
            ScrollView{
                VStack {
                    ForEach(artists + artists + artists) { artist in
                        NavigationLink(destination: ArtistView(viewModel: .init(artist: artist))) {
                            HStack(spacing: 15) {
                                Image(artist.artwork ?? "default_album_art")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 48)
                                    .clipShape(Circle())
                                Text(artist.title)
                                    .bold()
                                Spacer()
                            }
                            .foregroundColor(.primary)
                            .padding(5)
                        }
                        Divider()
                    }
                    Spacer()
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                .navigationTitle("Artists")
                .navigationBarTitleDisplayMode(.inline)
            }
            .padding()
    }
}

struct ArtistFinderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArtistFinderView()
        }
    }
}
