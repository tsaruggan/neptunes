//
//  PlayerView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-17.
//

import SwiftUI
import AVFoundation

struct PlayerView: View {
    @ObservedObject var viewModel: PlayerViewModel
    @Binding var expanded: Bool
    var animation: Namespace.ID
    
    @State var audioPlayer: AVAudioPlayer?
    
    @Environment(\.colorScheme) var colorScheme
    @State var offset: CGFloat = 0
    let expandedContentWidth = max(UIScreen.main.bounds.width * 2.5 / 3, 264)
    let expandedContentHeight = UIScreen.main.bounds.height * 2.5 / 3
    let expandedContentVerticalOffset = min(UIScreen.main.bounds.height / 8, 200)
    
    init(viewModel: PlayerViewModel, expanded: Binding<Bool>, animation: Namespace.ID) {
        self.viewModel = viewModel
        self._expanded = expanded
        self.animation = animation
    }
    
    var body: some View {
        VStack {
            if expanded {
                VStack() {
                    expandedcollapseButton
                    Spacer(minLength: 16)
                    songArtwork
                    expandedSongInformation
                        .padding(.top, 16)
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
        .background(viewModel.palette.background(colorScheme).opacity(0.75))
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
        //        .onAppear {
        //            let sound = Bundle.main.path(forResource: "song", ofType: "mp3")
        //            self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        //        }
    }
    
    var songArtwork: some View {
        Image(viewModel.song.artwork ?? "default_album_art")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .cornerRadius(8)
            .matchedGeometryEffect(id: "artwork", in: animation, properties: .frame)
            .frame(width: expanded ? nil : 55, height: expanded ? nil : 55)
    }
    
    var expandedSongInformation: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(spacing: 14){
                Text(viewModel.song.title)
                    .foregroundColor(viewModel.palette.primary(colorScheme))
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .matchedGeometryEffect(id: "title", in: animation, properties: .position)
                
                if viewModel.song.isExplicit {
                    Image(systemName: "e.square.fill")
                        .foregroundColor(viewModel.palette.accent(colorScheme))
                        .matchedGeometryEffect(id: "explicitSign", in: animation, properties: .position)
                }
                Spacer(minLength: 0)
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(viewModel.palette.secondary(colorScheme))
                }
            }
            .font(.title3)
            
            Text(viewModel.song.artist!.title)
                .foregroundColor(viewModel.palette.secondary(colorScheme))
                .lineLimit(1)
                .matchedGeometryEffect(id: "artist", in: animation)
            
            Spacer(minLength: 0)
        }
        .frame(height: expanded ? 64 : 0)
    }
    
    var expandedScrubber: some View {
        ScrubberView(duration: $viewModel.duration, percentage: $viewModel.percentage, backgroundColor: viewModel.palette.primary(colorScheme), textColor: viewModel.palette.secondary(colorScheme))
            .frame(height: 75)
    }
    
    var expandedControlButtons: some View {
        VStack {
            HStack() {
                Button(action: {}) {
                    Image(systemName: "backward.fill")
                }
                Spacer()
                Button(action: viewModel.playPause) {
                    Image(systemName: viewModel.isPlaying ? "play.fill" : "pause.fill")
                }
                Spacer()
                Button(action: {}) {
                    Image(systemName: "forward.fill")
                }
            }
            .buttonStyle(LargeMediaButtonStyle(foregroundColor: viewModel.palette.secondary(colorScheme)))
            .frame(height: 24)
            .padding(.vertical, nil)
            
            HStack {
                Button(action: {}) {
                    //            Image(systemName: "hifispeaker.2.fill")
                    Image(systemName: "airpodsmax")
                }
                Spacer()
                Button(action: {}) {
                    Image(systemName: "repeat")
                }
                Spacer()
                Button(action: {}) {
                    Image(systemName: "shuffle")
                }
                Spacer()
                Button(action: {}) {
                    Image(systemName: "list.triangle")
                }
            }
            .buttonStyle(SmallMediaButtonStyle(foregroundColor: viewModel.palette.secondary(colorScheme)))
            .padding(.vertical, nil)
        }
    }
    
    var expandedcollapseButton: some View {
        HStack(alignment: .center){
            Button(action: { withAnimation(.easeInOut){ expanded = false } }) {
                Image(systemName: "chevron.compact.down")
            }
        }
        .buttonStyle(LargeMediaButtonStyle(foregroundColor: viewModel.palette.secondary(colorScheme)))
        .padding()
    }
    
    var collapsedControlButtons: some View {
        Button(action: viewModel.playPause) {
            Image(systemName: viewModel.isPlaying ? "play.fill" : "pause.fill")
        }
        .buttonStyle(SmallMediaButtonStyle(foregroundColor: viewModel.palette.secondary(colorScheme)))
    }
    
    var collapsedSongInformation: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(viewModel.song.title)
                    .foregroundColor(viewModel.palette.primary(colorScheme))
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .matchedGeometryEffect(id: "title", in: animation, properties: .position)
                if viewModel.song.isExplicit {
                    Image(systemName: "e.square.fill")
                        .foregroundColor(viewModel.palette.accent(colorScheme))
                        .matchedGeometryEffect(id: "explicitSign", in: animation, properties: .position)
                }
            }
            Text(viewModel.song.artist!.title)
                .foregroundColor(viewModel.palette.secondary(colorScheme))
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

struct PlayerView_Previews: PreviewProvider {
    @State static var expanded = true
    @Namespace static var animation
    static var previews: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            TabView {
                PageView(text: "Home page")
                    .tabItem { Label("Home", systemImage: "music.note.house") }
                PageView(text: "Search page")
                    .tabItem { Label("Search", systemImage: "magnifyingglass") }
            }
            .accentColor(.teal)
            PlayerView(viewModel: .init(song: MusicData().albums[0].songs[0]) ,expanded: $expanded, animation: animation)
        }
    }
}
