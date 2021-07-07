//
//  Artist.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-07.
//

import Foundation

struct Artist: Sortable, Viewable, Identifiable {
    var title: String
    var date: Date = Date()
    var image: String = "default_artist_image"
    var header: String?
    var id: String { return title }
}
