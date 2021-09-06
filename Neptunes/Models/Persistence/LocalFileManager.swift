//
//  LocalFileManager.swift
//  LocalFileManager
//
//  Created by Saruggan Thiruchelvan on 2021-09-06.
//

import Foundation

final class LocalFileManager {
    let songsDirectory: URL
    
    init() {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        songsDirectory = documentsDirectory.appendingPathComponent("songs", isDirectory: true)
        if !fileManager.fileExists(atPath: songsDirectory.path) {
            do {
                try fileManager.createDirectory(atPath: songsDirectory.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
        
    }

    func saveAudio(file: String, id: UUID) -> URL? {
        do {
            let path = songsDirectory.appendingPathComponent("\(id.uuidString).mp3")
            let data = try Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: file, ofType: "mp3")!))
            try data.write(to: path)
            print("Success saving to \(path).")
            return path
        } catch {
            print("Error saving to path. \(error)")
            return nil
        }
    }
}
