//
//  ScrubberView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-18.
//

import SwiftUI

struct ScrubberView: View {
    var path: some View {
        GeometryReader { geometry in
            let startPoint: CGPoint = CGPoint(x: geometry.frame(in: .local).minX, y: geometry.frame(in: .local).maxY)
            let endPoint: CGPoint = CGPoint(x: geometry.frame(in: .local).maxX, y: geometry.frame(in: .local).maxY)
            let controlPoint: CGPoint = CGPoint(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).minY)
            ZStack{
                QuadBezier(startPoint: startPoint, endPoint: endPoint, controlPoint: controlPoint)
                    .stroke(Color.teal, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                let percent = 0.69
                Circle()
                    .frame(width: 24, height: 24)
                    .position(
                        x:  QuadBezier(startPoint: startPoint, endPoint: endPoint, controlPoint: controlPoint).point(at: percent).x,
                        y:  QuadBezier(startPoint: startPoint, endPoint: endPoint, controlPoint: controlPoint).point(at: percent).y
                    )
            }
            
        }
        .frame(width: 200, height: 50)
    }
    var body: some View {
        path
        
    }
}

struct ScrubberView_Previews: PreviewProvider {
    static var previews: some View {
        ScrubberView()
    }
}

struct QuadBezier: Shape {
    var startPoint: CGPoint
    var endPoint: CGPoint
    var controlPoint: CGPoint
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: startPoint)
        path.addQuadCurve(to: endPoint, control: controlPoint)
        return path
    }
    
    func point(at t: CGFloat) -> CGPoint {
        let t1 = 1 - t
        return CGPoint(
            x: t1 * t1 * startPoint.x + 2 * t * t1 * controlPoint.x + t * t * endPoint.x,
            y: t1 * t1 * startPoint.y + 2 * t * t1 * controlPoint.y + t * t * endPoint.y
        )
    }
}
