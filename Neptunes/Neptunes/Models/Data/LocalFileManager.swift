//
//  LocalFileManager.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-02.
//

import Foundation

final class LocalFileManager {
    let fileManager = FileManager.default
    let songsDirectory: URL
    
    init() {
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        songsDirectory = documentsDirectory.appendingPathComponent("songs", isDirectory: true)
    }
    
    func saveSong(filename: String, song: Song) {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: filename, ofType: "mp3")!))
            save(data: data, filename: "\(song.id!.uuidString).mp3", directory: songsDirectory)
        } catch {
            print("Error saving audio. \(error)")
        }
    }
    
    func retrieveSong(song: Song) -> URL? {
        let filename = "\(song.id!.uuidString).mp3"
        let url = songsDirectory.appendingPathComponent(filename)
        return url
    }
        
    func save(data: Data, filename: String, directory: URL) {
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
        } catch {
            print("Error saving to path. \(error)")
        }
    }
}
