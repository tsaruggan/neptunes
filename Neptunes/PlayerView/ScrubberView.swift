//
//  ScrubberView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-18.
//

import SwiftUI

struct ScrubberView: View {
    var body: some View {
        QuadBezier()
            .stroke(Color.teal, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
            .frame(width: 200, height: 50)
    }
}

struct ScrubberView_Previews: PreviewProvider {
    static var previews: some View {
        ScrubberView()
    }
}

struct QuadBezier: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let startPoint: CGPoint = CGPoint(x: rect.minX, y: rect.maxY)
        let endPoint: CGPoint = CGPoint(x: rect.maxX, y: rect.maxY)
        let controlPoint: CGPoint = CGPoint(x: rect.midX, y: rect.minY)
        path.move(to: startPoint)
        path.addQuadCurve(to: endPoint, control: controlPoint)
        return path
    }
}
