//
//  PlayerControllerView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-22.
//

import SwiftUI

struct PlayerControllerView: View {
    @Binding var duration: Int
    @Binding var percentage: CGFloat
    @Binding var isPlaying: Bool
    var primaryColor: Color
    var secondaryColor: Color
    
    var body: some View {
        VStack {
            ScrubberView(duration: $duration, percentage: $percentage, backgroundColor: primaryColor, textColor: secondaryColor)
                .frame(height: 75)
            VStack {
                HStack() {
                    backwardButton
                    Spacer()
                    playButton
                    Spacer()
                    forwardButton
                }
                .frame(height: 24)
                .padding(.vertical, nil)
                HStack {
                    speakerButton
                    Spacer()
                    repeatButton
                    Spacer()
                    shuffleButton
                    Spacer()
                    queueButton
                }
                .padding(.vertical, nil)
            }
            Spacer(minLength: 0)
        }
    }
    
    var backwardButton: some View {
        Button(action: {}) {
            Image(systemName: "backward.fill")
        }
        .buttonStyle(LargeMediaButtonStyle(foregroundColor: secondaryColor))
    }
    
    var playButton: some View {
        Button {
            isPlaying.toggle()
        } label: {
            Image(systemName: isPlaying ? "play.fill" : "pause.fill")
        }
        .buttonStyle(LargeMediaButtonStyle(foregroundColor: secondaryColor))
    }
    
    var forwardButton: some View {
        Button(action: {}) {
            Image(systemName: "forward.fill")
        }
        .buttonStyle(LargeMediaButtonStyle(foregroundColor: secondaryColor))
    }
    
    var speakerButton: some View {
        Button(action: {}) {
            //            Image(systemName: "hifispeaker.2.fill")
            Image(systemName: "airpodsmax")
        }
        .buttonStyle(SmalleMediaButtonStyle(foregroundColor: secondaryColor))
    }
    
    var repeatButton: some View {
        Button(action: {}) {
            Image(systemName: "repeat")
        }
        .buttonStyle(SmalleMediaButtonStyle(foregroundColor: secondaryColor))
    }
    
    var shuffleButton: some View {
        Button(action: {}) {
            Image(systemName: "shuffle")
        }
        .buttonStyle(SmalleMediaButtonStyle(foregroundColor: secondaryColor))
    }
    
    var queueButton: some View {
        Button(action: {}) {
            Image(systemName: "list.triangle")
        }
        .buttonStyle(SmalleMediaButtonStyle(foregroundColor: secondaryColor))
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

struct SmalleMediaButtonStyle: ButtonStyle {
    var foregroundColor: Color
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.callout)
            .foregroundColor(foregroundColor)
    }
}

struct PlayerControllerView_Previews: PreviewProvider {
    @State static var duration: Int = 194
    @State static var isPlaying: Bool = true
    @State static var percentage: CGFloat = 0.69
    static let palette = Palette()
    static var previews: some View {
        PlayerControllerView(
            duration: $duration,
            percentage: $percentage,
            isPlaying: $isPlaying,
            primaryColor: palette.primary.light,
            secondaryColor: palette.secondary.light
        )
            .padding(.horizontal, (UIScreen.main.bounds.width - UIScreen.main.bounds.height / 3) / 2)
    }
}
