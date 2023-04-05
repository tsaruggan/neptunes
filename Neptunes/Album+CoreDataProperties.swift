//
//  Album+CoreDataProperties.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-05.
//
//

import Foundation
import CoreData


extension Album {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Album> {
        return NSFetchRequest<Album>(entityName: "Album")
    }

    @NSManaged public var coverArtwork: Data?
    @NSManaged public var headerArtwork: Data?
    @NSManaged public var title: String
    @NSManaged public var artist: Artist
    @NSManaged public var songs: [Song]

}

extension Album : Identifiable {

}
