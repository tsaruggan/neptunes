//
//  FinderView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-08-01.
//

import SwiftUI

struct FinderView<FinderItemView: View>: View {
    let title: String
    private let _findables: [Findable]
    let finderItem: (Findable) -> FinderItemView
    
    @State var searchText = ""
    
    init(title: String, findables: [Findable], @ViewBuilder finderItem: @escaping (Findable) -> FinderItemView) {
        self.title = title
        self._findables = findables
        self.finderItem = finderItem
        
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(findables, id: \.self.title) { findable in
                    finderItem(findable)
                    Divider()
                }
                Spacer()
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
        .padding()
    }
    
    var findables: [Findable] {
        let findables = _findables.sorted { $0.title < $1.title }
        if searchText.isEmpty {
            return findables
        } else {
            return findables.filter {
                $0.title.letters.caseInsensitiveContains(searchText.letters)
            }
        }
    }
}

struct FinderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FinderView(title: "Albums", findables: MusicModel().albums) { findable in
                if let album = findable as? Album {
                    AlbumFinderItemView(album: album)
                }
            }
        }
    }
}

extension StringProtocol {
    func caseInsensitiveContains<S: StringProtocol>(_ string: S) -> Bool { range(of: string, options: .caseInsensitive) != nil }
}

extension StringProtocol where Self: RangeReplaceableCollection {
    var letters: Self { filter(\.isLetter) }
}
