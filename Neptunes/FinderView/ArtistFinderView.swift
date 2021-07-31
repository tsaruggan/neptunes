//
//  ArtistFinderView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-30.
//

import SwiftUI

struct ArtistFinderView: View {
    @State var searchText = ""
    
    init() {
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    var body: some View {
            ScrollView{
                VStack {
                    ForEach(artists) { artist in
                        ArtistFinderItemView(artist: artist)
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
    
    var artists: [Artist] {
        let artists = MusicModel().artists.sorted { $0.title < $1.title }
        if searchText.isEmpty {
            return artists
        } else {
            return artists.filter{
                $0.title.letters.caseInsensitiveContains(searchText.letters)
            }
        }
    }
}

struct ArtistFinderItemView: View {
    var artist: Artist
    var body: some View {
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
        .isDetailLink(false)
    }
}

struct ArtistFinderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArtistFinderView()
        }
    }
}


extension StringProtocol {
    func caseInsensitiveContains<S: StringProtocol>(_ string: S) -> Bool { range(of: string, options: .caseInsensitive) != nil }
}

extension StringProtocol where Self: RangeReplaceableCollection {
    var letters: Self { filter(\.isLetter) }
}
