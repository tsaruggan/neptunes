//
//  ContentView.swift
//  Apollo
//
//  Created by Saruggan Thiruchelvan on 2021-06-26.
//

import SwiftUI

struct ContentView: View {
    init() {
        UITabBar.appearance().backgroundColor = .clear
        UITabBar.appearance().barTintColor = .black
        UITabBar.appearance().isTranslucent = true
    }
    
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
        .accentColor(.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
