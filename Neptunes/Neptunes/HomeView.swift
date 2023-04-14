//
//  HomeView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-05.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Song.title, ascending: true)],
        animation: .default)
    private var songs: FetchedResults<Song>
    
    @State private var presentingEditor = false
    @State private var presentingImporter = false
    @State private var currentMetadata = Metadata()
    
    var body: some View {
        
        List {
            ForEach(songs) { song in
                SongView(song: song)
            }
            .onDelete(perform: deleteItems)
        }
        .toolbar {
            ToolbarItem {
                Button {
                    presentingImporter = true
                } label: {
                    Label("Add Song", systemImage: "plus")
                }
            }
        }
        .fileImporter(isPresented: $presentingImporter, allowedContentTypes: [.mp3], onCompletion: { result in
            switch result {
            case .success(let url):
                Task {
                    currentMetadata = await Metadata.getMetadata(for: url)
                }
                presentingEditor = true
            case .failure(let error):
                print(error)
            }
        })
        .sheet(isPresented: $presentingEditor) {
            EditorView(viewModel: EditorViewModel(metadata: currentMetadata, viewContext: viewContext), presentingEditor: $presentingEditor)
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
