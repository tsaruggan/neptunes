//
//  ScrubberView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-18.
//

import SwiftUI

struct ScrubberView: View {
    @Binding var percentage: CGFloat
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            let fullArch = Arch()
            let progressArch = Arch().trim(from: 0, to: percentage + 0.01)
            let handlePoint: CGPoint = progressArch.path(in: geometry.frame(in: .local)).currentPoint!
            let handleDiameter = 24.0
            let width = geometry.frame(in: .local).width
            let height = geometry.frame(in: .local).height
            
            ZStack {
                fullArch
                    .stroke(.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                
                progressArch
                    .stroke(.red, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                
                Circle()
                    .fill(Color.white)
                    .frame(width: handleDiameter, height: handleDiameter)
                    .scaleEffect(scale)
                    .position(x: handlePoint.x, y: handlePoint.y)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onEnded({ _ in withAnimation { self.scale = 1.0 } })
                            .onChanged({ value in
                        let vector = CGVector(
                            dx: value.location.x - width / 2,
                            dy: value.location.y - height
                        )
                        let maxAngle = 2 * asin(width / (2 * height)) * 180 / .pi
                        let angleAdjustment = 90.0 + maxAngle / 2
                        let angle = atan2(vector.dy - handleDiameter / 2, vector.dx - handleDiameter / 2) * (180.0 / .pi) + angleAdjustment
                        withAnimation(Animation.linear(duration: 0.15)) {
                            self.percentage = min(max(0, Double(angle / maxAngle)), 1)
                            self.scale = 1.4
                        }
                    }))
            }
        }
    }
}

struct ScrubberView_Previews: PreviewProvider {
    @State static var percentage: CGFloat = 0.5
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
