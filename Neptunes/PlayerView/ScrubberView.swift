//
//  ScrubberView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-18.
//

import SwiftUI

struct ScrubberView: View {
    @Binding var percentage: Double
    //    private let angle: Double = 45
    @State var width = 300.0
    @State var height = 300.0
    @State var progress: CGFloat = 0.1
    @State var angle: Double = 0
    @State var scale: CGFloat = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let fullArch = Arch()
                
                fullArch
                    .stroke(.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                
                let progressArch = Arch()
                    .trim(from: 0, to: progress + 0.01)
                
                progressArch
                    .stroke(.red, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                
                // Drag Circle
                let handlePoint: CGPoint = progressArch.path(in: geometry.frame(in: .local)).currentPoint!
                Circle()
                    .fill(Color.white)
                    .frame(width: 24, height: 24)
                    .scaleEffect(scale)
                    .position(x: handlePoint.x, y: handlePoint.y)
                    .rotationEffect(Angle(degrees: angle), anchor: .bottom)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onEnded({ _ in withAnimation { self.scale = 1.0 } })
                            .onChanged({ value in
                        self.progress = min(max(0, Double(value.location.x / geometry.size.width * 1)), 1)
                        self.scale = 1.4
                    }))
            }
        }
        .frame(width: width, height: height)
    }
}

struct ScrubberView_Previews: PreviewProvider {
    @State static var percentage: Double = 0.5
    static var previews: some View {
        ScrubberView(percentage: $percentage)
            .preferredColorScheme(.dark)
    }
}

struct Arch: Shape {
    func path(in rect: CGRect) -> Path {
        let radius: CGFloat = rect.height
        let center: CGPoint = CGPoint(x: rect.midX, y: rect.maxY)
        let angle = Angle.radians(2 * asin(rect.width / (2 * radius)))
        let rotationAdjustment = Angle.degrees(90)
        let start = -angle/2 - rotationAdjustment
        let end = angle/2 - rotationAdjustment
        var path = Path()
        path.addArc(
            center: center,
            radius: radius,
            startAngle: start,
            endAngle: end,
            clockwise: false
        )
        return path
    }
}
