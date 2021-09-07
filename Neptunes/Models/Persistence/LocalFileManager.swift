//
//  LocalFileManager.swift
//  LocalFileManager
//
//  Created by Saruggan Thiruchelvan on 2021-09-06.
//

import Foundation
import UIKit

final class LocalFileManager {
    let fileManager = FileManager.default
    let songsDirectory: URL
    let artworksDirectory: URL
    let headersDirectory: URL
    
    init() {
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        songsDirectory = documentsDirectory.appendingPathComponent("songs", isDirectory: true)
        artworksDirectory = documentsDirectory.appendingPathComponent("artworks", isDirectory: true)
        headersDirectory = documentsDirectory.appendingPathComponent("headers", isDirectory: true)
    }
    
    func saveAudio(file: String, id: UUID) -> URL? {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: file, ofType: "mp3")!))
            let audioURI = save(data: data, filename: "\(id.uuidString).mp3", directory: songsDirectory)
            return audioURI
        } catch {
            print("Error saving audio. \(error)")
            return nil
        }
    }
    
    func saveArtwork(file: String, id: UUID) -> URL? {
        do {
            let artwork = UIImage(named: file)
            guard let data = artwork?.jpegData(compressionQuality: 1.0) else { return nil }
            let imageURI = save(data: data, filename: "\(id.uuidString).jpeg", directory: artworksDirectory)
            return imageURI
        } catch {
            print("Error saving artwork. \(error)")
            return nil
        }
    }
    
    func saveHeader(file: String, id: UUID) -> URL? {
        do {
            let header = UIImage(named: file)
            guard let data = header?.jpegData(compressionQuality: 1.0) else { return nil }
            let imageURI = save(data: data, filename: "\(id.uuidString).jpeg", directory: headersDirectory)
            return imageURI
        } catch {
            print("Error saving header. \(error)")
            return nil
        }
    }
    
    func save(data: Data, filename: String, directory: URL) -> URL? {
        if !fileManager.fileExists(atPath: directory.path) {
            do {
                try fileManager.createDirectory(atPath: directory.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating directory \(directory). \(error)")
            }
        }
        
        do {
            let path = directory.appendingPathComponent(filename)
            try data.write(to: path)
            print("Success saving to \(path).")
            return path
        } catch {
            print("Error saving to path. \(error)")
            return nil
        }
    }
}
