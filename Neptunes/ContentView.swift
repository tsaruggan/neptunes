//
//  ContentView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-06-26.
//

import SwiftUI

struct ContentView: View {
    init() {
        UINavigationBar.appearance().isTranslucent = true
        UITabBar.appearance().backgroundColor = .clear
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().barTintColor = .white
    }
    
    var body: some View {
        if #available(iOS 15.0, *) {
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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
