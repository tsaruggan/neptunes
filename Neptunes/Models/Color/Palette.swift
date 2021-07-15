//
//  Palette.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-12.
//

import Foundation
import SwiftUI

typealias ColorTheme = (light: Color, dark: Color?)

struct Palette {
    var primary: ColorTheme = (light: .primary, dark: nil)
    var secondary: ColorTheme = (light: .secondary, dark: nil)
    var accent: ColorTheme = (light: .red, dark: nil)
    var background: ColorTheme = (light: .clear, dark: nil)
    
    func primary(_ scheme: ColorScheme) -> Color { getColor(from: primary, for: scheme) }
    
    func secondary(_ scheme: ColorScheme) -> Color { getColor(from: secondary, for: scheme) }
    
    func accent(_ scheme: ColorScheme) -> Color { getColor(from: accent, for: scheme) }
    
    func background(_ scheme: ColorScheme) -> Color { getColor(from: background, for: scheme) }
    
    private func getColor(from theme: ColorTheme, for scheme: ColorScheme) -> Color {
        switch scheme {
        case .light:
            return theme.light
        case .dark:
            if let dark = theme.dark { return dark } else { fallthrough }
        @unknown default:
            return theme.light
        }
    }
}
