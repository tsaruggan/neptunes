//
//  Artist.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-07.
//

import Foundation

struct Artist: Sortable, Viewable {
    var title: String
    var date: Date = Date()
    var artwork: String?
    var header: String?
    var id: String { return title }
}
