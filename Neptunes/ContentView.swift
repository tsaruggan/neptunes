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
            HomePageView().tabItem { Label("Home", systemImage: "music.note.house") }
            PageView(text: "Search page").tabItem { Label("Search", systemImage: "magnifyingglass") }
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

struct NowPlayingBar: View {
    var body: some View {
        VStack {
            Spacer()
            Rectangle()
                .frame(height: 65)
                .foregroundColor(Color.white.opacity(0.0))
                .background(.ultraThinMaterial)
        }
    }
}
