//
//  LibraryView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2024-07-23.
//

import SwiftUI

struct UpcomingSongsView: View {
    @ObservedObject var viewModel: UpcomingSongsViewModel
    @State private var editMode: EditMode = .active
    
    init(viewModel: UpcomingSongsViewModel) {
        self.viewModel = viewModel
    }
    
    var currentSong: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.currentSong!.title)
                    .fontWeight(.semibold)
                Text(viewModel.currentSong!.artist.title)
            }
            Spacer()
            if (viewModel.isPlaying) {
                Image(systemName: "waveform")
                    .font(.title2)
                    .foregroundColor(.indigo)
                    .symbolEffect(.variableColor)
            } else {
                Image(systemName: "waveform")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .symbolEffect(.pulse)
            }
        }
    }
    
    var nowPlaying: some View {
        Section("Now Playing", content: {
            if (!viewModel.isPlayingFromQueue) {
                currentSong
            }
            if (viewModel.songsInNowPlaying != nil), !viewModel.songsInNowPlaying!.isEmpty {
                ForEach(viewModel.songsInNowPlaying!, id: \.id) { song in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(song.title)
                                .fontWeight(.semibold)
                            Text(song.artist.title)
                        }
                        Spacer()
                    }
                }
                .onMove(perform: viewModel.rearrangeNowPlaying)
            }
        })
    }
    
    var queue: some View {
        Section("Queue", content: {
            if (viewModel.isPlayingFromQueue) {
                currentSong
            }
            if (viewModel.songsInQueue != nil), !viewModel.songsInQueue!.isEmpty {
                ForEach(viewModel.songsInQueue!, id: \.id) { song in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(song.title)
                                .fontWeight(.semibold)
                            Text(song.artist.title)
                        }
                        Spacer()
                    }
                }
                .onMove(perform: viewModel.rearrangeQueue)
            }
        })
    }
    
    var body: some View {
        List {
            if ((viewModel.songsInNowPlaying != nil && !viewModel.songsInNowPlaying!.isEmpty) || (!viewModel.isPlayingFromQueue)) {
                nowPlaying
            }
            if ((viewModel.songsInQueue != nil && !viewModel.songsInQueue!.isEmpty) || (viewModel.isPlayingFromQueue)) {
                queue
            }
        }
        .environment(\.editMode, $editMode)
    }
}

