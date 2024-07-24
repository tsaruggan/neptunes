//
//  LibraryView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2024-07-23.
//

import SwiftUI

struct LibraryView: View {
    @ObservedObject var viewModel: LibraryViewModel
    var listOfSongs: [Song]
    
    init(viewModel: LibraryViewModel, listOfSongs: [Song]) {
        self.viewModel = viewModel
        self.listOfSongs = listOfSongs
    }
    
    var nowPlaying: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Now Playing")
                .font(.title3)
                .fontWeight(.bold)
            ForEach(viewModel.songsInNowPlaying ?? []) { song in
                HStack{
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
        }
        .padding()
    }
    
    var queue: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Queue")
                .font(.title3)
                .fontWeight(.bold)
            ForEach(viewModel.songsInQueue ?? []) { song in
                HStack{
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
        }
        .padding()
    }
    
    var songs: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Songs")
                .font(.title3)
                .fontWeight(.bold)
            ForEach(listOfSongs) { song in
                HStack{
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
        }
        .padding()
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
        ScrollView(.vertical, showsIndicators: false) {
            nowPlaying
            queue
            songs
        }
        
    }
}

