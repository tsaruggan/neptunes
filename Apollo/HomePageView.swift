//
//  HomePageView.swift
//  Apollo
//
//  Created by Saruggan Thiruchelvan on 2021-06-27.
//

import SwiftUI

struct HomePageView: View {
    let items: [Item] = [
        Item(name: "Songs", icon: "music.note"),
        Item(name: "Artists", icon: "music.mic"),
        Item(name: "Albums", icon: "square.stack"),
        Item(name: "Playlists", icon: "music.note.list")
    ]
    let bg: Color = Color(red: 24/255, green: 24/255, blue: 24/255)
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack {
            bg.ignoresSafeArea()
            VStack {
                HStack {
                    Text(Date(), style: .time)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    Spacer()
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.green)
                }
                
                ForEach(items) { item in
                    Divider()
                        .background(Color.white)
                    HStack {
                        Label {
                            Text(item.name)
                        } icon: {
                            Image(systemName: item.icon)
                        }
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .listRowInsets(EdgeInsets())
                }
                Divider()
                    .background(Color.white)
                Spacer()
            }
            .padding()
        }
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}

struct Item: Identifiable {
    var id = UUID()
    var name: String
    var icon: String
}
