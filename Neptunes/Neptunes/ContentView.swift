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

    @State private var home = UUID()
    @State private var search = UUID()
    @State private var settings = UUID()
    
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
    
    init() {
        ConfigModel.shared = ConfigModel(nowPlayableBehavior: IOSNowPlayableBehavior())
        self._player = StateObject(wrappedValue: try! Player())
    }
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            TabView(selection: selectionBinding) {
                NavigationView {
                    HomeView()
                        .id(home)
                        .onChange(of: tappedTwice, perform: { tappedTwice in
                            guard tappedTwice else { return }
                            home = UUID()
                            self.tappedTwice = false
                        })
                }
                .navigationViewStyle(.stack)
                .tag(0)
                .tabItem { Label("Home", systemImage: "music.note.house") }
                
                NavigationView {
                    Text("Search")
                        .id(search)
                        .onChange(of: tappedTwice, perform: { tappedTwice in
                            guard tappedTwice else { return }
                            search = UUID()
                            self.tappedTwice = false
                        })
                }
                .navigationViewStyle(.stack)
                .tag(1)
                .tabItem { Label("Search", systemImage: "magnifyingglass") }
                
                NavigationView {
                    Text("Settings")
                        .id(settings)
                        .onChange(of: tappedTwice, perform: { tappedTwice in
                            guard tappedTwice else { return }
                            settings = UUID()
                            self.tappedTwice = false
                        })
                }
                .navigationViewStyle(.stack)
                .tag(2)
                .tabItem { Label("Settings", systemImage: "gear") }
            }
            
            PlayerView(viewModel: .init(player: player), expanded: $expanded, animation: animation)
        }
        .environmentObject(player)
    }
}
