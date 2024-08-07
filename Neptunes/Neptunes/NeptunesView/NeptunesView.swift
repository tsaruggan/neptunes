//
//  NeptunesView.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-17.
//

import SwiftUI

struct NeptunesView<Content: View, MenuButtonGroup: View>: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var player: Player
    
    var headerArtwork: Data?
    var backgroundColor: Color
    let content: Content
    let menu: MenuButtonGroup
    
    init(headerArtwork: Data?, backgroundColor: Color, @ViewBuilder content: () -> Content, @ViewBuilder menu: () -> MenuButtonGroup) {
        self.headerArtwork = headerArtwork
        self.backgroundColor = backgroundColor
        self.content = content()
        self.menu = menu()
    }
    
    func isPlayerCurrentlyVisible() -> Bool {
        return player.currentSong != nil
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack {
                VStack(spacing: 0) {
                    HeaderView(headerArtwork: headerArtwork)
                    Spacer()
                }
                
                VStack {
                    content
                }
                .padding(.top, 100)
                .padding(.bottom, isPlayerCurrentlyVisible() ? 80 : 0)
                .frame(minHeight: UIScreen.main.bounds.height)
            }
        }
        .background(LinearGradient(colors: [backgroundColor, .clear], startPoint: .top, endPoint: .bottom))
        .edgesIgnoringSafeArea(.top)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(false)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading){ backButton }
            ToolbarItemGroup(placement: .navigationBarTrailing){ menuButton }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
    }
    
    var backButton: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Label("Back", systemImage: "chevron.backward")
        }
        .buttonStyle(ToolbarButtonStyle(backgroundColor: backgroundColor))
    }
    
    var menuButton: some View {
        Menu() {
            menu
        } label: {
            Button(action: {}) { Image(systemName: "ellipsis") }
                .buttonStyle(ToolbarButtonStyle(backgroundColor: backgroundColor))
        }
    }
}

struct ToolbarButtonStyle: ButtonStyle {
    var backgroundColor: Color
    func makeBody(configuration: Self.Configuration) -> some View {
        let width: CGFloat = 40
        configuration.label
            .frame(width: width, height: width)
            .buttonStyle(.bordered)
            .foregroundColor(.primary)
            .background(backgroundColor.opacity(0.3), in: Circle())
            .background(.ultraThinMaterial, in: Circle())
    }
}

// Assorted witchcraft that lets you swipe back even when navigationBarBackButton is hidden
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
