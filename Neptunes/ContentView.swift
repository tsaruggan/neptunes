//
//  ContentView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-06-26.
//

import SwiftUI

struct ContentView: View {
    @State var current = 0
    @State var expanded = false
    @Namespace var animation
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            TabView(selection: $current) {
                HomePageView()
                    .tag(0)
                    .tabItem { Label("Home", systemImage: "music.note.house") }
                PageView(text: "Search page")
                    .tag(1)
                    .tabItem { Label("Search", systemImage: "magnifyingglass") }
            }
            .accentColor(.teal)
            .background(.thinMaterial)
            
            PlayerView(song: MusicModel().albums[3].songs[0] ,expanded: $expanded, animation: animation)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            ContentView().preferredColorScheme($0)
        }
    }
}
