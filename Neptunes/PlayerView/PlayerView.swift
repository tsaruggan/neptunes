//
//  PlayerView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-17.
//

import SwiftUI

struct PlayerView: View {
    @State var song: Song
    @Binding var expanded: Bool
    var animation: Namespace.ID
    let artworkHeight = UIScreen.main.bounds.height / 3
    @State var offset: CGFloat = 0
    let palette = Palette()
    @Environment(\.colorScheme) var colorScheme
    
    var expandedSongInformation: some View {
        VStack {
            HStack {
                Text(song.title)
                    .foregroundColor(palette.primary(colorScheme))
                    .fontWeight(.bold)
                    .matchedGeometryEffect(id: "title", in: animation, properties: .position)
                
                if song.isExplicit {
                    Image(systemName: "e.square.fill")
                        .foregroundColor(palette.accent(colorScheme))
                        .matchedGeometryEffect(id: "explicitSign", in: animation, properties: .position)
                }
                Spacer(minLength: 0)
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(palette.secondary(colorScheme))
                }
            }
            .padding(.vertical)
            .font(.title2)
            
            Spacer(minLength: 0)
        }
        .frame(height: expanded ? nil : 0)
        .opacity(expanded ? 1 : 0)
        
        .padding(.horizontal, (UIScreen.main.bounds.width - UIScreen.main.bounds.height / 3) / 2)
    }
    
    var expandedHeader: some View {
        HStack{
            Button(action: { withAnimation(.easeInOut){ expanded = false } }) {
                Image(systemName: "chevron.compact.down")
            }
        }
        .foregroundColor(palette.secondary(colorScheme))
        .font(.title)
        .frame(height: expanded ? nil : 0)
        .opacity(expanded ? 1 : 0)
        .padding(.top, expanded ? 30 : 0)
        .padding(.vertical, expanded ? 30 : 0)
    }
    
    var songArtwork: some View {
        Image(song.artwork ?? "default_album_art")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: expanded ? artworkHeight : 55, height: expanded ? artworkHeight : 55)
            .cornerRadius(8)
    }
    
    var collapsedControlButtons: some View {
        Group {
            Button(action: {}) {
                Image(systemName: "play.fill")
            }
            Button(action: {}) {
                Image(systemName: "forward.fill")
            }
        }
        .font(.title2)
        .foregroundColor(.primary)
    }
    
    var collapsedSongInformation: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(song.title)
                    .foregroundColor(palette.primary(colorScheme))
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .matchedGeometryEffect(id: "title", in: animation, properties: .position)
                if song.isExplicit {
                    Image(systemName: "e.square.fill")
                        .foregroundColor(palette.accent(colorScheme))
                        .matchedGeometryEffect(id: "explicitSign", in: animation, properties: .position)
                }
            }
            
            Text(song.artist?.title ?? "")
                .foregroundColor(palette.secondary(colorScheme))
                .lineLimit(1)
                .matchedGeometryEffect(id: "artist", in: animation)
        }
    }
    
    var body: some View {
        VStack {
            expandedHeader
            HStack(spacing: 15) {
                if expanded { Spacer(minLength: 0) }
                songArtwork
                if !expanded { collapsedSongInformation }
                Spacer(minLength: 0)
                if !expanded { collapsedControlButtons }
            }
            .padding(.horizontal)
            
            expandedSongInformation
        }
        .frame(maxHeight: expanded ? .infinity : 80)
        .background(palette.background(colorScheme).opacity(0.5))
        .background(.thinMaterial)
        .onTapGesture {
            withAnimation(.easeInOut){ expanded = true }
        }
        .cornerRadius(expanded ? 20 : 0)
        .offset(y: expanded ? 0 : -48)
        .offset(y: offset)
        .gesture(
            DragGesture()
                .onEnded(dragGestureOnEnded(value:))
                .onChanged(dragGestureOnChanged(value:))
        )
        .ignoresSafeArea()
    }
    
    
    func dragGestureOnChanged(value : DragGesture.Value) {
        if value.translation.height > 0 && expanded {
            offset = value.translation.height
        }
    }
    
    func dragGestureOnEnded(value : DragGesture.Value) {
        withAnimation(.easeInOut) {
            if value.translation.height > artworkHeight {
                expanded = false
            }
            offset = 0
        }
    }
}
