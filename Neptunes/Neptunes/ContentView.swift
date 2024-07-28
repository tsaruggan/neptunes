//
//  ContentView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2024-07-23.
//

import SwiftUI
import CoreData
import AVKit

struct ContentView: View {
    @State private var selected: Int = 0
    @State private var tappedTwice = false
    
    var selectionBinding: Binding<Int> { Binding {
        self.selected
    } set: {
        if $0 == self.selected {
            tappedTwice = true
        }
        self.selected = $0
    }}
    
    @State var expanded = false
    @Namespace var animation
    @StateObject var player: Player
    
    @State private var home = UUID()
    @State private var search = UUID()
    
    init() {
        ConfigModel.shared = ConfigModel(nowPlayableBehavior: IOSNowPlayableBehavior())
        self._player = StateObject(wrappedValue: try! Player())
    }
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            TabView(selection: selectionBinding) {
                NavigationView {
                    HomeView()
                }
                .navigationViewStyle(.stack)
                .tag(0)
                .tabItem { Label("Home", systemImage: "music.note.house") }
                
                NavigationView {
                    Text("Search")
                }
                .navigationViewStyle(.stack)
                .tag(1)
                .tabItem { Label("Search", systemImage: "magnifyingglass") }
                
            }
            
            PlayerView(viewModel: .init(player: player), expanded: $expanded, animation: animation)
        }
        .environmentObject(player)
    }
}
