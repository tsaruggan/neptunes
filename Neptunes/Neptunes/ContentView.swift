//
//  ContentView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2024-07-23.
//

import SwiftUI


struct ContentView: View {
    @State private var tabSelection: Int = 0
    @StateObject var assetPlayer: Player
    
    var listOfSongs: [Song]
    
    init() {
        ConfigModel.shared = ConfigModel(nowPlayableBehavior: IOSNowPlayableBehavior())
        self._assetPlayer = StateObject(wrappedValue: try! Player())
        
        let song1 = Song(title: "Not Around", filename: "song1", artist: "Drake", album: "Certified Lover Boy")
        let song2 = Song(title: "Hell of a Night", filename: "song2", artist: "Travis Scott", album: "Owl Pharoah")
        let song3 = Song(title: "Wither", filename: "song3", artist: "Frank Ocean", album: "Endless")
        let song4 = Song(title: "Rushes", filename: "song4", artist: "Frank Ocean", album: "Endless")
        let song5 = Song(title: "Cancun", filename: "song5", artist: "Playboi Carti", album: "Cancun")
        listOfSongs = [song1, song2, song3, song4, song5]
    }
    
    private func initializePlayer() {
        self.assetPlayer.replaceNowPlaying(songs: Array(listOfSongs[0...3]), from: 0)
        self.assetPlayer.addToQueue(song: listOfSongs[4])
    }
    
    var body: some View {
        TabView(selection: $tabSelection) {
            LibraryView(viewModel: .init(player: assetPlayer), listOfSongs: listOfSongs)
                .tag(0)
                .tabItem { Label("Library", systemImage: "book") }
            PlayerView(viewModel: .init(player: assetPlayer))
                .tag(1)
                .tabItem { Label("Music", systemImage: "music.note") }
        }
        .environmentObject(assetPlayer)
        .onAppear(perform: initializePlayer)
    }
}
