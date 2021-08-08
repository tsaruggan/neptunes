//
//  ScrubberView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-18.
//

import SwiftUI

struct ScrubberView: View {
    var duration: TimeInterval
    @Binding var percentage: Double
    var backgroundColor: Color
    var textColor: Color
    var onChanged: () -> Void
    var onEnded: () -> Void
    @State private var scale: CGFloat = 1.0
    var body: some View {
        GeometryReader { geometry in
            let width: CGFloat = geometry.size.width
            let radius: CGFloat = 400
            let fullArch = Arch(radius: radius)
            let progressArch = Arch(radius: radius)
                .trim(from: 0, to: percentage)
            let handlePoint: CGPoint = progressArch.path(in: geometry.frame(in: .local)).currentPoint ?? fullArch.path(in: geometry.frame(in: .local)).currentPoint!.applying(CGAffineTransform(translationX: -width, y: 0))
            let handleDiameter = 24.0
            let archHeight = radius - (pow(radius, 2) - pow(width / 2, 2)).squareRoot()
            
            ZStack {
                fullArch
                    .stroke(backgroundColor.opacity(0.5), style: StrokeStyle(lineWidth: 4))
                progressArch
                    .stroke(backgroundColor, style: StrokeStyle(lineWidth: 4))
                Circle()
                    .fill(backgroundColor.opacity(1))
                    .frame(width: handleDiameter, height: handleDiameter)
                    .scaleEffect(scale)
                    .position(x: handlePoint.x, y: handlePoint.y)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onEnded({ _ in
                                withAnimation {
                                    self.scale = 1.0
                                }
                                onEnded()
                            })
                            .onChanged({ value in
                                let vector = CGVector(
                                    dx: value.location.x - width / 2,
                                    dy: value.location.y - radius
                                )
                                let maxAngle = 2 * asin(width / (2 * radius)) * 180 / .pi
                                let angleAdjustment = 90.0 + maxAngle / 2
                                let angle = atan2(vector.dy - handleDiameter / 2, vector.dx - handleDiameter / 2) * (180.0 / .pi) + angleAdjustment
                                withAnimation(Animation.linear(duration: 0.15)) {
                                    self.percentage = min(max(0, Double(angle / maxAngle)), 1)
                                    self.scale = 1.4
                                    onChanged()
                                }
                            }))
                
                VStack {
                    HStack {
                        Text((duration * percentage).positionalTime)
                        Spacer()
                        Text(duration.positionalTime)
                    }
                    .font(.system(.footnote, design: .monospaced))
                    .foregroundColor(textColor)
                    Spacer(minLength: 0)
                }
                .padding(.top, archHeight + 16)
            }
        }
        .frame(height: 75)
    }
}

struct ScrubberView_Previews: PreviewProvider {
    @State static var duration: TimeInterval = 194.0
    @State static var percentage: Double = 0.69
    static var previews: some View {
        ScrubberView(duration: duration, percentage: $percentage, backgroundColor: .blue, textColor: .primary, onChanged: {}, onEnded: {})
            .frame(width: 300)
            .preferredColorScheme(.dark)
    }
}

struct Arch: Shape {
    let radius: CGFloat
    func path(in rect: CGRect) -> Path {
        let center: CGPoint = CGPoint(x: rect.midX, y: radius)
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

extension Formatter {
    static let positional: DateComponentsFormatter = {
        let positional = DateComponentsFormatter()
        positional.unitsStyle = .positional
        positional.zeroFormattingBehavior = .pad
        return positional
    }()
}

extension TimeInterval {
    var positionalTime: String {
        Formatter.positional.allowedUnits = self >= 3600 ?
        [.hour, .minute, .second] :
        [.minute, .second]
        let string = Formatter.positional.string(from: self)!
        return string.hasPrefix("0") && string.count > 4 ?
            .init(string.dropFirst()) : string
    }
}
