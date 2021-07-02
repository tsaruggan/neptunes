//
//  ContentView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-06-26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        TabView {
            HomePageView()
                .tabItem {
                    Image(systemName: "music.note.house")
                    Text("Home")
                }
            PageView(text: "Search page")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
        }
        .accentColor(.teal)
        .background(.ultraThinMaterial)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            ContentView().preferredColorScheme($0)
        }
    }
}
