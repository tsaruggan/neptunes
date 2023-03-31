//
//  Persistence.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-03-27.
//

import CoreData
import AVFoundation

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Neptunes")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
}

struct Metadata {
    var title: String?
    var artist: String?
    var albumName: String?
    var artwork: Data?
    
    init(titleItem: AVMetadataItem?, artistItem: AVMetadataItem?, albumNameItem: AVMetadataItem?, artworkItem: AVMetadataItem?) async {
        do {
            title = try await titleItem?.load(.stringValue)
            artist = try await artistItem?.load(.stringValue)
            albumName = try await albumNameItem?.load(.stringValue)
            artwork = try await artworkItem?.load(.dataValue)
        } catch {
            print(error)
        }
    }
    
    static func getMetadata(for url: URL) async -> Metadata {
        let asset = AVAsset(url: url)
        var metadata = [AVMetadataItem]()
        do {
            metadata = try await asset.loadMetadata(for: .id3Metadata)
        } catch {
            print(error)
        }
        let titleItem = getMetadataItem(metadata: metadata, identifier: .commonIdentifierTitle)
        let artistItem = getMetadataItem(metadata: metadata, identifier: .commonIdentifierArtist)
        let albumNameItem = getMetadataItem(metadata: metadata, identifier: .commonIdentifierAlbumName)
        let artworkItem = getMetadataItem(metadata: metadata, identifier: .commonIdentifierArtwork)
        
        return await Metadata(titleItem: titleItem,
                              artistItem: artistItem,
                              albumNameItem: albumNameItem,
                              artworkItem: artworkItem)
    }
    
    static func getMetadataItem(metadata: [AVMetadataItem], identifier: AVMetadataIdentifier) -> AVMetadataItem? {
        return AVMetadataItem.metadataItems(from: metadata, filteredByIdentifier: identifier).first
    }
}
