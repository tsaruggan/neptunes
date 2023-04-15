//
//  ColorAnalyzer.swift
//  Neptunes
//
//  Created by Saruggan Thiruchelvan on 2023-04-14.
//

import Foundation
import UIKit
import SwiftImage
import SwiftUI

typealias ColorTheme = (
    lightColor: UIColor,
    darkColor: UIColor
)

typealias ColorPalette = (
    primaryTheme: ColorTheme,
    secondaryTheme: ColorTheme,
    accentTheme: ColorTheme,
    backgroundTheme: ColorTheme
)

class ColorAnalyzer {
    
    public static func generatePalette(coverArtwork: Data?, headerArtwork: Data?) -> ColorPalette? {
        if let colors = getColors(coverArtwork: coverArtwork, headerArtwork: headerArtwork, 4) {
            return generatePaletteFromColors(colors[0], colors[1], colors[2], colors[3])
        } else{
            return nil
        }
    }
    
    private static func getPixelsFromImage(cgImage: CGImage, _ resizedWidth: Int, _ resizedHeight: Int) -> [Vector] {
        //        let cgImage: CGImage = UIImage(named: image)!.cgImage!
        //        let cgImage: CGImage = UIImage(data: imageData)!.cgImage!
        let image = SwiftImage.Image<RGBA<UInt8>>(cgImage: cgImage)
        let resizedImage = image.resizedTo(width: resizedWidth, height: resizedHeight, interpolatedBy: .nearestNeighbor)
        let pixels: [Vector] = resizedImage.map { pixel in
            Vector([pixel.redDouble, pixel.greenDouble, pixel.blueDouble])
        }
        return pixels
    }
    
    private static func getColors(coverArtwork: Data?, headerArtwork: Data?, _ numColors: Int) -> [UIColor]? {
        var pixels: [Vector] = []
        
        if let cover = coverArtwork,
           let coverUIImage = UIImage(data: cover),
           let coverCGImage = coverUIImage.cgImage {
            pixels += getPixelsFromImage(cgImage: coverCGImage, 16, 16)
        }
        
        if let header = headerArtwork,
           let headerUIImage = UIImage(data: header),
           let headerCGImage = headerUIImage.cgImage {
            pixels += getPixelsFromImage(cgImage: headerCGImage, 24, 8)
        }
        
        if pixels.isEmpty { return nil }
        
        let kmm = KMeans(numColors)
        kmm.trainCenters(pixels, convergeDistance: 0.01)
        let colors = kmm.centroids.map { centroid in
            return UIColor(
                red: centroid.data[0] / 255.0,
                green: centroid.data[1] / 255.0,
                blue: centroid.data[2] / 255.0,
                alpha: 1.0
            )
        }
        let sortedColors = colors.sorted { $0.colorfulness > $1.colorfulness }
        return sortedColors
    }
    
    private static func generatePaletteFromColors(_ color1: UIColor, _ color2: UIColor, _ color3: UIColor, _ color4: UIColor) -> ColorPalette {
        let (primaryTheme, backgroundTheme) = generatePrimaryAndBackground(color1: color1, color2: color2)
        let secondaryTheme = generateTheme(color: color3, backgroundTheme: backgroundTheme)
        let accentTheme = generateTheme(color: color4, backgroundTheme: backgroundTheme)
        return (
            primaryTheme: primaryTheme,
            secondaryTheme: secondaryTheme,
            accentTheme: accentTheme,
            backgroundTheme: backgroundTheme
        )
    }
    
    private static func generatePrimaryAndBackground(color1: UIColor, color2: UIColor) -> (primaryTheme: ColorTheme, backgroundTheme: ColorTheme) {
        var primary: UIColor
        var background: UIColor
        if color1.luminance > color2.luminance {
            primary = color2
            background = color1
        } else {
            primary = color1
            background = color2
        }
        
        var primaryLight = primary.darkenColor()
        var backgroundLight = background.lightenColor()
        var lightContrast = primaryLight.contrastRatio(with: backgroundLight)
        while (lightContrast < 3.00) {
            primaryLight = primaryLight.adjustBrightness(incrementBy: -0.05)
            backgroundLight = backgroundLight.adjustBrightness(incrementBy: 0.05)
            lightContrast = primaryLight.contrastRatio(with: backgroundLight)
        }
        
        var primaryDark = primary.lightenColor()
        var backgroundDark = background.darkenColor()
        var darkContrast = primaryDark.contrastRatio(with: backgroundDark)
        while (darkContrast < 3.00) {
            primaryDark = primaryDark.adjustBrightness(incrementBy: 0.05)
            backgroundDark = backgroundDark.adjustBrightness(incrementBy: -0.05)
            darkContrast = primaryDark.contrastRatio(with: backgroundDark)
        }
        
        return (
            primaryTheme: (primaryLight, primaryDark),
            backgroundTheme: (backgroundLight ,backgroundDark)
        )
    }
    
    private static func generateTheme(color: UIColor, backgroundTheme: ColorTheme) -> ColorTheme {
        let (backgroundLight, backgroundDark) = backgroundTheme
        var lightColor = color.darkenColor()
        var lightContrast = lightColor.contrastRatio(with: backgroundLight)
        while (lightContrast < 3.00) {
            lightColor = lightColor.adjustBrightness(incrementBy: -0.05)
            lightContrast = lightColor.contrastRatio(with: backgroundLight)
            if (lightColor.brightness == 0) { break }
        }
        
        var darkColor = color.lightenColor()
        var darkContrast = darkColor.contrastRatio(with: backgroundDark)
        while (darkContrast < 3.00) {
            darkColor = darkColor.adjustBrightness(incrementBy: 0.05)
            if (darkColor.brightness == 1) { break }
            darkContrast = darkColor.contrastRatio(with: backgroundDark)
        }
        return (lightColor, darkColor)
    }
    
}

extension RGBA where Channel == UInt8 {
    var redDouble: Double { return Double(red) }
    var greenDouble: Double { return Double(green) }
    var blueDouble: Double { return Double(blue) }
    var alphaDouble: Double { return Double(alpha) }
}

extension UIColor {
    var brightness: CGFloat {
        var hue: CGFloat        = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat      = 0.0
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return brightness
    }
    
    var luminance: CGFloat {
        let ciColor = CIColor(color: self)
        func adjust(colorComponent: CGFloat) -> CGFloat {
            return (colorComponent < 0.04045) ? (colorComponent / 12.92) : pow((colorComponent + 0.055) / 1.055, 2.4)
        }
        return 0.2126 * adjust(colorComponent: ciColor.red) + 0.7152 * adjust(colorComponent: ciColor.green) + 0.0722 * adjust(colorComponent: ciColor.blue)
    }
    
    var colorfulness: CGFloat {
        var red: CGFloat        = 0.0
        var green: CGFloat      = 0.0
        var blue: CGFloat       = 0.0
        var alpha: CGFloat      = 0.0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let rg = abs(red - green)
        let yb = abs(0.5 * (red + green) - blue)
        let root = (pow(rg, 2) + pow(yb, 2)).squareRoot()
        return root * 0.3
    }
    
    func contrastRatio(with color: UIColor) -> CGFloat {
        let luminance1 = self.luminance
        let luminance2 = color.luminance
        let luminanceDarker = min(luminance1, luminance2)
        let luminanceLighter = max(luminance1, luminance2)
        return (luminanceLighter + 0.05) / (luminanceDarker + 0.05)
    }
    
    func adjustBrightness(incrementBy increment: CGFloat) -> UIColor {
        var hue: CGFloat        = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat      = 0.0
        
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        let newColor = UIColor( hue: hue, saturation: saturation, brightness: max(min(brightness + increment, 1), 0), alpha: alpha)
        return newColor
    }
    
    func lightenColor() -> UIColor {
        var contrast = self.contrastRatio(with: .black)
        var lightenedColor = self
        while (contrast < 3.00) {
            lightenedColor = lightenedColor.adjustBrightness(incrementBy: 0.05)
            contrast = lightenedColor.contrastRatio(with: .black)
        }
        return lightenedColor
    }
    
    func darkenColor() -> UIColor {
        var contrast = self.contrastRatio(with: .white)
        var darkenedColor = self
        while (contrast < 3.00) {
            darkenedColor = darkenedColor.adjustBrightness(incrementBy: -0.05)
            contrast = darkenedColor.contrastRatio(with: .white)
        }
        return darkenedColor
    }
}


