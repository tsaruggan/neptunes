//
//  ContentView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-03-27.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Song.title, ascending: true)],
        animation: .default)
    private var songs: FetchedResults<Song>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(songs) { song in
                    VStack {
                        Text(song.title!)
                        Image(uiImage: UIImage(data: song.album!.coverArtwork!)!)
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
