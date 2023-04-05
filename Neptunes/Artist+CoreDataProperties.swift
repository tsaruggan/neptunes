//
//  Artist+CoreDataProperties.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-05.
//
//

import Foundation
import CoreData


extension Artist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Artist> {
        return NSFetchRequest<Artist>(entityName: "Artist")
    }

    @NSManaged public var coverArtwork: Data?
    @NSManaged public var headerArtwork: Data?
    @NSManaged public var title: String
    @NSManaged public var albums: [Album]
    @NSManaged public var songs: [Song]

}

extension Artist : Identifiable {

}
