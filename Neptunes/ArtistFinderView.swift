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
    
    var artists: [Artist] {
        let artists = MusicModel().artists.sorted { $0.title < $1.title }
        if searchText.isEmpty {
            return artists
        } else {
            return artists.filter{
                $0.title.containsCharactersInSequence(searchText, options: .caseInsensitive).result
            }
        }
    }
}

struct ArtistFinderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArtistFinderView()
        }
    }
}

extension StringProtocol where Self: RangeReplaceableCollection {
    func containsCharactersInSequence<S: StringProtocol>(_ string: S, options: String.CompareOptions = []) -> (result: Bool, ranges: [Range<Index>]) {
        var found = 0
        var startIndex = self.startIndex
        var index = string.startIndex
        var ranges: [Range<Index>] = []
        while index < string.endIndex,
            let range = self[startIndex...].range(of: string[index...index], options: options) {
            ranges.append(range)
            startIndex = range.upperBound
            string.formIndex(after: &index)
            found += 1
        }
        return (found == string.count, ranges)
    }
}

extension StringProtocol where Self: RangeReplaceableCollection {
    var letters: Self { filter(\.isLetter) }
}
