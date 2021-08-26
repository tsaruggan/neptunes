//
//  Collectable.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-07.
//

import Foundation

protocol Collectable: Viewable {

}

struct CollectableWrapper: Identifiable {
    let id = UUID()
    let collectable: Collectable
    
    init(_ collectable: Collectable) {
        self.collectable = collectable
    }
}
