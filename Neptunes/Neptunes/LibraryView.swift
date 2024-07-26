//
//  LibraryView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2024-07-23.
//

import SwiftUI

struct LibraryView: View {
    @ObservedObject var viewModel: LibraryViewModel
    @State var listOfSongs: [Song]
    @State private var users = ["Glenn", "Malcolm", "Nicola", "Terri"]
    
    init(viewModel: LibraryViewModel, listOfSongs: [Song]) {
        self.viewModel = viewModel
        self.listOfSongs = listOfSongs
    }
    
    var nowPlaying: some View {
        if (viewModel.songsInNowPlaying != nil), !viewModel.songsInNowPlaying!.isEmpty {
            return AnyView(
                List {
                    Section(header: Text("Now Playing")
                        .font(.title3)
                        .fontWeight(.bold)
                    ) {
                        ForEach(viewModel.songsInNowPlaying!, id: \.id) { song in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(song.title)
                                        .font(.headline)
                                    Text(song.artist)
                                        .font(.subheadline)
                                }
                                Spacer()
                                menuButton(song: song)
                            }
                        }
                        .onMove(perform: viewModel.rearrangeNowPlaying)
                    }
                }
            )
        } else {
            return AnyView(EmptyView())
        }
    }
    
    var queue: some View {
        if (viewModel.songsInQueue != nil), !viewModel.songsInQueue!.isEmpty {
            return AnyView(
                List {
                    Section(header: Text("Queue")
                        .font(.title3)
                        .fontWeight(.bold)
                    ) {
                        ForEach(viewModel.songsInQueue!, id: \.id) { song in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(song.title)
                                        .font(.headline)
                                    Text(song.artist)
                                        .font(.subheadline)
                                }
                                Spacer()
                                menuButton(song: song)
                            }
                        }
                        .onMove(perform: viewModel.rearrangeQueue)
                    }
                }
            )
        } else {
            return AnyView(EmptyView())
        }
    }
    
    
    var songs: some View {
        List {
            Section(header: Text("Songs")
                .font(.title3)
                .fontWeight(.bold)
            ) {
                ForEach(listOfSongs, id: \.id) { song in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(song.title)
                                .font(.headline)
                            Text(song.artist)
                                .font(.subheadline)
                        }
                        Spacer()
                        menuButton(song: song)
                    }
                }
                .onMove(perform: rearrangeSongs)
            }
        }
    }
    
    
    func menuButton(song: Song) -> some View {
        Menu() {
            Button {
                viewModel.addToNowPlaying(song: song)
            } label: {
                Label("Add To Now Playing", systemImage: "text.line.last.and.arrowtriangle.forward")
            }
            Button {
                viewModel.addToQueue(song: song)
            } label: {
                Label("Add To Queue", systemImage: "text.badge.plus")
            }
        } label: {
            Image(systemName: "ellipsis")
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                nowPlaying
                queue
                songs
            }
            .toolbar {
                EditButton()
            }
        }
    }
    
    
    func rearrangeSongs(from source: IndexSet, to destination: Int) {
        listOfSongs.move(fromOffsets: source, toOffset: destination)
    }
    
}

