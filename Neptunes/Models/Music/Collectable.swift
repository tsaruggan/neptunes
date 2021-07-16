//
//  Collectable.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-07.
//

import Foundation

protocol Collectable: Sortable, Viewable {
    var songs: [Song] { get set }
    mutating func addSongs(_ songs: Song...)
}

struct CollectableWrapper: Identifiable {
    let id = UUID()
    let collectable: Collectable
    
    init(_ collectable: Collectable) {
        self.collectable = collectable
    }
}
