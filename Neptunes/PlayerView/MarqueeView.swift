//
//  MarqueeView.swift
//  MarqueeView
//
//  Created by Saruggan Thiruchelvan on 2021-08-17.
//

import SwiftUI

struct MarqueeView<Content: View>: View {
    private var startDelay: Double
    private var autoreverses: Bool
    private var direction: MarqueeDirection
    private var stopWhenNotFit: Bool
    private  var idleAlignment: HorizontalAlignment
    private var content: () -> Content
    @State private var state: MarqueeState = .idle
    @State private var contentWidth: CGFloat = 0
    @State private var duration: CGFloat = 0
    @State private var isAppear = false
    
    public init(startDelay: Double, autoreverses: Bool, direction: MarqueeDirection, stopWhenNoFit: Bool, idleAlignment: HorizontalAlignment ,@ViewBuilder content: @escaping () -> Content) {
        self.startDelay = startDelay
        self.autoreverses = autoreverses
        self.direction = direction
        self.stopWhenNotFit = stopWhenNoFit
        self.idleAlignment = idleAlignment
        self.content = content
    }
    
    public var body: some View {
        GeometryReader { proxy in
            VStack() {
                if isAppear {
                    content()
                        .background(GeometryBackground())
                        .fixedSize()
                        .myOffset(x: offsetX(proxy: proxy), y: 0)
                        .frame(maxHeight: .infinity)
                } else {
                    Text("")
                }
            }
            .onPreferenceChange(WidthKey.self, perform: { value in
                self.contentWidth = value
                self.duration = value / 60
                resetAnimation(duration: duration, autoreverses: autoreverses, proxy: proxy)
            })
            .onAppear {
                self.isAppear = true
                resetAnimation(duration: duration, autoreverses: autoreverses, proxy: proxy)
            }
            .onDisappear {
                self.isAppear = false
            }
        }
        .clipped()
    }
    
    private func offsetX(proxy: GeometryProxy) -> CGFloat {
        switch self.state {
        case .idle:
            switch idleAlignment {
            case .center:
                return 0.5*(proxy.size.width-contentWidth)
            case .trailing:
                return proxy.size.width-contentWidth
            default:
                return 0
            }
        case .ready:
            return (direction == .right2left) ? 0 : proxy.size.width - contentWidth
        case .animating:
            return (direction == .right2left) ? proxy.size.width - contentWidth : 0
        }
    }
    
    private func resetAnimation(duration: Double, autoreverses: Bool, proxy: GeometryProxy) {
        let isNotFit = contentWidth < proxy.size.width
        if stopWhenNotFit && isNotFit {
            stopAnimation()
            return
        }
        
        if duration == 0 || duration == Double.infinity {
            stopAnimation()
        } else {
            startAnimation(duration: duration, autoreverses: autoreverses, proxy: proxy)
        }
    }
    
    private func startAnimation(duration: Double, autoreverses: Bool, proxy: GeometryProxy) {
        let isNotFit = contentWidth < proxy.size.width
        if stopWhenNotFit && isNotFit {
            stopAnimation()
            return
        }
        
        withAnimation(.instant) {
            self.state = .ready
            withAnimation(Animation.linear(duration: duration).delay(startDelay).repeatForever(autoreverses: autoreverses)) {
                self.state = .animating
            }
        }
    }
    
    private func stopAnimation() {
        withAnimation(.instant) {
            self.state = .idle
        }
    }
}

struct MarqueeView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 0) {
            MarqueeView(
                startDelay: 3.0,
                autoreverses: true,
                direction: .right2left,
                stopWhenNoFit: true,
                idleAlignment: .leading
            ) {
                Text("Hold On, We're Going Home ")
                    .fontWeight(.bold)
                    .font(.title)
            }
            Text("Drake")
                .fontWeight(.bold)
                .font(.callout)
            Spacer()
        }
        .frame(width: 200, height: 60)
    }
}

struct GeometryBackground: View {
    var body: some View {
        GeometryReader { geometry in
            return Color.clear.preference(key: WidthKey.self, value: geometry.size.width)
        }
    }
}

struct WidthKey: PreferenceKey {
    static var defaultValue = CGFloat(0)
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
    typealias Value = CGFloat
}

extension Animation {
    static var instant: Animation {
        return .linear(duration: 0.01)
    }
}

extension View {
    func myOffset(x: CGFloat, y: CGFloat) -> some View {
        return modifier(_OffsetEffect(offset: CGSize(width: x, height: y)))
    }
    
    func myOffset(_ offset: CGSize) -> some View {
        return modifier(_OffsetEffect(offset: offset))
    }
}

struct _OffsetEffect: GeometryEffect {
    var offset: CGSize
    
    var animatableData: CGSize.AnimatableData {
        get { CGSize.AnimatableData(offset.width, offset.height) }
        set { offset = CGSize(width: newValue.first, height: newValue.second) }
    }
    
    public func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: offset.width, y: offset.height))
    }
}

public enum MarqueeDirection {
    case right2left
    case left2right
}

private enum MarqueeState {
    case idle
    case ready
    case animating
}
