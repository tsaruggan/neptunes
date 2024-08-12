//
//  PlayerView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-11.
//

import SwiftUI
import AVFoundation
import Combine

struct PlayerView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var viewModel: PlayerViewModel
    @Binding var expanded: Bool
    var animation: Namespace.ID
    
    @State var offset: CGFloat = 0
    let expandedContentWidth = max(UIScreen.main.bounds.width * 2.5 / 3, 264)
    let expandedContentHeight = UIScreen.main.bounds.height * 2.5 / 3
    let expandedContentVerticalOffset = min(UIScreen.main.bounds.height / 8, 200)
    
    @State private var presentingUpcomingSongs = false
    
    // Font configuation constants
    let songTitleFont: Font
    let artistTitleFont: Font
    let collapsedSongTitleFont: Font
    let collapsedArtistTitleFont: Font
    
    @State private var isKeyboardVisible = false
    
    // Constructor
    init(viewModel: PlayerViewModel, expanded: Binding<Bool>, animation: Namespace.ID) {
        self.viewModel = viewModel
        self._expanded = expanded
        self.animation = animation
        
        self.songTitleFont = Font.system(.title2, design: .default, weight: .semibold)
        self.artistTitleFont = Font.system(.headline, design: .default, weight: .regular)
        self.collapsedSongTitleFont = Font.system(.body, design: .default, weight: .semibold)
        self.collapsedArtistTitleFont = Font.system(.callout, design: .default, weight: .regular)
    }
    
    var body: some View {
        VStack {
            if expanded {
                VStack() {
                    Spacer(minLength: 16)
                    expandedcollapseButton
                    Spacer(minLength: 16)
                    songArtwork
                    expandedSongInformation
                        .padding(.vertical, 8)
                    VStack {
                        expandedScrubber
                        expandedControlButtons
                        Spacer(minLength: 0)
                    }
                }
                .frame(height: expandedContentHeight)
                .padding(48)
                .opacity(expanded ? 1 : 0)
            } else {
                HStack(alignment: .center, spacing: 12) {
                    songArtwork
                    collapsedSongInformation
                    collapsedControlButtons
                }
                .padding(.all, 12)
            }
        }
        .frame(width: UIScreen.main.bounds.width)
        .frame(maxHeight: expanded ? .infinity : 72)
        .background(viewModel.palette?.background(colorScheme)?.opacity(0.50) ?? .clear)
        .background(.ultraThinMaterial)
        .opacity(viewModel.song != nil && !isKeyboardVisible ? 1 : 0)
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { _ in
                isKeyboardVisible = true
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                isKeyboardVisible = false
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        .onTapGesture {
            withAnimation(.spring()){ expanded = true }
        }
        .cornerRadius(expanded && offset > 0 ? 48 : 0, corners: [.topLeft, .topRight])
        .offset(y: expanded ? 0 : -48)
        .offset(y: offset)
        .gesture(
            DragGesture()
                .onEnded(dragGestureOnEnded(value:))
                .onChanged(dragGestureOnChanged(value:))
        )
        .onReceive(viewModel.timer) { _ in viewModel.onUpdate() }
        .ignoresSafeArea()
        .sheet(isPresented: $presentingUpcomingSongs) {
            UpcomingSongsView(viewModel: .init(player: viewModel.player))
        }
    }
    
    var songArtwork: some View {
        let artworkImage: Image
        if let artwork = viewModel.song?.album.coverArtwork,
           let image = UIImage(data: artwork) {
            artworkImage = Image(uiImage: image)
        } else {
            artworkImage = Image("defaultcover")
        }
        
        return artworkImage
            .resizable()
            .aspectRatio(contentMode: .fill)
            .cornerRadius(expanded ? 8 : 4)
            .matchedGeometryEffect(id: "artwork", in: animation, properties: .frame)
            .frame(width: expanded ? nil : 55, height: expanded ? nil : 55)
    }
    
    var expandedSongInformation: some View {
        VStack(alignment: .leading, spacing: 0) {
            MarqueeView(
                startDelay: 3.0,
                autoreverses: true,
                direction: .right2left,
                stopWhenNoFit: true,
                idleAlignment: .leading
            ) {
                Text(viewModel.song?.title ?? "")
                    .font(songTitleFont)
                    .foregroundColor(viewModel.palette?.primary(colorScheme) ?? .primary)
                    .lineLimit(1)
            }
            .id(viewModel.song?.title ?? "")
            .matchedGeometryEffect(id: "title", in: animation, properties: .position)
            
            Text(viewModel.song?.artist.title ?? "")
                .font(artistTitleFont)
                .foregroundColor(viewModel.palette?.secondary(colorScheme) ?? .secondary)
                .lineLimit(1)
                .matchedGeometryEffect(id: "artist", in: animation, properties: .position)
            
            Spacer()
        }
        .frame(height: expanded ? 60 : 0)
    }
    
    var expandedScrubber: some View {
        ScrubberView(
            duration: viewModel.duration,
            percentage: $viewModel.percentage,
            backgroundColor: viewModel.palette?.primary(colorScheme) ?? .primary,
            textColor: viewModel.palette?.secondary(colorScheme) ?? .secondary,
            onChanged: viewModel.onScrubberChanged,
            onEnded: viewModel.onScrubberEnded
        )
    }
    
    var expandedControlButtons: some View {
        VStack {
            HStack() {
                Button(action: viewModel.previous) {
                    Image(systemName: "backward.fill")
                }
                Spacer()
                Button(action: viewModel.togglePlayPause) {
                    Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                }
                Spacer()
                Button(action: viewModel.next) {
                    Image(systemName: "forward.fill")
                }
            }
            .buttonStyle(LargeMediaButtonStyle(foregroundColor: viewModel.palette?.secondary(colorScheme) ?? .secondary))
            .frame(height: 24)
            .padding(.vertical, nil)
            
            HStack(alignment: .top) {
                Button(action: {}) {
                    Image(systemName: "airpodsmax")
                }
                Spacer()
                VStack(spacing: 4){
                    Button(action: viewModel.toggleRepeat) {
                        if viewModel.repeatState == .repeating {
                            Image(systemName: "repeat")
                                .foregroundColor(viewModel.palette?.accent(colorScheme) ?? .teal)
                        } else if viewModel.repeatState == .repeatingone {
                            Image(systemName: "repeat.1")
                                .foregroundColor(viewModel.palette?.accent(colorScheme) ?? .teal)
                        } else {
                            Image(systemName: "repeat")
                        }
                    }
                    Image(systemName: "circle.fill")
                        .foregroundColor(viewModel.repeatState != .unrepeating ? (viewModel.palette?.accent(colorScheme) ?? .teal) : .clear)
                        .font(.system(size: 4))
                }
                Spacer()
                VStack(spacing: 4){
                    Button(action: viewModel.toggleShuffle) {
                        if viewModel.shuffleState == .shuffled {
                            Image(systemName: "shuffle")
                                .foregroundColor(viewModel.palette?.accent(colorScheme) ?? .teal)
                        } else {
                            Image(systemName: "shuffle")
                        }
                    }
                    Image(systemName: "circle.fill")
                        .foregroundColor(viewModel.shuffleState == .shuffled ? (viewModel.palette?.accent(colorScheme) ?? .teal) : .clear)
                        .font(.system(size: 4))
                }
                Spacer()
                Button {
                    presentingUpcomingSongs = true
                } label: {
                    Image(systemName: "list.triangle")
                }
                
            }
            .buttonStyle(SmallMediaButtonStyle(foregroundColor: viewModel.palette?.secondary(colorScheme) ?? .secondary))
            .padding(.vertical, nil)
        }
    }
    
    var expandedcollapseButton: some View {
        HStack(alignment: .center){
            Button(action: { withAnimation(.easeInOut.speed(1.5)){ expanded = false } }) {
                Image(systemName: "chevron.compact.down")
            }
        }
        .buttonStyle(LargeMediaButtonStyle(foregroundColor: viewModel.palette?.secondary(colorScheme) ?? .secondary))
        .padding()
    }
    
    var collapsedControlButtons: some View {
        Button(action: viewModel.togglePlayPause) {
            Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
        }
        .font(.title2)
        .foregroundColor(viewModel.palette?.secondary(colorScheme) ?? .secondary)
    }
    
    var collapsedSongInformation: some View {
        VStack(alignment: .leading, spacing: 0) {
            MarqueeView(
                startDelay: 3.0,
                autoreverses: true,
                direction: .right2left,
                stopWhenNoFit: true,
                idleAlignment: .leading
            ) {
                Text(viewModel.song?.title ?? "")
                    .font(collapsedSongTitleFont)
                    .foregroundColor(Color.primary)
                    .lineLimit(1)
            }
            .id(viewModel.song?.title ?? "")
            .matchedGeometryEffect(id: "title", in: animation, properties: .position)
            
            Text(viewModel.song?.artist.title ?? "")
                .font(collapsedArtistTitleFont)
                .foregroundColor(viewModel.palette?.primary(colorScheme) ?? .primary)
                .lineLimit(1)
                .matchedGeometryEffect(id: "artist", in: animation, properties: .position)
            
            Spacer()
        }
        .frame(height: 50)
    }
    
    func dragGestureOnChanged(value : DragGesture.Value) {
        if value.translation.height > 0 && expanded {
            offset = value.translation.height
        }
    }
    
    func dragGestureOnEnded(value : DragGesture.Value) {
        withAnimation(.easeInOut.speed(1.5)) {
            if value.translation.height > 50 {
                expanded = false
            }
            offset = 0
        }
    }
}

struct LargeMediaButtonStyle: ButtonStyle {
    var foregroundColor: Color
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.largeTitle)
            .foregroundColor(foregroundColor)
    }
}

struct SmallMediaButtonStyle: ButtonStyle {
    var foregroundColor: Color
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(foregroundColor)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
