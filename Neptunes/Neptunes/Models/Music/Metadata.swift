//
//  Metadata.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-02.
//

import Foundation
import AVFoundation

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
