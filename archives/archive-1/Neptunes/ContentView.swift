//
//  ContentView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-03-27.
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
//    @StateObject var audioPlayer = Player()
    @StateObject var assetPlayer: AssetPlayer
    
    @State private var home = UUID()
    @State private var search = UUID()
    
    init() {
        ConfigModel.shared = ConfigModel(nowPlayableBehavior: IOSNowPlayableBehavior())
        self._assetPlayer = StateObject(wrappedValue: try! AssetPlayer())
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
            
            PlayerView(viewModel: .init(player: assetPlayer), expanded: $expanded, animation: animation)
        }
        .environmentObject(assetPlayer)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        
        
//        ForEach(ColorScheme.allCases, id: \.self) {
//            ContentView()
//                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//                .preferredColorScheme($0)
//        }
    }
}
