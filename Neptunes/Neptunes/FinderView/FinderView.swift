//
//  FinderView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-08-01.
//

import SwiftUI

struct FinderView<FinderItemView: View>: View {
    @EnvironmentObject var player: Player
    let title: String
    private let _findables: [Findable]
    let finderItem: (Findable) -> FinderItemView
    
    @State var searchText = ""
    
    init(title: String, findables: [Findable], @ViewBuilder finderItem: @escaping (Findable) -> FinderItemView) {
        self.title = title
        self._findables = findables
        self.finderItem = finderItem
    }
    
    func isPlayerCurrentlyVisible() -> Bool {
        return player.currentSong != nil
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
            .padding(.bottom, isPlayerCurrentlyVisible() ? 80 : 0)
        }
        .scrollIndicators(.never)
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

extension StringProtocol {
    func caseInsensitiveContains<S: StringProtocol>(_ string: S) -> Bool { range(of: string, options: .caseInsensitive) != nil }
}

extension StringProtocol where Self: RangeReplaceableCollection {
    var letters: Self { filter(\.isLetter) }
}
