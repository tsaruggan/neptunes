//
//  Collectable.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-07.
//

import Foundation

protocol Collectable {
    var id: UUID { get set }
    var title: String { get set }
    var artworkURI: URL? { get set }
    var headerURI: URL? { get set }
}
