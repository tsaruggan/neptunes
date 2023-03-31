//
//  ContentView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-03-27.
//

import SwiftUI
import CoreData
import AVFoundation

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Song.title, ascending: true)],
        animation: .default)
    private var songs: FetchedResults<Song>
    
    var fileManager = LocalFileManager()
    var player: AVPlayer = AVPlayer()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(songs) { song in
                    VStack {
                        Text(song.title!)
                        Image(uiImage: UIImage(data: song.album!.coverArtwork!)!)
                    }
                    .onTapGesture {
                        let url = fileManager.getAudioURL(id: song.id!)
                        play(url: url!)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Song", systemImage: "plus")
                    }
                }
            }
        }
    }
    
    private func addItem() {
        // create Song from mp3 file
        Task {
            let filename = "01 Nikes"
            let url = Bundle.main.url(forResource: filename, withExtension: "mp3")!
            let metadata = await Metadata.getMetadata(for: url)
            
            let newArtist = Artist(context: viewContext)
            newArtist.title = metadata.artist
            
            let newAlbum = Album(context: viewContext)
            newAlbum.artist = newArtist
            newAlbum.coverArtwork = metadata.artwork
            
            let newSong = Song(context: viewContext)
            newSong.title = metadata.title
            newSong.album = newAlbum
            newSong.artist = newArtist
            newSong.id = UUID()
            
            fileManager.saveAudio(file: filename, id: newSong.id!)
            
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { songs[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func play(url: URL) {
        print("playing \(url)")
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

import Foundation
import UIKit

final class LocalFileManager {
    let fileManager = FileManager.default
    let songsDirectory: URL
    
    init() {
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        songsDirectory = documentsDirectory.appendingPathComponent("songs", isDirectory: true)
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
    
    func getAudioURL(id: UUID) -> URL? {
        let filename = "\(id.uuidString).mp3"
        let url = songsDirectory.appendingPathComponent(filename)
        return url
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
