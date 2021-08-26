//
//  Playlist+CoreDataProperties.swift
//  Playlist
//
//  Created by Saruggan Thiruchelvan on 2021-08-25.
//
//

import Foundation
import CoreData


extension Playlist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Playlist> {
        return NSFetchRequest<Playlist>(entityName: "Playlist")
    }

    @NSManaged public var title: String?
    @NSManaged public var artwork: String?
    @NSManaged public var header: String?
    @NSManaged public var songs: NSSet?

}

// MARK: Generated accessors for songs
extension Playlist {

    @objc(addSongsObject:)
    @NSManaged public func addToSongs(_ value: Song)

    @objc(removeSongsObject:)
    @NSManaged public func removeFromSongs(_ value: Song)

    @objc(addSongs:)
    @NSManaged public func addToSongs(_ values: NSSet)

    @objc(removeSongs:)
    @NSManaged public func removeFromSongs(_ values: NSSet)

}

extension Playlist : Identifiable, Findable {
    var date: Date? {
        return nil
    }
    

}
