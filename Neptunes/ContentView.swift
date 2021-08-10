//
//  ContentView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-06-26.
//

import SwiftUI
import UIKit
import AVKit

struct ContentView: View {
    @State private var selected: Int = 0
    @State private var tappedTwice = false

    @State private var home = UUID()
    @State private var search = UUID()
    
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
    
    @StateObject var audioPlayer = AudioPlayer()
    
    init() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.systemBackground.withAlphaComponent(0.95)
    }
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            TabView(selection: selectionBinding) {
                NavigationView {
                    HomePageView()
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
                    PageView(text: "Search page")
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
            }
            .background(.thinMaterial)
            .accentColor(.teal)
            
            PlayerView(viewModel: .init(audioPlayer: audioPlayer),expanded: $expanded, animation: animation)
        }
        .environmentObject(audioPlayer)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            ContentView().preferredColorScheme($0)
        }
    }
}

