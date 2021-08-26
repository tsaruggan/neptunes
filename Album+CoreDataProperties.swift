//
//  Album+CoreDataProperties.swift
//  Album
//
//  Created by Saruggan Thiruchelvan on 2021-08-25.
//
//

import Foundation
import CoreData


extension Album {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Album> {
        return NSFetchRequest<Album>(entityName: "Album")
    }

    @NSManaged public var artwork: String?
    @NSManaged public var header: String?
    @NSManaged public var isSingle: Bool
    @NSManaged public var title: String?
    @NSManaged public var songs: NSSet?
    @NSManaged public var artist: Artist?

}

// MARK: Generated accessors for songs
extension Album {

    @objc(addSongsObject:)
    @NSManaged public func addToSongs(_ value: Song)

    @objc(removeSongsObject:)
    @NSManaged public func removeFromSongs(_ value: Song)

    @objc(addSongs:)
    @NSManaged public func addToSongs(_ values: NSSet)

    @objc(removeSongs:)
    @NSManaged public func removeFromSongs(_ values: NSSet)

}

extension Album : Identifiable, Findable {
    var date: Date? {
        return nil
    }
    

}
