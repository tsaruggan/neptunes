//
//  Palette.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2021-07-12.
//

import Foundation
import SwiftUI

struct Palette {
    var primary: ColorTheme
    var secondary: ColorTheme
    var tertiary: ColorTheme
    var accent: ColorTheme
    var background: ColorTheme
    
    func primary(_ scheme: ColorScheme) -> Color {
        switch scheme {
        case .light:
            return primary.light
        case .dark:
            return primary.dark
        @unknown default:
            return primary.light
        }
    }
    
    func secondary(_ scheme: ColorScheme) -> Color {
        switch scheme {
        case .light:
            return secondary.light
        case .dark:
            return secondary.dark
        @unknown default:
            return secondary.light
        }
    }
    
    func tertiary(_ scheme: ColorScheme) -> Color {
        switch scheme {
        case .light:
            return tertiary.light
        case .dark:
            return tertiary.dark
        @unknown default:
            return tertiary.light
        }
    }
    
    func accent(_ scheme: ColorScheme) -> Color {
        switch scheme {
        case .light:
            return accent.light
        case .dark:
            return accent.dark
        @unknown default:
            return accent.light
        }
    }
    
    func background(_ scheme: ColorScheme) -> Color {
        switch scheme {
        case .light:
            return background.light
        case .dark:
            return background.dark
        @unknown default:
            return background.light
        }
    }
}
