//
//  PlayerView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-17.
//

import SwiftUI

struct PlayerView: View {
    var song: Song
    @Binding var expanded: Bool
    var animation: Namespace.ID
    let artworkHeight = UIScreen.main.bounds.height / 3
    @State var offset: CGFloat = 0
    
    var body: some View {
        VStack {
            
            Capsule()
                .fill(.gray)
                .frame(width: expanded ? 60 : 0, height: expanded ? 4 : 0)
                .opacity(expanded ? 1 : 0)
                .padding(.top, expanded ? 30 : 0)
                .padding(.vertical, expanded ? 30 : 0)
            
            HStack(spacing: 15) {
                
                if expanded { Spacer(minLength: 0) }
                
                Image(song.artwork ?? "default_album_art")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: expanded ? artworkHeight : 55, height: expanded ? artworkHeight : 55)
                    .cornerRadius(8)
                
                if !expanded  {
                    VStack(alignment: .leading) {
                        Text(song.title)
                            .foregroundColor(.primary)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .matchedGeometryEffect(id: "title", in: animation)
                        Text(song.artist?.title ?? "")
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                            .matchedGeometryEffect(id: "artist", in: animation)
                    }
                }
                
                Spacer(minLength: 0)
                
                if !expanded {
                    Button(action: {}) {
                        Image(systemName: "play.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    Button(action: {}) {
                        Image(systemName: "forward.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
                
            }
            .padding(.horizontal)
            
            VStack {
                HStack {
                    if expanded  {
                        Text(song.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .matchedGeometryEffect(id: "title", in: animation)
                    }
                    Spacer(minLength: 0)
                    Button(action: {}) {
                        Image(systemName: "ellipsis.circle")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
                .padding()
                Spacer(minLength: 0)
            }
            .frame(height: expanded ? nil : 0)
            .opacity(expanded ? 1 : 0)
        }
        .frame(maxHeight: expanded ? .infinity: 80)
        .background(.ultraThinMaterial)
        .onTapGesture {
            withAnimation(.easeInOut){expanded = true}
        }
        .cornerRadius(expanded ? 20 : 0)
        .offset(y: expanded ? 0 : -48)
        .offset(y: offset)
        .gesture(
            DragGesture()
                .onEnded(onended(value:))
                .onChanged(onchanged(value:))
        )
        .ignoresSafeArea()
    }
    
    
    func onchanged(value : DragGesture.Value) {
        if value.translation.height > 0 && expanded {
            offset = value.translation.height
        }
    }
    
    func onended(value : DragGesture.Value) {
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.95, blendDuration: 0.95)) {
            if value.translation.height > artworkHeight {
                expanded = false
            }
            offset = 0
        }
    }
}
