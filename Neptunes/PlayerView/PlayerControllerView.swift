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
    var primaryColor: Color
    var secondaryColor: Color
    var body: some View {
        VStack {
            ScrubberView(duration: $duration, percentage: $percentage, backgroundColor: primaryColor, textColor: secondaryColor)
                .frame(height: 60)
            VStack {
                HStack() {
                    Image(systemName: "backward.fill")
                    Spacer()
                    Image(systemName: "play.fill")
                    Spacer()
                    Image(systemName: "forward.fill")
                }
                .font(.largeTitle)
                .padding(.vertical, nil)
                HStack {
                    Image(systemName: "hifispeaker.2.fill")
                    Spacer()
                    Image(systemName: "repeat")
                    Spacer()
                    Image(systemName: "shuffle")
                    Spacer()
                    Image(systemName: "list.triangle")
                }
                .font(.callout)
                .padding(.vertical, 10)
            }
            .foregroundColor(secondaryColor)
            
            Spacer(minLength: 0)
        }
        
    }
}

struct PlayerControllerView_Previews: PreviewProvider {
    @State static var duration: Int = 194
    @State static var percentage: CGFloat = 0.69
    static let palette = Palette()
    static var previews: some View {
        PlayerControllerView(duration: $duration, percentage: $percentage, primaryColor: palette.primary.light, secondaryColor: palette.secondary.light)
            .padding(.horizontal, (UIScreen.main.bounds.width - UIScreen.main.bounds.height / 3) / 2)
    }
}
