//
//  ScrubberView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-18.
//

import SwiftUI

struct ScrubberView: View {
    @Binding var percentage: Double
    private let angle: Double = 45
    var body: some View {
        GeometryReader { geometry in
            let leftArch: Arch = Arch(percentFilled: percentage)
            let rightArch: Arch = Arch(percentFilled: -(1 - percentage))
            let handlePoint: CGPoint = leftArch.path(in: geometry.frame(in: .local)).currentPoint!
            ZStack {
                leftArch
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                rightArch
                    .stroke(Color.red, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                Circle()
                    .frame(width: 24, height: 24)
                    .position(x: handlePoint.x, y: handlePoint.y)
                    .foregroundColor(.black)
            }
        }
    }
}

struct ScrubberView_Previews: PreviewProvider {
    @State static var percentage: Double = 0.5
    static var previews: some View {
        ScrubberView(percentage: $percentage)
    }
}

struct Arch: Shape {
    let percentFilled: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let radius: CGFloat = rect.height
        let angle = Angle.radians(2 * asin(rect.width / (2 * radius)))
        let center: CGPoint = CGPoint(x: rect.midX, y: rect.maxY)
        let start = percentFilled >= 0 ? Angle.degrees(180) + (Angle.degrees(180) - angle) / 2 : -(Angle.degrees(180) - angle) / 2
        let end = percentFilled >= 0 ? start + angle * abs(percentFilled) : start - angle * abs(percentFilled)
        let clockwise = percentFilled >= 0 ? false : true

        var path = Path()
        path.addArc(
            center: center,
            radius: radius,
            startAngle: start,
            endAngle: end,
            clockwise: clockwise
        )
        return path
    }
}
