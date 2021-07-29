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
    var palette: Palette
    
    @State var offset: CGFloat = 0
    @Environment(\.colorScheme) var colorScheme
    
    @State var duration: Int = 235
    @State var percentage: CGFloat = 0.5
    @State var scrollText: Bool = true
    
    
    let expandedContentWidth = max(UIScreen.main.bounds.width * 2.5 / 3, 264)
    let expandedContentHeight = UIScreen.main.bounds.height * 2.5 / 3
    let expandedContentVerticalOffset = min(UIScreen.main.bounds.height / 8, 200)
    
    init(song: Song, expanded: Binding<Bool>, animation: Namespace.ID) {
        self.song = song
        self._expanded = expanded
        self.animation = animation
        //        self.palette = ColorAnalyzer.generatePalette(artwork: self.song.artwork, header: self.song.header)
        self.palette = Palette()
    }
    
    var body: some View {
        VStack {
            if expanded {
                VStack() {
                    collapseButton
                    Spacer(minLength: 16)
                    songArtwork
                    expandedSongInformation
                        .padding(.top, 16)
                    PlayerControllerView(
                        duration: $duration,
                        percentage: $percentage,
                        primaryColor: palette.primary(colorScheme),
                        secondaryColor: palette.secondary(colorScheme)
                    )
                }
                .frame(height: expandedContentHeight)
                .padding(48)
                .opacity(expanded ? 1 : 0)
            } else {
                HStack(spacing: 15) {
                    songArtwork
                    collapsedSongInformation
                    Spacer(minLength: 0)
                    collapsedControlButtons
                }
                .padding(.horizontal)
            }
        }
        .frame(width: UIScreen.main.bounds.width)
        .frame(maxHeight: expanded ? .infinity : 80)
        .background(palette.background(colorScheme).opacity(0.75))
        .background(.ultraThinMaterial)
        .onTapGesture {
            withAnimation(.easeInOut){ expanded = true }
        }
        .cornerRadius(expanded && offset > 0 ? 20 : 0)
        .offset(y: expanded ? 0 : -48)
        .offset(y: offset)
        .gesture(
            DragGesture()
                .onEnded(dragGestureOnEnded(value:))
                .onChanged(dragGestureOnChanged(value:))
        )
        .ignoresSafeArea()
    }
    
    var songArtwork: some View {
        Image(song.artwork ?? "default_album_art")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .cornerRadius(8)
            .matchedGeometryEffect(id: "artwork", in: animation, properties: .frame)
            .frame(width: expanded ? nil : 55, height: expanded ? nil : 55)
    }
    
    var expandedSongInformation: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(spacing: 14){
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
                Spacer(minLength: 0)
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(palette.secondary(colorScheme))
                }
            }
            .font(.title3)
            
            Text(song.artist!.title)
                .foregroundColor(palette.secondary(colorScheme))
                .lineLimit(1)
                .matchedGeometryEffect(id: "artist", in: animation)
            
            Spacer(minLength: 0)
        }
        .frame(height: expanded ? 64 : 0)
    }
    
    var expandedScrubber: some View {
        ScrubberView(duration: $duration, percentage: $percentage, backgroundColor: palette.primary(colorScheme), textColor: palette.secondary(colorScheme))
            .frame(height: expanded ? 50 : 0)
            .opacity(expanded ? 1 : 0)
            .padding(.vertical, expanded ? nil : 0)
            .padding(.horizontal, (UIScreen.main.bounds.width - UIScreen.main.bounds.height / 3) / 2)
    }
    
    var collapseButton: some View {
        HStack(alignment: .center){
            Button(action: { withAnimation(.easeInOut){ expanded = false } }) {
                Image(systemName: "chevron.compact.down")
            }
        }
        .foregroundColor(palette.secondary(colorScheme))
        .font(.title)
        .padding()
    }
    
    var collapsedControlButtons: some View {
        Button(action: {}) {
            Image(systemName: "play.fill")
        }
        .font(.title2)
        .foregroundColor(palette.secondary(colorScheme))
        .matchedGeometryEffect(id: "playButton", in: animation)
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
            
            Text(song.artist!.title)
                .foregroundColor(palette.secondary(colorScheme))
                .lineLimit(1)
                .matchedGeometryEffect(id: "artist", in: animation)
        }
    }
    
    func dragGestureOnChanged(value : DragGesture.Value) {
        if value.translation.height > 0 && expanded {
            offset = value.translation.height
        }
    }
    
    func dragGestureOnEnded(value : DragGesture.Value) {
        withAnimation(.easeInOut) {
            if value.translation.height > expandedContentWidth {
                expanded = false
            }
            offset = 0
        }
    }
}
