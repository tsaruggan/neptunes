//
//  Song+CoreDataClass.swift
//  Song
//
//  Created by Saruggan Thiruchelvan on 2021-08-28.
//
//

import Foundation
import CoreData

@objc(Song)
public class Song: NSManagedObject, Findable {
    var artworkURI: URL? {
        return album.artworkURI
    }
}
