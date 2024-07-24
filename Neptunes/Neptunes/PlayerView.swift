//
//  PlayerView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2024-07-23.
//

import SwiftUI

struct PlayerView: View {
    
    @ObservedObject var viewModel: PlayerViewModel
    
    init(viewModel: PlayerViewModel) {
        self.viewModel  = viewModel
    }
    
    var body: some View {
        VStack {
            Spacer(minLength: 16)
            songArtwork
            songInformation
                .padding(.vertical, 20)
            VStack {
                scrubber
                controlButtons
                Spacer()
            }
        }
        .padding(48)
        .onReceive(viewModel.timer) { _ in viewModel.onUpdate() }
    }
    
    var songArtwork: some View {
        Image("defaultcover")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .cornerRadius(8)
            .frame(width: 300)
    }
    
    var songInformation: some View {
        VStack(alignment: .center, spacing: 0) {
            
            Text(viewModel.song?.title ?? "")
                .font(.title3)
                .foregroundColor(.primary)
                .fontWeight(.bold)
                .lineLimit(1)
            
            Text(viewModel.song?.artist ?? "")
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
    }
    
    var scrubber: some View {
        ScrubberView(
            duration: viewModel.duration,
            percentage: $viewModel.percentage,
            backgroundColor: .orange,
            textColor: .primary,
            onChanged: viewModel.onScrubberChanged,
            onEnded: viewModel.onScrubberEnded
        )
    }
    
    var controlButtons: some View {
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
            .buttonStyle(LargeMediaButtonStyle(foregroundColor: .secondary))
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
                                .foregroundColor(.accentColor)
                        } else if viewModel.repeatState == .repeatingone {
                            Image(systemName: "repeat.1")
                                .foregroundColor(.accentColor)
                        } else {
                            Image(systemName: "repeat")
                        }
                    }
                    Image(systemName: "circle.fill")
                        .foregroundColor(viewModel.repeatState != .unrepeating  ? .accentColor : .clear)
                        .font(.system(size: 4))
                }
                Spacer()
                VStack(spacing: 4){
                    Button(action: viewModel.toggleShuffle) {
                        if viewModel.shuffleState == .shuffled {
                            Image(systemName: "shuffle")
                                .foregroundColor(.accentColor)
                        } else {
                            Image(systemName: "shuffle")
                        }
                    }
                    Image(systemName: "circle.fill")
                        .foregroundColor(viewModel.shuffleState == .shuffled ? .accentColor : .clear)
                        .font(.system(size: 4))
                }
                Spacer()
                Button(action: {}) {
                    Image(systemName: "list.triangle")
                }
            }
            .buttonStyle(SmallMediaButtonStyle(foregroundColor: .secondary))
            .padding(.vertical, nil)
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

